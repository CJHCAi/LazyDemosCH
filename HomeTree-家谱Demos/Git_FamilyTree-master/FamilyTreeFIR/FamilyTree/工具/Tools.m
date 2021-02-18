//
//  Tools.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/24.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "Tools.h"

@implementation Tools


#pragma mark *** VC Titles ***

NSString * _Nonnull const kStringWithHomeVcTitle = @"首页";
NSString * _Nonnull const kStringWithFamilyTreeVcTitle = @"家谱";
NSString * _Nonnull const kStringWithServiceVcTitle = @"服务";
NSString * _Nonnull const kStringWithPersonalCenterVcTitle = @"我的";

#pragma mark *** VC Images ***
NSString * _Nonnull const kImageWithHomeVc = @"index_icon_a";
NSString * _Nonnull const kImageWithFamilyTreeVc = @"jiapu_icon_a";
NSString * _Nonnull const kImageWithServiceVc = @"fuwu_icon_a";
NSString * _Nonnull const kImageWithPersonalCenterVc = @"geren_icon_a";

#pragma mark *** VC SelectedImages ***

NSString * _Nonnull const kSelectedImageWithHomeVc = @"index_icon_b";
NSString * _Nonnull const kSelectedImageWithFamilyTreeVc = @"jiapu_icon_b";
NSString * _Nonnull const kSelectedImageWithServiceVc = @"fuwu_icon_b";
NSString * _Nonnull const kSelectedImageWithPersonalCenterVc = @"geren_icon_b";

#pragma mark *** 网络请求requestcode ***
//登录
NSString * _Nonnull const kRequestCodeLogin = @"login";
NSString * _Nonnull const kRequestCodeRegister = @"register";
NSString * _Nonnull const kRequestCodeUpdatePassword = @"updatepswd";
NSString * _Nonnull const kRequestCodeEditProfile = @"editperinfo";
NSString * _Nonnull const kRequestCodeBackPassword = @"backpswd";

NSString * _Nonnull const kRequestCodeGetMemallInfo = @"getmemallinfo";
NSString * _Nonnull const kRequestCodeQueryMem = @"querymem";
NSString * _Nonnull const kRequestCodeQuerygendata = @"querygendeta";
NSString * _Nonnull const kRequestCodeGetsyntype =  @"getsyntype";
NSString * _Nonnull const kRequestCodeUpdatepswd = @"updatepswd";
NSString * _Nonnull const kRequestCodeGetprovince = @"getprovince";
NSString * _Nonnull const kRequestCodeGetVIPtq = @"getviptq";
NSString * _Nonnull const kRequestCodeGetMemys = @"getmemys";
NSString * _Nonnull const kRequestCodeUploadCefm = @"uploadcefm";
NSString * _Nonnull const kRequestCodeCemeteryList = @"cemeterylist";
NSString * _Nonnull const kRequestCodeEditCemetery =@"editcemetery";
NSString * _Nonnull const kRequestCodeDelcemetery = @"delcemetery";
NSString * _Nonnull const kRequestCodeCemeterDetail = @"cemeterdetail";
NSString * _Nonnull const kRequestCodeBarrageList = @"barragelist";
NSString * _Nonnull const kRequestCodeCreateBarrage = @"createbarrage";
NSString * _Nonnull const kRequestCodeRitual = @"ritual";
NSString * _Nonnull const kRequestCodeGetNewsList =@"getnewslist";
NSString * _Nonnull const kRequestCodeGetFamilyNamesList = @"getfamilynameslist";
NSString * _Nonnull const kRequestCodeGetFamilyNamesDetail = @"getfamilynamesdetail";
NSString * _Nonnull const kRequestCodeGetNewsDetail = @"getnewsdetail";
NSString * _Nonnull const kRequestCodeQueryClan = @"queryclan";
NSString * _Nonnull const kRequestCodeUploadMemimg = @"uploadmemimg";
NSString * _Nonnull const kRequestCodeMemySadd = @"memysadd";
NSString * _Nonnull const kRequestCodeCreateZqhz = @"createzqhz";
NSString * _Nonnull const kRequestCodeUploadClan = @"uploadclan";

+(void)showAlertViewControllerAutoDissmissWithTarGet:(id)target
                                             Message:(NSString *)message
                                               delay:(NSInteger)time
                                            complete:(void (^)(BOOL))complete{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [target presentViewController:alert animated:YES completion:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [target dismissViewControllerAnimated:YES completion:nil];
            complete(YES);
        });
    }];
}

+(void)showAlertViewcontrollerWithTarGet:(id)target Message:(NSString *)message complete:(void (^)(BOOL))complete{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        complete(true);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        complete(false);
    }]];
    
    [target presentViewController:alert animated:YES completion:nil];

}
@end
