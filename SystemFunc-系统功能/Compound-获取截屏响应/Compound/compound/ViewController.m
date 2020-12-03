//
//  ViewController.m
//  compound
//
//  Created by 超级腕电商 on 2017/8/7.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation ViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.frame  = CGRectMake(10, 100, self.view.frame.size.width-20, 300);
    [self.view addSubview:self.scrollView];
    
    //图片展示
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.image = [self addImage:[UIImage imageNamed:@"温心1.jpg"] toImage:[UIImage imageNamed:@"赵艺2.jpg"]];
    [self.scrollView addSubview:self.imageView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
}
//截屏响应
-(void)userDidTakeScreenshot:(NSNotification *)notification{
    NSLog(@"检测到截屏");
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    [self imageWithScreenshot:^(UIImage *image) {

        self.imageView.image = [self addImage:image toImage:self.imageView.image];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.imageView.image.size.height) ;
        self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.imageView.image.size.height);
    }];

}
//返回截取到的图片
- (void)imageWithScreenshot:(void (^)(UIImage * image))compete;
{
    [self dataWithScreenshotInPNGFormat:^(NSData *data) {
        if (compete) {
            compete([UIImage imageWithData:data]);
        }
    }];
}

//截取当前屏幕
- (void)dataWithScreenshotInPNGFormat:(void(^)(NSData * data))compete;{
    
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
      
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (compete) {
            compete(UIImagePNGRepresentation(image));
        }
    });
    
}

/**图片拼接*/
- (UIImage *)addImage:(UIImage *)addImage toImage:(UIImage *)toImage {
  
    CGSize drawSize = CGSizeMake(toImage.size.width>addImage.size.width?toImage.size.width:addImage.size.width, toImage.size.height+addImage.size.height);
    UIGraphicsBeginImageContext(drawSize);
    
    // Draw image1
    [toImage drawInRect:CGRectMake((drawSize.width-toImage.size.width)/2, 0, toImage.size.width, toImage.size.height)];
    
    // Draw image2
    [addImage drawInRect:CGRectMake((drawSize.width-addImage.size.width)/2, toImage.size.height, addImage.size.width, addImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


#pragma mark getter
-(UIImageView*)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.contentMode = UIViewContentModeTop;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
-(UIScrollView*)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor purpleColor];
    }
    return _scrollView;
}


@end
