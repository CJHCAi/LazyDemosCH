//
//  ViewController.m
//  TJImageEditer
//
//  Created by TanJian on 16/8/1.
//  Copyright © 2016年 Joshpell. All rights reserved.
//

#import "MCPosterEditController.h"

#define  kDeviceWidth        [[UIScreen mainScreen] bounds].size.width
#define  kDeviceHeight       [[UIScreen mainScreen] bounds].size.height

#define editViewW kDeviceWidth
#define editViewH (kDeviceHeight - 60)
#define kScaleW  kDeviceWidth/375


@interface MCLabel : UILabel
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,assign) BOOL isLabelMoved;
@end
@implementation MCLabel
@end

@interface MCImageVeiw : UIImageView
@property (nonatomic,strong) UIButton *deleteBtn;
@end
@implementation MCImageVeiw
@end

@interface MCPosterEditController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;
//前期需要的撤销方法，后期取消，功能代码未删除
//@property (weak, nonatomic) IBOutlet UIButton *undoBtn;

@property (weak, nonatomic) IBOutlet UIButton *addLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *picView;

//前期需要的撤销方法，后期取消，功能代码未删除
//@property (weak, nonatomic) IBOutlet UIButton *chooseColorBtn;


//@property (nonatomic,strong) UIImageView *picView;
@property (nonatomic,strong) UIView *colorPickView;
@property (nonatomic,strong) UIImageView *pointerImgView;

@property (nonatomic,strong)UITextField *toolTextField;
@property (nonatomic,strong)MCLabel *currentLabel;
@property (nonatomic,strong)UIButton *labelScaleBtn;
@property (nonatomic,strong)MCImageVeiw *currentImageView;
@property (nonatomic,strong)UIView *currentView;
@property (nonatomic,strong)UILabel *tempLabel;

@property (nonatomic,strong)UIImage *colorImg;
@property (nonatomic,strong)UIImageView *colorImgView;
@property (nonatomic,strong)UIColor *currentColor;

@property (nonatomic,strong)NSMutableArray *labelArr;
@property (nonatomic,strong)NSMutableArray *viewArr;

@property (nonatomic,assign)CGFloat wordsFont;
@property (nonatomic,assign)NSInteger scaleSize;
@property (nonatomic,assign)BOOL appearColorChooser;

@property (nonatomic,assign)BOOL isLabelMoved;

@end

@implementation MCPosterEditController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
    
    [_addLabelBtn addTarget:self action:@selector(addWordsLabel) forControlEvents:UIControlEventTouchUpInside];
    [_addImageBtn addTarget:self action:@selector(choosePicImage) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)backMethod:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextStapMethod:(id)sender {
    
    [self saveCurrentEditingImage];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setupUI{
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(labelEndEditMethod)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self addSwipeRecognizer];
    
    
    _appearColorChooser = NO;
    _wordsFont = 20;
    _scaleSize = 0;
    
    [self addImageToView];
    
    //添加手势，操作文本框或者图片
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(scale:)];
    [self.picView addGestureRecognizer:pinchGestureRecognizer];
    //添加手势旋转
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    
    [self.picView addGestureRecognizer:rotationRecognizer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}


//重新添加右滑手势，不进行操作
- (void)addSwipeRecognizer
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(notDoOnlyThing)];
    
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    
    // 添加手势
    [self.view  addGestureRecognizer:swipeRecognizer];
}

- (void)notDoOnlyThing
{

}

-(void)labelEndEditMethod{
    
    [_toolTextField resignFirstResponder];
    
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp){
        return aImage;
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void)addImageToView{
    
    _picView.image = _editImage;
    _picView.userInteractionEnabled = YES;

}

//视图添加文字编辑区
-(void)addWordsLabel{
    
    if (_currentLabel) {
        _currentLabel.deleteBtn.hidden = YES;
    }
    
    if (!_colorPickView) {
        [self addColorChooser];
    }

    //图片上添加输入框
    MCLabel *wordsLabel = [[MCLabel alloc]initWithFrame:CGRectMake(0, 0, 50, 22)];
    wordsLabel.backgroundColor = [UIColor clearColor];
    wordsLabel.text = @"双击输入文字  ";
    wordsLabel.textColor = [UIColor whiteColor];
    [wordsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:_wordsFont]];
    [wordsLabel sizeToFit];
    
    wordsLabel.frame = CGRectMake(_picView.bounds.size.width*0.5-wordsLabel.bounds.size.width*0.5, _picView.bounds.size.height*0.5-wordsLabel.bounds.size.height*0.5, wordsLabel.bounds.size.width, wordsLabel.bounds.size.height);
    wordsLabel.userInteractionEnabled = YES;
    
    //添加删除按钮
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteCurrentView) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.frame = CGRectMake(CGRectGetWidth(wordsLabel.frame)-10 ,-10, 20, 20);
    
    wordsLabel.isLabelMoved = NO;
    wordsLabel.deleteBtn = deleteBtn;
    [wordsLabel addSubview:deleteBtn];
    [wordsLabel bringSubviewToFront:deleteBtn];
    
    [self addDeleteAndDoneButton:wordsLabel];
    
    //单击手势
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(addOrDeleteEditBtns:)];
    [singleRecognizer setNumberOfTapsRequired:1];
    [wordsLabel addGestureRecognizer:singleRecognizer];
    
    //双击手势
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelEditMethod:)];
    [doubleRecognizer setNumberOfTapsRequired:2];
    [wordsLabel addGestureRecognizer:doubleRecognizer];
    //未检测到双击手势时才监测单击手势
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [wordsLabel addGestureRecognizer:panGestureRecognizer];
    
    
    _currentLabel = wordsLabel;
    _currentView = wordsLabel;
    
    [self.viewArr addObject:wordsLabel];
    [_picView addSubview:wordsLabel];

}

-(void)addImageViewToEditImage:(UIImage *)image{
    
    if (_currentImageView) {
        _currentImageView.deleteBtn.hidden = YES;
    }
    
    MCImageVeiw *imageView = [[MCImageVeiw alloc]initWithImage:image];
    [imageView sizeToFit];
    
    CGFloat width = kDeviceWidth/3 - 10;
    CGFloat tempScale = CGRectGetHeight(imageView.frame)/CGRectGetWidth(imageView.frame);
    if (tempScale<=1) {
        imageView.frame = CGRectMake(_picView.bounds.size.width*0.5-width*0.5, _picView.bounds.size.height*0.5-width*0.5,width, width*tempScale);
    }else{
        imageView.frame = CGRectMake(_picView.bounds.size.width*0.5-width*0.5, _picView.bounds.size.height*0.5-width*0.5,width/tempScale, width);
    }
    
    //添加删除按钮
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteCurrentView) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.frame = CGRectMake(CGRectGetWidth(imageView.frame)-10 ,-10, 20, 20);
    
    imageView.deleteBtn = deleteBtn;
    [imageView addSubview:deleteBtn];
    
    imageView.userInteractionEnabled = YES;
    
    [self addDeleteAndDoneButton:imageView];
    
    //单击
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(addOrDeleteEditBtns:)];
    [singleRecognizer setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:singleRecognizer];
    
    //拖动
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [imageView addGestureRecognizer:panGestureRecognizer];
    
    _currentImageView = imageView;
    _currentView = imageView;
    
    [self.viewArr addObject:imageView];
    [_picView addSubview:imageView];
}

//防止拍照时图片旋转
//- (UIImage *)fixOrientation:(UIImage *)aImage {
//    
////    if (aImage.size.width>120) {
////        
////        aImage = [aImage imageRotatedByDegrees:90];
////        
////    }
////    aImage = [aImage imageRotatedByDegrees:90];
//    return aImage;
//    
//}


-(void)choosePicImage{
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"sorry, no photo library is unavailable.");
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)addDeleteAndDoneButton:(UIView *)view{

    if ([view isKindOfClass:[MCImageVeiw class]]) {
        
        _currentLabel.deleteBtn.hidden = YES;
    }else if([view isKindOfClass:[MCLabel class]]){
        
        _currentImageView.deleteBtn.hidden = YES;
    }
}
//双击进入文字编辑方法
-(void)labelEditMethod:(UITapGestureRecognizer *)recognizer{
    
    UIView *view = recognizer.view;
    _currentView = view;

    if([view isKindOfClass:[MCLabel class]]){
        _currentLabel = (MCLabel *)view;
        _currentLabel.deleteBtn.hidden = NO;
    }
    
    self.toolTextField.delegate = self;

    
    [self.view addSubview:_toolTextField];
    
    if (!_currentLabel.isLabelMoved) {
        [_toolTextField  becomeFirstResponder];
    }else{
        [self showTips:@"请编辑完成后再对文字进行旋转缩放操作"];
    }
}
//拖拽方法
- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    if (_currentLabel) {
        [_toolTextField endEditing:YES];
    }
    
    //如果控件范围超出图片则不能改变frame
//    if (recognizer.view.frame.origin.x >= 0 && recognizer.view.frame.origin.y >= 0 && CGRectGetMaxX(recognizer.view.frame) <= CGRectGetWidth(_picView.frame) && CGRectGetMaxY(recognizer.view.frame) <= CGRectGetHeight(_picView.frame)) {
    
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];

    if (recognizer.view.frame.origin.y < 0 || (recognizer.view.frame.origin.y+recognizer.view.frame.size.height) > _picView.frame.size.height || recognizer.view.frame.origin.x < 0 || (recognizer.view.frame.origin.x + recognizer.view.frame.size.width)>_picView.frame.size.width) {
        [self showTips:@"图片区域外的文字图片部分将不能显示"];
    }
    
}

-(void)showTips:(NSString *)tipsString{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:tipsString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//单击出现编辑按钮
-(void)addOrDeleteEditBtns:(UITapGestureRecognizer *)recognizer{
    
    UIView *view = recognizer.view;
    _currentView = view;
    
    if ([view isKindOfClass:[MCLabel class]]) {
        
        _currentImageView.deleteBtn.hidden = YES;
        _currentImageView = nil;
        
        MCLabel *tempLabel = (MCLabel *)view;
        if (tempLabel == _currentLabel) {
            _currentLabel.deleteBtn.hidden = !_currentLabel.deleteBtn.hidden;
            _currentLabel = nil;
            [self colorPickerViewAppear:NO];
            
        }else{
            _currentLabel.deleteBtn.hidden = YES;
            _currentLabel = tempLabel;
            _currentLabel.deleteBtn.hidden = NO;
            
            [self colorPickerViewAppear:YES];
        }
        
        if (!_currentLabel.deleteBtn.hidden) {
            _currentView = nil;
        }
        [self.picView bringSubviewToFront:_currentLabel];

    }else if([view isKindOfClass:[MCImageVeiw class]]){
        
        _currentLabel.deleteBtn.hidden = YES;
        _currentLabel = nil;
        [self colorPickerViewAppear:NO];
        
        MCImageVeiw *tempImgView = (MCImageVeiw *)view;
        if (_currentImageView == tempImgView) {
            _currentImageView.deleteBtn.hidden = !_currentImageView.deleteBtn.hidden;
            _currentImageView = nil;
        }else{
            _currentImageView.deleteBtn.hidden = YES;
            _currentImageView = tempImgView;
            _currentImageView.deleteBtn.hidden = NO;
        }
        
        if (!_currentImageView.deleteBtn.hidden) {
            _currentView = nil;
        }
        [self.picView bringSubviewToFront:_currentImageView];
    }
}

-(void)colorPickerViewAppear:(BOOL)isAppear{

    [UIView animateWithDuration:0.6 animations:^{
        _colorPickView.alpha = isAppear;
    }];
    

}

//缩放
-(void)scale:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    
    if (_currentView) {
        
        if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            _currentView.transform = CGAffineTransformScale(_currentView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            pinchGestureRecognizer.scale = 1;
            
            //若当前label缩放了则将isLabelMoved置1
            if ([_currentView isKindOfClass:[MCLabel class]]) {
                _currentLabel.isLabelMoved = YES;
            }
        }
    }
}

//label的手势旋转方法
-(void)rotate:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    
    if (_currentView) {
        if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            _currentView.transform = CGAffineTransformRotate(_currentView.transform, rotationGestureRecognizer.rotation);
            [rotationGestureRecognizer setRotation:0];
            
            //若当前label旋转了则将isLabelMoved置1
            if ([_currentView isKindOfClass:[MCLabel class]]) {
                _currentLabel.isLabelMoved = YES;
            }
        }
        
    }
}

-(void)resetUndoBtnAndSaveBtnFrame:(UIView *)currentView{


}

//撤销上一步操作{
-(void)undoLastChange{
    
    if (self.viewArr.count>0) {
        
        if (_currentLabel) {
            _currentLabel.deleteBtn.hidden = YES;
        }
        if (_currentImageView) {
            _currentImageView.deleteBtn.hidden = YES;
        }
        
        UIView *lastView =_viewArr.lastObject;
        
        [lastView removeFromSuperview];
        [self.viewArr removeLastObject];
    }else{
        NSLog(@"已经是最初的图片");
    }
    
    NSLog(@"%ld",(unsigned long)self.viewArr.count);
}

-(void)deleteCurrentView{
    
    if (_currentLabel) {
        [_toolTextField endEditing:YES];
    }
    [_currentView removeFromSuperview];

}


#pragma mark imagepicker代理回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //加在视图中
        [self addImageViewToEditImage:image];
        
    } 
    
}

#pragma mark 保存图片方法
-(void)saveCurrentEditingImage{
    
    [self labelEndEditMethod];
    _currentImageView.deleteBtn.hidden = YES;
    _currentLabel.deleteBtn.hidden = YES;

    [self saveCurrentImage];
    _currentLabel = nil;
    _currentImageView = nil;
    
}

//用原比例截图方法获取新图片
-(void)saveCurrentImage{
    
    // 开启图片类型的图形上下文
    UIGraphicsBeginImageContextWithOptions(_picView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // 获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 获取截图的view的layer对象
    CALayer* layer = _picView.layer;
    [layer renderInContext:ctx];
    
    // 取图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([self.delegate respondsToSelector:@selector(getFinalPoster:)]) {
        [self.delegate getFinalPoster:image];
    }
    
    NSArray *controllerArr = self.navigationController.childViewControllers;
    UIViewController *viewVC = controllerArr[controllerArr.count-3];
    [self.navigationController popToViewController:viewVC animated:YES];
    
}

#pragma mark 颜色条选颜色方法
-(void)addColorChooser{
    
    _colorImgView =[[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.05, 5, kDeviceWidth*0.9, 20)];
    _colorImg = [UIImage imageNamed:@"vitta"];
    _colorImgView.userInteractionEnabled = YES;

    _colorImgView.image = _colorImg;
    
    [self.colorPickView addSubview:_colorImgView];
    [_colorPickView addSubview:self.pointerImgView];
    [self.view addSubview:_colorPickView];
    
    _colorPickView.alpha = 0;
    //下排按钮渐隐，颜色选择器渐现
    [UIView animateWithDuration:0.6 animations:^{
        
        _colorPickView.alpha = 1;
        
    }];
    
    
    
}

-(void)panMethod:(UIPanGestureRecognizer *)pgr
{
    NSLog(@"拖动了图片");
    
    CGPoint point = [pgr translationInView:self.view];
//    NSLog(@"%f",point.x);
    static CGPoint center;
    if (pgr.state ==UIGestureRecognizerStateBegan) {
        
        center = pgr.view.center;
    }
    // pgr.view获取对应的view   view.center获取推动后的view的中心点
    pgr.view.center = CGPointMake(center.x+point.x+10,30);
    
    if (pgr.view.center.x < kDeviceWidth*0.05) {
        pgr.view.center = CGPointMake(kDeviceWidth*0.05,30);
    }
    if (pgr.view.center.x > CGRectGetMaxX(_colorImgView.frame)  ) {
        pgr.view.center = CGPointMake(kDeviceWidth*0.95 ,30);
    }
    
    
//    NSLog(@"center.x == %f",pgr.view.center.x);
    
    _currentColor = [self colorAtPixel:CGPointMake(pgr.view.center.x+10, 10)];
    
    if (_currentLabel) {
        _currentLabel.textColor = _currentColor;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches anyObject].view == _colorImgView) {
        // 判断点击的区域如果不是菜单按钮_btnMenu, 则关闭菜单
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        UITouch *touch = [allTouches anyObject];
        CGPoint point = [touch locationInView:[touch view]];

        
        if (point.x>0&&point.x<_colorImgView.frame.size.width) {
            _pointerImgView.center = CGPointMake(point.x+kDeviceWidth*0.05, 30);
        }
        
        
        _currentColor = [self colorAtPixel:CGPointMake(_pointerImgView.center.x, 10)];
        
        if (_currentLabel) {
            _currentLabel.textColor = _currentColor;
        }

    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches anyObject].view == _colorImgView) {
        // 判断点击的区域如果不是菜单按钮_btnMenu, 则关闭菜单
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        UITouch *touch = [allTouches anyObject];
        CGPoint point = [touch locationInView:[touch view]];

        
        if (point.x>0&&point.x<_colorImgView.frame.size.width) {
            _pointerImgView.center = CGPointMake(point.x+kDeviceWidth*0.05, 30);
        }
        
        _currentColor = [self colorAtPixel:CGPointMake(_pointerImgView.center.x, 10)];
        
        if (_currentLabel) {
            _currentLabel.textColor = _currentColor;
        }
        
    }

}



//像素点颜色获取方法
- (UIColor *)colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = _colorImg.CGImage;
    NSUInteger width = _colorPickView.frame.size.width;
    NSUInteger height = _colorImgView.frame.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark textField代理

- (void) textFieldDidChange:(UITextField *) TextField{
    
    NSLog(@"输入内容%@",TextField.text);
    NSString *newStr = [TextField.text stringByAppendingString:@"  " ];
    
    CGRect lastRect = _currentLabel.frame;
    self.currentLabel.text = newStr;
    [self.currentLabel sizeToFit];
    
    self.currentLabel.frame = CGRectMake(CGRectGetMinX(_currentLabel.frame)-(CGRectGetWidth(_currentLabel.frame)-lastRect.size.width)*0.5, lastRect.origin.y, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
    _currentLabel.deleteBtn.frame = CGRectMake(CGRectGetWidth(_currentLabel.frame)-10 ,-10, 20, 20);
    if (_currentLabel.frame.size.width>=kDeviceWidth) {
        _currentLabel.frame = CGRectMake(0, lastRect.origin.y, kDeviceWidth, _currentLabel.frame.size.height);
        _currentLabel.numberOfLines = 0;
    }
    
    self.tempLabel.text = newStr;
    [_tempLabel sizeToFit];
    _tempLabel.frame = CGRectMake(kDeviceWidth*0.5-_tempLabel.frame.size.width*0.5, 80, _tempLabel.frame.size.width, _tempLabel.frame.size.height);
    if (_tempLabel.frame.size.width>=kDeviceWidth) {
        _tempLabel.frame = CGRectMake(0, 80, kDeviceWidth, _tempLabel.frame.size.height);
        _tempLabel.numberOfLines = 0;
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    textField.text = @"";
    [_tempLabel removeFromSuperview];
    _tempLabel = nil;
    
}


#pragma mark 键盘监听，计算高度
//计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    
    float keyboardH = [self keyboardEndingFrameHeight:notification.userInfo];
    
    float currentLabelBottom = kDeviceHeight-( _picView.frame.origin.y+_currentLabel.frame.origin.y+_currentLabel.frame.size.height);
    
    if (keyboardH<currentLabelBottom) {
        self.tempLabel.hidden = YES;
    }else{
        self.tempLabel.hidden = NO;
    }
    
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    _tempLabel.hidden = YES;
    
}


-(NSMutableArray *)viewArr{
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
}

-(UITextField *)toolTextField{
    if (!_toolTextField) {
        _toolTextField = [[UITextField alloc]initWithFrame:CGRectMake(-200, -200, kDeviceWidth, 22*kScaleW)];
        [_toolTextField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    }
    return _toolTextField;
}

-(UILabel *)tempLabel{
    if (!_tempLabel) {
        
        _tempLabel = [[UILabel alloc]init];
        _tempLabel.text = @"请输入文字";
        _tempLabel.textAlignment = NSTextAlignmentCenter;
        _tempLabel.textColor = [UIColor blackColor];
        _tempLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_tempLabel sizeToFit];
        _tempLabel.frame = CGRectMake(0, 80, kDeviceWidth, _tempLabel.frame.size.height);
        _tempLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tempLabel];
    }
    return _tempLabel;
}

-(UIView *)pointerImgView{
    if (!_pointerImgView) {
        _pointerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth*0.05, 20, 20, 20)];
        _pointerImgView.image = [UIImage imageNamed:@"sanjiao"];
        //创建手势
        _pointerImgView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
        [_pointerImgView addGestureRecognizer:pgr];

    }
    return _pointerImgView;
}

-(UIView *)colorPickView{
    if (!_colorPickView) {
        _colorPickView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kDeviceWidth, 30)];
    }
    return _colorPickView;
}

@end
