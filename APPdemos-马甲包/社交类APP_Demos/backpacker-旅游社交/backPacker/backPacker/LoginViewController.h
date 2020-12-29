//
//  LoginViewController.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-1.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
@property (nonatomic,retain) NSString*loginBaseURLString;
@property (nonatomic,retain)NSString *userEmail;
@property (nonatomic,retain)NSString *userPassWord;
@property (nonatomic,retain)NSString *userId;


- (IBAction)editDidEnd:(id)sender;
-(IBAction)lButtonPressed:(id)sender;
@end
