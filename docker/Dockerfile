ARG IMAGE
FROM ${IMAGE}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  zip \
  unzip \
  curl \
  wget \
  git \
  tree \
  vim \
  sudo \
  python3-all \
  python3-numpy \
  ca-certificates \
  software-properties-common \
  libopencv-core-dev \
  libopencv-imgproc-dev \
  libopencv-video-dev \
  libopencv-highgui-dev \
  libopencv-videoio-dev \
  libopencv-contrib-dev

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 3

RUN wget -O /usr/bin/bazel \
         https://github.com/bazelbuild/bazelisk/releases/download/v1.10.0/bazelisk-linux-$(dpkg --print-architecture) && \
    chmod +x /usr/bin/bazel
