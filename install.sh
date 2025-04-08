#!/usr/bin/env bash

pause() {
    read -rp "Press Enter to continue..."
}

quit() {
    read -rp "Press Enter to exit..."
}

check_python() {
    if ! command -v python3 2>&1 >/dev/null; then
        echo "Python is not installed. Please install it and rerun this script."
        quit
        exit 1
    fi
}

find_plugin_dir() {
    PLUGIN_DIR=$(find ~/.config/GIMP -type d -name "plug-ins" | head -n 1)
    if [ -z "$PLUGIN_DIR" ]; then
        echo "GIMP plugins directory not found. Please ensure GIMP is installed and run once."
        quit
        exit 1
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
    wget -O selection_refiner.py https://raw.githubusercontent.com/manu12121999/GIMP-Selection-Refiner/main/selection_refiner.py
    wget -O sam_inference.py https://raw.githubusercontent.com/manu12121999/GIMP-Selection-Refiner/main/sam_inference.py
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
    python3 -m venv gimpenv
    source gimpenv/bin/activate
    python3 -m pip install --upgrade pip

    echo "Installing torch and torchvision..."
    if [[ "$DEVICE" == "cpu" ]]; then
        python3 -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
    else
        python3 -m pip install torch torchvision
    fi

    if [[ "$SAM_VERSION" == "1" ]]; then
        echo "Installing SAM v1..."
        python3 -m pip install git+https://github.com/facebookresearch/segment-anything.git
    else
        echo "Installing SAM v2..."
        python3 -m pip install sam2
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
                wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_l_0b3195.pth
                ;;
            3)
                wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth
                ;;
            *)
                wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth
                ;;
        esac
    else
        echo "1) SAM 2.1 - Hiera Small"
        echo "2) SAM 2.1 - Hiera Base Plus"
        echo "3) SAM 2.1 - Hiera Large"
        read -p "Enter your choice [1-3] (default: 2): " MODEL_CHOICE
        case $MODEL_CHOICE in
            1)
                wget https://dl.fbaipublicfiles.com/segment_anything_2/092824/sam2.1_hiera_small.pt
                ;;
            3)
                wget https://dl.fbaipublicfiles.com/segment_anything_2/092824/sam2.1_hiera_large.pt
                ;;
            *)
                wget https://dl.fbaipublicfiles.com/segment_anything_2/092824/sam2.1_hiera_base_plus.pt
                ;;
        esac
    fi
    echo "Model downloaded."
}

echo "Starting GIMP Selection Refiner installation..."
pause

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
