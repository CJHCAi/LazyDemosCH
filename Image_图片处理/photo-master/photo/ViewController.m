//
//  ViewController.m
//  photo
//
//  Created by apple on 15/12/31.
//  Copyright © 2015年 Sweet. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
@interface ViewController ()
@property(strong, nonatomic)UIView* containView;
@property (nonatomic, strong) UIView* showView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupContainView];
    [self setUpTouchRecognizer];
    [self addMaskView];
}

- (void) setShowView:(UIImageView *)showView{
    if (_showView&&_showView!=showView) {
        [_showView removeFromSuperview];
        _showView = NULL;
    }
    showView.frame = CGRectMake(1, 1, showView.image.size.width/2, showView.image.size.height/2);
    showView.center = CGPointMake(self.containView.frame.size.width/2, self.containView.frame.size.height/2);
    showView.layer.borderColor = [UIColor whiteColor].CGColor;
    showView.layer.borderWidth = 2;
    [self.containView addSubview:showView];
    _showView = showView;
}

- (void)setupContainView{
    self.containView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5, self.view.frame.size.width*0.5, self.view.frame.size.width*0.8 , self.view.frame.size.height*0.5)];
    self.containView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
    self.containView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containView.layer.borderWidth = 2;
    [self.view addSubview:self.containView];
}

-(void)addMaskView{
    
    
    CGSize s= [[UIScreen mainScreen] bounds].size;

    /*
     *画实线
     */
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    solidShapeLayer.lineWidth = 100.f ;
    float lineWidth = solidShapeLayer.lineWidth/2;
    CGPathMoveToPoint(solidShapePath, NULL, s.width/2-self.containView.frame.size.width/2-lineWidth, s.height/3+self.containView.frame.size.height/2+lineWidth);
    CGPathAddLineToPoint(solidShapePath, NULL, s.width/2+self.containView.frame.size.width/2+lineWidth,s.height/3+self.containView.frame.size.height/2+lineWidth);
    CGPathAddLineToPoint(solidShapePath, NULL, s.width/2+self.containView.frame.size.width/2+lineWidth,s.height/3-self.containView.frame.size.height/2-lineWidth);
    CGPathAddLineToPoint(solidShapePath, NULL, s.width/2-self.containView.frame.size.width/2-lineWidth,s.height/3-self.containView.frame.size.height/2-lineWidth);
    CGPathAddLineToPoint(solidShapePath, NULL, s.width/2-self.containView.frame.size.width/2-lineWidth,s.height/3+self.containView.frame.size.height/2+lineWidth);
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.view.layer addSublayer:solidShapeLayer];
    
    [self.view.layer addSublayer:solidShapeLayer];
    
}

- (void) setUpTouchRecognizer{
    [self addGestureRecognizerToView:self.containView];
    //如果处理的是图片
    [self.containView setUserInteractionEnabled:YES];
    [self.containView setMultipleTouchEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)photoButtonTouch:(UIButton *)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展
}
- (IBAction)imgButtongTouch:(UIButton *)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展
}

#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self setShowView:[[UIImageView alloc] initWithImage:image]];
    
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = self.showView;
    if (!view) {
        return;
    }
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showView;
    if (!view) {
        return;
    }
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showView;
    if (!view) {
        return;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (IBAction)saveButtonTouch:(UIButton *)sender {
    if (!self.showView) {
        return;
    }
    UIImage* saveImg = [Utils makeImageWithView:self.containView];
    [self saveImageToPhotos:saveImg];

}


- (void)saveImageToPhotos:(UIImage*)savedImage

{

    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}

// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{

    NSString *msg = nil ;

    if(error != NULL){

        msg = @"保存图片失败" ;

    }else{
        msg = @"保存图片成功" ;

    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"

                                                    message:msg

                                                   delegate:self

                                          cancelButtonTitle:@"确定"

                                          otherButtonTitles:nil];
    [alert show];

}



























@end
