# HYCGuideView
 手图引导图
## podfile
To integrate HYCGuideView into your Xcode project using CocoaPods, specify it in your Podfile:

`$ pod 'HYCGuideView'`

or

`pod 'HYCGuideView', '~> 1.3'`

 或者
 
 `pod 'HYCGuideView'`

Then, run the following command:

`$ pod install`

## Usage
### ImageObject处数组里面的元素为一组手图,一次可添加多张,每一个字典为一张手图,数组内用逗号隔开
```
[self.view addSubview:[[HYCGuideView alloc]initWithaddGuideViewOnWindowImageObject:
      @[@{
          @"image":@"第一张图名字",
          @"frame":[NSValue valueWithCGRect:frame],
          @"color":[[UIColor blackColor] colorWithAlphaComponent:0.8]
          },
          @{
          @"image":@"第二张图片的名字"
          }
          ] isDEBUG:YES]];
```
__isDEBUG__: 设置为NO则为只显示一次即第一次进来展示,调试时不确定位置可设置为YES,建议使用全局宏定义BOOL填写此处

__image__:图片名字

__frame__:(选填) 图片的frame,如果不填则为全屏

__color__:(选填) 手图背景颜色
