//
//  ZQAlbumListVC.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Typedefs.h"

@class ZQAlbumModel;
@interface ZQAlbumListVC : UIViewController
@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, assign) ZQAlbumType type;
@property (nonatomic, assign) BOOL bSingleSelection;
@property (nonatomic, copy) void(^dataLoaded)(NSArray<ZQAlbumModel*>*Albums);


//- (instancetype)initWithType:(ZQAlbumType)type;
@end
