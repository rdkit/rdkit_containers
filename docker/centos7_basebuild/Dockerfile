FROM centos7_base
LABEL maintainer="Greg Landrum <greg.landrum@t5informatics.com>"


ENV LANG C


ENV RDBASE=/src/rdkit
ENV LD_LIBRARY_PATH=/lib64:$RDBASE/lib
RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

# ready to build:
RUN cmake3 -DBoost_LIBRARY_DIR=/usr/lib64/boost169 -DBoost_INCLUDE_DIR=/usr/include/boost169 \
-DPYTHON_EXECUTABLE=/usr/bin/python3 -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON \
-DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_PYTHON_WRAPPERS=OFF ..
RUN make -j4 install
RUN ctest3 -j4 --output-on-failure




