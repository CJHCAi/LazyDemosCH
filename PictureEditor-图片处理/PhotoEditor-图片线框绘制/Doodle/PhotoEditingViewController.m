//
//  PhotoEditingViewController.m
//  Doodle
//
//  Created by 0xfeedface on 16/7/11.
//  Copyright © 2016年 0xfeedface. All rights reserved.
//

#import "PhotoEditingViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

static NSUInteger viewTagValue = DrawViewTagStart;

@interface PhotoEditingViewController () <PHContentEditingController>
@property (strong, nonatomic) UIImageView *selectImage;
@property (strong) PHContentEditingInput *input;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, strong) UIImageView *drawView;
@property (nonatomic, assign) DrawRectType rectType;
@property (nonatomic, assign) UIColor *color;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, assign) CGRect preRect;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImageView *oneTimeView;
@end

@implementation PhotoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PHContentEditingController

- (BOOL)canHandleAdjustmentData:(PHAdjustmentData *)adjustmentData {
    // Inspect the adjustmentData to determine whether your extension can work with past edits.
    // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
    return NO;
}

- (void)startContentEditingWithInput:(PHContentEditingInput *)contentEditingInput placeholderImage:(UIImage *)placeholderImage {
    // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
    // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
    // If you returned NO, the contentEditingInput has past edits "baked in".
    
    self.originImage = [placeholderImage copy];
    CGFloat width;
    CGFloat height;
    
    //调整图片大小
    if (placeholderImage.size.width <= self.view.frame.size.width && placeholderImage.size.height <= self.view.frame.size.height - 128) {
        width = self.view.frame.size.width;
        height = self.view.frame.size.height - 128;
    }   else {
        if (placeholderImage.size.width >= self.view.frame.size.width) {
            width = self.view.frame.size.width;
            height = placeholderImage.size.height * width / placeholderImage.size.width;
            if (height > self.view.frame.size.height - 128) {
                height = self.view.frame.size.height - 128;
                width = placeholderImage.size.width * height / placeholderImage.size.height;
            }
        }   else {
            height = self.view.frame.size.height;
            width = placeholderImage.size.width * height / placeholderImage.size.height;
            if (width > self.view.frame.size.width) {
                width = self.view.frame.size.width;
                height = placeholderImage.size.height * width / placeholderImage.size.width;
            }
        }
    }
    
    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,  width, height)];
    self.selectImage.image = placeholderImage;
    self.selectImage.center = self.view.center;
    [self.view addSubview:self.selectImage];
    
    //遮罩层
    self.drawView.image = [[UIImage alloc] init];
    self.drawView = [[UIImageView alloc] initWithFrame:self.selectImage.frame];
    self.drawView.backgroundColor = [UIColor clearColor];
    self.drawView.userInteractionEnabled = YES;
    [self.view addSubview:self.drawView];
    
    self.oneTimeView = [[UIImageView alloc] init];
    self.oneTimeView.userInteractionEnabled = NO;
    [self.drawView addSubview:self.oneTimeView];
    
    self.rectType = DrawRectTypeRadio;
    self.color = [UIColor redColor];
    
    self.paths = [[NSMutableArray alloc] init];
    
    self.input = contentEditingInput;
}

- (void)finishContentEditingWithCompletionHandler:(void (^)(PHContentEditingOutput *))completionHandler {
    
    [self drawRawView];
    
    // Render and provide output on a background queue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create editing output from the editing input.
        PHContentEditingOutput *output = [[PHContentEditingOutput alloc] initWithContentEditingInput:self.input];
        
        // Provide new adjustments and render output to given location.
        // output.adjustmentData = <#new adjustment data#>;
        // NSData *renderedJPEGData = <#output JPEG#>;
        // [renderedJPEGData writeToURL:output.renderedContentURL atomically:YES];
        
        // Call completion handler to commit edit to Photos.
        //
        CIFilter *filiter = [CIFilter filterWithName:@"CISepiaTone"];
        [filiter setValue:_selectImage.image forKey:@"inputImage"];
        [filiter setValue:[NSNumber numberWithFloat:0] forKey:@"inputIntensity"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"CISepiaTone"];
        output.adjustmentData = [[PHAdjustmentData alloc] initWithFormatIdentifier:@"com.kmvc.PhotoEditor" formatVersion:@"1.0" data:data];
        NSData *jpng = UIImageJPEGRepresentation(_selectImage.image, 1.0);
        
        [jpng writeToURL:output.renderedContentURL atomically:YES];
        completionHandler(output);
        
        // Clean up temporary files, etc.
    });
}

- (BOOL)shouldShowCancelConfirmation {
    // Returns whether a confirmation to discard changes should be shown to the user on cancel.
    // (Typically, you should return YES if there are any unsaved changes.)
    return NO;
}

- (void)cancelContentEditing {
    // Clean up temporary files, etc.
    // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
}

- (IBAction)editPhoto:(id)sender {
    if (viewTagValue > DrawViewTagStart) {
        UIImageView *imageView = [self.drawView viewWithTag:viewTagValue-- - 1];
        [imageView removeFromSuperview];
        [self.paths removeObjectAtIndex:self.paths.count - 1];
    }
}

- (IBAction)cubRect:(id)sender {
    self.rectType = DrawRectTypeCub;
}

- (IBAction)radioRect:(id)sender {
    self.rectType = DrawRectTypeRadio;
}

- (IBAction)red:(id)sender {
    self.color = [UIColor redColor];
}

- (IBAction)blue:(id)sender {
    self.color = [UIColor blueColor];
}

- (IBAction)addText:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入文字"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"填写文字";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *textField = [alert.textFields objectAtIndex:0];
        if (![textField.text isEqualToString:@""]) {
            self.text = textField.text;
        }
        self.rectType = DrawRectTypeText;
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches != nil && touches.count > 0) {
        NSArray *array = [touches allObjects];
        UITouch *touch = array[0];
        UIImageView *imageView = (UIImageView *)touch.view;
        if (imageView == self.drawView) {
            self.startPoint = [touch locationInView:imageView];
        }
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches != nil && touches.count > 0) {
        NSArray *array = [touches allObjects];
        UITouch *touch = array[0];
        UIImageView *imageView = (UIImageView *)touch.view;
        if (imageView == self.drawView) {
            self.movePoint = [touch locationInView:imageView];
            //[self drawSomething];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self drawNewWay:DrawViewTypeDrawImage rectType:_rectType color:_color];
                });
                
            });
            
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches != nil && touches.count > 0) {
        NSArray *array = [touches allObjects];
        UITouch *touch = array[0];
        UIImageView *imageView = (UIImageView *)touch.view;
        if (imageView == self.drawView) {
            self.endPoint = [touch locationInView:imageView];
            //[self drawInImage];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self drawNewWay:DrawViewTypeMiddleImage rectType:_rectType color:_color];
                });
                
            });
        }
    }
}

#pragma mark - 绘图方法

- (void)drawRawView {
    UIImageView *imageView = _selectImage;
    BOOL opaque = NO;
    CGSize size = self.originImage.size;
    CGRect rect = CGRectZero;
    
    //开始绘制
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将图片根据原始大小绘制到上下文
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height)];
    NSArray *array = [self.paths copy];
    for (int i = 0; i < array.count; i++) {
        DrawPath path;
        [array[i] getValue:&path];
        rect = path.rect;
        DrawRectType rectType = path.type;
        UIColor *color = [UIColor colorWithRed:path.red green:path.green blue:path.blue alpha:path.alpha];
        
        //线条宽度转换，因为两个画布的大小不一样，按比例计算
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 2.5 * fabs(imageView.image.size.width / _drawView.frame.size.width));
        
        //转换遮罩层上的大小，对应背景层的大小
        rect.origin.x = rect.origin.x / _drawView.frame.size.width * imageView.image.size.width;
        rect.origin.y = rect.origin.y / _drawView.frame.size.height * imageView.image.size.height;
        rect.size.width = rect.size.width / _drawView.frame.size.width * imageView.image.size.width;
        rect.size.height = rect.size.height / _drawView.frame.size.height * imageView.image.size.height;
        
        [self drawShapWith:rectType context:context rect:rect adjustFont:YES color:color];
        
        //渲染
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

#pragma mark - 绘制文字
- (void)drawTextInRect:(CGRect)rect color:(UIColor *)color adjustFont:(BOOL)adjust {
    
    /*写文字*/
    
    UIFont  *font = [UIFont boldSystemFontOfSize:adjust ? 16.0 * _selectImage.image.size.width / self.view.frame.size.width:16];//定义默认字体
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;//文字居中：发现只能水平居中，而无法垂直居中
    NSDictionary* attribute = @{
                                NSForegroundColorAttributeName:color,//设置文字颜色
                                NSFontAttributeName:font,//设置文字的字体
                                NSKernAttributeName:@0,//文字之间的字距
                                NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
                                };
    
    //计算文字的宽度和高度：支持多行显示
    CGSize sizeText = [_text boundingRectWithSize:rect.size
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                                    NSFontAttributeName:font,//设置文字的字体
                                                    NSKernAttributeName:@0,//文字之间的字距
                                                    }
                                          context:nil].size;
    
    //为了能够垂直居中，需要计算显示起点坐标x,y
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, sizeText.width, sizeText.height);
    [_text drawInRect:newRect withAttributes:attribute];
}

#pragma mark - 绘制形状
- (void)drawShapWith:(DrawRectType)type context:(CGContextRef)context rect:(CGRect)rect adjustFont:(BOOL)adjust color:(UIColor *)color{
    switch (type) {
        case DrawRectTypeRadio:
            CGContextAddEllipseInRect(context, rect); //椭圆
            break;
        case DrawRectTypeCub:
            CGContextAddRect(context, rect); //矩形
            break;
        case DrawRectTypeText:
            [self drawTextInRect:rect color:color adjustFont:adjust];
            break;
        default:
            break;
    }
}

#pragma mark - 测试新绘图方法
- (void)drawNewWay:(DrawViewType)viewType rectType:(DrawRectType)rectType color:(UIColor *)color {
    CGPoint finishedPoint;
    UIImageView *tmpView;
    
    //获取遮罩层和画布大小、移动位置
    switch (viewType) {
        case DrawViewTypeDrawImage:
            finishedPoint = _movePoint;
            tmpView = _oneTimeView;
            break;
        case DrawViewTypeMiddleImage:
            finishedPoint = _endPoint;
            _oneTimeView.image = nil;
            tmpView = [[UIImageView alloc] init];
            [self.drawView insertSubview:tmpView belowSubview:_oneTimeView];
            break;
        default:
            break;
    }
    
    CGRect rect = CGRectZero;
    
    //根据手指位移计算图形大小
    rect.origin = CGPointMake(finishedPoint.x > _startPoint.x ? _startPoint.x:finishedPoint.x, finishedPoint.y > _startPoint.y ? _startPoint.y:finishedPoint.y);
    rect.size = CGSizeMake(fabs(finishedPoint.x - _startPoint.x), fabs(finishedPoint.y - _startPoint.y));
    
    tmpView.frame = rect;
    
    //开始绘制
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (context == 0x0) {
        goto finished;
    }
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.5);
    
    [self drawShapWith:rectType context:context rect:CGRectMake(2.5, 2.5, rect.size.width - 5, rect.size.height - 5) adjustFont:NO color:_color];
    
    //渲染
    CGContextDrawPath(context, kCGPathStroke);
    
    tmpView.image = UIGraphicsGetImageFromCurrentImageContext();
    if (DrawViewTypeMiddleImage == viewType) {
        DrawPath path;
        path.rect = rect;
        path.type = rectType;
        [color getRed:&path.red green:&path.green blue:&path.blue alpha:&path.alpha];
        [self.paths addObject:[NSValue valueWithBytes:&path objCType:@encode(DrawPath)]];
        tmpView.tag = viewTagValue++;
    }
    
finished:
    UIGraphicsEndImageContext();
}

@end
