FROM centos7_boostbuild
LABEL maintainer="Greg Landrum <greg.landrum@t5informatics.com>"


# ready to build:
RUN mkdir $RDBASE/build_cffi
WORKDIR $RDBASE/build_cffi
RUN cmake3 -DRDK_BUILD_CFFI_LIB=ON \
-DRDK_BUILD_SWIG_WRAPPERS=OFF -DRDK_BUILD_AVALON_SUPPORT=ON -DRDK_BUILD_INCHI_SUPPORT=ON \
-DRDK_BUILD_THREADSAFE_SSS=ON -DRDK_TEST_MULTITHREADED=ON -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
-DBOOST_ROOT=/opt/boost -DBoost_USE_STATIC_LIBS=ON \
-DBoost_LIBRARY_DIR=/opt/boost/lib -DBoost_INCLUDE_DIR=/opt/boost/include \
-DBoost_NO_BOOST_CMAKE=TRUE -DBoost_NO_SYSTEM_PATHS=ON ..
#
RUN make -j2 cffi_test 
RUN ./Code/MinimalLib/cffi_test

#WORKDIR $RDBASE