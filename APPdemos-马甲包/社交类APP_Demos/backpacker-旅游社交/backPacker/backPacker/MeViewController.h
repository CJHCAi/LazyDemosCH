//
//  MeViewController.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-5-23.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOrRegisterViewController.h"
#import "ASIHTTPRequest.h"
@interface MeViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
    int lastViewindex;
    UIImage *imageForPortrait;
    
}
@property (nonatomic,retain) NSString*loginBaseURLString;
@property (nonatomic,retain)NSString *userEmail;
@property (nonatomic,retain)NSString *userPassWord;
@end
