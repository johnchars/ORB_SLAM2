#### 安装与编译ORB—SLAM2

##### 说明

ORB-SLAM2安装使用都十分友好，按照官网教程可以比较容易安装成功，这里记录安装过程，作为一键安装脚本的文字版说明

#####  前期准备

```shell
cd 
mkdir -p slam_ws/src
git clone https://github.com/johnchars/ORB_SLAM2.git ORB2_CWJ
cd ORB_SLAM2/Thirdparty
```



##### Pangolin

```shell
git clone https://github.com/stevenlovegrove/Pangolin.git
sudo apt-get install libglew-dev
sudo apt-get install cmake
sudo apt-get install libpython2.7-dev
cd Pangolin/ && mkdir build && cd build/
cmake ..
cmake --build .
echo "Pangolin install finished"
```

##### OpenCV

```shell
cd ../..
git clone https://github.com/opencv/opencv.git
sudo apt-get install build-essential
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
cd opencv/ && mkdir build && cd build/
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j4
sudo make install
```

##### Eigen

```shell
cd ../../
git clone https://github.com/eigenteam/eigen-git-mirror.git Eigen
cd Eigen/
git branch -v
git checkout 3.3.6 
mkdir build && cd build 
cmake ..
sudo make install
```

##### 编译

```shell
echo "Configuring and building Thirdparty/DBoW2 ..."

cd ../Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j4

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j4

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM2 ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j4                             
```

##### 编译ROS节点

```shell
cd ../Examples/ROS
echo "export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/xbot/slam_ws/src/ORB2_CWJ/Examples/ROS" >> ~/.bashrc
source ~/.bashrc
./build_ros.sh
```

##### 错误说明

直接编译raulmur/ORB_SLAM2的package可能会出现的两个错误

- 'usleep' not declared

在Examples/Monocular/mono_euroc.cc mono_tum.cc, Examples/RGB-D/rgbd_tum.cc, Examples/Stereo/stereo_euroc.cc stereo_kitti.cc 及 src/ LocalMapping.cc LoopClosing.cc, System.cc

Tracking.cc Viewer.cc中增加头文件

`#include <unistd.h>`

- '_ZN5boost6system15system_categoryEv' 和 DSO missing from command line

在Examples/ROS/ORB_SLAM2/CMakeLists.txt中修改如下

```txt
set(LIBS 
${OpenCV_LIBS} 
${EIGEN3_LIBS}
${Pangolin_LIBRARIES}
${PROJECT_SOURCE_DIR}/../../../Thirdparty/DBoW2/lib/libDBoW2.so
${PROJECT_SOURCE_DIR}/../../../Thirdparty/g2o/lib/libg2o.so
${PROJECT_SOURCE_DIR}/../../../lib/libORB_SLAM2.so
-lboost_system #adding this line
)
```

