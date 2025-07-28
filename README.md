# PDF Outline Extractor

This solution extracts structured outlines from PDF documents, identifying the title and headings (H1-H6) along with their page numbers.

## Features

- Processes PDF files up to 50 pages
- Extracts document title and hierarchical headings (up to 6 levels deep)
- Outputs structured JSON format
- Works completely offline (no internet required)
- Runs efficiently on CPU (no GPU needed)
- Supports multilingual documents (including Japanese)
- Optimized for 8-core CPU systems
- Modular architecture for easy extension and customization
- Advanced pattern-based hierarchy detection for various heading formats
- Contextual heading level validation and correction

## Input Format
input/
├── apple.pdf     
├── banana.pdf  
├── cat.pdf     
└── dog.pdf
- the outputs are generated in output dir... ✔️

## Output Format

```json
{
  "title": "Document Title",
  "outline": [
    { "level": "H1", "text": "First Heading", "page": 1 },
    { "level": "H2", "text": "Subheading", "page": 2 },
    { "level": "H3", "text": "Sub-subheading", "page": 3 },
    { "level": "H4", "text": "Deep Heading", "page": 4 },
    { "level": "H5", "text": "Deeper Heading", "page": 5 },
    { "level": "H6", "text": "Deepest Heading", "page": 6 }
  ]
}
```

## Expected Execution Commands

### Build Command
```bash
docker build --platform linux/amd64 -t pdf-outline-extractor:1a .
```

### Run Command
```bash
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-outline-extractor:1a
```

### Expected Behavior
- **Input**: Place PDF files in the `input/` directory
- **Processing**: Container automatically processes all PDFs from `/app/input`
- **Output**: Generates corresponding `filename.json` files in `/app/output` for each `filename.pdf`

## Quick Start with Docker

### 1. Clone the Repository
```bash
git clone https://github.com/sahu-SuMiT/1a.git
cd 1a
```

### 2. Prepare Your PDF Files
```bash
# Create input directory and add your PDF files
mkdir -p input
# Copy your PDF files to the input directory
cp /path/to/your/pdfs/*.pdf input/
```

### 3. Build the Docker Image
```bash
docker build --platform linux/amd64 -t pdf-outline-extractor:1a .
```

### 4. Run the Container
```bash
# For Linux/Mac
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-outline-extractor:1a

# For Windows (PowerShell)
docker run --rm -v ${PWD}/input:/app/input -v ${PWD}/output:/app/output --network none pdf-outline-extractor:1a

# For Windows (Command Prompt)
docker run --rm -v %cd%/input:/app/input -v %cd%/output:/app/output --network none pdf-outline-extractor:1a

# For Windows (Git Bash) - Use absolute paths for better compatibility
docker run --rm -v "C:\Users\YourUsername\path\to\project\input:/app/input" -v "C:\Users\YourUsername\path\to\project\output:/app/output" --network none pdf-outline-extractor:1a
```

### 5. Check Results
```bash
# View the generated JSON files
ls output/
cat output/your_document.json
```

**✅ Successfully Tested:** The system has been verified to work correctly, processing 5 PDF files and generating corresponding JSON output files with extracted document titles and hierarchical headings (H1-H6) with page numbers.

## Project Structure

```
pdf_outline_extractor/     # Main package
├── core/                  # Core components
│   ├── font_analyzer.py   # Font analysis
│   ├── text_cleaner.py    # Text cleaning
│   ├── heading_detector.py # Heading detection
│   ├── hierarchy_validator.py # Heading hierarchy validation
│   └── page_processor.py  # PDF page processing
└── extractors/            # Extraction strategies
    ├── base.py            # Base extractor interface
    ├── standard.py        # Standard extraction
    ├── fast.py            # Fast extraction for large docs
    └── main.py            # Main entry point

docs/                      # Documentation
tests/                     # Test files
input/                     # Place your PDF files here
output/                    # Generated JSON files appear here
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Docker Build Fails
```bash
# If you get platform-related errors, try:
docker build --platform linux/amd64 -t pdf-outline-extractor:1a .

# If you get permission errors on Linux/Mac:
sudo docker build --platform linux/amd64 -t pdf-outline-extractor:1a .
```

#### 2. Container Can't Access Input Files
```bash
# Make sure the input directory exists and has PDF files:
ls -la input/

# Check if the volume mount is working:
docker run --rm -v $(pwd)/input:/app/input pdf-outline-extractor:1a ls /app/input
```

#### 3. No Output Generated
```bash
# Check if the output directory exists:
mkdir -p output

# Run with verbose logging:
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-outline-extractor:1a
```

#### 4. Performance Issues
```bash
# For large documents, the system will automatically switch to fast mode
# You can monitor performance with:
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-outline-extractor:1a
```

#### 5. Windows Path Issues
If you encounter "No PDF files found" errors on Windows, try using absolute paths:
```bash
# Replace with your actual path
docker run --rm -v "C:\Users\YourUsername\Desktop\Apple\Adobe_hack\1a\1a\input:/app/input" -v "C:\Users\YourUsername\Desktop\Apple\Adobe_hack\1a\1a\output:/app/output" --network none pdf-outline-extractor:1a
```

**Note:** The system automatically detects Docker environment and uses `/app/input` and `/app/output` paths when running in a container.

### Testing with Sample Files

The repository includes sample PDF files in the `input/` directory. You can test the system with these:

```bash
# Run with sample files
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output --network none pdf-outline-extractor:1a

# Check results
ls output/
cat output/file01.json
```

## Manual Installation (Alternative to Docker)

### Prerequisites
- Python 3.9 or higher
- pip

### Installation Steps
```bash
# Clone the repository
git clone https://github.com/sahu-SuMiT/1a.git
cd 1a

# Install dependencies
pip install -r requirements.txt

# Install the package
pip install -e .

# Run the extractor
python main.py
```

## Using as a Library

You can use the extractor as a library in your own Python code:

```python
from pdf_outline_extractor import PDFOutlineExtractor

# Create the extractor
extractor = PDFOutlineExtractor()

# Extract outline from a PDF file
outline = extractor.extract_outline("path/to/your/document.pdf")

# Access the extracted information
print(f"Title: {outline['title']}")
for heading in outline['outline']:
    print(f"{heading['level']}: {heading['text']} (Page {heading['page']})")
```

## Performance Characteristics

- **Processing Speed**: ~1-2 seconds per page for standard documents
- **Memory Usage**: ~50-100MB per document
- **CPU Usage**: Optimized for 8-core systems
- **File Size Limit**: Handles PDFs up to 100MB
- **Page Limit**: Optimized for documents up to 50 pages

## Supported Document Types

- Technical documentation
- Academic papers
- Business reports
- User manuals
- Research papers
- Multilingual documents (including Japanese)

## License

This project is part of the Adobe Hack challenge submission.