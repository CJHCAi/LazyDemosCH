//
//  SXTLoginViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/7.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTLoginViewController.h"
#import "UMSocial.h"
#import "SXTUserHelper.h"
#import "SXTTabBarViewController.h"

@interface SXTLoginViewController ()

@end

@implementation SXTLoginViewController

- (IBAction)sinaLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            [SXTUserHelper sharedUser].nickName = snsAccount.userName;
            [SXTUserHelper sharedUser].iconUrl = snsAccount.iconURL;
            [SXTUserHelper saveUser];
            
            self.view.window.rootViewController = [[SXTTabBarViewController alloc] init];
            
        } else {
            
            NSLog(@"登录失败");
        }
        
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
