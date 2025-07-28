#!/usr/bin/env python3
"""
Verification script to test if the PDF outline extractor is properly set up.
"""

import os
import sys
import json
from pathlib import Path

def check_dependencies():
    """Check if all required dependencies are installed."""
    print("🔍 Checking dependencies...")
    
    required_packages = ['pdfplumber', 'numpy']
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package)
            print(f"✅ {package} is installed")
        except ImportError:
            missing_packages.append(package)
            print(f"❌ {package} is missing")
    
    if missing_packages:
        print(f"\n⚠️  Missing packages: {', '.join(missing_packages)}")
        print("Run: pip install -r requirements.txt")
        return False
    
    return True

def check_project_structure():
    """Check if the project structure is correct."""
    print("\n🔍 Checking project structure...")
    
    required_files = [
        'main.py',
        'requirements.txt',
        'setup.py',
        'pdf_outline_extractor/__init__.py',
        'pdf_outline_extractor/extractors/__init__.py',
        'pdf_outline_extractor/core/__init__.py'
    ]
    
    missing_files = []
    for file_path in required_files:
        if os.path.exists(file_path):
            print(f"✅ {file_path} exists")
        else:
            missing_files.append(file_path)
            print(f"❌ {file_path} is missing")
    
    if missing_files:
        print(f"\n⚠️  Missing files: {', '.join(missing_files)}")
        return False
    
    return True

def check_directories():
    """Check if input/output directories exist."""
    print("\n🔍 Checking directories...")
    
    directories = ['input', 'output']
    for directory in directories:
        if os.path.exists(directory):
            print(f"✅ {directory}/ directory exists")
        else:
            print(f"⚠️  {directory}/ directory doesn't exist (will be created when needed)")
    
    return True

def test_import():
    """Test if the package can be imported."""
    print("\n🔍 Testing package import...")
    
    try:
        from pdf_outline_extractor import PDFOutlineExtractor
        print("✅ PDFOutlineExtractor can be imported")
        return True
    except ImportError as e:
        print(f"❌ Failed to import PDFOutlineExtractor: {e}")
        return False

def test_sample_files():
    """Test if sample files exist and can be processed."""
    print("\n🔍 Checking sample files...")
    
    input_dir = Path('input')
    if input_dir.exists():
        pdf_files = list(input_dir.glob('*.pdf'))
        if pdf_files:
            print(f"✅ Found {len(pdf_files)} PDF files in input/")
            for pdf_file in pdf_files[:3]:  # Show first 3
                print(f"   - {pdf_file.name}")
            if len(pdf_files) > 3:
                print(f"   ... and {len(pdf_files) - 3} more")
        else:
            print("⚠️  No PDF files found in input/ directory")
    else:
        print("⚠️  input/ directory doesn't exist")
    
    return True

def main():
    """Run all verification checks."""
    print("🚀 PDF Outline Extractor Setup Verification")
    print("=" * 50)
    
    checks = [
        check_dependencies,
        check_project_structure,
        check_directories,
        test_import,
        test_sample_files
    ]
    
    all_passed = True
    for check in checks:
        if not check():
            all_passed = False
    
    print("\n" + "=" * 50)
    if all_passed:
        print("✅ All checks passed! Your setup is ready.")
        print("\n📋 Next steps:")
        print("1. Add PDF files to the input/ directory")
        print("2. Run: python main.py")
        print("3. Or use Docker: docker build -t pdf-outline-extractor .")
        print("   docker run -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output pdf-outline-extractor")
    else:
        print("❌ Some checks failed. Please fix the issues above.")
        sys.exit(1)

if __name__ == "__main__":
    main() 