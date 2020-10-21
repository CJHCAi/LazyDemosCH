# UPYUN iOS SDK
[![Build Status](https://travis-ci.org/upyun/ios-sdk.svg?branch=master)](https://travis-ci.org/upyun/ios-sdk)
[![Latest Stable Version](https://img.shields.io/cocoapods/v/UPYUN.svg)](https://github.com/upyun/ios-sdk/releases)
![Platform](http://img.shields.io/cocoapods/p/UPYUN.svg)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](License.md)

UPYUN iOS SDK, 集成:
- [又拍云存储 表单 API接口](http://docs.upyun.com/api/form_api/) 
- [又拍云存储 分块上传接口](http://docs.upyun.com/api/multipart_upload/)

## 运行环境
- iOS 7.0 及以上版本, ARC 模式, 使用系统网络库 NSURLSession 
 
- 如想使用 LivePhot 的相关功能, 要求 iOS 9.1 及以上版本, ARC 模式, (需要 Photos , PhotosUI, MobileCoreServices 等framework , 没有导入会 bulid failed)

## 使用说明：
 1.直接下载, 引入 `UPYUNSDK` 文件夹, `#import "UpYun.h"` 即可使用

 2.通过 CocoaPods 
        ```
	      pod 'UPYUN', '~> 1.0.0'
        ``` , `#import "UpYun.h"` 即可使用


## 参数设置
在 [UPYUNConfig.m](https://github.com/upyun/ios-sdk/blob/master/UpYunSDK/UPYUNConfig.m) 中可以对 SDK 的一些参数进行配置, 通过 CocoaPods 引用的可以通过 ``` [UPYUNConfig sharedInstance].DEFAULT_BUCKET ``` 来进行修改

* `DEFAULT_BUCKET` : 默认空间名（必填项）, 
* `DEFAULT_PASSCODE` : 默认表单 API 功能密钥 , 用户从服务端获取 `signature` 则无须填写
* `DEFAULT_EXPIRES_IN` : 默认当前上传授权的过期时间，单位为“秒” （必填项，较大文件需要较长时间)
* `DEFAULT_RETRY_TIMES` : 失败之后重传次数, 默认2次
* `SingleBlockSize` : 单个分块大小, 默认500KB

**注意: 如果需要在上传的过程中不断变动一些参数值, 建议初始化 `UpYun` 之后, 通过 `UpYun` 的属性来修改**


## 上传接口

> 详细示详见 UpYunSDKDemo 的 [Viewcontroller](https://github.com/upyun/ios-sdk/blob/master/UpYunSDKDemo/UpYunSDKDemo/ViewController.m) 或着 [test](https://github.com/upyun/ios-sdk/blob/master/UpYunSDKDemo/UpYunSDKDemoTests/UpYunSDKDemoTests.m)。
> 
> 详细 LivePhoto 相关使用, 详见 UpYunSDKDemo 的 [UPLivePhotoViewController](https://github.com/upyun/ios-sdk/blob/master/UpYunSDKDemo/UpYunSDKDemo/UPLivePhotoViewController.m) 。

### 文件上传

````
UpYun *uy = [[UpYun alloc] init];
uy.successBlocker = ^(NSURLResponse *response, id responseData) {
  //TODO
};
uy.failBlocker = ^(NSError * error) {
  //TODO
};
uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {
  //TODO
};

[uy.params setObject:@"value" forKey:@"key"];
uy.uploadMethod = UPFormUpload;

[uy uploadFile:'file' saveKey:'saveKey'];
````


### 参数说明：

#### 1、`file` 需要上传的文件
* 可传入类型：
 * `NSData`: 文件数据
 * `NSString`: 本地文件路径
 * `UIImage`: 传入的图片 (*当以此类型传入图片时，都会转成PNG数据，需要其他格式请先转成 `NSData` 传入 或者 传入文件路径 `NSString`*)

#### 2、`saveKey` 要保存到又拍云存储的具体地址
* 可传入类型：
 * `NSString`: 要保存到又拍云存储的具体地址
* 由开发者自己生成 saveKey :
  * 比如 `/dir/sample.jpg`表示以`sample.jpg` 为文件名保存到 `/dir` 目录下；
  * 若保存路径为 `/sample.jpg` , 则表示保存到根目录下；
  * **注意 `saveKey` 的路径必须是以`/`开始的**，下同
* 由开发者传入关键 `key` 由服务器生成 `saveKey` :
  * 比如 `/{year}/{mon}/{filename}{.suffix}` 表示以上传文件完成时服务器年 `{year}` 、月 `{mon}` 最为目录，以传入的文件名 `{filename}` 及后缀 `{.suffix}` 作为文件名保存
  * **特别的** 当参数 `file` 以 `UIImage` 、 `NSData` 类型传入时, `saveKey` 不能带有 `{filename}` 
  * 其他服务器支持的关键 `key` 详见 [save-key详细说明](http://docs.upyun.com/api/form_api/#_4) 

#### 3、`successBlocker` 上传成功回调
* 回调中的参数：
  * `response`: 成功后服务器返回的信息响应
  * `responseData`: 成功后服务器返回的数据 `body` (JSON)格式

#### 4、`failBlocker` 上传失败回调
* 回调中的参数：
  * `error`: 失败后返回的错误信息

#### 5、`progressBlocker` 上传进度回调
* 回调中的参数：
  * `percent`: 上传进度的百分比
  * `requestDidSendBytes`: 已经发送的数据量
 
#### 6、`signatureBlocker` 用户获取 signature 回调
* 回调中的参数：
  * `policy`: 经过处理的 policy 字符串, 用户可以直接上传到用户服务端与 `密钥` 拼接, 
* 返回的参数：
  * `sinature`: 用户服务端使用上传的 `policy` 生成的 sinature , 或者用户自己生成 `sinature`

#### 7、`policyBlocker` 用户获取 policy 回调 
* 返回的参数：
  * `policy`: 用户服务端生成的 `policy` , 或者用户自己生成 `policy`

#### 8、`params` [可选参数](http://docs.upyun.com/api/form_api/#api_1)

#### 9、`uploadMethod` 上传方法选择
* 默认根据文件大小选择表单还是分块上传, 可以通过 `uy.uploadMethod = UPFormUpload` 来选择表单上传, `uy.uploadMethod = UPMutUPload` 来选择分块上传.

#### 10、`dateExpiresIn` 用户服务端生成的过期时间
* 默认用户服务端生成的过期时间,防止手机时间和服务端时间不一致出现的上传错误,一般情况用不上.用户可以自行在上传的时候配置。注意必须符合文档要求



### 错误代码
* `-1997`: 参数 `filepath` , 找不到文件
* `-1998`: 参数 `file` 以 `UIImage` 、 `NSData` 类型传入时, `saveKey` 带有 `{filename}` 
* `-1999`: 参数 `file `以 `UIImage` 、 `NSData`、 `NSString` 外的类型传入
* 其他错误代码详见 [API错误代码表](http://docs.upyun.com/api/errno/)
