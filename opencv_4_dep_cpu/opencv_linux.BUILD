# Bazel is only available for amd64 and arm64 only.

config_setting(
  name = "x86_64-linux-gnu",
  values = {"cpu": "k8"},
)

config_setting(
  name = "aarch64-linux-gnu",
  values = {"cpu": "aarch64"},
)

cc_library(
  name = "opencv",
  hdrs = glob([
      "opencv4/opencv2/**/*.h*",
  ]) + select({
    ":x86_64-linux-gnu":    ["x86_64-linux-gnu/opencv4/opencv2/cvconfig.h"],
    ":aarch64-linux-gnu":   ["aarch64-linux-gnu/opencv4/opencv2/cvconfig.h"],
  },  no_match_error = "Invalid configuration"),
  includes = [
      "opencv4",
  ] + select({
    ":x86_64-linux-gnu":    ["x86_64-linux-gnu/opencv4"],
    ":aarch64-linux-gnu":   ["aarch64-linux-gnu/opencv4"],
  }, no_match_error = "Invalid configuration"),
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
  visibility = ["//visibility:public"],
)
