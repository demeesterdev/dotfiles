SHELL := bash

.PHONY: all
all: bin dotfiles

.PHONY: bin
bin: ## Installs the bin directory files
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f ); do \
		f=$$(basename $$file); \
		ln -sf $$file $(HOME)/bin/$$f; \
	done

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles
	for file in $(shell find $(CURDIR)/dotfiles -name ".*"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;
