LIBRARY_NAME=$(shell grep -m 1 name pyproject.toml | awk -F" = " '{print $$2}')
LIBRARY_VERSION=$(shell grep __version__ ${LIBRARY_NAME}/__init__.py | awk -F" = " '{print substr($$2,2,length($$2)-2)}')

.PHONY: usage install uninstall
usage:
	@echo "Library: ${LIBRARY_NAME}"
	@echo "Version: ${LIBRARY_VERSION}\n"
	@echo "Usage: make <target>, where target is one of:\n"
	@echo "install:      install the library locally from source"
	@echo "uninstall:    uninstall the local library"
	@echo "check:        peform basic integrity checks on the codebase"
	@echo "build-deps:   install essential python build dependencies"
	@echo "wheel:        build python .whl files for distribution"
	@echo "sdist:        build python source distribution"
	@echo "clean:        clean python build and dist directories"
	@echo "dist:         build all python distribution files"
	@echo "testdeploy:   build all and deploy to test PyPi"
	@echo "deploy:       build all and deploy to PyPi"
	@echo "tag:          tag the repository with the current version"

install:
	./install.sh --unstable

uninstall:
	./uninstall.sh

pytest:
	tox -e py

qa:
	tox -e qa

build-deps:
	python3 -m pip install build

check:
	@echo "Checking for trailing whitespace"
	@! grep -IUrn --color "[[:blank:]]$$" --exclude-dir=dist --exclude-dir=.tox --exclude-dir=.git --exclude=PKG-INFO
	@echo "Checking for DOS line-endings"
	@! grep -lIUrn --color "" --exclude-dir=dist --exclude-dir=.tox --exclude-dir=.git --exclude=Makefile
	@echo "Checking CHANGELOG.md"
	@cat CHANGELOG.md | grep ^${LIBRARY_VERSION}
	@echo "Checking ${LIBRARY_NAME}/__init__.py"
	@cat ${LIBRARY_NAME}/__init__.py | grep "^__version__ = '${LIBRARY_VERSION}'"

tag:
	git tag -a "v${LIBRARY_VERSION}" -m "Version ${LIBRARY_VERSION}"

wheel: check
	python3 -m build --wheel

sdist: check
	python3 -m build --sdist

clean:
	-rm -r dist

dist: clean wheel sdist
	ls dist

testdeploy: dist
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

deploy: dist
	twine upload dist/*
