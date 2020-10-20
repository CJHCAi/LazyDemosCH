//
//  ViewController.m
//  VPN
//
//  Created by Godlike on 2017/6/2.
//  Copyright © 2017年 不愿透露姓名的洪先生. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define ServiceAddress @"207.148.89.94"
#define UserName @"vpnuser"
#define Password @"a3ztPw4mJdGoAffn"
#define PSK  @"85i72626K467wwFR"

#import "ViewController.h"
#import <NetworkExtension/NetworkExtension.h>

@interface ViewController ()
@property (nonatomic, strong) NEVPNManager *manage;
@property(nonatomic,strong)UILabel * stateLabel;
@property(nonatomic,strong)UIButton *connectBtn;
@property(nonatomic,strong)UILabel * errorLabel;
@end


#pragma mark - Demo

/**
 *
 *      如果你的
 *      服务器地址   用户名   密码
 *
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self connectBtn];
    [self stateLabel];
    [self errorLabel];
    [self setupVPN];
    
    [self removeVPNProfile];
    
}

-(void)setupVPN{
    
    self.manage = [NEVPNManager sharedManager];
    [self.manage loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        NSError *errors = error;
        if (errors) {
            NSLog(@"%@",errors);
            self.errorLabel.text=[NSString stringWithFormat:@"loadFromPreferencesWithCompletionHandler %@",errors];
        }
        else{
            
            NEVPNProtocolIKEv2 *p = [[NEVPNProtocolIKEv2 alloc] init];
            //用户名
            p.username = UserName;
            //服务器地址
            p.serverAddress = ServiceAddress;
            //密码
            [self createKeychainValue:Password forIdentifier:@"VPN_PASSWORD"];
            p.passwordReference =  [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
            //共享秘钥可以和密码同一个.
            [self createKeychainValue:PSK forIdentifier:@"PSK"];
            p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
            
            p.localIdentifier = @"";
            //远程服务器地址
            p.remoteIdentifier = @"";
            
            //这特么是个坑
            //NEVPNIKEAuthenticationMethodCertificate
            //NEVPNIKEAuthenticationMethodSharedSecret
            p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
            
            p.useExtendedAuthentication = YES;
            p.disconnectOnSleep = NO;
            self.manage.onDemandEnabled = NO;
            [self.manage setProtocolConfiguration:p];
            //我们app的描述 叫这个 你随便..
            self.manage.localizedDescription = @"华少最帅";
            self.manage.enabled = true;
            
            //安装描述文件
            [self.manage saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                }
                else {
                    NSLog(@"Saved!");
                }
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVpnStateChange:) name:NEVPNStatusDidChangeNotification object:nil];

}
- (void)removeVPNProfile{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError *error){
                if(error)
                {
                    //                            //NSLog(@"Remove error: %@", error);
//                    ALERT(@"removeFromPreferences", error.description);
                }
                else
                {
//                    ALERT(@"removeFromPreferences", @"删除成功");
                }
            }];
        }
    }];
}

#pragma mark-ge各种响应事件
-(void)onVpnStateChange:(NSNotification *)Notification {
    
    NEVPNStatus state = self.manage.connection.status;
 
    switch (state) {
        case NEVPNStatusInvalid:
            NSLog(@"无效连接");
            self.stateLabel.text=@"无效连接";
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"未连接");
            self.stateLabel.text=@"未连接";
            break;
        case NEVPNStatusConnecting:
            NSLog(@"正在连接");
            self.stateLabel.text=@"正在连接";
            break;
        case NEVPNStatusConnected:
            NSLog(@"已连接");
             self.stateLabel.text=@"已连接";
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"断开连接");
            self.stateLabel.text=@"断开连接";
            break;
        default:
            break;
    }
    [self.connectBtn setTitle:_stateLabel.text forState:UIControlStateNormal];
}

- (void)clicks{
    NSError *error = nil;
    [self.manage.connection startVPNTunnelAndReturnError:&error];
    if(error) {
        NSLog(@"Start error: %@", error.localizedDescription);
        self.errorLabel.text=[NSString stringWithFormat:@"Start error: %@",error.localizedDescription];
    }
    else
    {
        NSLog(@"Connection established!");
        self.errorLabel.text=@"服务器连接成功";
    }
}




#pragma mark-Keychain
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    // creat a new item
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    //OSStatus 就是一个返回状态的code 不同的类返回的结果不同
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    //   keychain item creat
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    //   extern CFTypeRef kSecClassGenericPassword  一般密码
    //   extern CFTypeRef kSecClassInternetPassword 网络密码
    //   extern CFTypeRef kSecClassCertificate 证书
    //   extern CFTypeRef kSecClassKey 秘钥
    //   extern CFTypeRef kSecClassIdentity 带秘钥的证书
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    //ksecClass 主键
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:ServiceAddress forKey:(__bridge id)kSecAttrService];
    return searchDictionary;
}



#pragma mark-懒加载
-(UIButton *)connectBtn{
    if (!_connectBtn) {
        _connectBtn= [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [_connectBtn setTitle:@"连接VPN" forState:UIControlStateNormal];
        [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _connectBtn.backgroundColor = [UIColor orangeColor];
        [_connectBtn addTarget:self action:@selector(clicks) forControlEvents:UIControlEventTouchUpInside];
        _connectBtn.layer.cornerRadius=50;
        _connectBtn.layer.masksToBounds=YES;
        [self.view addSubview:_connectBtn];

    }
    return _connectBtn;
}
-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel=[UILabel new];
        _stateLabel.frame=CGRectMake(50,CGRectGetMaxY(_connectBtn.frame)+20,200,20);
        _stateLabel.text=@"未连接";
        _stateLabel.font=[UIFont systemFontOfSize:18];
        _stateLabel.textColor=[UIColor blackColor];
        _stateLabel.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}
-(UILabel *)errorLabel{
    if (!_errorLabel) {
        _errorLabel=[UILabel new];
        _errorLabel.frame=CGRectMake(50, CGRectGetMaxY(self.stateLabel.frame),SCREEN_WIDTH-50*2, 80);
        _errorLabel.textColor=[UIColor blackColor];
        _errorLabel.font=[UIFont systemFontOfSize:13];
        _errorLabel.numberOfLines=0;
        [self.view addSubview:_errorLabel];
    }
    return _errorLabel;
}

@end
