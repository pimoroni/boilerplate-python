LIBRARY_NAME := $(shell hatch project metadata name 2> /dev/null)
LIBRARY_VERSION := $(shell hatch version 2> /dev/null)

.PHONY: usage install uninstall check pytest qa build-deps check tag wheel sdist clean dist testdeploy deploy
usage:
ifdef LIBRARY_NAME
	@echo "Library: ${LIBRARY_NAME}"
	@echo "Version: ${LIBRARY_VERSION}\n"
else
	@echo "WARNING: You should 'make dev-deps'\n"
endif
	@echo "Usage: make <target>, where target is one of:\n"
	@echo "install:      install the library locally from source"
	@echo "uninstall:    uninstall the local library"
	@echo "dev-deps:     install Python dev dependencies"
	@echo "check:        perform basic integrity checks on the codebase"
	@echo "qa:           run linting and package QA"
	@echo "pytest:       run Python test fixtures"
	@echo "wheel:        build Python .whl files for distribution"
	@echo "sdist:        build Python source distribution"
	@echo "clean:        clean Python build and dist directories"
	@echo "dist:         build all Python distribution files"
	@echo "testdeploy:   build all and deploy to test PyPi"
	@echo "deploy:       build all and deploy to PyPi"
	@echo "tag:          tag the repository with the current version"

install:
	./install.sh --unstable

uninstall:
	./uninstall.sh

dev-deps:
	python3 -m pip install -r requirements-dev.txt
	sudo apt install dos2unix

check:
	@bash check.sh

qa:
	tox -e qa

pytest:
	tox -e py

nopost:
	@bash check.sh --nopost

tag:
	git tag -a "v${LIBRARY_VERSION}" -m "Version ${LIBRARY_VERSION}"

wheel: check
	hatch build --clean --target wheel

sdist: check
	hatch build --clean --target wheel

dist: check
	@hatch build

clean:
	-rm -r dist

testdeploy: dist
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

deploy: nopost dist
	twine upload dist/*
