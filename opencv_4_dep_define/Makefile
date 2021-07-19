.PHONY: build clean

# dpkg-architecture -qDEB_HOST_MULTIARCH
build:
	bazel build --define=triplet=$(shell gcc -print-multiarch) \
	            //:convexhull

clean:
	rm -f bazel-*
