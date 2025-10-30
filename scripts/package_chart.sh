#!/bin/bash
# Script to package the Helm chart and update the index
# This script can be run locally to test chart packaging

set -e

# Configuration
CHART_DIR="charts/cats8"
OUTPUT_DIR=".helmrepo"
REPO_URL="https://albal.github.io/cats8"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Packaging Helm Chart${NC}"
echo "======================================"

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo -e "${RED}Error: Helm is not installed${NC}"
    echo "Please install Helm: https://helm.sh/docs/intro/install/"
    exit 1
fi

# Check if chart directory exists
if [ ! -d "$CHART_DIR" ]; then
    echo -e "${RED}Error: Chart directory '$CHART_DIR' not found${NC}"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo -e "${YELLOW}Linting chart...${NC}"
helm lint "$CHART_DIR"

echo -e "${YELLOW}Packaging chart...${NC}"
helm package "$CHART_DIR" -d "$OUTPUT_DIR"

# Get the chart version from Chart.yaml
CHART_VERSION=$(grep '^version:' "$CHART_DIR/Chart.yaml" | awk '{print $2}')
CHART_NAME=$(grep '^name:' "$CHART_DIR/Chart.yaml" | awk '{print $2}')
PACKAGED_CHART="${CHART_NAME}-${CHART_VERSION}.tgz"

echo -e "${GREEN}Chart packaged: ${OUTPUT_DIR}/${PACKAGED_CHART}${NC}"

# Update or create index
if [ -f "$OUTPUT_DIR/index.yaml" ]; then
    echo -e "${YELLOW}Updating existing index.yaml...${NC}"
    helm repo index "$OUTPUT_DIR" --url "$REPO_URL" --merge "$OUTPUT_DIR/index.yaml"
else
    echo -e "${YELLOW}Creating new index.yaml...${NC}"
    helm repo index "$OUTPUT_DIR" --url "$REPO_URL"
fi

echo -e "${GREEN}Index updated: ${OUTPUT_DIR}/index.yaml${NC}"

# Display summary
echo ""
echo "======================================"
echo -e "${GREEN}Packaging complete!${NC}"
echo ""
echo "Chart:   ${CHART_NAME}"
echo "Version: ${CHART_VERSION}"
echo "Package: ${OUTPUT_DIR}/${PACKAGED_CHART}"
echo ""
echo "To test the chart locally:"
echo "  helm install my-cats ${OUTPUT_DIR}/${PACKAGED_CHART}"
echo ""
echo "To publish to GitHub Pages:"
echo "  1. Copy contents of ${OUTPUT_DIR}/ to gh-pages branch"
echo "  2. Commit and push to GitHub"
echo "  3. Enable GitHub Pages in repository settings"
echo ""
