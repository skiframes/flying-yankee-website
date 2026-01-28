#!/bin/bash

# Flying Yankee Website Deploy Script
# Deploys to S3 and invalidates CloudFront cache

set -e

# Configuration
S3_BUCKET="flying-yankee-live"
CLOUDFRONT_DISTRIBUTION_ID="EJPEO5ANGX6UX"
SRC_DIR="src"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Flying Yankee Website Deploy         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI not found"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${YELLOW}Syncing to S3...${NC}"
aws s3 sync "$PROJECT_DIR/$SRC_DIR" "s3://$S3_BUCKET" \
    --delete \
    --content-type "text/html" \
    --exclude "*" \
    --include "*.html"

# Sync other file types with correct content types
aws s3 sync "$PROJECT_DIR/$SRC_DIR" "s3://$S3_BUCKET" \
    --delete \
    --exclude "*.html"

echo -e "${GREEN}✓ S3 sync complete${NC}"
echo ""

echo -e "${YELLOW}Invalidating CloudFront cache...${NC}"
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)

echo -e "${GREEN}✓ Cache invalidation created: $INVALIDATION_ID${NC}"
echo ""

echo -e "${GREEN}Deploy complete!${NC}"
echo ""
echo "Site will update in 1-2 minutes."
echo "  Main:  https://flying-yankee.com"
echo "  Live:  https://flying-yankee.com/live/"
