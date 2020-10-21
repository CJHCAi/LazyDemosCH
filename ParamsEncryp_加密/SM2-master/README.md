# SM2
国密算法的数字签名算法

## 使用说明
在viewController.m找到SM2SignMessage的初始化方法，传入skString(私钥)，IDString(用户A的可辨别标识),Message(待签名的消息),k(产生随机数k)即刻生成消息M的签名(r、s)的合并值。

## 更详细说明
https://www.jianshu.com/p/0dd79fd48012
