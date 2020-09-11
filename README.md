# os-kernel-bid-supplier-wbvue

## 项目简介

招采供应商端前端

## 环境准备

## 工程目录

```
├─assets
│  └─fonts
├─env
├─i18n
├─images
├─ios
│  ├─Flutter
│  ├─Runner
│  │  ├─Assets.xcassets
│  │  │  ├─AppIcon.appiconset
│  │  │  └─LaunchImage.imageset
│  │  └─Base.lproj
│  ├─Runner.xcodeproj
│  │  ├─project.xcworkspace
│  │  │  └─xcshareddata
│  │  └─xcshareddata
│  │      └─xcschemes
│  └─Runner.xcworkspace
│      └─xcshareddata
├─jsons
├─lib
│  ├─common
│  ├─config
│  ├─generated
│  ├─model
│  │  ├─base
│  │  ├─demand_quotation
│  │  ├─goods
│  │  ├─sales_order
│  │  ├─user_center
│  │  └─vo
│  ├─pages
│  │  ├─component
│  │  │  └─select_component.dart
│  │  ├─goods_warehouse
│  │  │  └─detail_page
│  │  ├─offer
│  │  │  ├─add_quote_area
│  │  │  └─select_products
│  │  ├─personal_center
│  │  ├─purchasing_demand
│  │  │  └─details
│  │  ├─quotation
│  │  ├─sales_order
│  │  └─signup
│  ├─provide
│  │  ├─demand_quotation
│  │  ├─sales_order
│  │  └─select
│  ├─routers
│  └─service
└─test
```

## 环境配置文件

工程目录下/env

```
├─env
│      app_dev_config.json
│      app_prod_config.json
│      app_test_config.json
```

- app_dev_config.json ：开发环境请求地址配置
- app_test_config.json ：测试环境请求地址配置
- app_prod_config.json ：生产环境请求地址配置

## 运行

在命令行终端执行:

```
flutter run
```

profile 模式运行:

```
flutter run --profile
```

## 原生命令方式

该命令启动开发环境

```
flutter run -t lib/main_dev.dart
```

该命令启动测试环境

```
flutter run -t lib/main_test.dart
```

## 批处理脚本方式

该命令默认启动开发环境

```
./run_dev.bat
```

该命令指定启动开发环境

```
./run_test.bat
```

该命令指定启动测试环境

## 打包

### 原生命令方式

先清除/build 目录:

```
flutter clean
```

开发环境打包:

```
flutter build apk -t lib/main_dev.dart
```

测试环境打包:

```
flutter build apk -t lib/main_test.dart
```

生产环境打包:

```
flutter build apk -t lib/main_prod.dart
```

### 命令行参数方式

开发环境打包:

```
./tool_package.bat dev
```

测试环境打包:

```
./tool_package.bat test
```

生产环境打包:

```
./tool_package.bat prod
```

### 交互式方式

在终端键入:

```
./tool_package.bat
```

进入交互式菜单:

```
###################### 请选择你的操作!(Please choose your operation !)######################

----------------------1. input "dev" and press the enter button, will package dev apk----------------------
-                        请输入"dev"然后按回车，将打dev环境的apk包

----------------------2. input "test" and press the enter button, will package test apk----------------------
-                        请输入"test"然后按回车，将打dev环境的apk包

----------------------3. input "prod" and press the enter button, will package prod apk----------------------
-                        请输入"prod"然后按回车，将打dev环境的apk包

----------------------4. input "exit" and press the enter button, will exit ----------------------
-                        请输入"exit"然后按回车，将退出本终端

###################### 联系我(CONTACT ME):fenghaolin@utopa.com.cn ######################

Please input:

```

根据提示键入 ：dev 或 test 或 prod
然后按下回车即可.

## 更新日志

**2020-9-11** `feature:` 通过 scheme 协议,实现外链唤起 APP 时动态注入代理 IP 和端口。实现原理参见 confluence：[flutter 通过外链唤起 app 注入代理设置](http://10.186.140.17:8090/pages/viewpage.action?pageId=9374383)

**2020-9-10** `feature:`升级打包脚本 tool_package.bat，支持命令行参数

**2020-9-09** `feature:`重构原有代码实现多环境切换;添加 run_dev.bat、run_test.bat 脚本便于启动不同运行环境;添加 tool_package.bat 脚本便于不同环境打包.

## 联系

**邮箱:** fenghaolin@utopa.com.cn
