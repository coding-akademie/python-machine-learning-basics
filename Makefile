PY3VERSION := 8
VENVDIR := $(PWD)/venv/py3$(PY3VERSION)
PYBINDIR := $(VENVDIR)/bin
PYTHON := $(VENVDIR)/bin/python3
NOTEBOOKSDIR := Notebooks

NOTEBOOKS := $(filter-out %.run.ipynb, $(shell ls $(NOTEBOOKSDIR)/*.ipynb | sed -e 's| |+|g' | grep -v 'Playground') )
RUN_NOTEBOOKS := $(patsubst %.ipynb, %.run.ipynb, $(NOTEBOOKS))

.PHONY: all venv dist notebooks nbserve
.PHONE: clean clean_venv

all: dist notebooks

dist: dist.zip

dist.zip: notebooks Makefile
	@rm -f $@
	@zip -9 $@ Makefile requirements.txt $(NOTEBOOKSDIR)/*.ipynb

pdf: $(PDFS)

# Cannot use 'make' dependencies for single notebooks due to spaces in filenames. :-/
notebooks:
	@FAILED= ; ls $(NOTEBOOKSDIR)/*.ipynb | fgrep -v .run.ipynb | egrep -v '/(000|9|Generate)[^/]+[.]ipynb' | while read notebook ; do \
		target="$${notebook%.ipynb}.run.ipynb"; \
		[ -f "$$target" -a "$$target" -nt "$${notebook}" ] || $(PYBINDIR)/papermill "$${notebook}" "$${target}" || { rm -f "$${target}" ; FAILED="$${FAILED} $${notebook}" ;}; \
	done; \
	[ -z "$${FAILED}" ] || echo "Failed notebooks:$${FAILED}" | sed -e 's|$(NOTEBOOKSDIR)/||g'

venv: $(PYBINDIR)

$(PYBINDIR): requirements.txt Makefile
	python3.$(PY3VERSION) -m venv $(VENVDIR)
	touch $(PYBINDIR)  # just in case
	$(PYTHON) -m pip install -U pip setuptools
	$(PYTHON) -m pip install -r requirements.txt
	@for logo_file in $(VENVDIR)/lib/*/site-packages/notebook/static/base/images/logo.png; do \
  		[ -f "$${logo_file}" ] && cp -a CodingAkademie.png "$${logo_file}" || true; \
	done

nbserve: $(PYBINDIR) Makefile
	$(PYTHON) -m jupyter notebook --port=8888  # force port to avoid multiple starts

clean:
	rm -f *~ $(NOTEBOOKSDIR)/*.run.ipynb

clean_venv:
	rm -fr $(VENVDIR)
