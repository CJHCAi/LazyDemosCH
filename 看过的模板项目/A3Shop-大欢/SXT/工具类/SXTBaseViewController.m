//
//  SXTBaseViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/19.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTBaseViewController.h"
#import "SXTHTTPTool.h"
#import <SVProgressHUD.h>
#import "UIView+Toast.h"
@interface SXTBaseViewController ()

@end

@implementation SXTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainColor;
}
- (void)getData:(NSString *)url
          param:(NSDictionary *)param
        success:(requestSuccessBlock)returnSuccess
          error:(requestErrorBlock)returnError{
    
    [SVProgressHUD show];
    [SXTHTTPTool getData:url
                   param:param
                 success:^(id responseObject) {
                     [SVProgressHUD dismiss];
                     if (returnSuccess) {
                         returnSuccess(responseObject);
                     }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showTostMessage:@"请求失败，请检查网络"];
        if (returnError) {
            returnError(error);
        }
    }];
}

- (void)postData:(NSString *)url
           param:(NSDictionary *)param
         success:(requestSuccessBlock)returnSuccess
           error:(requestErrorBlock)returnError{
    [SVProgressHUD show];
    [SXTHTTPTool postData:url param:param success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if (returnSuccess) {
            returnSuccess(responseObject);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showTostMessage:@"请求失败，请检查网络"];
        if (returnError) {
            returnError(error);
        }
    }];
}

- (void)showTostMessage:(NSString *)tost{
    [self.view makeToast:tost duration:1.5 position:@"center"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
