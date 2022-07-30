.PHONY: all clean

define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

# Put it first so that "make" without argument is like "make help".
help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean:
	rm -fr src/_build/

all: install view

install: ## install the required packages
	pip install -r requirements.txt

book: clean ## build the book
	jupyter-book build content

view: book ## view the book in browser
	$(BROWSER) $$PWD/content/_build/html/index.html

test: ## build the book and tests the links
	jupyter-book build content -W --builder linkcheck
