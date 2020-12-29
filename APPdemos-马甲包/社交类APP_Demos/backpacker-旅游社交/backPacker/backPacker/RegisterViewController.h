//
//  RegisterViewController.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-1.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface RegisterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
@property (nonatomic,retain) NSString*registerBaseURLString;
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSString *userEmail;
@property (nonatomic,retain)NSString *userId;
@property (nonatomic,retain)NSString *userPassWord;
@property (nonatomic,retain)NSString *userRePassWord;

- (IBAction)editDidEnd:(id)sender;
-(IBAction)rButtonPressed:(id)sender;

@end
