
#import "UIViewController+DBPrivacyHelper.h"
#import <objc/runtime.h>

@implementation UIViewController (DBPrivacyHelper)

- (void) showPrivacyHelperForType:(DBPrivacyType)type
{
    [self showPrivacyHelperForType:type controller:nil didPresent:nil didDismiss:nil useDefaultSettingPane:YES];
}

- (void) showPrivacyHelperForType:(DBPrivacyType)type controller:(void(^)(DBPrivateHelperController *vc))controllerBlock
                       didPresent:(DBPrivateHelperCompletionBlock)didPresent
                       didDismiss:(DBPrivateHelperCompletionBlock)didDismiss
            useDefaultSettingPane:(BOOL)defaultSettingPane
{
    
    if ( IS_IOS_8 && defaultSettingPane)
    {
        if ( UIApplicationOpenSettingsURLString )
        {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
            return;
        }
    }
    
    DBPrivateHelperController *vc = [DBPrivateHelperController helperForType:type];
    vc.appIcon = self.appIcon;
    vc.didDismissViewController = didDismiss;
    vc.snapshot = [self snapshot];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ( controllerBlock )
    {
        controllerBlock(vc);
    }
    
    [self presentViewController:vc animated:YES completion:didPresent];
}

- (UIImage *) snapshot
{
    id <UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];

    UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, NO, appDelegate.window.screen.scale);
    
    [appDelegate.window drawViewHierarchyInRect:appDelegate.window.bounds afterScreenUpdates:NO];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (void) setAppIcon:(NSString *)appIcon
{
    objc_setAssociatedObject(self, @"kAppIcon", appIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *) appIcon
{
    return objc_getAssociatedObject(self, @"kAppIcon");
}

@end