//
//  MeViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-5-23.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "MeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "AsyncImageView.h"
@interface MeViewController ()

@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initURL{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"url" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *ipPath = [dic objectForKey:@"baseIp"];
    NSString *loginString = [dic objectForKey:@"loginURL"];
    
    self.loginBaseURLString = [NSString stringWithFormat:@"%@%@",ipPath,loginString];
}

-(void)requestData{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    self.userEmail = [saveDefaults valueForKey:@"userEmail"];
    self.userPassWord =[saveDefaults valueForKey:@"userPassWord"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?email=%@&password=%@",self.loginBaseURLString,[self.userEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.userPassWord];
    NSLog(@"loginURL:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request setDelegate:self];
    [request startAsynchronous];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:5.0/255.0 green:111.0/255.0 blue:209.0/255.0 alpha:1.0]];
    lastViewindex = -1;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]];
    
    [self initURL];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hasLogin = [saveDefaults objectForKey:@"hasLogin"];
    if (!hasLogin) {
        hasLogin = @"0";
    }
    switch (hasLogin.intValue) {
        case 0:
            if (lastViewindex == -1) {
                [self addNotLoginView];
                NSLog(@"-1AddnotLoginView");
            }else if(lastViewindex == 0){                   
                
            }else{
                UIView *hasloginView = (UIView *)[self.view viewWithTag:1];
                [hasloginView removeFromSuperview];
                [self addNotLoginView];
            }
            break;
        case 1:
            if (lastViewindex == -1) {
                [self addHasLoginView];
                [self requestData];
            }else if(lastViewindex == 0){
                UIView *notLoginView =(UIView *)[self.view viewWithTag:5];
                [notLoginView removeFromSuperview];
                [self addHasLoginView];
                [self requestData];
            }else{
                
            }
            break;
        default:
            break;
    }
}

#pragma AsihttpRequest delegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *response = [request responseString];
    NSLog(@"response:%@",response);
    NSMutableDictionary *loginData =[response objectFromJSONString];
    if (loginData == nil) {
        NSLog(@"访问出错");
        return;
    }
    NSString *error = [loginData objectForKey:@"errorMsg"];
    if ([[error stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        NSString *pictureString = [loginData objectForKey:@"picture"];
        NSString *nameString = [loginData objectForKey:@"name"];
        NSString *moodString = [loginData objectForKey:@"mood"];
        NSString *attentionCount = [NSString stringWithFormat:@"关注数：%@",[loginData objectForKey:@"attentionCount"]];
        NSString *listenerCount = [NSString stringWithFormat:@"粉丝数：%@",[loginData objectForKey:@"listenerCount"]];
        NSString *microBlogCount = [NSString stringWithFormat:@"微言数：%@",[loginData objectForKey:@"microblogCount"]];
        NSString *picCount = [NSString stringWithFormat:@"照片数：%@",[loginData objectForKey:@"pictureCount"]];
        
        UIView *hasLoginView = (UIView *)[self.view viewWithTag:1];
        UIButton *portraitButton = (UIButton *)[hasLoginView viewWithTag:10];
        UILabel *nameLabel = (UILabel *)[hasLoginView viewWithTag:11];
        UILabel *moodLabel = (UILabel *)[hasLoginView viewWithTag:12];
        UILabel *attentionCountLabel = (UILabel *)[hasLoginView viewWithTag:13];
        UILabel *listenerCountLabel = (UILabel *)[hasLoginView viewWithTag:14];
        UILabel *microBlogCountLabel = (UILabel *)[hasLoginView viewWithTag:15];
        UILabel *picCountlabel = (UILabel *)[hasLoginView viewWithTag:16];

        AsyncImageView *portraitView = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        portraitView.imageURL = [NSURL URLWithString:pictureString];
        portraitView.layer.cornerRadius = 2.0;
        [portraitButton addSubview:portraitView];
        
        [nameLabel setText:nameString];
        [moodLabel setText:moodString];
        [attentionCountLabel setText:attentionCount];
        [listenerCountLabel setText:listenerCount];
        [microBlogCountLabel setText:microBlogCount];
        [picCountlabel setText:picCount];
        
        
    }else{
        NSLog(@"errorMsg:%@",error);
    }

}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
}

-(void)addNotLoginView{
    lastViewindex = 0;                          //目前加载的是未登录的页面
    UIView *notLoginView = [[UIView alloc]initWithFrame:self.view.frame];
    [notLoginView setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]];
    [notLoginView setTag:5];
    UILabel *loginText = [[UILabel alloc]initWithFrame:CGRectMake(30, 95, 260, 20)];
    [loginText setText:@"登陆账号，开启属于你的精彩之旅吧"];
    [loginText setFont:[UIFont systemFontOfSize:16.0]];
    [loginText setBackgroundColor:[UIColor clearColor]];
    [notLoginView addSubview:loginText];
    UIButton *registerButton =[[UIButton alloc]initWithFrame:CGRectMake(30, 140, 260, 35)];
    registerButton.backgroundColor = [UIColor colorWithRed:62/255.0 green:136/255.0 blue:82.0/255.0 alpha:1.0];
    registerButton.layer.cornerRadius = 4;
    registerButton.layer.shadowColor = [UIColor blackColor].CGColor;
    registerButton.layer.shadowOffset = CGSizeMake(1,1);
    registerButton.layer.shadowOpacity = 0.5;
    registerButton.layer.shadowRadius = 3;
    registerButton.layer.borderWidth = 1.0;
    registerButton.layer.borderColor = [UIColor grayColor].CGColor;
    [registerButton setTitle:@"登录" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTag:3];
    [registerButton addTarget:self action:@selector(LoginOrRegisterBPressed:) forControlEvents:UIControlEventTouchUpInside];
    [notLoginView addSubview:registerButton];
    
    UIButton *loginButton =[[UIButton alloc]initWithFrame:CGRectMake(30, 185, 260, 35)];
    loginButton.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:206.0/255.0 blue:231.0/255.0 alpha:1.0];
    loginButton.layer.cornerRadius = 4;
    loginButton.layer.shadowColor = [UIColor blackColor].CGColor;
    loginButton.layer.shadowOffset = CGSizeMake(1,1);
    loginButton.layer.shadowOpacity = 0.5;
    loginButton.layer.shadowRadius = 3;
    loginButton.layer.borderWidth = 1.0;
    loginButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTag:4];
    [loginButton addTarget:self action:@selector(LoginOrRegisterBPressed:) forControlEvents:UIControlEventTouchUpInside];
    [notLoginView addSubview:loginButton];
    [self.view addSubview:notLoginView];
}
-(void)addHasLoginView{
    lastViewindex = 1;                    //目前加载的是login以后的页面
    UIView *hasloginView = [[UIView alloc]initWithFrame:self.view.frame];
    [hasloginView setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]];
    [hasloginView setTag:1];
    //init backView
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280, 80)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 280, 30)];
    [view2 setBackgroundColor:[UIColor colorWithRed:160.0/255 green:160.0/255 blue:160.0/255 alpha:1.0]];
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(139, 0, 2, 60)];
    [lineLabel1 setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(20, 150, 280, 60)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [view3 addSubview:lineLabel1];
    
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(139, 0, 2, 60)];
    [lineLabel2 setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0]];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(20, 230, 280, 60)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [view4 addSubview:lineLabel2];
    [hasloginView addSubview:view1];
    [hasloginView addSubview:view2];
    [hasloginView addSubview:view3];
    [hasloginView addSubview:view4];
    
    // portrait view
    UIButton *portraitView = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 60, 60)];
    [portraitView setTag:10];
    portraitView.layer.borderColor = [UIColor blackColor].CGColor;
    portraitView.layer.borderWidth = 1.5;
    portraitView.layer.cornerRadius = 2.0;
    [portraitView addTarget:self action:@selector(portraitViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    [hasloginView addSubview:portraitView];
    //name Label
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 25)];
    [nameLabel setTag:11];
    [hasloginView addSubview:nameLabel];
    //mood label
    UILabel *moodLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 200, 30)];
    [moodLabel setBackgroundColor:[UIColor clearColor]];
    [moodLabel setTag:12];
    [hasloginView addSubview:moodLabel];
    
    //attentionAmount Label
    UILabel *attentionAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 150, 90, 60)];
    [attentionAmountLabel setTag:13];
    [hasloginView addSubview:attentionAmountLabel];
    //FollowerAmount label
    UILabel *followerAmountLabel =[[UILabel alloc]initWithFrame:CGRectMake(210, 150, 90, 60)];
    [followerAmountLabel setTag:14];
    [hasloginView addSubview:followerAmountLabel];
    //WordS amount label
    UILabel *wordsAmountLabel = [[UILabel alloc]init];
    [wordsAmountLabel setTag:15];
    [wordsAmountLabel setFrame:CGRectMake(70, 230, 90, 60)];
    
    [hasloginView addSubview:wordsAmountLabel];
    
    //photosAmountLabel
    UILabel *photoAmountLabel = [[UILabel alloc]init];
    [photoAmountLabel setTag:16];
    [photoAmountLabel setFrame:CGRectMake(210, 230, 90, 60)];
    [hasloginView addSubview:photoAmountLabel];
    
    [self.view addSubview:hasloginView];
}

//loginView method
-(IBAction)portraitViewPressed:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"头像设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从现有照片中选取",@"拍照", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:delegate{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)||(delegate == nil)||(controller == nil)) {
        return NO;
    }
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc]init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.allowsEditing =YES;
    mediaUI.delegate = delegate;
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

-(BOOL)startCameraControllerFromViewController:(UIViewController *)controller usingDelegate:delegate{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO)||(delegate == nil)||(controller == nil)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc]init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}
//actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==[actionSheet firstOtherButtonIndex]) {
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
    if (buttonIndex-1 == [actionSheet firstOtherButtonIndex]) {
        [self startCameraControllerFromViewController:self usingDelegate:self];
    }
}


//delegate method for picked media
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editedImage = (UIImage *) [info objectForKey:
                                        UIImagePickerControllerEditedImage];
    // Do something with editedImage
    imageForPortrait = [[UIImage alloc]init];
    imageForPortrait = editedImage;
    
    UIView *hasLoginView = (UIView *)[self.view viewWithTag:1];
    UIButton *portraitButton = (UIButton *)[hasLoginView viewWithTag:10];
    [portraitButton setBackgroundImage:imageForPortrait forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//notloginView method
-(void)LoginOrRegisterBPressed:(UIButton *)sender{
    LoginOrRegisterViewController *lrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginOrRegisterVC"];
    if (sender.tag == 3) {
        [lrVC setLoginOrRegister:@"1"];
    }else if (sender.tag == 4){
        [lrVC setLoginOrRegister:@"0"];
    }
    [self.navigationController pushViewController:lrVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
