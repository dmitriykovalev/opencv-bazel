.PHONY: build clean

build:
	bazel build --define=multiarch=$(shell gcc -print-multiarch) \
	            //:convexhull

clean:
	rm -f bazel-*
