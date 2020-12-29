//
//  HK_WalletTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_WalletTool.h"

@implementation HK_WalletTool

+(void)getUserWalletInfoWithSuccessBlock:(void(^)(id responseObject))success{
    NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
    LoginUserData * data =[LoginUserData sharedInstance];
    [dic setValue:data.loginUid forKey:@"loginUid"];
    [HK_BaseRequest buildPostRequest:get_userMyWallet body:dic success:^(id  _Nullable responseObject) {
        
        success(responseObject);

    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)pushWalletListController:(UIViewController *)controller {
    HK_WallectListController *list =[[HK_WallectListController alloc] init];
    [controller.navigationController pushViewController:list animated:YES];
    
}
+(void)pushMyIncomeController:(UIViewController *)controller {
    HkK_IncomeController * incomeVc =[[HkK_IncomeController alloc] init];
    [controller.navigationController pushViewController:incomeVc animated:YES];
}

+(void)pushChargeController:(UIViewController *)controller {
    HK_RechargeController * chage =[[HK_RechargeController alloc] init];
    [controller.navigationController pushViewController:chage animated:YES];
}
+(void)getUserTodayIncomeListWithPage:(NSInteger)page successBlock:(void(^)(MyWalletLogModel * response))response  fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userMyWalletLog body:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        MyWalletLogModel * resp =[MyWalletLogModel mj_objectWithKeyValues:responseObject];
        if (resp.code==0) {
            response(resp);
        }else {
            error(resp.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
  
}
+(void)getUserCoinsByType:(NSInteger)type andPages:(NSInteger)page successBlock:(void(^)(MyWalletLogModel * response))response  fial:(void(^)(NSString *error))error {
    [HK_BaseRequest buildPostRequest:get_userSelectUserIntegral body:@{kloginUid:HKUSERLOGINID,@"pageNumber":@(page),@"type":@(type)} success:^(id  _Nullable responseObject) {
        MyWalletLogModel * resp =[MyWalletLogModel mj_objectWithKeyValues:responseObject];
        if (resp.code==0) {
            response(resp);
        }else {
            error(resp.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
@end
