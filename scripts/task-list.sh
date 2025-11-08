
#!/usr/bin/env bash

json="$(task +ACTIVE export 2>/dev/null)"

# If Taskwarrior returned nothing or an empty array, bail cleanly.
if [ -z "$json" ] || [ "$json" = "[]" ]; then
    echo "NTA"
    exit 0
fi

# Otherwise extract the description.
desc="$(printf '%s' "$json" | jq -er '.[0].description' 2>/dev/null || true)"

# If description is empty or null, also bail.
if [ -z "$desc" ] || [ "$desc" = "null" ]; then
    echo "NTA"
    exit 0
fi

echo "$desc"
