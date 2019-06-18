#!/usr/bin/bash 
echo "Cloning ORB_SLAM2 from git "
cd 
mkdir -p slam_ws/src
git clone https://github.com/johnchars/ORB_SLAM2.git ORB2_CWJ
cd ORB_SLAM2/Thirdparty

echo "Pangolin modules compiling ..."
git clone https://github.com/stevenlovegrove/Pangolin.git
sudo apt-get install libglew-dev
sudo apt-get install cmake
sudo apt-get install libpython2.7-dev
cd Pangolin/ && mkdir build && cd build/
cmake ..
cmake --build .
echo "Pangolin install finished"

echo "OpenCV3.4.6 compiling ..."
cd ../..
git clone https://github.com/opencv/opencv.git
sudo apt-get install build-essential
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
cd opencv/ && mkdir build && cd build/
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j4
sudo make install
echo "OpenCV finished sucessfully"

echo "Eigen compiling ..."
cd ../../
git clone https://github.com/eigenteam/eigen-git-mirror.git Eigen
cd Eigen/
git branch -v
git checkout 3.3.6 
mkdir build && cd build 
cmake ..
sudo make install

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

echo "Compiling ROS node of ORB_SLAM2"
cd ../Examples/ROS
echo "export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/xbot/slam_ws/src/ORB2_CWJ/Examples/ROS" >> ~/.bashrc
source ~/.bashrc
./build_ros.sh  
