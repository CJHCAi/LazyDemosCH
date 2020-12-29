//
//  HK_LoginRegesterTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_LoginRegesterTool.h"
#import "HKDateTool.h"
#import "HKPersonController.h"
@implementation HK_LoginRegesterTool

+(void)updateUserInfoWithDic:(NSMutableDictionary *)dic successBlock:(void(^)(void))success fail:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_updateUserData body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//用户增加自媒体分类
+(void)addCatergoryListForUserWithCaterArray:(NSMutableArray *)caterArr successBlock:(void(^)(void))success error:(void(^)(NSString *error))error {
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [params setValue:caterArr forKey:@"categoryId"];

    [HK_BaseRequest buildPostRequest:get_mediaAdvAddUserCategory body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)saveUserTagListWithSelectTagArr:(NSMutableArray *)selectArr succeessBlock:(void(^)(void))success andFail:(void(^)(NSString *error))error {
    //拼接字符数组
    NSMutableString *ids = [NSMutableString stringWithString:@""];
    for (NSString *name in selectArr) {
        [ids appendFormat:@"%@",name];
        [ids  appendString:@","];
    }
    [ids deleteCharactersInRange:NSMakeRange(ids.length-1,1)];
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:kloginUid];
    [params setValue:ids forKey:@"labels"];
    [HK_BaseRequest buildPostRequest:get_userSaveUserLabel body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//获取用户标签
+(void)getUserSetingTabLabelsSuccess:(void(^)(NSArray *array))array userSelectArr:(void(^)(NSArray *selectArr))selectArr  failed:(void(^)(NSString *msg))meg {

    [HK_BaseRequest buildPostRequest:get_userGetUserLabel body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HK_UserTagResponse * response =[HK_UserTagResponse mj_objectWithKeyValues:responseObject];
        if (!response.code) {
            array(response.data.userlabels);
            selectArr(response.data.systemlabels);
        }else {
            meg(response.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)completeUserInfoStepWithHeadImgeArr:(NSMutableArray *)imageArr WithUserName:(NSString *)name andCurrentVC:(UIViewController *)controller {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [params setValue:name forKey:@"name"];
    [HK_NetWork uploadImageURL:[NSString stringWithFormat:@"%@%@",Host,get_userSetSecondInfo] parameters:params images:imageArr name:@"headImg" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (error) {
            [EasyShowTextView showText:@"头像上传失败"];
        }else {
            if ([[responseObject objectForKey:@"code"] integerValue] ==0) {
                NSString *data =[responseObject objectForKey:@"data"];
                [LoginUserData sharedInstance].headImg = data;
                [LoginUserData sharedInstance].name =name;
                HKTagSetController *setVc =[[HKTagSetController alloc] init];
                [controller.navigationController pushViewController:setVc animated:YES];
            }else {
                NSString *msg =responseObject[@"msg"];
                [EasyShowTextView showText:msg];
            }
        }
    }];
}
+(void)completeUserInfoFirstStepWithBirthDay:(NSString *)birthDay WithSex:(NSInteger)sex  andCurrentVc:(UIViewController *)controller {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:birthDay forKey:@"birthday"];
    [params setValue:@(sex) forKey:@"sex"];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [HK_BaseRequest buildPostRequest:get_userSetFirstInfo body:params success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
             NSString *msg =responseObject[@"msg"];
            [EasyShowTextView showText:msg];
        }else {
            if (sex==1) {
                [LoginUserData sharedInstance].sex =@"男";
            }else {
                [LoginUserData sharedInstance].sex=@"女";
            }
            HKNickNameController *nick =[[HKNickNameController alloc] initWithNibName:@"HKNickNameController" bundle:nil];
            [controller.navigationController pushViewController:nick animated:YES];
        }
    } failure:^(NSError * _Nullable error) {
         [EasyShowTextView showText:@"网络有问题"];
    }];
}

+(void)StartTencentOAuth:(TencentOAuth *)oAuth andDelegete:(id)controllerDelegete{
    
    oAuth=[[TencentOAuth alloc]initWithAppId:@"1106489030" andDelegate:controllerDelegete];
    
    NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
   
    [oAuth authorize:permissions];
    
}
+(void)WeixinOauthSuccessForApi:(NSString *)code withCurrentVc:(UIViewController *)controller {
    //发起微信登录请求
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:code forKey:@"code"];
    [params setValue:kUUID forKey:@"registrationID"];
    [HK_BaseRequest buildPostRequest:get_userweixinlogin body:params success:^(id  _Nullable responseObject) {
        
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
        }else {
            [AppUtils saveUserDataWithObject:responseObject];
             //[self skipToEditUserInfoController:controller];
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError * _Nullable error) {
         [EasyShowTextView showText:@"网络有问题"];
    }];
}

+(void)tencentOauthSuccessApi:(APIResponse*)response andOpenId:(NSString *)openid withCurrentController:(UIViewController *)controller {
    NSString *nickName =response.jsonResponse[@"nickname"];
    NSString *headImg =response.jsonResponse[@"figureurl_qq_2"];
    NSString *openID =openid;
    //进行QQ登录
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:headImg forKey:@"headImg"];
    [params setValue:nickName forKey:@"name"];
    [params setValue:openID forKey:@"openid"];
    [params setValue:kUUID forKey:@"registrationID"];
    [HK_BaseRequest buildPostRequest:get_userLoginQQ body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            [AppUtils saveUserDataWithObject:responseObject];
            [controller dismissViewControllerAnimated:YES completion:nil];
            [self skipToEditUserInfoController:controller];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)pushRigeSterControllerWithCurrentVc:(UIViewController *)controller {
    HK_ReGisterView * reger =[[HK_ReGisterView alloc] init];
    [controller.navigationController pushViewController:reger animated:YES];
    
}
+(void)pushLoadControllerWithCurrentVc:(UIViewController *)controller withType:(int)fromType{
    HKLoginViewController * viewLogin =[[HKLoginViewController alloc] init];
    viewLogin.fromRegister =fromType;
    [controller.navigationController pushViewController:viewLogin animated:YES];
}

+(void)pushCodeSendMessageVcWithPreCode:(NSString *)presString andPhone:(NSString *)phonString withTypeCode:(codeReceivedType)typeCode onCurrentVc:(UIViewController *)controller {
    HK_CodeReceived * received =[[HK_CodeReceived alloc] init];
    received.presString =presString;
    received.phonString = phonString;
    received.typeCode = typeCode;
    [controller.navigationController pushViewController:received animated:YES];
}

#pragma mark 账号密码登录
+(void)loadAppWithParamsDic:(NSDictionary *)params andCurrentController:(UIViewController *)controller {
    //进行账号密码登录
    [Toast loading];
    [HK_BaseRequest buildPostRequest:get_phoneLgin body:params success:^(id  _Nullable responseObject) {
        [Toast loaded];
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg =responseObject[@"msg"];
            
            [EasyShowTextView showText:msg];
        }else {
            [AppUtils saveUserDataWithObject:responseObject];
          //账号密码登录.....
            NSString * mobile = [params objectForKey:@"mobile"];
            [LoginUserDataModel saveUserInfoUsername:mobile];
            NSString *password =[params objectForKey:@"password"];
            [LoginUserDataModel saveUserInfopassword:password];
            [controller dismissViewControllerAnimated:YES completion:nil];
            // self skipToEditUserInfoController:controller];
        }
    } failure:^(NSError * _Nullable error) {
        [Toast loaded];
    }];
}
+(void)skipToEditUserInfoController:(UIViewController *)controller {
    HKPersonController *personVc =[[HKPersonController alloc] initWithNibName:@"HKPersonController" bundle:nil];
    [controller.navigationController pushViewController:personVc animated:YES];
    
}

@end
