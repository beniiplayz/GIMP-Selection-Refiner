cat:
	cat Makefile

install:
	bash ./install.sh

install_uv:
	bash ./install-uv.sh

clean:
	rm -f ./README.md
	rm -f ./install.sh
	rm -f ./install-uv.sh
	rm -f ./sam_inference.py
	rm -f ./selection_refiner.py
	rm -f ./urls.sh
	rm -f ./Makefile
