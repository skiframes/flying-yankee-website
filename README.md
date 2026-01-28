# Flying Yankee Website

Ski Racing Video Analytics at Ragged Mountain, New Hampshire.

## Live Site

- **Main Site**: https://flying-yankee.com
- **Live Stream**: https://flying-yankee.com/live/

## Structure

```
src/
├── index.html              # Main archive page
└── live/
    └── index.html          # Live stream player
streaming/
└── start_live_stream.sh    # Adaptive streaming script for Jetson
scripts/
└── deploy.sh               # Deploy to S3 + invalidate CloudFront
```

## Deployment

### Manual Deploy

```bash
./scripts/deploy.sh
```

### What it does

1. Syncs `src/` folder to S3 bucket `flying-yankee-live`
2. Invalidates CloudFront cache

## Streaming

### Setup on Jetson

```bash
# Copy script to Jetson
scp streaming/start_live_stream.sh j40@J40:~/bin/

# Make executable
ssh j40@J40 "chmod +x ~/bin/start_live_stream.sh"
```

### Usage

```bash
# Run bandwidth test
./start_live_stream.sh test

# Start streaming (adaptive mode - default)
./start_live_stream.sh

# Fixed quality modes
./start_live_stream.sh low
./start_live_stream.sh medium
./start_live_stream.sh high
./start_live_stream.sh ultra
```

### Quality Presets

| Preset | Resolution | Bitrate | FPS | Use Case |
|--------|-----------|---------|-----|----------|
| `low` | Sub-stream | 400k | 10 | Poor LTE |
| `medium` | 720p | 1.2M | 15 | Stable LTE |
| `high` | 1080p | 3.5M | 25 | Good connection |
| `ultra` | Native | 7M | 30 | Excellent connection |
| `adaptive` | Auto | Auto | Auto | **Default - Race day** |

### Camera Auto-Detection

- Primary: `192.168.0.101`
- Fallback: `192.168.0.103`

## AWS Resources

| Service | Resource |
|---------|----------|
| S3 Bucket | `flying-yankee-live` |
| CloudFront | `d80wup0l69q45.cloudfront.net` |
| MediaPackage | `channel-group-FY/channel-FY` |
| MediaLive | RTMP input at `44.215.230.146:1935` |

## Development with Claude

This repository is designed to work with Claude for AI-assisted development:

1. Share your changes or ideas with Claude
2. Claude can help modify the HTML/CSS/JS or streaming scripts
3. Run `./scripts/deploy.sh` to publish website changes
4. Copy streaming scripts to Jetson manually

## Stream Configuration

The live player connects to MediaPackage at:
```
https://vwgvyk.egress.t7c7zl.mediapackagev2.us-east-1.amazonaws.com/out/v1/channel-group-FY/channel-FY/standard-hls/manifest.m3u8
```
