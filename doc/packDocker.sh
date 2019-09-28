#!/bin/bash

#set -eo pipefail

echo "process start ... "

# 项目名
project_name=xxl-job-jayu-job
# 项目路径
project_path="./${project_name}"
# 版本号
m_version=1.0.0

if [ $1 ]; then
  m_version=$1
else
  echo "镜像版本号必填，第一个参数是项目版本号"
  exit 5
fi

# step 1/4:
# 获取代码
echo "step 1/4: fetch code"
if [ -e ../pom.xml ]; then
  project_path=../
  echo "code already exists"  
else
  if [ -e "./${project_name}/pom.xml" ]; then
    echo "code already exists"
  else
    git clone "https://github.com/jayuc/${project_name}.git"
  fi
fi

# step 2/4:
# 配置
echo "setp 2/4: config"
cd ${project_path}
cp ./doc/application.properties ./src/main/resources/

# setp 3/4:
# 编译项目
echo "setp 3/4: mvn package"
mvn clean package -Dmaven.test.skip=true

# setp 4/4:
# 构建docker镜像
# 注意：DockerFile 中的版本号要配置和项目版本号一致
echo "setp 4/4: docker build"
cp ./doc/Dockerfile ./target/
cp ./doc/application.properties ./target/
cd ./target/
docker build -t "xxl-job/jayu:${m_version}" .
docker save "xxl-job/jayu:${m_version}" -o "xxl_job_jayu_${m_version}.jar"

echo "finshed."

