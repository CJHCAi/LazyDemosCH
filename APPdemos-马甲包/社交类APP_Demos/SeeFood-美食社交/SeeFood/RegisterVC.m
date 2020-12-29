//
//  RegisterVC.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "RegisterVC.h"
#import "XMPPManager.h"
#import "CoreDataManager.h"
#import "UserModel.h"
#import "HyTransitions.h"
#import "HyLoglnButton.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "PrefixHeader.pch"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>

@interface RegisterVC () <XMPPStreamDelegate, UITextFieldDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UIViewControllerTransitioningDelegate> {
    CGRect _frameDefault;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) HyLoglnButton *button;
@property (assign, nonatomic) BOOL selectedPhoto;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //  初始化UI
    [self initUI];
}

//  初始化UI
- (void)initUI {
    _frameDefault = self.view.frame;
    _userName.delegate = self;
    _password.delegate = self;
    _email.delegate = self;
    _phone.delegate = self;
    
    _photo.layer.masksToBounds = YES;
    _photo.layer.cornerRadius = _photo.bounds.size.height / 2;
    
    //  button
    _button = [[HyLoglnButton alloc] initWithFrame:CGRectMake(0, 0, 225, 45)];
    [_button setBackgroundColor:[UIColor colorWithRed:0.945 green:0.294 blue:0.157 alpha:1.000]];
    [self.view addSubview:_button];
    [_button setTitle:@"Register" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
    _button.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _button.center = CGPointMake(KScreenWidth / 2, _phone.frame.origin.y + 80);
    _button.hidden = NO;
    _button.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _button.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  返回
- (IBAction)cancleRegister:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 照片选择
//  添加照片
- (IBAction)addPhoto:(id)sender {
    //  点击动画
    [self clickAnimation];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    //  二级菜单选择照片
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Chooose a photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"PhotoLibrary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [sheet addAction:photoLibrary];
    //  如果相机可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [sheet addAction:camera];
    }
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:cancle];
    [self presentViewController:sheet animated:YES completion:nil];
}

//  photo动画
- (void)clickAnimation {
    [UIView animateWithDuration:0 animations:^{
        _photo.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _photo.alpha = 1.0;
        }];
    }];
}

//  显示照片(代理)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _photo.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    _selectedPhoto = YES;
}

//  储存照片至本地
- (NSString *)savePhotoLocal {
    if (!_selectedPhoto) {
        return nil;
    }
    __block NSString *returnURL;
    NSString *strImageName = [NSString stringWithFormat:@"%@.png",_userName.text];
    NSData *imageData = UIImagePNGRepresentation(_photo.image);
    [BmobProFile uploadFileWithFilename:strImageName fileData:imageData block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            //  上传成功
            returnURL = url;
        }
    } progress:nil];
    return returnURL;
}


#pragma mark - 键盘控制
//  触摸空白处隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignRespondersForTextFields];
}

//  文本框输入view上移
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = -textField.tag * textField.frame.size.height;
    [UIView animateWithDuration:0.24 animations:^{
        [self.view setFrame:newFrame];
    }completion:nil];
}

//  输入焦点切换
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userName) {
        [_email becomeFirstResponder];
    }else if (textField == _email) {
        [_password becomeFirstResponder];
    }else if (textField == _password) {
        [_phone becomeFirstResponder];
    }else {
        [self resignRespondersForTextFields];
    }
    return YES;
}

//  键盘消失恢复frame
-(void)resignRespondersForTextFields {
    [UIView animateWithDuration:0.24 animations:^{
        [self.view setFrame:_frameDefault];
    }completion:nil];
    
    [_userName resignFirstResponder];
    [_email resignFirstResponder];
    [_password resignFirstResponder];
    [_phone resignFirstResponder];
}

#pragma mark - Register
//  注册
- (void)Register {
    [_button setTitle:@"" forState:UIControlStateNormal];
    //  检查拼写问题
    NSString *error = [self checkUserDetails];
    
    typeof(self) __weak weak = self;
    if (![error isEqualToString:@""]) {
        //  注册出错
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_button ErrorRevertAnimationCompletion:^{
                [weak didPresentControllerButtonTouch];
            }];
        });
        //  打印出错信息
        [self performSelector:@selector(buttonReforme:) withObject:error afterDelay:1.2];
    }else {
        //  存储照片
        NSString *strImageName = [NSString stringWithFormat:@"%@.png",_userName.text];
        NSData *imageData = UIImagePNGRepresentation(_photo.image);
        [BmobProFile uploadFileWithFilename:strImageName fileData:imageData block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
            if (isSuccessful) {
                //  上传成功
                //  在线注册
                [self loginOnlineWithURL:url];
            }
        } progress:nil];        
    }
}

//  在线注册
-(void)loginOnlineWithURL:(NSString *)url {
    BmobUser *user = [BmobUser objectWithClassName:@"User"];
    user.username = _userName.text;
    user.password = _password.text;
    user.email = _email.text;
    [user setObject:_phone.text forKey:@"mobilePhoneNumber"];
    [user setObject:url forKey:@"photoURL"];
//    typeof(self) __weak weak = self;
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //  注册成功
            [self loginSucceed];
        }else {
            if (error.code == 203) {
                [self loginFailedWithError:@"email already taken."];
            }else if(error.code == 202) {
                [self loginFailedWithError:@"username already taken."];
            }else if (error.code == 209) {
                [self loginFailedWithError:@"mobilePhoneNumber already taken."];
            }else if (error.code == 301) {
                [self loginFailedWithError:@"check the formate please"];
            }else {
                NSLog(@"%@", error);
                [self loginFailedWithError:@"some wrong"];
            }
        }
    }];
}

//  登陆成功
-(void)loginSucceed {
    typeof(self) __weak weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_button ExitAnimationCompletion:^{
            [weak didPresentControllerButtonTouch];
        }];
    });
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.logUsername = _userName.text;
    [[CoreDataManager shareInstance]insertDataWithUsername:_userName.text];
}

//  登陆失败
-(void)loginFailedWithError:(NSString *)error {
    typeof(self) __weak weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_button ErrorRevertAnimationCompletion:^{
            [weak didPresentControllerButtonTouch];
        }];
    });
    //  打印出错信息
    [self performSelector:@selector(buttonReforme:) withObject:error afterDelay:1.2];
}

//  本地注册
- (void)localRegisterWithPhotoURL:(NSString *)photoPath {
    //  注册成功
    UserModel *model = [[UserModel alloc]init];
    model.username = _userName.text;
    model.email = _email.text;
    model.password = _password.text;
    model.phone = _phone.text;
    model.photoURL = photoPath;
    [[CoreDataManager shareInstance]addNewUserWithUserModel:model];
}

//  检查信息
-(NSString *)checkUserDetails {
    __block NSString *message = @"";

    if (![self validateEmail:_email.text]) {
        message = [NSString stringWithFormat:@"Wrong E-mail form!"];
    }
    if ([_password.text length] < 6){
        message = [NSString stringWithFormat:@"Password is too short!"];
    }
    if ([_userName.text length] < 3){
        message = [NSString stringWithFormat:@"Username is too short!"];
    }
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery whereKey:@"username" equalTo:_userName.text];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            //  没有该用户名
        }else {
            //  重名
            message = [NSString stringWithFormat:@"Existed same username!"];
        }
    }];
    
    return message;
}


//  邮箱格式检查
- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegEx=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES  %@",emailRegEx];
    return [emailTest evaluateWithObject:email];
}

//  现实错误信息
- (void)buttonReforme:(NSString *)error {
    [_button setTitle:error forState:UIControlStateNormal];
}

//  转场动画
- (void)didPresentControllerButtonTouch
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //  返回该storyboard的程序入口
    TabBarController *main = [storyboard instantiateInitialViewController];
    main.transitioningDelegate = self;
    [self presentViewController:main animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isBOOL:false];
}

//  跳转页面
- (void)jumpToMainPage:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - 服务器
//  注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  注册失败(代理)
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    NSLog(@"注册失败:%@", error);

}
@end
