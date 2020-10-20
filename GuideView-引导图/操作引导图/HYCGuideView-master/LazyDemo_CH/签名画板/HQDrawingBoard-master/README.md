# HQDrawingBoard
签名 画板

```
#import <UIKit/UIKit.h>

typedef void(^SaveSuccessBlock)();

@interface HQDrawingView : UIView

// 用来设置线条的颜色
@property (nonatomic, strong) UIColor *color;
// 用来设置线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;
// 用来记录已有线条
@property (nonatomic, strong) NSMutableArray *allLines;

// 初始化相关参数
- (void)initDrawingView;
// back操作
- (void)doBack;
// Forward操作
- (void)doForward;
// 保存Image
- (void)saveImage:(SaveSuccessBlock)saveSuccessBlock;


@end

```

![图片](http://upload-images.jianshu.io/upload_images/661600-81ba5d2ec176f4d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)