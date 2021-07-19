.PHONY: build clean

# https://wiki.debian.org/Multiarch/Tuples
build:
	bazel build --copt=-I/usr/include/opencv4 \
	            --copt=-I/usr/include/$(shell gcc -print-multiarch)/opencv4 \
	            --linkopt=-l:libopencv_core.so \
	            --linkopt=-l:libopencv_calib3d.so \
	            --linkopt=-l:libopencv_features2d.so \
	            --linkopt=-l:libopencv_highgui.so \
	            --linkopt=-l:libopencv_imgcodecs.so \
	            --linkopt=-l:libopencv_imgproc.so \
	            --linkopt=-l:libopencv_video.so \
	            --linkopt=-l:libopencv_videoio.so \
	            //:convexhull

clean:
	rm -f bazel-*
