#!/bin/bash

# Extract Pokémon data from JSON file using jq, awk, and sed
# Usage: ./extract_pokemon.sh pokemon.json

JSON_FILE="${1:-pokemon.json}"

# Check if file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File $JSON_FILE not found!"
    exit 1
fi

# Extract name using jq
name=$(jq -r '.name' "$JSON_FILE")

# Capitalize first letter using sed
name=$(echo "$name" | sed 's/^./\u&/')

# Extract height (in decimeters, convert to meters)
height=$(jq -r '.height' "$JSON_FILE" | awk '{printf "%.1f", $1/10}')

# Extract weight (in hectograms, convert to kg)
weight=$(jq -r '.weight' "$JSON_FILE" | awk '{print $1/10}')

# Extract types and join them with " and " or just use first type
types=$(jq -r '.types[].type.name' "$JSON_FILE" | sed 's/^./\u&/' | awk '
    BEGIN { ORS="" }
    NR==1 { printf "%s", $0 }
    NR==2 { printf " and %s", $0 }
    NR>2 { printf ", %s", $0 }
')

# Format and print the output
echo "$name is of type $types, weighs ${weight}kg, and is ${height}m tall."