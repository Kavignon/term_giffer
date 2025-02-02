#!/bin/bash
set -e  # Exit on any error

# Default values
SPEED=1        # Default playback speed (1x)
FONT_SIZE=20   # Default font size (20 pixels)
OUTPUT_DIR="." # Default: current working directory
DURATION=30    # Default recording time (30s)
SESSION_NAME="$(date +%F_%H-%M-%S)_my_session" # Default: YYYY-MM-DD_HH-MM-SS_my_session
GIF_NAME=""    # Default to session name

usage() {
    echo "Usage: termgiffer <session-name> [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --speed <value>       Playback speed multiplier (default: 1x)"
    echo "  --font-size <value>   Font size in pixels (default: 20)"
    echo "  --output <dir>        Specify output directory (default: current working directory)"
    echo "  --duration <seconds>  Auto-stop recording (default: 30s, must be a positive integer)"
    echo "  --name <gif-name>     Name for the GIF output (default: YYYY-MM-DD_HH-MM-SS_<session-name>)"
    echo "  -h, --help            Show this help message"
    exit 1
}

validate_integer() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: '$1' is not a valid positive integer."
        exit 1
    fi
}

# Check for required dependencies
for cmd in asciinema agg timeout; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ Error: $cmd is not installed."
        exit 1
    fi
done

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --speed)
            validate_integer "$2"
            SPEED="$2"
            shift ;;
        --font-size)
            validate_integer "$2"
            FONT_SIZE="$2"
            shift ;;
        --output)
            OUTPUT_DIR="$2"
            shift ;;
        --duration)
            validate_integer "$2"
            if [[ "$2" -le 0 ]]; then
                echo "❌ Error: Duration must be greater than 0 seconds."
                exit 1
            fi
            DURATION="$2"
            shift ;;
        --name)
            GIF_NAME="$2"
            shift ;;
        -h|--help)
            usage ;;
        *)
            if [[ "$SESSION_NAME" == "$(date +%F_%H-%M-%S)_my_session" ]]; then
                SESSION_NAME="$1"
            else
                echo "❌ Error: Unexpected argument: $1"
                usage
            fi
            ;;
    esac
    shift
done

# If no GIF name was provided, use the session name
if [ -z "$GIF_NAME" ]; then
    GIF_NAME="$SESSION_NAME"
fi

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define file paths
CAST_FILE="${OUTPUT_DIR}/${SESSION_NAME}.cast"
GIF_FILE="${OUTPUT_DIR}/${GIF_NAME}.gif"

# Step 1: Record terminal session with enforced duration
echo "📽️  Recording terminal session (Duration: ${DURATION}s)..."
(script -q -c "asciinema rec --overwrite '$CAST_FILE'" /dev/null) &

PID=$! # Get the process ID of asciinema

# Kill the process after the specified duration
sleep "$DURATION" && kill $PID 2>/dev/null &
wait $PID
echo "✅ Terminal session saved: $CAST_FILE"

# Step 2: Convert to GIF using agg
echo "🎞️  Converting to GIF (Speed: ${SPEED}x, Font size: ${FONT_SIZE}px)..."
agg -speed "$SPEED" --font-size "$FONT_SIZE" "$CAST_FILE" "$GIF_FILE"
echo "✅ GIF saved at: $GIF_FILE"

exit 0
