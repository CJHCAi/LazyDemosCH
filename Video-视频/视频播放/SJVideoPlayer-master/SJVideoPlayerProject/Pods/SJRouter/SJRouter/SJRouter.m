//
//  SJRouter.m
//  Pods
//
//  Created by 畅三江 on 2018/9/14.
//

#import "SJRouter.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
static UIViewController *_sj_get_top_view_controller() {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (  [vc isKindOfClass:[UINavigationController class]] || [vc isKindOfClass:[UITabBarController class]] ) {
        if ( [vc isKindOfClass:[UINavigationController class]] ) vc = [(UINavigationController *)vc topViewController];
        if ( [vc isKindOfClass:[UITabBarController class]] ) vc = [(UITabBarController *)vc selectedViewController];
        if ( vc.presentedViewController ) vc = vc.presentedViewController;
    }
    return vc;
}

@interface SJRouter()
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, Class<SJRouteHandler>> *handlersM;
@end

@implementation SJRouter
+ (instancetype)shared {
    static id _instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _handlersM = [NSMutableDictionary new];
    
    /// Thanks @yehot, @Potato121
    /// https://www.jianshu.com/p/534eccb63974
    /// https://github.com/changsanjiang/SJRouter/pull/1
    
    unsigned int img_count = 0;
    const char **imgs = objc_copyImageNames(&img_count);
    const char *main = NSBundle.mainBundle.bundlePath.UTF8String;
    for ( unsigned int i = 0 ; i < img_count ; ++ i ) {
        const char *img = imgs[i];
        if ( !strstr(img, main) ) continue;
        unsigned int cls_count = 0;
        const char **classes = objc_copyClassNamesForImage(img, &cls_count);
        Protocol *p_handler = @protocol(SJRouteHandler);
        for ( unsigned int i = 0 ; i < cls_count ; ++ i ) {
            const char *cls_name = classes[i];
            NSString *cls_str = [NSString stringWithUTF8String:cls_name];
            Class cls = NSClassFromString(cls_str);
            if ( ![cls conformsToProtocol:p_handler] ) continue;
            if ( ![(id)cls respondsToSelector:@selector(handleRequestWithParameters:topViewController:completionHandler:)] ) continue;
            if ( [(id)cls respondsToSelector:@selector(routePath)] )
                _handlersM[[(id<SJRouteHandler>)cls routePath]] = cls;
            else if ( [(id)cls respondsToSelector:@selector(multiRoutePath)] ) {
                for ( NSString *rp in [(id<SJRouteHandler>)cls multiRoutePath] )
                    _handlersM[rp] = cls;
            }
        }
        if ( classes ) free(classes);
    }
    if ( imgs ) free(imgs);
    return self;
}
- (void)handleRequest:(SJRouteRequest *)request completionHandler:(nullable SJCompletionHandler)completionHandler {
    NSParameterAssert(request); if ( !request ) return;
    Class<SJRouteHandler> handler = _handlersM[request.requestPath];
    if ( handler ) {
        [handler handleRequestWithParameters:request.prts topViewController:_sj_get_top_view_controller() completionHandler:completionHandler];
    }
    else {
        printf("\n (-_-) Unhandled request: %s", request.description.UTF8String);
        if ( _unhandledCallback ) _unhandledCallback(request, _sj_get_top_view_controller());
    }
}
- (BOOL)canHandleRoutePath:(NSString *)routePath {
    if ( 0 == routePath.length ) return NO;
    return _handlersM[routePath];
}
@end
NS_ASSUME_NONNULL_END
