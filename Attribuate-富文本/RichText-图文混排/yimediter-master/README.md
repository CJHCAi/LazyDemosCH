# yimediter

***

一个富文本编辑器。

可以修改字体，颜色，加粗，斜体，对齐方式，行高等，暂时不支持插入图片。支持导出html

![Untitled2.gif](https://i.loli.net/2017/12/04/5a25001e2718a.gif)

> 使用pod安装 pod 'yimediter'

默认只包含苹方和黑体两种iOS内置的中文字体，可以使用
> [[YIMEditerFontFamilyManager defualtManager] regiestFont:@"字体名称"];

如果是自定义字体需要先导入字体到工程，如果是iOS内置字体则不需要

## 使用方式
```
#import "YIMEditerTextView.h"

YIMEditerTextView *textView = [[YIMEditerTextView alloc]init];
textView.frame = self.view.bounds;
[self.view addSubview:textView];

```

## Build List

***

>0.1.0 加入了html转NSAttributedString算法，c之前用的比较少，算法有待改进
