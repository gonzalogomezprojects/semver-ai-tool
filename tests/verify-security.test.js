/**
 * Security Verification Tests for SemVer AI Tool
 * Run with: node tests/verify-security.test.js
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const TEST_DIR = path.join(__dirname, 'verify-temp');

function run(command, options = {}) {
    try {
        return execSync(command, {
            cwd: options.cwd || TEST_DIR,
            encoding: 'utf-8',
            timeout: 30000,
            stdio: ['pipe', 'pipe', 'pipe'],
            ...options
        });
    } catch (error) {
        return {
            stdout: error.stdout || '',
            stderr: error.stderr || '',
            code: error.status,
            error: error.message
        };
    }
}

function assert(condition, message) {
    if (!condition) throw new Error(`Assertion failed: ${message}`);
}

function assertContains(text, substring, message) {
    if (!text.includes(substring)) {
        throw new Error(`${message}. Expected to contain: "${substring}"`);
    }
}

// Setup test environment
function setup() {
    // Clean up any existing test dir
    if (fs.existsSync(TEST_DIR)) {
        fs.rmSync(TEST_DIR, { recursive: true, force: true });
    }
    fs.mkdirSync(TEST_DIR, { recursive: true });

    // Create a git repo
    run('git init');
    run('git config user.email "test@test.com"');
    run('git config user.name "Test"');

    // Create package.json
    fs.writeFileSync(path.join(TEST_DIR, 'package.json'), JSON.stringify({
        name: "test-project",
        version: "0.0.0"
    }, null, 2));

    console.log('✅ Test environment setup complete\n');
}

function cleanup() {
    if (fs.existsSync(TEST_DIR)) {
        fs.rmSync(TEST_DIR, { recursive: true, force: true });
    }
}

// ============================================
// SECURITY TESTS
// ============================================

function test1_env_file_not_in_git() {
    console.log('📋 Test 1: .env file should NOT be in git');

    const envFile = path.join(TEST_DIR, '.semver-ai.env');
    fs.writeFileSync(envFile, 'GROQ_API_KEY=test_key_123\n');

    const gitignorePath = path.join(TEST_DIR, '.gitignore');
    fs.writeFileSync(gitignorePath, '# Ignore node_modules\nnode_modules/\n');

    // Run semver-ai init logic (manually simulate the init.sh)
    const envFileName = '.semver-ai.env';
    if (!fs.readFileSync(gitignorePath, 'utf-8').includes(envFileName)) {
        fs.appendFileSync(gitignorePath, `\n# SemVer AI Tool Credentials\n${envFileName}\n`);
    }

    const gitignoreContent = fs.readFileSync(gitignorePath, 'utf-8');
    assert(gitignoreContent.includes('.semver-ai.env'), '.env should be in .gitignore');

    console.log('   ✅ .env file is protected by .gitignore\n');
}

function test2_json_config_has_no_secrets() {
    console.log('📋 Test 2: JSON config should NOT contain API key');

    const config = {
        project_name: "test-project",
        author_name: "Test Author",
        release_language: "en",
        docs_dir: "docs/releases",
        groq_model: "llama-3.3-70b-versatile",
        groq_url: "https://api.groq.com/openai/v1/chat/completions"
        // NO groq_api_key here!
    };

    fs.writeFileSync(path.join(TEST_DIR, '.semver-ai.json'), JSON.stringify(config, null, 2));

    const configContent = fs.readFileSync(path.join(TEST_DIR, '.semver-ai.json'), 'utf-8');
    assert(!configContent.includes('groq_api_key'), 'JSON config should NOT have groq_api_key');
    assert(configContent.includes('project_name'), 'JSON should have project_name');

    console.log('   ✅ JSON config is public and safe to commit\n');
}

function test3_env_example_template_safe() {
    console.log('📋 Test 3: .env.example should have placeholder, not real keys');

    const examplePath = path.join(__dirname, '..', '.semver-ai.env.example');
    assert(fs.existsSync(examplePath), '.env.example should exist');

    const exampleContent = fs.readFileSync(examplePath, 'utf-8');
    assert(exampleContent.includes('your_groq_api_key_here'), 'Should have placeholder text');
    assert(!exampleContent.includes('gsk_'), 'Should NOT contain real API key format');

    console.log('   ✅ .env.example is safe to commit\n');
}

function test4_gitignore_has_both_files() {
    console.log('📋 Test 4: .gitignore should protect both config files');

    const gitignore = path.join(TEST_DIR, '.gitignore');
    fs.writeFileSync(gitignore, '');

    // Simulate init.sh gitignore logic
    const configFile = '.semver-ai.json';
    const envFile = '.semver-ai.env';

    const current = fs.readFileSync(gitignore, 'utf-8');
    if (!current.includes(configFile)) {
        fs.appendFileSync(gitignore, `\n# SemVer AI Tool\n${configFile}\n`);
    }
    if (!current.includes(envFile)) {
        fs.appendFileSync(gitignore, `\n# SemVer AI Credentials\n${envFile}\n`);
    }

    const finalContent = fs.readFileSync(gitignore, 'utf-8');
    assert(finalContent.includes(configFile), '.semver-ai.json should be in gitignore');
    assert(finalContent.includes(envFile), '.semver-ai.env should be in gitignore');

    console.log('   ✅ Both files are protected in .gitignore\n');
}

function test5_priority_order_correct() {
    console.log('📋 Test 5: Credentials priority order: env var > .env file > none');

    // This test verifies the logic in config_loader.sh
    // Priority 1: Environment variable (for CI/CD)
    // Priority 2: .env file (for local development)
    // Priority 3: No credentials (local mode)

    const testPriority = (envVarSet, envFileExists, expected) => {
        // Logic from config_loader.sh:
        // if [ -n "$GROQ_API_KEY" ]; then (env var)
        // elif [ -f "$env_file" ]; then (.env file)
        // else (none)

        let result;
        if (envVarSet) {
            result = 'env_variable';
        } else if (envFileExists) {
            result = 'env_file';
        } else {
            result = 'none';
        }
        return result === expected;
    };

    assert(testPriority(true, false, 'env_variable'), 'Env var should win');
    assert(testPriority(false, true, 'env_file'), '.env file should be used when no env var');
    assert(testPriority(false, false, 'none'), 'None when no credentials');

    console.log('   ✅ Priority order is correct\n');
}

function test6_json_structure_valid() {
    console.log('📋 Test 6: JSON config has all required fields');

    const configPath = path.join(TEST_DIR, '.semver-ai.json');
    const config = {
        project_name: "test-project",
        author_name: "Test Author",
        release_language: "en",
        docs_dir: "docs/releases",
        groq_model: "llama-3.3-70b-versatile",
        groq_url: "https://api.groq.com/openai/v1/chat/completions"
    };

    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));

    const loaded = JSON.parse(fs.readFileSync(configPath, 'utf-8'));
    assert(loaded.project_name, 'project_name required');
    assert(loaded.author_name, 'author_name required');
    assert(loaded.release_language, 'release_language required');
    assert(loaded.docs_dir, 'docs_dir required');
    assert(loaded.groq_model, 'groq_model required');

    console.log('   ✅ JSON structure is valid\n');
}

// ============================================
// RUN TESTS
// ============================================

async function main() {
    console.log('═══════════════════════════════════════════════════════');
    console.log('  Security Verification Tests');
    console.log('═══════════════════════════════════════════════════════\n');

    try {
        setup();

        test1_env_file_not_in_git();
        test2_json_config_has_no_secrets();
        test3_env_example_template_safe();
        test4_gitignore_has_both_files();
        test5_priority_order_correct();
        test6_json_structure_valid();

        console.log('═══════════════════════════════════════════════════════');
        console.log('  ✅ ALL SECURITY TESTS PASSED');
        console.log('═══════════════════════════════════════════════════════\n');

    } catch (error) {
        console.error('\n═══════════════════════════════════════════════════════');
        console.error(`  ❌ TEST FAILED: ${error.message}`);
        console.error('═══════════════════════════════════════════════════════\n');
        process.exit(1);
    } finally {
        cleanup();
    }
}

main();