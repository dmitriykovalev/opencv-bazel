.PHONY: build clean

build:
	bazel build --crosstool_top=@crosstool//:toolchains \
	            --compiler=gcc \
	            --cpu=k8 \
	            //:convexhull

build-armhf:
	bazel build --crosstool_top=@crosstool//:toolchains \
	            --compiler=gcc \
	            --cpu=armv7a \
	            //:convexhull

build-arm64:
	bazel build --crosstool_top=@crosstool//:toolchains \
	            --compiler=gcc \
	            --cpu=aarch64 \
	            //:convexhull

clean:
	rm -f bazel-*
