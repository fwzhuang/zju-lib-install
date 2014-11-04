#! /bin/bash 

# Author: Tengfei Jiang 
# This script is to compile the geo_sim_sdk
# Due to the complex dependence, compiling geo_sim_sdk becomes a time-consuming thing, this script may save your time.
# If you meet any problem, or want it to do more thing, please contact me: jiangtengfei@zjucadcg.cn


#########################################################
################# basical libraries #####################
for lib in build-essential minpack-dev libpetsc3.4.2-dev libf2c2-dev libglib2.0-dev libatlas3gf-base libatlas-dev libboost-dev doxygen subversion cmake
do
    sudo apt-get install $lib    
done

INSTALL_PREFIX=${HOME}/usr
GEO_LIB_PATH=${HOME}/usr/geo_sim_sdk
BUILD_TYPE=release

mkdir $GEO_LIB_PATH
cd $GEO_LIB_PATH
svn co http://10.76.1.125:8080/svn/geo_sim_sdk/ .

#########################################################
#### begin to install zju libraries #####################
cd $GEO_LIB_PATH
cp usr/share $INSTALL_PREFIX -r
cp usr/share/maxima $HOME/.maxima -r

cd 3rd/modification
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_CXX_FLAGS=-fPIC -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ..
for dir in alglib ann HLBFGS laspack liblbfgs mesquite-2.2.0 qp verdict
do
    cd $dir
    make install
    cd ..
done 

cd $INSTALL_PREFIX/include
if [ ! -f "clapack.h" ]; then
  wget www.netlib.org/clapack/clapack.h
fi

cd $GEO_LIB_PATH/trunk
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ..

for dir in zjucad/matrix zjucad/ptree hjlib/sparse hjlib/function hjlib/math_func jtflib/util jtflib/math  hjlib/math zjucad/linear_solver jtflib/mesh hjlib/half_edge jtflib/function jtflib/optimizer
do 
    cd $dir
    make install
    cd ../../
done

for dir in zjucad hjlib jtflib
do 
    cd $dir
    make install
    cd ../
done
