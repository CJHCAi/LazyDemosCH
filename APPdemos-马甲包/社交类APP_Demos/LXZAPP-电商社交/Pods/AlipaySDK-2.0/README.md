AlipaySDK
=========

[Alipay SDK](http://doc.open.alipay.com/doc2/detail?treeId=54&articleId=103419&docType=1)

[支付宝文档](http://doc.open.alipay.com/doc2/detail?spm=0.0.0.0.BPSDYG&treeId=59&articleId=103660&docType=1)

支付宝移动支付 SDK 标准版 from 2.0

由于不太经常关注更新，如果发现有新版更新欢迎PR。Thx

> TIPS:
> 
>  iOS 9 出现支付时不能打开支付宝app反而调用 webview 的情况（支付宝app已安装），请在 `info.plist` 文件的 `LSApplicationQueriesSchemes` key 下增加 `alipay` 和 `alipayshare` 两个值。

###Changelog

####3.0.1.3 (2015-10-26) 非官方

- 增加 ANAlipayResultCode.h 文件，其中包括支付宝文档中所有客户端返回码 - `ANAlipayResultCode`(注意：支付宝支付接口的 callback `resultDict` 中的 code 是字符串类型)。
- 增加 `AlipaySDK-2.0/Order` subspec，其中包括支付订单的创建和RSA签名。如需使用：`pod 'AlipaySDK-2.0/Order'`(默认不包括此 subspec)。


####3.0.1.2 (2015-10-13)

- 支持iOS9 bitcode

####3.0.1 (2015-08-25)

- 适配 iOS 9.0 对于 `canOpenURL` 的限制

####2.2.3 (2015-06-16)

- 提高了埋点数据的代码健壮性

####2.2.2 (2015-06-04)

- 增加客户端数据埋点

####2.2.1 (2015-03-17)

- 修改 `APAuthV2Info.m` 文件，删除数组 `decriptionArray` 中的元素 service = "mobile.securitypay.pay"，该参数无意义。

####2.1.2 (2014-12-08)

- 重置 H5 页面状态栏样式，不受调用方 app 影响。

####2.1.1 (2014-11-21)

- 无线账户授权返回值的解析逻辑，解决 `authcode` 获取不到问题。

####2.1.0 (2014-11-14)

- [解决] iOS 8 中横竖屏不一致。
- [解决] iPad 上跳到 支付宝HD 支付报错。
- [解决] H5 页面在弱网情况下白屏没有进度提示问题
- [新增] Demo中 `libcrypto.a` 和 `libssl.a` 支持 `arm64` 和 `x86_64`。
- [新增] SDK 支持 `arm64` 和 `x86_64。
- [删除] DemoTest 模块文件引用失败编译失败。
