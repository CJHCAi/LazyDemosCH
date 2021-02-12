# ZWGraphicView
签名涂鸦画板

# 功能
实际开发中主要用于手写签名及其它绘画涂鸦，最终生成图片，用于上传服务器。

# 文件结构
ZWGraphicView.h 和 ZWGraphicView.m两个文件。
ZWGraphicView.h的代码如下：
```
@interface ZWGraphicView : UIView
{
    CGPoint _start;//起始点
    CGPoint _move;//移动点
    CGMutablePathRef _path;//路径
    NSMutableArray * _pathArray;//保存路径信息
    CGFloat _lineWidth;//线宽
    UIColor * _lineColor;//线的颜色
    BOOL _isDrawLine;//是否有画线
}

/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat  lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  画线路径
 */
@property (nonatomic,strong) NSMutableArray * pathArray;

/**
 *  获取画图
 */
-(UIImage*)getDrawingImg;

/**
 *  清空画板
 */
-(void)clearDrawBoard;

/**
 *  撤销上一次操作
 */
-(void)undoLastDraw;

/**
 *  保存图像至相册
 */
-(void)savePhotoToAlbum;

```
# 用法

#import "ZWGraphicView.h"引入头文件
```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZWGraphicView * drawView = [[ZWGraphicView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    self.graphicView = drawView;
    [self.view addSubview:drawView];
   

}
- (IBAction)savePhoto:(id)sender {
    
    [self.graphicView savePhotoToAlbum];
}

- (IBAction)undo:(id)sender {
    
    [self.graphicView undoLastDraw];
}

- (IBAction)clearAll:(id)sender {
    
    [self.graphicView clearDrawBoard];
}

```
# 演示效果
![image](https://github.com/xzwgithub/ZWGraphicView/blob/master/ZWGraphicViewDemo/ZWGraphicViewDemo/demo演示.gif)

