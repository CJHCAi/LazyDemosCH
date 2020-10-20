##支持Gif图的UIImageView
####示例图
![gifUIImageView](https://github.com/ashen-zhao/asGifImageView/blob/master/ASGifUIImageView/screenshot.gif)  
####功能说明：
这是一个UIImageView的分类，可以让UIImageView支持显示本地Gif以及网络Gif图片。
####使用说明
1.导入分类头文件 `#import "UIImageView+ASGif.h"`  
2.调用  
&emsp;a.显示本地gif图片   
	`[self.gifImgV showGifImageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"abc" ofType:@"gif"]]];`  
&emsp;b.显示网络gif图片  
	   `[self.gifImgV showGifImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/large/85cccab3gw1etdi67ue4eg208q064n50.gif"]];`