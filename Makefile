TEST_INC_PATH::=$(PWD)/testbench
MODULES_FILE::=$(PWD)/all_modules.d

build: $(MODULES_FILE)
	dmd -i -Isrc/ -I$(TEST_INC_PATH) $(MODULES_FILE) src/bdd/runner.d
	./runner

.PHONY: build

$(MODULES_FILE): $(shell find $(PWD)/testbench/ -name "*.d")  $(PWD)/gen_modules.d
	./gen_modules.d -I$(TEST_INC_PATH) -o$@

e:
	echo $(shell find $(PWD)/testbench/ -name "*.d")

.PHONY: e
