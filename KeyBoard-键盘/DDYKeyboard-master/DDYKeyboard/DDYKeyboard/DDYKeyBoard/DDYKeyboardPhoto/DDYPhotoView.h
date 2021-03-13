#import <UIKit/UIKit.h>

@interface DDYPhotoView : UIView

@property (nonatomic, copy) void (^albumBlock)(void);

@property (nonatomic, copy) void (^editBlock)(UIImage *image);

@property (nonatomic, copy) void (^sendImagesBlock)(NSArray<UIImage *> *imgArray, BOOL isOrignal);

+ (instancetype)viewWithFrame:(CGRect)frame;

- (void)reset;

@end
