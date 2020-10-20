//
//  LoginViewController.m
//  IKEv2_Demo
//
//  Created by zqqf16 on 16/3/16.
//  Copyright © 2016年 zqqf16. All rights reserved.
//

#import <NetworkExtension/NEVPNManager.h>
#import <NetworkExtension/NEVPNConnection.h>
#import <NetworkExtension/NEVPNProtocolIKEv2.h>

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NEVPNManager *vpnManager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.vpnManager = [NEVPNManager sharedManager];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(vpnStatusDidChanged:)
               name:NEVPNStatusDidChangeNotification
             object:nil];
}


#pragma mark - UITextField Delegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSArray *textFieldList = @[_server, _username, _password, _presharedKey, _remoteIdentifier, _localIdentifier];
//    NSUInteger index = [textFieldList indexOfObject:textField];
//
//    [textField resignFirstResponder];
//
//    if (index < textFieldList.count - 1) {
//        [(UITextField *)[textFieldList objectAtIndex:index+1] becomeFirstResponder];
//    }
//
//    return YES;
//}
//
#pragma mark - VPN Control

- (void)installProfile {
    NSString *server = @"207.148.89.94";
    NSString *username =@"vpnuser";
    NSString *remoteIdentifier = @"";
    NSString *localIdnetifier = @"";
    
    // Save password & psk
    [self createKeychainValue:@"a3ztPw4mJdGoAffn" forIdentifier:@"VPN_PASSWORD"];
    [self createKeychainValue:@"85i72626K467wwFR" forIdentifier:@"PSK"];
    
    // Load config from perference
    [_vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        
        if (error) {
            NSLog(@"Load config failed [%@]", error.localizedDescription);
            return;
        }
        
        NEVPNProtocolIKEv2 *p = (NEVPNProtocolIKEv2 *)_vpnManager.protocolConfiguration;
        
        if (p) {
            // Protocol exists.
            // If you don't want to edit it, just return here.
        } else {
            // create a new one.
            p = [[NEVPNProtocolIKEv2 alloc] init];
        }
        
        // config IPSec protocol
        p.username = username;
        p.serverAddress = server;
        
        // Get password persistent reference from keychain
        // If password doesn't exist in keychain, should create it beforehand.
        // [self createKeychainValue:@"your_password" forIdentifier:@"VPN_PASSWORD"];
        p.passwordReference = [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
        
        // PSK
        p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
        // [self createKeychainValue:@"your_psk" forIdentifier:@"PSK"];
        p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
        
        /*
         // certificate
         p.identityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
         p.identityDataPassword = @"[Your certificate import password]";
         */
        
        p.localIdentifier = localIdnetifier;
        p.remoteIdentifier = remoteIdentifier;
        
        p.useExtendedAuthentication = YES;
        p.disconnectOnSleep = NO;
        
        _vpnManager.protocolConfiguration = p;
        _vpnManager.localizedDescription = @"IPSec IKEv2 Demo";
        _vpnManager.enabled = YES;
        
        [_vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"Save config failed [%@]", error.localizedDescription);
            }
        }];
    }];
}

- (IBAction)changeVPNStatus:(id)sender
{
    NEVPNStatus status = _vpnManager.connection.status;
    if (status == NEVPNStatusConnected
        || status == NEVPNStatusConnecting
        || status == NEVPNStatusReasserting) {
        [self disconnect];
    } else {
        [self connect];
    }
}

- (void)connect {
    // Install profile
    [self installProfile];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(vpnConfigDidChanged:)
               name:NEVPNConfigurationChangeNotification
             object:nil];
    
}

- (void)disconnect
{
    [_vpnManager.connection stopVPNTunnel];
}

- (void)vpnConfigDidChanged:(NSNotification *)notification
{
    // TODO: Save configuration failed
    [self startConnecting];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NEVPNConfigurationChangeNotification
                                                  object:nil];
}

- (void)startConnecting
{
    NSError *startError;
    [_vpnManager.connection startVPNTunnelAndReturnError:&startError];
    if (startError) {
        NSLog(@"Start VPN failed: [%@]", startError.localizedDescription);
    }
}

- (void)vpnStatusDidChanged:(NSNotification *)notification
{
    NEVPNStatus status = _vpnManager.connection.status;
    switch (status) {
        case NEVPNStatusConnected:
            _actionButton.enabled = YES;
            [_actionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            _activityIndicator.hidden = YES;
            break;
        case NEVPNStatusInvalid:
        case NEVPNStatusDisconnected:
            _actionButton.enabled = YES;
            [_actionButton setTitle:@"Connect" forState:UIControlStateNormal];
            _activityIndicator.hidden = YES;
            break;
        case NEVPNStatusConnecting:
        case NEVPNStatusReasserting:
            _actionButton.enabled = YES;
            [_actionButton setTitle:@"Connecting..." forState:UIControlStateNormal];
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
            break;
        case NEVPNStatusDisconnecting:
            _actionButton.enabled = NO;
            [_actionButton setTitle:@"Disconnecting..." forState:UIControlStateDisabled];
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark - KeyChain

static NSString * const serviceName = @"im.zorro.ipsec_demo.vpn_config";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    // Must be persistent ref !!!!
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

@end
