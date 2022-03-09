PY3VERSION := 8
VENVDIR := $(PWD)/venv/py3$(PY3VERSION)
PYBINDIR := $(VENVDIR)/bin
PYTHON := $(VENVDIR)/bin/python3
EXAMPLESDIR := Examples
NOTEBOOKSDIR := Notebooks

NOTEBOOKS := $(filter-out %.run.ipynb, $(shell ls $(NOTEBOOKSDIR)/*.ipynb | sed -e 's| |+|g' | grep -v 'Playground') )
RUN_NOTEBOOKS := $(patsubst %.ipynb, %.run.ipynb, $(NOTEBOOKS))

.PHONY: all venv dist notebooks nbserve
.PHONE: clean clean_venv

all: dist notebooks

dist: dist.zip dist.de.zip dist.en.zip

dist.zip: notebooks Makefile $(wildcard $(EXAMPLESDIR)/*/)
	@rm -f $@
	@zip -r9 $@ Makefile requirements.txt $(EXAMPLESDIR) $(NOTEBOOKSDIR)/*.ipynb $(NOTEBOOKSDIR)/img

dist.%.zip: notebooks Makefile requirements.txt $(wildcard $(EXAMPLESDIR)/*/)
	@rm -f $@
	@zip -r9 $@ Makefile requirements.txt $(EXAMPLESDIR) $(NOTEBOOKSDIR)/*_$(subst dist.,,$(subst .zip,,$@)).*ipynb $(NOTEBOOKSDIR)/img

pdf: $(PDFS)

# Cannot use 'make' dependencies for single notebooks due to spaces in filenames. :-/
notebooks:
	@(cd $(NOTEBOOKSDIR) && ls *.ipynb | fgrep -v .run.ipynb | egrep -v '^(000|9|Generate)[^/]+[.]ipynb$$' | egrep -v '_[a-z][a-z][.]ipynb$$' | while read notebook ; do \
		echo "Processing notebook $${notebook} ..."; \
		target="$${notebook%.ipynb}.run.ipynb"; \
		{ [ -f "$${target}" -a "$${target}" -nt "$${notebook}" ] || $(PYBINDIR)/papermill --no-progress-bar "$${notebook}" "$${target}" || { rm -f "$${target}"; FAILED="$${FAILED} $${notebook}"; } & } ; \
		for language in en de; do \
			langnb="$${notebook%.ipynb}_$${language}.ipynb"; \
			[ -f "$${langnb}" -a "$${langnb}" -nt "$${notebook}" ] \
				|| $(PYBINDIR)/jupyter nbconvert --to selectLanguage --NotebookLangExporter.language=$${language} "$${notebook}" \
				|| { rm -f "$${langnb}" ; FAILED="$${FAILED} $${notebook}" ;}; \
			target="$${langnb%.ipynb}.run.ipynb"; \
			{ [ -f "$${target}" -a "$${target}" -nt "$${langnb}" ] || $(PYBINDIR)/papermill --no-progress-bar "$${langnb}" "$${target}" || { rm -f "$${target}"; FAILED="$${FAILED} $${notebook}"; } & } ; \
		done; \
		wait; \
	done; \
	[ -z "$${FAILED}" ] || exit 1 )

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
	rm -f *~ $(NOTEBOOKSDIR)/*.run.ipynb $(NOTEBOOKSDIR)/*_{de,en}.ipynb

clean_venv:
	rm -fr $(VENVDIR)
