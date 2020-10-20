#import "ConfigVPN.h"
#import <NetworkExtension/NetworkExtension.h>
#import <UIKit/UIKit.h>
#import "VPNAccount.h"

NSString *ConfigVPNStatusChangeNotification = @"ConfigVPNStatusChangeNotification";

@implementation ConfigVPN

//DEBUG
#define ALERT(title,msg)
#define ALERTReal(title,msg) dispatch_async(dispatch_get_main_queue(), ^{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alert show];});

//从Keychain取密码对应的key
#define kPasswordReference @"passwordReferencess"
#define kSharedSecretReference @"sharedSecretReferencess"
#define kLocalIdentifier @"vpn"
#define kRemoteIdentifier @"vpn.psk"

+ (instancetype)shareManager
{
    static ConfigVPN *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ConfigVPN alloc] init];
    });
    
    return manager;
    
}

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (void)VPNStatusDidChangeNotification
{
    switch ([NEVPNManager sharedManager].connection.status)
    {
        case NEVPNStatusInvalid:
        {
            NSLog(@"NEVPNStatusInvalid");
            self.status = ConfigVpnInvalid;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
            break;
        }
        case NEVPNStatusDisconnected:
        {
            NSLog(@"NEVPNStatusDisconnected");
            self.status = ConfigVpnDisconnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusConnecting:
        {
            NSLog(@"NEVPNStatusConnecting");
            self.status = ConfigVpnConnecting;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case NEVPNStatusConnected:
        {
            NSLog(@"NEVPNStatusConnected");
            self.status = ConfigVpnConneced;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusReasserting:
        {
            NSLog(@"NEVPNStatusReasserting");
            self.status = ConfigVpnReasserting;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
            break;
        }
        case NEVPNStatusDisconnecting:
        {
            NSLog(@"NEVPNStatusDisconnecting");
            self.status = ConfigVpnDisconnecting;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NEVPNStatusDidChangeNotification object:nil];
}





#pragma mark - Keychain
- (void)configVPNKeychain
{
    
    if (![self searchKeychainCopyMatching:kPasswordReference])
    {
        [self deleteKeychainItem:kPasswordReference];
        [self addKeychainItem:kPasswordReference password:[VPNAccount shareManager].vpnUserPassword];
    }
    
    if (![self searchKeychainCopyMatching:kSharedSecretReference])
    {
        [self deleteKeychainItem:kSharedSecretReference];
        [self addKeychainItem:kSharedSecretReference password:[VPNAccount shareManager].sharePsk];
    }
}

//获取Keychain里的对应密码
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier{
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    //    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    searchDictionary[(__bridge id)kSecReturnPersistentRef] = @YES;//这很重要
    searchDictionary[(__bridge id)kSecAttrSynchronizable] = @NO;
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    return (__bridge NSData *)result;
}

//插入密码到Keychain
- (void)addKeychainItem:(NSString *)identifier password:(NSString*)password
{
    NSData *passData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    //         searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecValueData] = passData;
    searchDictionary[(__bridge id)kSecAttrSynchronizable] = @NO;
    ;
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)(searchDictionary), &result);
    if (status != noErr)
    {
        //        //NSLog(@"Keychain插入错误!");
        ALERT(@"Keychain", @"密码保存出错!");
    }
}
/**从Keychain里面删除*/
- (void)deleteKeychainItem:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    //    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrSynchronizable] = @NO;
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
    if (status != noErr)
    {
        //        //NSLog(@"Keychain插入错误!");
    }
}




#pragma mark - VPNConfig
- (void)setupIPSec
{
    [self configVPNKeychain];

    NEVPNProtocolIPSec * p = [[NEVPNProtocolIPSec alloc] init];
    p.username = [VPNAccount shareManager].vpnUserName;
    p.passwordReference = [self searchKeychainCopyMatching:kPasswordReference];
    p.serverAddress = [VPNAccount shareManager].severAddress;
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    p.sharedSecretReference = [self searchKeychainCopyMatching:kSharedSecretReference];
    //    p.identityData = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    //    p.identityReference = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    //    p.identityDataPassword = @"test";
    p.disconnectOnSleep = NO;
    
    //需要扩展鉴定(群组)
//    p.localIdentifier = kLocalIdentifier;
//    p.remoteIdentifier = kRemoteIdentifier;
    p.useExtendedAuthentication = YES;
    
    [[NEVPNManager sharedManager] setProtocolConfiguration:p];
    [[NEVPNManager sharedManager] setOnDemandEnabled:NO];
    [[NEVPNManager sharedManager] setLocalizedDescription:@"你看你看"];//VPN自定义名字
    [[NEVPNManager sharedManager] setEnabled:YES];
}



/**连接VPN*/
- (void)connectVPN
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            //配置IPSec
            [self setupIPSec];
            
            //保存VPN到系统->通用->VPN->个人VPN
            [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler:^(NSError *error){
                if(error)
                {
                    NSLog(@"证书安装失败 +%@",error.description);
                    self.status = ConfigVpnInvalid;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
                }
                else
                {
                    NSLog(@"证书安装成功");
                    if ( iGetSystemVersion() > 8)
                    {
                        NSError * error = nil;
                        [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&error];
                        if (error)
                        {
                            NSLog(@"连接失败%@",error);
                        }else{
                            NSLog(@"连接成功");
                        }
                        
                    }
                }
            }];
            
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
}

/**创建VPN证书*/
- (void)creatVPNProfile
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if(error)
        {
            NSLog(@"Load error: %@", error);
        }
        else
        {
            //配置IPSec
            [self setupIPSec];
            //保存VPN到系统->通用->VPN->个人VPN
            [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler:^(NSError *error){
                if(error)
                {
                    NSLog(@"证书安装失败 +%@",error.description);
                    self.status = ConfigVpnInvalid;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ConfigVPNStatusChangeNotification object:self];
                }
                else
                {
                    NSLog(@"证书安装成功");
                }
            }];
        }
    }];

}


float iGetSystemVersion()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


/**取消连接VPN*/
- (void)disconnectVPN
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [[NEVPNManager sharedManager].connection stopVPNTunnel];
        }
    }];
}

/**删除VPN证书*/
- (void)removeVPNProfile{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError *error){
                if(error)
                {
                    NSLog(@"证书删除失败%@",error.description);
                }
                else
                {
                    NSLog(@"证书删除成功");
                }
            }];
        }
    }];
}

/**返回VPN连接状态*/
- (void)connected:(void (^)(BOOL))completion
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [self setupIPSec];
            completion([self connected]);
        }
        else
        {
            completion(NO);
        }
    }];
}
- (BOOL)connected
{
    return (NEVPNStatusConnected == [[NEVPNManager sharedManager] connection].status);
}

@end
