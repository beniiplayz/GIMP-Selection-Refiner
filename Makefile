PLUGIN_DIR := $(shell find ~/.config/GIMP -type d -name "plug-ins" | head -n 1)

cat:
	cat Makefile

install:
	bash ./install.sh

install_uv:
	bash ./install-uv.sh

clean_plugin:
	@if [ -z "$(PLUGIN_DIR)" ]; then \
		echo "GIMP plugins directory not found. Please ensure GIMP is installed and run once."; \
		exit 1; \
	fi
	@rm -rf "$(PLUGIN_DIR)"/selection_refiner

clean:
	rm -f ./README.md
	rm -f ./install.sh
	rm -f ./install-uv.sh
	rm -f ./sam_inference.py
	rm -f ./selection_refiner.py
	rm -f ./urls.sh
	rm -f ./Makefile
