SHELL := bash

.PHONY: all
all: bin dotfiles

.PHONY: bin
bin: ## Installs the bin directory files
	# add aliases for things in bin 
	mkdir -m 700 -p "$(HOME)/bin" ;\
	for file in $(shell find $(CURDIR)/bin -type f ); do \
		f=$$(basename $$file); \
		ln -sf $$file $(HOME)/bin/$$f; \
	done

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles
	for file in $(shell find $(CURDIR)/dotfiles -type f -name "**.*"); do \
		p=$$(realpath --relative-to="$(CURDIR)/dotfiles" $$file); \
		d=$$(dirname $$p); \
		f=$$(basename $$file); \
		if [ $$d != '.' ] && [ ! -d $$d ]; then \
			mkdir -m 700 -p $(HOME)/$$d; \
	    fi; \
		ln -sfn $$file $(HOME)/$$p; \
	done;
