#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ConfigVpnAction) {
    ConfigVpnConnecting,
    ConfigVpnConneced,
    ConfigVpnDisconnecting,
    ConfigVpnDisconnected,
    ConfigVpnInvalid,
    ConfigVpnReasserting,
};

extern NSString *ConfigVPNStatusChangeNotification;

@interface ConfigVPN : NSObject

@property (nonatomic, assign) ConfigVpnAction status;

+ (instancetype)shareManager;
- (void)connectVPN;
- (void)disconnectVPN;
- (void)creatVPNProfile;
- (void)removeVPNProfile;
- (void)connected:(void (^)(BOOL connected))completion;//需要异步读取VPN是否连接的状态
@end
