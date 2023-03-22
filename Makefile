LIBRARY_NAME=$(shell grep -m 1 name pyproject.toml | awk -F" = " '{print $$2}')
LIBRARY_VERSION=$(shell grep __version__ ${LIBRARY_NAME}/__init__.py | awk -F" = " '{print substr($$2,2,length($$2)-2)}')

.PHONY: usage install uninstall
usage:
	@echo "Library: ${LIBRARY_NAME}"
	@echo "Version: ${LIBRARY_VERSION}\n"
	@echo "Usage: make <target>, where target is one of:\n"
	@echo "install:       install the library locally from source"
	@echo "uninstall:     uninstall the local library"
	@echo "check:         peform basic integrity checks on the codebase"
	@echo "python-wheels: build python .whl files for distribution"
	@echo "python-sdist:  build python source distribution"
	@echo "python-clean:  clean python build and dist directories"
	@echo "python-dist:   build all python distribution files"
	@echo "python-testdeploy: build all and deploy to test PyPi"
	@echo "tag:           tag the repository with the current version"

install:
	./install.sh

uninstall:
	./uninstall.sh

check:
	@echo "Checking for trailing whitespace"
	@! grep -IUrn --color "[[:blank:]]$$" --exclude-dir=sphinx --exclude-dir=.tox --exclude-dir=.git --exclude=PKG-INFO
	@echo "Checking for DOS line-endings"
	@! grep -lIUrn --color "" --exclude-dir=.tox --exclude-dir=.git --exclude=Makefile
	@echo "Checking CHANGELOG.md"
	@cat CHANGELOG.md | grep ^${LIBRARY_VERSION}
	@echo "Checking ${LIBRARY_NAME}/__init__.py"
	@cat ${LIBRARY_NAME}/__init__.py | grep "^__version__ = '${LIBRARY_VERSION}'"

tag:
	git tag -a "v${LIBRARY_VERSION}" -m "Version ${LIBRARY_VERSION}"

python-wheels: check
	python3 -m build --wheel

python-sdist: check
	python3 -m build --sdist

python-clean:
	-rm -r dist

python-dist: python-clean python-wheels python-sdist
	ls dist

python-testdeploy: python-dist
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

python-deploy: python-dist
	twine upload dist/*
