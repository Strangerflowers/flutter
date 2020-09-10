@echo off

rem Author: DANTE FUNG
rem DATE: 2020-9-9 18:02:01
rem DESCIPTION: flutter打包脚本工具

REM 声明采用UTF-8编码
chcp 65001
rem 设置命令行参数
SET parameter=%1

if defined parameter (

    echo ---------------------------------/
    echo.
    echo receive the parameter is "%parameter%", executing ...
    echo 接收到的参数为"%parameter%", 执行中 ...
    echo.
    echo 即将为你打%parameter%环境的包哟~
    echo.
    echo ---------------------------------/

    if "%parameter%" == "dev" (
        set env=%parameter%
        goto :PackageRes
    ) else if "%parameter%" == "test" (
        set env=%parameter%
        goto :PackageRes
    ) else if "%parameter%" == "prod" (
        set env=%parameter%
        goto :PackageRes
    ) else (
        echo illegal parameter!
        echo 非法参数!
        goto :eof
    )
) else (
    goto :menu
)

rem 菜单交互模式
:menu
cls
color 03
echo.
echo.
echo ###################### 请选择你的操作!(Please choose your operation !)######################
echo.
echo ----------------------1. input "dev" and press the enter button, will package dev apk----------------------
echo -                        请输入"dev"然后按回车，将打dev环境的apk包
echo.
echo ----------------------2. input "test" and press the enter button, will package test apk----------------------
echo -                        请输入"test"然后按回车，将打dev环境的apk包
echo.
echo ----------------------3. input "prod" and press the enter button, will package prod apk----------------------
echo -                        请输入"prod"然后按回车，将打dev环境的apk包
echo.
echo ----------------------4. input "exit" and press the enter button, will exit ----------------------
echo -                        请输入"exit"然后按回车，将退出本终端
echo.
echo ###################### 联系我(CONTACT ME):fenghaolin@utopa.com.cn ######################
echo.
echo Please input:
echo.
set /p env=

:PackageRes
if "%env%" == "dev" (
echo.
echo you are trying to package dev apk...
echo.
echo.
echo 1. clean the /build folder...
echo 正在清理/build目录的内容，请稍等片刻 ...
echo.
flutter clean 
echo.
echo 2. packaging the apk , please take a break ...
echo 正在努力为您打包apk,  喝杯咖啡等等吧...
echo.
flutter build apk -t lib/main_dev.dart
) else if  "%env%" == "test" (
echo.
echo you are trying to package test apk...
echo.
echo.
echo 1. clean the /build folder...
echo 正在清理/build目录的内容，请稍等片刻 ...
echo.
flutter clean 
echo.
echo 2. packaging the apk , please take a break ...
echo 正在努力为您打包apk,  喝杯咖啡等等吧...
echo.
flutter build apk -t lib/main_test.dart
) else if "%env%" == "prod"  (
echo.
echo you are trying to package prod apk...
echo.
echo.
echo 1. clean the /build folder...
echo 正在清理/build目录的内容，请稍等片刻 ...
echo.
flutter clean 
echo.
echo 2. packaging the apk , please take a break ...
echo 正在努力为您打包apk,  喝杯咖啡等等吧...
echo.
echo.
flutter build apk -t lib/main_prod.dart
) else if  "%env%" == "exit" (
    echo Bye ~
)






