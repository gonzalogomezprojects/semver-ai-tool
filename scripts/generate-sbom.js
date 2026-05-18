#!/usr/bin/env node
/**
 * SBOM Generator - Creates Software Bill of Materials
 * Run: node scripts/generate-sbom.js
 */

const fs = require('fs');
const path = require('path');

const packageJson = require('../package.json');

const sbom = {
    bomFormat: "CycloneDX",
    specVersion: "1.5",
    serialNumber: "urn:uuid:" + require('crypto').randomUUID(),
    version: 1,
    metadata: {
        timestamp: new Date().toISOString(),
        tools: [{
            name: "semver-ai-tool",
            version: packageJson.version
        }],
        component: {
            type: "application",
            name: packageJson.name,
            version: packageJson.version,
            purl: `pkg:npm/${packageJson.name}@${packageJson.version}`,
            supplier: {
                name: packageJson.author
            }
        }
    },
    components: [
        {
            type: "application",
            name: packageJson.name,
            version: packageJson.version,
            description: packageJson.description,
            purl: `pkg:npm/${packageJson.name}@${packageJson.version}`,
            licenses: [{ license: { id: packageJson.license } }],
            properties: [
                { name: "npm:engine", value: packageJson.engines?.node || "N/A" }
            ]
        }
    ],
    dependencies: []
};

// Add dependencies
if (packageJson.dependencies) {
    Object.entries(packageJson.dependencies).forEach(([name, version]) => {
        sbom.dependencies.push({
            ref: `pkg:npm/${name}@${version}`,
            dependsOn: []
        });
    });
}

if (packageJson.devDependencies) {
    Object.entries(packageJson.devDependencies).forEach(([name, version]) => {
        sbom.dependencies.push({
            ref: `pkg:npm/${name}@${version}`,
            dependsOn: [],
            type: "development"
        });
    });
}

// Output
const format = process.argv.includes('--json') ? 'json' : 'markdown';

if (format === 'json') {
    console.log(JSON.stringify(sbom, null, 2));
} else {
    // Markdown output
    console.log(`# Software Bill of Materials (SBOM)`);
    console.log(`Generated: ${sbom.metadata.timestamp}`);
    console.log(`Format: CycloneDX 1.5`);
    console.log(``);
    console.log(`## Project`);
    console.log(`| Property | Value |`);
    console.log(`|----------|-------|`);
    console.log(`| Name | ${packageJson.name} |`);
    console.log(`| Version | ${packageJson.version} |`);
    console.log(`| License | ${packageJson.license} |`);
    console.log(`| Author | ${packageJson.author} |`);
    console.log(``);
    console.log(`## Dependencies`);
    console.log(`| Package | Version | Type |`);
    console.log(`|---------|---------|------|`);

    [...Object.entries(packageJson.dependencies || {}), ...Object.entries(packageJson.devDependencies || {})].forEach(([name, version]) => {
        const type = packageJson.devDependencies?.[name] ? 'dev' : 'prod';
        console.log(`| ${name} | ${version} | ${type} |`);
    });
}