#import "DDYPhotoCell.h"
#import <Photos/Photos.h>
#import "DDYKeyboardConfig.h"
#import "DDYLongPressManager.h"

@implementation DDYPhotoModel

#pragma mark 获取指定asset数组
+ (NSMutableArray <PHAsset *> *)latestAsset:(NSInteger)number {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    NSMutableArray *assetsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < MIN(fetchResult.count, number); i++) {
        [assetsArray addObject:(PHAsset *)(fetchResult[i])];
    }
    return assetsArray;
}

#pragma mark 获取图片 暂时忽略iCloud情况
+ (void)imageWithAsset:(PHAsset *)asset isOrignal:(BOOL)orignal size:(CGSize)size complete:(void (^)(UIImage *resultImage))complete {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = orignal ? PHImageRequestOptionsDeliveryModeHighQualityFormat : PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = orignal;
    options.synchronous = NO;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {                                                if (complete) complete(result);
                                            }];
}

@end


@interface DDYPhotoCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIView *alertWindow;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation DDYPhotoCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        _longPressGesture = [_imageView ddy_AddLongGestureTarget:self action:@selector(longPress:) minDuration:0.1];
        _longPressGesture.delegate = self;
    }
    return _imageView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"DDYPhoto.bundle/selectN"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"DDYPhoto.bundle/selectS"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}

- (void)handleSelect:(UIButton *)sender {
    if (self.photoModel.orignalImage == nil) [self requestOrignalImage];
    _photoModel.selected = (sender.selected = !sender.selected);
    if (self.selectBlock) {
        self.selectBlock(self.photoModel);
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CGRect rectInWindow = [self.imageView convertRect:self.bounds toView:self.alertWindow];
        [self.alertWindow addSubview:self.imageView];
        self.imageView.frame = rectInWindow;
        self.selectButton.hidden = YES;
        if (self.photoModel.orignalImage == nil) [self requestOrignalImage];
        [DDYLongPressManager sharedManager].isDragEditting = YES;
        
    } else if (longPress.state == UIGestureRecognizerStateChanged) {
        
        self.imageView.ddy_CenterY = [longPress locationInView:self.alertWindow].y;
        [DDYLongPressManager sharedManager].isDragEditting = YES;
        
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
        
        CGRect rectInCell = [self.imageView convertRect:self.imageView.bounds toView:self.contentView];
        
        if (-rectInCell.origin.y>self.ddy_H/2 && self.swipeToSendBlock) {
            self.swipeToSendBlock(self.photoModel);
        }
        [self.contentView addSubview:self.imageView];
        self.imageView.ddy_Origin = CGPointMake(0, 0);
        self.selectButton.hidden = NO;
        [self.contentView bringSubviewToFront:self.selectButton];
        [DDYLongPressManager sharedManager].isDragEditting = NO;
    } else {
        // cancel/fail
        [DDYLongPressManager sharedManager].isDragEditting = NO;
    }
}

- (void)setPhotoModel:(DDYPhotoModel *)photoModel {
    _photoModel = photoModel;
    
    _selectButton.selected = photoModel.isSelected;
    
    if (photoModel.image) {
        self.imageView.image = photoModel.image;
    } else {
        CGSize size = CGSizeMake(self.ddy_W, self.ddy_H);
        [DDYPhotoModel imageWithAsset:photoModel.asset isOrignal:NO size:size complete:^(UIImage *resultImage) {
            self.imageView.image = resultImage;
            photoModel.image = resultImage;
        }];
    }
}

- (void)requestOrignalImage {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(orignalImageWithAsset:) object:self.photoModel.asset];
    [self performSelector:@selector(orignalImageWithAsset:) withObject:self.photoModel.asset afterDelay:0.05];
}

- (void)orignalImageWithAsset:(PHAsset *)asset {
    [DDYPhotoModel imageWithAsset:asset isOrignal:YES size:PHImageManagerMaximumSize complete:^(UIImage *resultImage) {
        self.photoModel.orignalImage = resultImage;
    }];
}

- (UIView *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[self superview] superview];
    }
    return _alertWindow ? _alertWindow : DDYKeyWindow;
}

#pragma mark 如果将视图放到了textView.inputView 则需要放到键盘window上
//- (UIView *)alertWindow {
//    if (!_alertWindow) {
//        for (UIView *view in [UIApplication sharedApplication].windows) {
//            if ([@"UIRemoteKeyboardWindow" isEqualToString:NSStringFromClass([view class])]) {
//                _alertWindow = view;
//                break;
//            }
//        }
//    }
//    return _alertWindow ? _alertWindow : DDYKeyWindow;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.selectButton.frame = CGRectMake(self.ddy_W-28, 6, 24, 24);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizerShouldBegin %@",[DDYLongPressManager sharedManager].isDragEditting ? @"YES" : @"NO");
    if (gestureRecognizer != self.longPressGesture) {
        return NO;
    } else if ([DDYLongPressManager sharedManager].isDragEditting) {
        return NO;
    } else {
        [DDYLongPressManager sharedManager].isDragEditting = YES;
        return YES;
    }
}

@end
/**
 QQ 选择按钮在滑动时悬浮状态，当cell划出屏幕才消失
 */
