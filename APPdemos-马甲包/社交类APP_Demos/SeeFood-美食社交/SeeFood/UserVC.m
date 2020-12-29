//
//  OptionViewController.m
//  EyeSight
//
//  Created by Zac on 15/11/3.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "UserVC.h"
#import "UIView+UIView_Frame.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "UserModel.h"
#import "LikeVC.h"
#import "SDImageCache.h"
#import "OptionTVC.h"
#import "LoginVC.h"
#import "UserInformVC.h"
#import <BmobSDK/BmobProFile.h>
#import <BmobSDK/Bmob.h>
#import <UIImageView+WebCache.h>
#import <MessageUI/MessageUI.h>

#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface UserVC () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSArray *buttonArray;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UIImageView *faceImage;
@end

@implementation UserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //  Image
    UIImageView *faceBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    faceBackImage.userInteractionEnabled = YES;
    faceBackImage.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:faceBackImage];
    
    //  backButton
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 30, 30, 30);
    backButton.tintColor = [UIColor whiteColor];
    [backButton setImage:[UIImage imageNamed:@"Back Icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [faceBackImage addSubview:backButton];
    
    //  photo
    _faceImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    _faceImage.center = CGPointMake(KScreenWidth / 2, KScreenHeight / 5);
    _faceImage.image = [UIImage imageNamed:@"Photo"];
    _faceImage.layer.masksToBounds = YES;
    _faceImage.layer.cornerRadius = _faceImage.width / 2;
    [faceBackImage addSubview:_faceImage];
    
    //  name
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _nameLable.center = CGPointMake(KScreenWidth / 2, _faceImage.y + _faceImage.height + 30);
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.font = [UIFont systemFontOfSize:24];
    _nameLable.text = @"Angela Baby";
    _nameLable.textColor = [UIColor whiteColor];
    [faceBackImage addSubview:_nameLable];
    
    UITextView *introductionBack = [[UITextView alloc]initWithFrame:CGRectMake(50, _nameLable.y + 50, KScreenWidth - 100, 80)];
    introductionBack.backgroundColor = [UIColor clearColor];
    introductionBack.textColor = [UIColor whiteColor];
    introductionBack.text = @"Hello! My name is Chen Danqing. My English name is Joy. I'm 14 years old. I'm a happy girl.";
    introductionBack.textAlignment = NSTextAlignmentCenter;
    [faceBackImage addSubview:introductionBack];
    
    UIView *buttonBack = [[UIView alloc]initWithFrame:CGRectMake(50, KScreenHeight / 2, KScreenWidth - 50 * 2, KScreenHeight / 4)];
    [faceBackImage addSubview:buttonBack];
    
    _buttonArray = @[@"imformation", @"favorite", @"feedback", @"clean", @"about", @"exit"];
    for (int i = 0; i < 6; i++) {
        //  button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonBack addSubview:button];
        //  lable
        UILabel *lable = [[UILabel alloc]init];
        [buttonBack addSubview:lable];
        if (i < 3) {
            button.frame = CGRectMake(buttonBack.width / 3 * i, 0, buttonBack.width / 3, buttonBack.width / 3);
            button.tag = i;
            lable.frame = CGRectMake(buttonBack.width / 3 * i, buttonBack.width / 3, buttonBack.width / 3, 20);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.frame = CGRectMake(buttonBack.width / 3 * (i - 3), buttonBack.width / 3 + 20, buttonBack.width / 3, buttonBack.width / 3);
            button.tag = i;
            lable.frame = CGRectMake(buttonBack.width / 3 * (i - 3), buttonBack.width / 3 * 2 + 20, buttonBack.width / 3, 20);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self setButtonWithButton:button label:lable number:i];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
    }
}

#pragma mark --- 按钮的点击方法 ---
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            UserInformVC *userInfor = [[UserInformVC alloc]init];
            [self.navigationController pushViewController:userInfor animated:YES];
        }
            break;
        case 101:
        {
            LikeVC *likeVC = [[LikeVC alloc]init];
            
            [self.navigationController pushViewController:likeVC animated:YES];
        }
            break;
        case 102:
        {
            //判断当前是否能够发送邮件
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc]init];
                //设置代理，注意这里不是delegate，而是mailComposeDelegate
                mailController.mailComposeDelegate=self;
                //设置收件人
                [mailController setToRecipients:[@"jihongboo@qq.com" componentsSeparatedByString:@","]];
                //设置抄送人
                [mailController setCcRecipients:[@"794551660@qq.com" componentsSeparatedByString:@","]];
                //设置密送人
                [mailController setBccRecipients:[@"424533364@qq.com" componentsSeparatedByString:@","]];
                //设置主题
                [mailController setSubject:@"Feedback"];
                //设置内容
//                [mailController setMessageBody:nil isHTML:YES];
                //添加附件
                [self presentViewController:mailController animated:YES completion:nil];
            }
        }
            break;
        case 103:
        {
            [self confirmCleanTheCache];
        }
            break;
        case 104:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OptionTVC *option = [storyboard instantiateViewControllerWithIdentifier:@"About"];
            [self.navigationController pushViewController:option animated:YES];
        }
            break;
        case 105:
        {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.logUsername = @"";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoglinStoryboard" bundle:nil];
            LoginVC *login = [storyboard instantiateInitialViewController];
            [self presentViewController:login animated:YES completion:nil];
            [[CoreDataManager shareInstance]deleteLogedUsername];
        }
            default:
            break;
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:{
            NSLog(@"发送成功.");
        }
            break;
        case MFMailComposeResultSaved://如果存储为草稿（点取消会提示是否存储为草稿，存储后可以到系统邮件应用的对应草稿箱找到）
            NSLog(@"邮件已保存.");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送.");
            break;
            
        default:
            NSLog(@"发送失败.");
            break;
    }
    if (error) {
        NSLog(@"发送邮件过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmCleanTheCache
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除缓存" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearDisk];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth / 2 - 50, KScreenHeight / 2, 100, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = @"清除缓存成功";
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
           
        [self performSelector:@selector(removeLabel:) withObject:label afterDelay:2.0];
    }];
    [alertController addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)removeLabel:(UILabel *)label
{
    [label removeFromSuperview];
}

- (void)setButtonWithButton:(UIButton *)button label:(UILabel *)label number:(int)number
{
    NSString *imageName = [NSString stringWithFormat:@"%@",_buttonArray[number]];
    NSString *imageName0 = [NSString stringWithFormat:@"%@0", imageName];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName0] forState:UIControlStateHighlighted];
    
    label.text = _buttonArray[number];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  显示用户姓名
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.logUsername != nil && ![appDelegate.logUsername isEqualToString:@""]) {
        _nameLable.text = appDelegate.logUsername;
    }
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:appDelegate.logUsername];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *user = [array lastObject];
        NSString *photoURL = [user objectForKey:@"photoURL"];
        photoURL = [NSString stringWithFormat:@"%@?t=1&a=f9794509da450cf1d08aa472900ca477", photoURL];
        [self performSelectorOnMainThread:@selector(loadPhoto:) withObject:photoURL waitUntilDone:YES];
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
}

- (void)loadPhoto:(NSString *)url {
    [_faceImage sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
