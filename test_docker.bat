@echo off
echo === PDF Outline Extractor Docker Test ===

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker first.
    exit /b 1
)

echo ✅ Docker is installed

REM Check if we're in the right directory
if not exist "Dockerfile" (
    echo ❌ Dockerfile not found. Please run this script from the project root directory.
    exit /b 1
)

echo ✅ Dockerfile found

REM Create input/output directories if they don't exist
if not exist "input" mkdir input
if not exist "output" mkdir output

REM Check if there are PDF files in input
dir input\*.pdf >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  No PDF files found in input directory. Creating a test setup...
    echo Please add your PDF files to the input\ directory
)

echo === Building Docker Image ===
docker build --platform linux/amd64 -t pdf-outline-extractor:latest .

if %errorlevel% equ 0 (
    echo ✅ Docker image built successfully
) else (
    echo ❌ Docker build failed
    exit /b 1
)

echo === Testing Docker Container ===
echo Running container with current input files...

REM Run the container
docker run --rm -v "%cd%/input:/app/input" -v "%cd%/output:/app/output" --network none pdf-outline-extractor:latest

if %errorlevel% equ 0 (
    echo ✅ Container ran successfully
    
    REM Check if output files were generated
    dir output\*.json >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ Output files generated:
        dir output\*.json
    ) else (
        echo ⚠️  No output files generated (this might be normal if no PDFs were processed)
    )
) else (
    echo ❌ Container failed to run
    exit /b 1
)

echo === Test Complete ===
echo If you see output files above, your Docker setup is working correctly!
pause 