
test: ## run tests
	err=0; for t in *_test.sh; do /bin/sh $$t; e=$$?; if [ $$e -ne 0 ]; then echo "^ $$t"; err=$$e; fi; done; exit $$err

lint: ./bin/shfmt ## run shellcheck and other lints
	./scripts/lint.sh

fmt: ./bin/shfmt  ## reformat shell scripts
	./bin/shfmt -ci -p -i 2 -w *.sh

clean:  ## clean up
	rm -rf ./bin
	git gc --aggressive

./bin/shfmt: ./scripts/godownloader-shfmt.sh
	./scripts/godownloader-shfmt.sh

# https://www.client9.com/self-documenting-makefiles/
help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
	printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
	}' $(MAKEFILE_LIST)
.DEFAULT_GOAL=help
.PHONY=help
