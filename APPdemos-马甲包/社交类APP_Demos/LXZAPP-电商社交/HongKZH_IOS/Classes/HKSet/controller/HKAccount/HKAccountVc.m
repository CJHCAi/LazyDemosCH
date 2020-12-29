//
//  HKAccountVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAccountVc.h"
#import "HKSetTool.h"
#import "HKAddMobileVc.h"
#import "HKChangeMobileVc.h"
#import "HK_ForGetCodeController.h"
#import "WXApi.h"
@interface HKAccountVc ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
    
}
@property (nonatomic, strong)HKAccountResponse *response;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString *wechatName;
@property (nonatomic, copy) NSString *qqName;
@property (nonatomic, assign) BOOL isCode;

@end
@implementation HKAccountVc

-(void)initData {
    
    NSArray * listData =@[@[@"手机号",@"登录密码"],@[@"微信账号",@"QQ账号"]];
    [self.data addObjectsFromArray:listData];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setFoot {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"账户与安全";
    self.hasFootView= YES;
    //增加监听 监听三方登录返回的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:WeChatLoginMessage object:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      [self getUserAccountInfo];
    
}
-(void)getUserAccountInfo {
    
    [HKSetTool getUserAccountInfoSuccessBlock:^(HKAccountResponse *response) {
        self.mobile = response.data.mobile;
        self.wechatName = response.data.weixin;
        self.qqName = response.data.qq;
        if (response.data.password) {
            self.isCode = YES;
        }else {
            self.isCode  = NO;
        }
        [self.tabView reloadData];
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
//微信绑定
-(void)wechatLogin:(NSNotification *)noti {
    
    [HKSetTool bindWechatWithCode:noti.object successBlock:^{
        [EasyShowTextView showText:@"微信绑定成功"];
        //再次获取账户信息 并刷新列表...
        [self getUserAccountInfo];
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        [_tencentOAuth getUserInfo];
        
    }else{
        
        [EasyShowTextView showText:@"token获取失败"];
    }
}
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    // [self startAnimation];
    if (cancelled) {
        [EasyShowTextView showText:@"用于取消登录"];
    }else{
        [EasyShowTextView showText:@"登录失败"];
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    [EasyShowTextView showText:@"没有网络"];
}
#pragma mark 进行绑定..
- (void)getUserInfoResponse:(APIResponse*) response{
    NSString *nickName =response.jsonResponse[@"nickname"];
    NSString *openID =_tencentOAuth.openId;
    [HKSetTool bindQQWithOpenID:openID userName:nickName successBlock:^{
        [EasyShowTextView showText:@"QQ绑定成功"];
        //再次获取账户信息 并刷新列表...
        [self getUserAccountInfo];
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
     }
    ];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case  0:
            {
                if (self.mobile.length) {
                    HKChangeMobileVc *chanVC =[[HKChangeMobileVc alloc] init];
                    chanVC.mobile = self.mobile;
                    [self.navigationController pushViewController:chanVC animated:YES];
                }else {
                    HKAddMobileVc *addVc =[[HKAddMobileVc alloc] init];
                    [self.navigationController pushViewController:addVc animated:YES];
                }
            }
                break;
            case 1:
            {
               //忘记密码
                HK_ForGetCodeController * forgetVc =[[HK_ForGetCodeController alloc] init];
                forgetVc.fromAccount = YES;
                [self.navigationController pushViewController:forgetVc animated:YES];
            }
                break;
            default:
                break;
        }
    }else {

        if (indexPath.row==0) {
           //判断是否安装了
            if (![WXApi isWXAppInstalled]) {
                  [EasyShowTextView showText:@"请先去AppStore下载微信"];
                  return;
            }
            if (self.wechatName.length) {
                [EasyShowTextView showText:@"您已经绑定微信"];
            }else {
                // 绑定微信
                [AppUtils sendWechatAuthRequest];
            }
         
        }else  {
            if (![TencentOAuth iphoneQQInstalled]) {
                [EasyShowTextView showText:@"请先去AppStore下载QQ"];
                return;
            }
            if (self.qqName.length) {
                [EasyShowTextView showText:@"您已经绑定QQ"];
            }else {
                 //绑定QQ
                _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQAppID andDelegate:self];
                NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
                [_tencentOAuth authorize:permissions];
            }
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"TB"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier:@"TB"];
    }
    cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
    cell.textLabel.textColor = RGB(51, 51, 51);
    NSString * titles =self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = titles;
    cell.detailTextLabel.font =PingFangSCRegular13;
    cell.detailTextLabel.textColor =[UIColor colorFromHexString:@"666666"];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.detailTextLabel.text = self.mobile.length>0 ? self.mobile:@"未设置";
        }else {
             cell.detailTextLabel.text = self.isCode ? @"":@"未设置";
        }
    }else {
        if (indexPath.row==0) {
            cell.detailTextLabel.text = self.wechatName.length>0 ?self.wechatName:@"未绑定";
        }else {
            cell.detailTextLabel.text = self.qqName.length>0 ?self.qqName:@"未绑定";
        }
    }
    return cell;
}
@end
