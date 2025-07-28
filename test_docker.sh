#!/bin/bash

# Test script for Docker setup
echo "=== PDF Outline Extractor Docker Test ==="

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
    echo "⚠️  No PDF files found in input directory. Creating a test setup..."
    echo "Please add your PDF files to the input/ directory"
fi

echo "=== Building Docker Image ==="
docker build --platform linux/amd64 -t pdf-outline-extractor:latest .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully"
else
    echo "❌ Docker build failed"
    exit 1
fi

echo "=== Testing Docker Container ==="
echo "Running container with current input files..."

# Run the container
docker run --rm -v "$(pwd)/input:/app/input" -v "$(pwd)/output:/app/output" --network none pdf-outline-extractor:latest

if [ $? -eq 0 ]; then
    echo "✅ Container ran successfully"
    
    # Check if output files were generated
    if [ "$(ls -A output/*.json 2>/dev/null)" ]; then
        echo "✅ Output files generated:"
        ls -la output/*.json
    else
        echo "⚠️  No output files generated (this might be normal if no PDFs were processed)"
    fi
else
    echo "❌ Container failed to run"
    exit 1
fi

echo "=== Test Complete ==="
echo "If you see output files above, your Docker setup is working correctly!" 