
#import "SNLoading.h"
#import "MBProgressHUD.h"

static MBProgressHUD *progressHud = nil;

@implementation SNLoading

+ (void)showWithTitle:(NSString *)title
{
    if (!progressHud)
    {
        [progressHud removeFromSuperview];
        progressHud = nil;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    progressHud = [[MBProgressHUD alloc] initWithWindow:window];
    progressHud.labelText = title ? title : GBLocalizedString(@"Loading");
    progressHud.removeFromSuperViewOnHide = YES;
    [window addSubview:progressHud];
    [progressHud show:YES];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideWithTitle:(NSString *)title
{
    progressHud.labelText = title ? title : GBLocalizedString(@"Loaded");
    [progressHud hide:YES];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

+ (void)updateWithTitle:(NSString *)title detailsText:(NSString *)detailsText
{
    progressHud.labelText = title ? title : GBLocalizedString(@"Loading");
    progressHud.detailsLabelText = detailsText;
}

@end
