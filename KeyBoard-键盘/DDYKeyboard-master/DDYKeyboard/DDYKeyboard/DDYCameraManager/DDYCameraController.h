#import <UIKit/UIKit.h>

@interface DDYCameraController : UIViewController

@property (nonatomic, copy) void (^takePhotoBlock)(UIImage *image, UIViewController *vc);

@end
