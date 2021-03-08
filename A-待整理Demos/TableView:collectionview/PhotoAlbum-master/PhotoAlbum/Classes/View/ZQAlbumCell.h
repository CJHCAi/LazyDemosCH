//
//  ZQAlbumCell.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/24.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQPhotoModel.h"
#import "Typedefs.h"

static CGFloat kLineSpacing = 2;
#define kAlbumCellWidth (kTPScreenWidth - kLineSpacing*3)/4
#define kAlbumCellThumbWidth 15

@class PHAsset;
@class ZQAlbumCell;
@protocol ZQAlbumCellDelegate <NSObject>

@optional
- (BOOL)ZQAlbumCell:(ZQAlbumCell *)cell changeSelection:(ZQPhotoModel *)model;

@end


@interface ZQAlbumCell : UICollectionViewCell
@property (nonatomic, strong) ZQPhotoModel *model;
@property (nonatomic, assign) BOOL bSingleSelection;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, assign) BOOL cancelLoad;
@property (nonatomic, assign) ZQAlbumType type;

@property (nonatomic, weak) id<ZQAlbumCellDelegate> delegate;

- (void)display:(NSIndexPath *)indexPath cache:(NSCache *)cache;
- (void)displayThumb:(NSIndexPath *)indexPath cache:(NSCache *)cache;
@end
