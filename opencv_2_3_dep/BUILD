cc_binary(
  name = "convexhull",
  srcs = ["convexhull.cpp"],
  deps = [":opencv"],
)

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
