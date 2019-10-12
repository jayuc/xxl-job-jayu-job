@ECHO OFF

@REM 打包批处理脚本

echo process start ... 

@REM 项目名
set project_name=xxl-job-jayu-job
@REM 项目路径
set project_path=./%project_name%
@REM 版本号
set project_version=1.0.0

if "%1" == "" (
	echo Error: the mirror version number must be filled in. The first parameter is the project version number.
	goto end
) else (
	set project_version=%1
)

@REM step 1/4:
@REM 获取代码
echo step 1/4: fetch code
if exist ../pom.xml (
	set project_path=../
	echo code already exists
) else (
	if exist %project_path%/pom.xml (
		echo code already exists
	) else (
		git clone https://github.com/jayuc/%project_name%.git
	)
)

cd %project_path%

@REM step 2/4:
@REM 配置
echo setp 2/4: config
copy /y .\doc\application.properties .\src\main\resources\

@REM setp 3/4:
@REM 编译项目
echo setp 3/4: mvn package
call mvn clean package -Dmaven.test.skip=true

@REM setp 4/4:
@REM 构建docker镜像
@REM 注意：DockerFile 中的版本号要配置和项目版本号一致
echo setp 4/4: docker build
copy /y .\doc\Dockerfile .\target\
copy /y .\doc\application.properties .\target\
cd ./target/
docker build -t xxl-job/jayu:%project_version% .
docker save xxl-job/jayu:%project_version% -o xxl_job_jayu_%project_version%.jar

echo "finshed."

@REM 结束
:end