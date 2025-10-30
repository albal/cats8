#!/bin/bash
set -e

# Script to package the Helm chart and update the repository index
# Usage: ./scripts/package_chart.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHART_DIR="$REPO_ROOT/charts/cats8"
PACKAGE_DIR="$REPO_ROOT/.helmrepo"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐱 Cats8 Helm Chart Packager${NC}"
echo -e "${BLUE}==============================${NC}\n"

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo -e "${YELLOW}⚠️  Helm is not installed. Please install Helm first.${NC}"
    echo "Visit: https://helm.sh/docs/intro/install/"
    exit 1
fi

echo -e "${GREEN}✓${NC} Helm found: $(helm version --short)"

# Create package directory if it doesn't exist
echo -e "\n${BLUE}Creating package directory...${NC}"
mkdir -p "$PACKAGE_DIR"
echo -e "${GREEN}✓${NC} Package directory: $PACKAGE_DIR"

# Lint the chart first
echo -e "\n${BLUE}Linting chart...${NC}"
if helm lint "$CHART_DIR"; then
    echo -e "${GREEN}✓${NC} Chart linting passed"
else
    echo -e "${YELLOW}⚠️  Chart linting failed. Please fix the errors above.${NC}"
    exit 1
fi

# Package the chart
echo -e "\n${BLUE}Packaging chart...${NC}"
if helm package "$CHART_DIR" -d "$PACKAGE_DIR"; then
    echo -e "${GREEN}✓${NC} Chart packaged successfully"
else
    echo -e "${YELLOW}⚠️  Chart packaging failed.${NC}"
    exit 1
fi

# Update the repository index
echo -e "\n${BLUE}Updating repository index...${NC}"
if helm repo index "$PACKAGE_DIR" --url https://albal.github.io/cats8; then
    echo -e "${GREEN}✓${NC} Repository index updated"
else
    echo -e "${YELLOW}⚠️  Failed to update repository index.${NC}"
    exit 1
fi

# Display results
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Chart packaging complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo "Packaged files:"
ls -lh "$PACKAGE_DIR"/*.tgz 2>/dev/null || echo "  No .tgz files found"

echo -e "\nRepository index:"
ls -lh "$PACKAGE_DIR"/index.yaml 2>/dev/null || echo "  No index.yaml found"

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Commit the packaged chart and index to the gh-pages branch"
echo "2. Push to GitHub to make it available via GitHub Pages"
echo -e "\n${YELLOW}Note:${NC} The GitHub Actions workflow will do this automatically on push to main."
