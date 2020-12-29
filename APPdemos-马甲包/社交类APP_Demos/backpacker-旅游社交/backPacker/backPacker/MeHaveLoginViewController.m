//
//  MeHaveLoginViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-4.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "MeHaveLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MeHaveLoginViewController ()

@end

@implementation MeHaveLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)addHasLoginView{

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
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    
    // init action view
    UIButton *portraitView = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 60, 60)];
    [portraitView setTag:10];
    portraitView.layer.borderColor = [UIColor blackColor].CGColor;
    portraitView.layer.borderWidth = 1.5;
    portraitView.layer.cornerRadius = 2.0;
    [portraitView addTarget:self action:@selector(portraitViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:portraitView];
    
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name =[saveDefaults valueForKey:@"userName"];
    NSLog(@"name:%@",name);
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 25)];
    [nameLabel setText:name];
    [self.view addSubview:nameLabel];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
