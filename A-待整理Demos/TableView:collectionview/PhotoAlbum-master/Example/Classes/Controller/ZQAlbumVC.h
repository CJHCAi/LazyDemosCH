//
//  ZQAlbumVC.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/29.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Typedefs.h"


@class ZQAlbumModel;
@interface ZQAlbumVC : UIViewController
@property (nonatomic, strong) ZQAlbumModel *mAlbum;
@property (nonatomic, assign) ZQAlbumType  type;
@property (nonatomic, assign) BOOL bSingleSelection;
@property (nonatomic, assign) NSInteger    maxImagesCount;
@end
