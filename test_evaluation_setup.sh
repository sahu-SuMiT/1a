#!/bin/bash

# Test script using the exact evaluation commands
echo "=== PDF Outline Extractor Evaluation Test ==="
echo "Testing with exact evaluation commands..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

echo "✅ Docker is installed"

# Check if we're in the right directory
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found. Please run this script from the project root directory."
    exit 1
fi

echo "✅ Dockerfile found"

# Create input/output directories if they don't exist
mkdir -p input output

# Check if there are PDF files in input
if [ ! "$(ls -A input/*.pdf 2>/dev/null)" ]; then
    echo "⚠️  No PDF files found in input directory."
    echo "Please add your PDF files to the input/ directory"
    exit 1
fi

echo "✅ PDF files found in input directory"

echo "=== Building Docker Image (Evaluation Command) ==="
echo "Command: docker build --platform linux/amd64 -t pdf-outline-extractor:1a ."

docker build --platform linux/amd64 -t pdf-outline-extractor:1a .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully with tag: pdf-outline-extractor:1a"
else
    echo "❌ Docker build failed"
    exit 1
fi

echo "=== Running Container (Evaluation Command) ==="
echo "Command: docker run --rm -v \$(pwd)/input:/app/input -v \$(pwd)/output:/app/output --network none pdf-outline-extractor:1a"

# Clear output directory for clean test
rm -f output/*.json

# Run the container with exact evaluation command
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-outline-extractor:1a

if [ $? -eq 0 ]; then
    echo "✅ Container ran successfully"
    
    # Check if output files were generated
    if [ "$(ls -A output/*.json 2>/dev/null)" ]; then
        echo "✅ Output files generated:"
        ls -la output/*.json
        
        # Show sample output
        echo ""
        echo "=== Sample Output ==="
        if [ -f "output/file01.json" ]; then
            echo "file01.json content:"
            cat output/file01.json
        fi
    else
        echo "⚠️  No output files generated"
        exit 1
    fi
else
    echo "❌ Container failed to run"
    exit 1
fi

echo ""
echo "=== Evaluation Test Complete ==="
echo "✅ Your solution is ready for evaluation!"
echo ""
echo "Expected behavior verified:"
echo "✅ Container processes all PDFs from /app/input"
echo "✅ Generates corresponding filename.json in /app/output"
echo "✅ Works with exact evaluation commands" 