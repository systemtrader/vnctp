cmake_minimum_required(VERSION 2.8) # 版本要求
project(vn_ctp_api)     # 项目名称

# 设置使用的编译器
set(CMAKE_BUILD_TYPE "Release")
if (CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++11")
endif ()

# 设置输出目录
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)  # CMAKE_BINARY_DIR 如果是 in source 编译,指得就是工程顶层目录,如果是 out-of-source 编译,指的是工程编译发生的目录
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)

# 使用64位编译
option(USE_64BITS "comiple 64bits" ON)  # option命令为用户提供了一个在ON和OFF中做出选择的选项。如果没有指定初始值，将会使用OFF作为初值。
if (USE_64BITS)
  add_definitions(-DUSE_64BITS)       # 为源文件的编译添加由-D引入的define flag
endif()

# 设置C++ API源文件的所在目录
message("Under unix: " ${CMAKE_SIZEOF_VOID_P})
if (CMAKE_SIZEOF_VOID_P MATCHES "8")  # 检查当前电脑是否是64位的
    set(CTPAPI_PATH api/x64_linux) # 设置ctpapi的搜索路径
endif()
include_directories(${CTPAPI_PATH}) # 添加到include文件的搜索路径
set(CTPAPI_LIBRARY )
find_library(CTPAPI_MD_LIBRARY  # 在CTPAPI_PATH目录查找库文件thostmduserapi，保存在名为CTPAPI_MD_LIBRARY的变量中
  NAMES thostmduserapi
  PATHS ${CTPAPI_PATH})
find_library(CTPAPI_TD_LIBRARY  # 在CTPAPI_PATH目录查找库文件thosttraderapi，保存在名为CTPAPI_TD_LIBRARY的变量中
  NAMES thosttraderapi
  PATHS ${CTPAPI_PATH})
  # 设置编译源文件

set (vnctpmd )
set (vnctptd )

option(BUILD_CTP_MD "build ctp md" ON)  # 增加选项BUILD_CTP_MD，初始值为ON。
if (BUILD_CTP_MD)
  add_definitions(-DBUILD_CTP_MD)
  set(CTP_MD_PATH vnctpmd)  # 设置CTP_MD_PATH变量，即CTP_MD头文件的路径
  include_directories(CTP_MD_PATH)
  set(VN_CTP_MD_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/vnctpmd/vnctpmd.cpp)     # 设置VN_CTP_MD_SOURCE变量，即其cpp源代码的位置
  add_library(vnctpmd SHARED ${VN_CTP_MD_SOURCE}) # 使用指定的源文件向工程中添加一个库。vnctpmd是名称。SHARED库会被动态链接，在运行时被加载。
endif()
option(BUILD_CTP_TD "build ctp td" ON)  # 选项BUILD_CTP_TD 同上
if (BUILD_CTP_TD)
  add_definitions(-DBUILD_CTP_TD)
  set(CTP_TD_PATH vnctptd)
  include_directories(CTP_TD_PATH)
  set(VN_CTP_TD_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/vnctptd/vnctptd.cpp)
  add_library(vnctptd SHARED ${VN_CTP_TD_SOURCE})
endif()

# 设置Python所在的目录，这里使用系统的python3.5
# 如果使用anaconda虚拟环境，lib和include的目录相应修改
set(PYTHON_LIBRARY )
set(PYTHON_INCLUDE_PATH /usr/include/python3.5m)
find_library(PYTHON_LIBRARY
  NAMES python3.5m
  PATHS /usr/lib/x86_64-linux-gnu)
include_directories(${PYTHON_INCLUDE_PATH})

# 链接boost库
set(Boost_USE_MULTITHREADED      ON)    # Boost多线程
find_package(Boost 1.66.0 COMPONENTS python3 locale thread date_time system chrono REQUIRED) # 如果boost库没有完全编译，需要将编译的库明确地指出，否者message(${Boost_LIBRARIES})会出错.这里指出了依赖的boost组件

if(Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIRS})
endif()

# 去掉生成的so文件名中前缀的lib
set_target_properties(vnctpmd PROPERTIES PREFIX "")
set_target_properties(vnctptd PROPERTIES PREFIX "")

# 链接生成.so文件
target_link_libraries(vnctpmd  ${Boost_LIBRARIES} ${PYTHON_LIBRARY} ${CTPAPI_MD_LIBRARY})
target_link_libraries(vnctptd  ${Boost_LIBRARIES} ${PYTHON_LIBRARY} ${CTPAPI_TD_LIBRARY})