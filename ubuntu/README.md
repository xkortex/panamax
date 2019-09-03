## Dependency notes
Since dependencies are currently in flux, this document is meant more as a hint, 
than a definitive dependency list

## Base Image
Frequently used base images (as OS_BASE:OS_VERS tag) :
- ubuntu:xenial, ubuntu:bionic
- nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04


### Python
Python 2 is provided along 3, even though Py2 is [end-of-life](https://pythonclock.org/),
because a lot of legacy CV code/ ROS1 depends on it. It's easier to set up both alongside
each other with `pip` defaulting to `pip2` than to try to ascertain which is installed. 
Best practice is to always specify version number when calling `python` and `pip`,
eg `pip2 install numpy`. Also, please work to upgrade your code to py3 wherever possible. 

### Numpy
[Numpy: building](https://docs.scipy.org/doc/numpy/user/building.html)
- gfortran (maybe), libatlas-base-dev

## OpenCV (as of 4.1.1)
[Tutorial: Linux Install](https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html)
- Required: pkg-config libavcodec-dev libavformat-dev libswscale-dev
- Recommended: python-dev numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev

### Boost
Boost is used by a lot of CV libraries and takes a while to install, even
as a deb. In the `cvfull` image, it is pre-installed since it will likely be used. 