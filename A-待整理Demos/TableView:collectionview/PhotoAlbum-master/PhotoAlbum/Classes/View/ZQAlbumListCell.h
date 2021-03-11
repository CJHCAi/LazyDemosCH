//
//  CTAlbumListCell.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQAlbumModel;

static const CGFloat AlbumListCellHeight = 70.0;

@interface ZQAlbumListCell : UITableViewCell
@property (nonatomic, strong) ZQAlbumModel *model;

- (void)setModel:(ZQAlbumModel *)model indexPath:(NSIndexPath *)indexPath;
@end
