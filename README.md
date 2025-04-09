# GIMP Selection Refiner

A GIMP plugin that uses Meta's Segment Anything Model (SAM) to refine selections.

![Image](https://github.com/user-attachments/assets/5cd938df-5dc3-40b1-87e2-4649a9401c07)

## Features

- Refine selections using Meta's Segment Anything Model (SAM)
- Support for both SAM v1 and SAM v2
- CPU and GPU support
- Multiple model size options
- Simple installation process

## Requirements

- GIMP 3.0 (or later)
- Python 3
- Internet connection for downloading dependencies and models

## Installation

### For Users

1. Download and run the installation script:
   ```bash
   wget https://raw.githubusercontent.com/beniiplayz/GIMP-Selection-Refiner/main/install.sh && chmod +x install.sh && ./install.sh
   ```

   The script will:
   - Check for Python installation
   - Locate your GIMP plugins directory
   - Download and install the plugin files
   - Set up a Python virtual environment
   - Install required dependencies
   - Let you choose between CPU and GPU installation
   - Let you select SAM version (v1 or v2)
   - Download your chosen model

2. Restart GIMP

### For Developers

1. Clone the repository:
   ```bash
   git clone https://github.com/beniiplayz/GIMP-Selection-Refiner.git
   cd GIMP-Selection-Refiner
   ```

2. You can use either the installation script or Makefile:

   Using the installation script:
   ```bash
   ./install.sh
   ```

   Using Makefile:
   ```bash
   # Standard installation
   make install

   # Installation using uv (faster)
   make install-uv
   ```

## Usage

1. Make a selection in GIMP (use Lasso for better results)
2. Go to `Select > Refine Selection using SAM`
3. The plugin will use AI to refine your selection

## Models

### SAM v1 Options
- Base (default)
- Large
- Huge

### SAM v2 Options
- Hiera Small
- Hiera Base Plus (default)
- Hiera Large
