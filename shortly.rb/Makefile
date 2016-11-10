.PHONY: test

SPECS = $(shell find spec -name "*.rb")

test: $(SPECS)
$(SPECS): FORCE
	ruby $@

FORCE:
