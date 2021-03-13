#import <UIKit/UIKit.h>

@class PHAsset;

//------------------- 模型 -------------------//
@interface DDYPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImage *orignalImage;

/** 获取最近指定数量asset的数组 */
+ (NSMutableArray <PHAsset *> *)latestAsset:(NSInteger)number;

@end



@interface DDYPhotoCell : UICollectionViewCell

@property (nonatomic, copy) void (^selectBlock)(DDYPhotoModel *model);

@property (nonatomic, copy) void (^swipeToSendBlock)(DDYPhotoModel *model);

@property (nonatomic, strong) DDYPhotoModel *photoModel;

@end
