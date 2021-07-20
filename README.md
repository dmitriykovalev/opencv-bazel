# Build OpenCV projects using Bazel on Linux

## OpenCV Packages

Many Linux distributions have OpenCV packages. Debian-based ones:

OS                   | OpenCV
-------------------- | ------
Debian 9 (stretch)   | 2.4
Debian 10 (buster)   | 3.2
Debian 11 (bullseye) | 4.5
Ubuntu 16.04 LTS     | 2.4
Ubuntu 18.04 LTS     | 3.2
Ubuntu 20.04 LTS     | 4.2
Ubuntu 21.04         | 4.5

Install OpenCV:
```bash
sudo apt-get install -y \
  libopencv-core-dev \
  libopencv-highgui-dev \
  libopencv-calib3d-dev \
  libopencv-features2d-dev \
  libopencv-imgproc-dev \
  libopencv-video-dev
```

Check where OpenCV header files are located:
```bash
dpkg -L libopencv-core-dev | grep 'include/'
```

Checek where OpenCV shared libraries are located:
```bash
dpkg -L libopencv-core-dev | grep 'lib/'
```

Get the version of currently installed OpenCV:
```bash
apt-cache show libopencv-core-dev
```

Inspect a list of default GCC include directories:
```bash
echo | gcc -xc++ -E -v -
```

Bazel uses the same list of default include directories:
```bash
cat $(bazel info output_base)/external/local_config_cc/builtin_include_directory_paths
```

Inspect a list of default GCC library directories:
```bash
gcc -print-search-dirs | grep 'libraries:'
```

### OpenCV 2/3 Packages

Header files are installed to `/usr/include/opencv2/`. `/usr/include` is a
default include directory (`-I` flag is not needed).

Library files are installed to `/usr/lib/aarch64-linux-gnu/`. This is a default
library directory (`-L` flag is not needed). Link specific OpenCV libraries by
adding `-l` flags:
```bash
-lopencv_core
-lopencv_calib3d
-lopencv_features2d
-lopencv_highgui
-lopencv_imgcodecs
-lopencv_imgproc
-lopencv_video
-lopencv_videoio
```
There are both static `.a` and shared `.so` versions of each library. Shared
library is chosen by default. Usage of *only* shared libraries can be more
explicit:
```bash
-l:libopencv_core.so
-l:libopencv_calib3d.so
-l:libopencv_features2d.so
-l:libopencv_highgui.so
-l:libopencv_imgcodecs.so
-l:libopencv_imgproc.so
-l:libopencv_video.so
-l:libopencv_videoio.so
```

Pay attention that sometimes (e.g. manual compilation) OpenCV
libraries can go to `/usr/local/lib`. This is not a default library directory
for the compiler! You have to pass `-L/usr/local/lib` explicitly in this case.

### OpneCV 4 Packages

Header files are installed to `/usr/include/opencv4/opencv2` and
`/usr/include/<multiarch>/opencv4/opencv2`. Pass additional include directories
to the compiler:
  ```bash
-I/usr/include/opencv4/
-I/usr/include/$(shell gcc -print-multiarch)/opencv4/
```

Library files are installed at the same location as for OpenCV 2/3.

## Bazel Compilation

Pass any compiler flag to Bazel using `--copt=<option>` and linker flag by
using`--linkopt=<option>`.

To compile OpenCV 2/3 project:
```bash
bazel build \
  --linkopt=-l:libopencv_core.so \
  --linkopt=-l:libopencv_calib3d.so \
  --linkopt=-l:libopencv_features2d.so \
  --linkopt=-l:libopencv_highgui.so \
  --linkopt=-l:libopencv_imgcodecs.so \
  --linkopt=-l:libopencv_imgproc.so \
  --linkopt=-l:libopencv_video.so \
  --linkopt=-l:libopencv_videoio.so \
  <bazel-target>
```

To compile OpenCV 4 project:
```bash
bazel build \
  --copt=-I/usr/include/opencv4/ \
  --copt=-I/usr/include/$(shell gcc -print-multiarch)/opencv4/ \
  --linkopt=-l:libopencv_core.so \
  --linkopt=-l:libopencv_calib3d.so \
  --linkopt=-l:libopencv_features2d.so \
  --linkopt=-l:libopencv_highgui.so \
  --linkopt=-l:libopencv_imgcodecs.so \
  --linkopt=-l:libopencv_imgproc.so \
  --linkopt=-l:libopencv_video.so \
  --linkopt=-l:libopencv_videoio.so \
  <bazel-target>
```

Sometimes it is preferable to avoid passing special command flags to Bazel and
use dependency mechanism instead. Passing linker flags is easy:

```python
cc_library(
  name = "opencv",
  linkopts = [
    "-l:libopencv_core.so",
    "-l:libopencv_calib3d.so",
    "-l:libopencv_features2d.so",
    "-l:libopencv_highgui.so",
    "-l:libopencv_imgcodecs.so",
    "-l:libopencv_imgproc.so",
    "-l:libopencv_video.so",
    "-l:libopencv_videoio.so",
  ],
)
```

Include directories are more complicated for OpenCV 4 (OpenCV 2/3 needs nothing).
You have to define `new_local_repository` in the `WORKSPACE` file and point it
to the `/usr/include`:

```python
new_local_repository(
    name = "opencv_linux",
    path = "/usr/include",
    build_file_content = """
cc_library(
  name = "opencv",
  hdrs = glob([
      "opencv4/opencv2/**/*.h*",
      "x86_64-linux-gnu/opencv4/opencv2/cvconfig.h",
  ])
  includes = [
      "opencv4",
      "x86_64-linux-gnu/opencv4"
  ],
  linkopts = [
    "-l:libopencv_core.so",
    "-l:libopencv_calib3d.so",
    "-l:libopencv_features2d.so",
    "-l:libopencv_highgui.so",
    "-l:libopencv_imgcodecs.so",
    "-l:libopencv_imgproc.so",
    "-l:libopencv_video.so",
    "-l:libopencv_videoio.so",
  ],
)
"""
)
```

The tricky part here is a multiarch `x86_64-linux-gnu` value which can be
different for cross-compilation.

## Bazel Cross-Compilation

Cross-compilation is done using
[crosstool](https://github.com/google-coral/crosstool) project. Corresponding
dependency should be added to the [`WORKSPACE`](opencv_cross/WORKSPACE) file.

Pass `--crosstool_top`, `--compiler`, and `--cpu` to cross-compile:
```bash
# Cross-compile to arm64
bazel build --crosstool_top=@crosstool//:toolchains \
            --compiler=gcc \
            --cpu=aarch64 \
            <bazel-target>

# Cross-compile to armhf
bazel build --crosstool_top=@crosstool//:toolchains \
            --compiler=gcc \
            --cpu=armv7a \
            <bazel-target>
```

Mapping between arch/multiarch and Bazel:

arch  | multiarch          | Bazel `--cpu` | Bazel `--cpu` + crosstool
------|--------------------|---------------|--------------------------
amd64 |x86_64-linux-gnu    | k8            | k8
arm64 |aarch64-linux-gnu   | aarch64       | aarch64
armhf |arm-linux-gnueabihf | N/A           | armv7a

Get `arch` value:
```bash
dpkg --print-architecture
```

Get `multiarch` value:
```bash
dpkg-architecture -qDEB_HOST_MULTIARCH
gcc -print-multiarch
```

## Docker Environment

Get docker container shell with OpenCV 3 installed:
```bash
DOCKER_IMAGE=debian:buster ./docker.sh
```

Get docker container shell with OpenCV 4 installed:
```bash
DOCKER_IMAGE=debian:bullseye ./docker.sh
```

Get docker container shell for cross-compiling OpenCV 4 to
[armhf](docker/Dockerfile.armhf) (e.g. [Raspberry Pi](https://www.raspberrypi.org/products/)):
```bash
DOCKER_IMAGE=debian:bullseye DOCKER_FILE=docker/Dockerfile.armhf ./docker.sh
container$ cd opencv_cross
container$ make build-armhf
```

Get docker container shell for cross-compiling OpenCV 4 to
[arm64](docker/Dockerfile.arm64) (e.g. [Coral Dev Board](https://coral.ai/products/dev-board/)):
```bash
DOCKER_IMAGE=debian:bullseye DOCKER_FILE=docker/Dockerfile.arm64 ./docker.sh
container$ cd opencv_cross
container$ make build-arm64
```

Run commands directly in the container by passing arguments to `docker.sh`:
```bash
DOCKER_IMAGE=debian:bullseye ./docker.sh dpkg -L libopencv-core-dev
```
