//
//  ZQPreviewCell.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@class ZQPhotoModel;
@interface ZQPreviewCell : UICollectionViewCell
@property (nonatomic, strong) ZQPhotoModel *mPhoto;
@property (nonatomic, strong) void(^singleTapBlock)();
@property (nonatomic, strong) UIImageView *ivPhoto;
@property (nonatomic, strong) UIScrollView *scrollView;

- (UIImage *)crop:(CGRect)rect;
- (void)display:(BOOL)bSingleSelect cache:(NSCache *)cache indexPath:(NSIndexPath *)indexPath;
@end
