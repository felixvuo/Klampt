#!/bin/bash
set -e

# 1. Install System Deps
sudo apt install -y build-essential cmake git libompl-dev libeigen3-dev \
    libode-dev libtinyxml-dev libglpk-dev libassimp-dev libfreeimage-dev libglew-dev

# 2. Setup Environment Variables for Ubuntu 24.04 OMPL
# Find the ompl-1.x folder dynamically
OMPL_DIR=$(find /usr/include -maxdepth 1 -type d -name "ompl-*" | head -n 1)
OMPL_CMAKE_DIR=/usr/share/ompl/cmake
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/usr/include/eigen3:$OMPL_DIR
export USE_OMPL=1


# 3. Build Dependencies (This will now pull YOUR forked KrisLibrary)
cd Cpp/Dependencies
make unpack-deps
make deps

# 4. Build Main Library
cd ../..   # Back to Klampt Root
cmake . -DUSE_OMPL=ON -DOMPL_INCLUDE_DIR=$OMPL_CMAKE_DIR
make -j$(nproc)

# 5. Install Python Bindings
cd Python
pip install . --no-build-isolation -v

echo ">>> Installation Complete!"
