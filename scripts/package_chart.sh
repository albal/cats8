#!/bin/bash
set -e

# Script to package Helm chart and update repository index
# This script is idempotent and merges with existing index.yaml

CHART_DIR="charts/cats8"
OUTPUT_DIR="gh-pages"
REPO_URL="https://albal.github.io/cats8"

echo "📦 Packaging Helm chart..."

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Package the chart
helm package "$CHART_DIR" --destination "$OUTPUT_DIR"

echo "📝 Generating/updating Helm repository index..."

# Check if index.yaml exists and merge with it
if [ -f "$OUTPUT_DIR/index.yaml" ]; then
    echo "Found existing index.yaml, merging..."
    helm repo index "$OUTPUT_DIR" --url "$REPO_URL" --merge "$OUTPUT_DIR/index.yaml"
else
    echo "Creating new index.yaml..."
    helm repo index "$OUTPUT_DIR" --url "$REPO_URL"
fi

echo "✅ Chart packaged successfully!"
echo "📁 Output directory: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR"
