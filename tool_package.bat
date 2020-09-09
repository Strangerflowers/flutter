@echo off

rem Author: DANTE FUNG
rem DATE: 2020-9-9 18:02:01
rem DESCIPTION: 输出操作菜单
:again
cls
color 03
echo.
echo.
echo ###################### Please choose your operation !######################
echo.
echo ----------------------1. input "dev" and press the enter button, will package dev apk----------------------
echo.
echo ----------------------2. input "test" and press the enter button, will package test apk----------------------
echo.
echo ----------------------3. input "prod" and press the enter button, will package prod apk----------------------
echo.
echo ----------------------4. input "exit" and press the enter button, will exit ----------------------
echo.
echo ###################### CONTACT ME :fenghaolin@utopa.com.cn ######################
echo.
echo Please input:
echo.
set /p env=

if "%env%" == "dev" (
echo.
echo you are trying to package dev apk...
echo.
echo.
echo 1. clean the /build folder...
echo.
flutter clean 
echo.
echo 2. packaging the apk , please take a break ...
echo.
flutter build apk -t lib/main_dev.dart
) else if  "%env%" == "test" (
echo.
echo you are trying to package test apk...
echo.
echo.
echo 1. clean the /build folder...
echo.
flutter clean 
echo.
echo 2. packaging the apk , please take a break ...
echo.
flutter build apk -t lib/main_test.dart
) else if "%env%" == "prod"  (
echo.
echo you are trying to package prod apk...
echo.
echo.
echo 1. clean the /build folder...
echo.
flutter clean 
echo.
echo 2. packaging the apk , please take a break ...
echo.
echo.
flutter build apk -t lib/main_prod.dart
) else if  "%env%" == "exit" (
    echo Bye ~
)






