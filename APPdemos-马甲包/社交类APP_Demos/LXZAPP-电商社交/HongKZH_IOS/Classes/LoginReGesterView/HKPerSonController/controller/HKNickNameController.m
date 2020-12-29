//
//  HKNickNameController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNickNameController.h"
#import "HK_LoginRegesterTool.h"
@interface HKNickNameController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation HKNickNameController
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
#pragma mark 上传接口
- (IBAction)nextStep:(id)sender {
    NSMutableArray *headArr =[[NSMutableArray alloc] init];
    [headArr addObject:self.headImageView.image];
    
    [HK_LoginRegesterTool completeUserInfoStepWithHeadImgeArr:headArr WithUserName:self.nickTF.text andCurrentVC:self];
}
#pragma mark 选照片
-(void)uploadPhoto {
    //自定义消息框
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"从相册选择", nil];
    //显示消息框
    [sheet showInView:self.view];
}
#pragma mark -消息框代理实现-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
    imagePickerController.allowsEditing = YES;
    if (buttonIndex == 0) {
        //拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else if (buttonIndex == 1){
        //相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}
#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    self.headImageView.image =image;
    self.addImageBtn.hidden =YES;
    if (self.nickTF.text.length >2) {
        self.nextBtn.backgroundColor =RGB(255,49,34);
        self.nextBtn.enabled =YES;
    }
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
-(void)configueUI {
    if ([[LoginUserData sharedInstance].sex isEqualToString:@"女"]) {
        self.headImageView.image =[UIImage imageNamed:@"woman"];
    }else {
        self.headImageView.image =[UIImage imageNamed:@"Man"];
    }
    self.headImageView.userInteractionEnabled =YES;
    UITapGestureRecognizer * tapClick =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhoto)];
    [self.headImageView addGestureRecognizer:tapClick];
    
    [self.nickTF setValue:RGB(153,153,153) forKeyPath:@"_placeholderLabel.textColor"];
    [self.nickTF setValue:PingFangSCRegular16 forKeyPath:@"_placeholderLabel.font"];
    self.nextBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    self.nextBtn.enabled =NO;
     [self.nickTF addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark 输入框编辑时候调用
-(void)inputChanged {
    
    if (self.addImageBtn.hidden && self.nickTF.text.length >=2) {
        self.nextBtn.backgroundColor =RGB(255,49,34);
        self.nextBtn.enabled =YES;
    }else {
        self.nextBtn.enabled =NO;
        self.nextBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    }
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.sx_disableInteractivePop =YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton =YES;
    self.title =@"填写昵称";
     self.view.backgroundColor =[UIColor whiteColor];
    [AppUtils addBarButton:self title:@"跳过" action:@selector(skip) position:PositionTypeRight];
    [self configueUI];
   
}

-(void)skip {
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"确定要跳过此步骤吗?"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGB(35,35,35) range:NSMakeRange(0, 9)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 9)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleA setValue:RGB(132,132,132) forKey:@"titleTextColor"];
    
    [alertController addAction:cancleA];
    UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HKTagSetController *setVc =[[HKTagSetController alloc] init];
        [self.navigationController pushViewController:setVc animated:YES];
    }];
   [define setValue:RGB(233,67,48) forKey:@"titleTextColor"];
    [alertController addAction:define];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
   
}
@end
