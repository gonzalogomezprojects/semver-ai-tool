# ai_client.sh
# Abstracting HTTP requests to Large Language Models.

generate_release_notes() {
    local version="$1"
    local type="$2"
    local commit="$3"
    local diff="$4"
    
    local curr_date=$(date +%Y-%m-%d)
    
    local prompt="Act strictly as a Senior Technical Writer for a software engineering team.
Generate release notes for version $version.

## Context
- Project: $PROJECT_NAME
- Primary Author: $AUTHOR_NAME
- Date of Release: $curr_date
- Release Intent (SemVer action): $type

## Contextual Data
Commit Message:
$commit

Code Differences Payload:
$diff

## Requirements Output:
1. Provide valid Markdown format response.
2. Structure sections: 'Executive Summary', 'Detailed Changes', 'Technical Modules Affected'.
3. Extract real meaning out of the code differences payload and explain the 'why'.
4. Do NOT output XML tags like <think>, only the markdown content."

    # Construct JSON payload utilizing Node mapping arguments safely
    local payload=$(PROMPT="$prompt" node -e "
      console.log(JSON.stringify({
        model: process.env.GROQ_MODEL || 'llama-3.1-70b-versatile',
        messages: [
            {role: 'system', content: 'You are an expert technical documenter and analyst.'},
            {role: 'user', content: process.env.PROMPT}
        ],
        temperature: 0.2
      }));
    ")
        
    local response=$(curl -sS -f --max-time 45 "$GROQ_URL" \
        -H "Authorization: Bearer $GROQ_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$payload" || true)
        
    # If the response was empty or curl failed heavily
    if [ -z "$response" ]; then
        echo "Error: AI API Request failed, generating fallback documentation." >&2
        echo "# Release v$version\nFallback documentation trigger, AI Service Unavailable.\n\nChanges: $commit"
        return 0
    fi
    
    # Strip any potential tags generated from open-weight models (like <think> tokens)
    local content=$(JSON_RESPONSE="$response" node -e "
      try {
        const data = JSON.parse(process.env.JSON_RESPONSE);
        console.log(data.choices[0].message.content || '');
      } catch(e) {}
    " | sed -e 's/<think>.*<\/think>//g' -e '/<think>/,/<\/think>/d')
    
    echo "$content"
}
