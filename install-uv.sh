#!/usr/bin/env bash

pause() {
    read -rp "Press Enter to continue..."
}

quit() {
    read -rp "Press Enter to exit..."
    exit 1
}

check_python() {
    if ! command -v python3 2>&1 >/dev/null; then
        echo "Python is not installed. Please install it and rerun this script."
        quit
    fi
}

find_plugin_dir() {
    PLUGIN_DIR=$(find ~/.config/GIMP -type d -name "plug-ins" | head -n 1)
    if [ -z "$PLUGIN_DIR" ]; then
        echo "GIMP plugins directory not found. Please ensure GIMP is installed and run once."
        quit
    fi
    echo "GIMP plugin directory found: $PLUGIN_DIR"
    pause
}

prepare_plugin_folder() {
    DEST="$PLUGIN_DIR/selection_refiner"
    mkdir -p "$DEST"
    echo "Plugin directory ready at: $DEST"
    cd "$DEST"
    pause
}

download_plugin_files() {
    echo "Downloading required plugin files..."
    wget -O selection_refiner.py "$SELECTION_REFINER"
    wget -O sam_inference.py "$SAM_INFERENCE"
    echo "Plugin scripts downloaded."
}

make_executable() {
    chmod +x selection_refiner.py
}

prompt_device() {
    read -p "Install for CPU or GPU? [cpu/gpu] (default: cpu): " DEVICE
    DEVICE=${DEVICE,,}
    if [[ "$DEVICE" != "gpu" ]]; then
        DEVICE="cpu"
    fi
    echo "Selected device: $DEVICE"
    pause
}

prompt_sam_version() {
    read -p "Install SAM version 1 or 2? [1/2] (default: 2): " SAM_VERSION
    if [[ "$SAM_VERSION" != "1" ]]; then
        SAM_VERSION="2"
    fi
    echo "Selected SAM version: $SAM_VERSION"
    pause
}

install_dependencies() {
    echo "Setting up Python virtual environment..."
    uv venv gimpenv
    source gimpenv/bin/activate

    echo "Installing torch and torchvision..."
    if [[ "$DEVICE" == "cpu" ]]; then
        uv pip install torch torchvision --index-url "$TORCH_INDEX_URL"
    else
        uv pip install torch torchvision
    fi

    if [[ "$SAM_VERSION" == "1" ]]; then
        echo "Installing SAM v1..."
        uv pip install "$PREFIXED_SAM_V1"
    else
        echo "Installing SAM v2..."
        uv pip install sam2
    fi

    deactivate
    echo "Dependencies installed."
    pause
}

prompt_model_download() {
    echo "Choose a model to download:"
    if [[ "$SAM_VERSION" == "1" ]]; then
        echo "1) SAM 1 - Base"
        echo "2) SAM 1 - Large"
        echo "3) SAM 1 - Huge"
        read -p "Enter your choice [1-3] (default: 1): " MODEL_CHOICE
        case $MODEL_CHOICE in
            2)
                wget "$SAM_V1_LARGE"
                ;;
            3)
                wget "$SAM_V1_HUGE"
                ;;
            *)
                wget "$SAM_V1_BASE"
                ;;
        esac
    else
        echo "1) SAM 2.1 - Hiera Small"
        echo "2) SAM 2.1 - Hiera Base Plus"
        echo "3) SAM 2.1 - Hiera Large"
        read -p "Enter your choice [1-3] (default: 2): " MODEL_CHOICE
        case $MODEL_CHOICE in
            1)
                wget "$SAM_V2_SMALL"
                ;;
            3)
                wget "$SAM_V2_LARGE"
                ;;
            *)
                wget "$SAM_V2_BASE"
                ;;
        esac
    fi
    echo "Model downloaded."
}

echo "Starting GIMP Selection Refiner installation..."
pause

source ./urls.sh

check_python
find_plugin_dir
prepare_plugin_folder
download_plugin_files
make_executable
prompt_device
prompt_sam_version
install_dependencies
prompt_model_download

cd ~-
echo "All done!"
echo "To use the plugin, restart GIMP and go to Select > Refine Selection using SAM"

