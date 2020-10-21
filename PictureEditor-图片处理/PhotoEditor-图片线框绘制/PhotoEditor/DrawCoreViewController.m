//
//  DrawCoreViewController.m
//  PhotoEditor
//
//  Created by 0xfeedface on 16/7/12.
//  Copyright © 2016年 0xfeedface. All rights reserved.
//

#import "DrawCoreViewController.h"

static NSUInteger viewTagValue = DrawViewTagStart;

@interface DrawCoreViewController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UIImageView *selectedImage;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, strong) UIImageView *drawView;
@property (nonatomic, assign) DrawRectType rectType;
@property (nonatomic, assign) UIColor *color;
@property (nonatomic, strong) NSDictionary *colors;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImageView *oneTimeView;
@end

@implementation DrawCoreViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    self.originImage = image;
    self.colors = @{@"红色":[UIColor redColor],@"黄色":[UIColor yellowColor],@"蓝色":[UIColor blueColor],@"绿色":[UIColor greenColor],@"青色":[UIColor grayColor],@"紫色":[UIColor purpleColor],@"橙色":[UIColor orangeColor],@"黑色":[UIColor blackColor],@"白色":[UIColor whiteColor]};
    self.paths = [[NSMutableArray alloc] init];
    self.text = @"";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //定宽算高，最宽为父视图的宽，按比例算高
    CGFloat width = self.originImage.size.width > self.view.frame.size.width ? self.view.frame.size.width : self.originImage.size.width;
    CGFloat height = self.originImage.size.height * width / self.originImage.size.width;
    
    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,  width, height)];
    self.selectedImage.image = self.originImage;
    self.selectedImage.center = self.view.center;
    [self.view addSubview:self.selectedImage];
    
    //遮罩层
    self.drawView.image = [[UIImage alloc] init];
    self.drawView = [[UIImageView alloc] initWithFrame:self.selectedImage.frame];
    self.drawView.backgroundColor = [UIColor clearColor];
    //self.drawView.backgroundColor = [UIColor redColor];
    self.drawView.userInteractionEnabled = YES;
    self.drawView.layer.masksToBounds = YES;
    [self.view addSubview:self.drawView];
    
    //圆形、蓝色
    self.rectType = DrawRectTypeRadio;
    self.color = self.colors[[self.colors allKeys][0]];
    
    //取消
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 28, 100, 60)];
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor]
                  forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    leftBtn.layer.borderColor = [[UIColor blueColor]CGColor];
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.cornerRadius = 4;
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    //完成
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 105, 28, 100, 60)];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor]
                  forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:2];
    rightBtn.layer.borderColor = [[UIColor blueColor]CGColor];
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.cornerRadius = 4;
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    //撤销
    UIButton *rollbackBtn = [[UIButton alloc]initWithFrame:CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width + 5, leftBtn.frame.origin.y, self.view.frame.size.width - (leftBtn.frame.size.width + rightBtn.frame.size.width + 4 * 5), leftBtn.frame.size.height)];
    [rollbackBtn setBackgroundColor:[UIColor whiteColor]];
    [rollbackBtn setTitle:@"撤销" forState:UIControlStateNormal];
    rollbackBtn.titleLabel.textColor = [UIColor blackColor];
    rollbackBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    rollbackBtn.layer.borderColor = [[UIColor blueColor]CGColor];
    rollbackBtn.layer.borderWidth = 1;
    rollbackBtn.layer.cornerRadius = 4;
    [rollbackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rollbackBtn addTarget:self action:@selector(rollback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rollbackBtn];

    
    //形状
    UIButton *upBtn = [[UIButton alloc]initWithFrame:CGRectMake( 5, self.view.frame.size.height - 65, 100, 60)];
    [upBtn setBackgroundColor:[UIColor whiteColor]];
    [upBtn setTitle:@"椭圆" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor blueColor]
                  forState:UIControlStateNormal];
    upBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    upBtn.layer.borderColor = [[UIColor blueColor]CGColor];
    upBtn.layer.borderWidth = 1;
    upBtn.layer.cornerRadius = 4;
    [upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(shap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
    
    //颜色
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 105, self.view.frame.size.height - 65, 100, 60)];
    [downBtn setBackgroundColor:[UIColor whiteColor]];
    [downBtn setTitle:[self.colors allKeys][0] forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor blueColor]
                forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    downBtn.layer.borderColor = [[UIColor blueColor]CGColor];
    downBtn.layer.borderWidth = 1;
    downBtn.layer.cornerRadius = 4;
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(colorChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];

    self.oneTimeView = [[UIImageView alloc] init];
    self.oneTimeView.userInteractionEnabled = NO;
    [self.drawView addSubview:self.oneTimeView];
}

#pragma mark - 返回
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 撤销
- (void)rollback {
    if (viewTagValue > DrawViewTagStart) {
        UIImageView *imageView = [self.drawView viewWithTag:viewTagValue-- - 1];
        [imageView removeFromSuperview];
        [self.paths removeObjectAtIndex:self.paths.count - 1];
    }
}

#pragma mark - 保存
- (void)save {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示:" message:@"正在保存" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self drawRawView];
    self.loadImage(self.selectedImage.image);
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [self goBack];
}

#pragma mark - 添加文字
- (void)addText:(UIButton *)btn {
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

#pragma mark - 形状
- (void)shap:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择图形" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camaraAction = [UIAlertAction actionWithTitle:@"椭圆" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.rectType = DrawRectTypeRadio;
        [btn setTitle:@"椭圆" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"矩形" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.rectType = DrawRectTypeCub;
        [btn setTitle:@"矩形" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *textAction = [UIAlertAction actionWithTitle:@"文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.rectType = DrawRectTypeText;
        [btn setTitle:@"文字" forState:UIControlStateNormal];
        [self addText:btn];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:camaraAction];
    [alert addAction:libraryAction];
    [alert addAction:textAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 颜色改变
- (void)colorChange:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择颜色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSArray *array = [self.colors allKeys];
    for (int i = 0; i < array.count; i++) {
        NSString *key = array[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            self.color = self.colors[key];
            [btn setTitle:array[i] forState:UIControlStateNormal];
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIImageView *imageView = _selectedImage;
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
    
    UIFont  *font = [UIFont boldSystemFontOfSize:adjust ? 16.0 * _selectedImage.image.size.width / self.view.frame.size.width:16];//定义默认字体
    
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
    
    //获取遮罩层画布大小、移动位置
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
    
    //绘图上下文获取失败则跳转
    if (context == 0x0) {
        goto finished;
    }
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.5);
    
    [self drawShapWith:rectType context:context rect:CGRectMake(2.5, 2.5, rect.size.width - 5, rect.size.height - 5) adjustFont:NO color:_color];
    
    //渲染
    CGContextDrawPath(context, kCGPathStroke);
    
    tmpView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //手指绘图结束则纪录该绘图信息
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
