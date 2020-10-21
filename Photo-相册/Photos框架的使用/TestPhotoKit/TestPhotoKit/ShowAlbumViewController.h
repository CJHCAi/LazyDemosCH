//
//  ShowAlbumViewController.h
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface ShowAlbumViewController : UICollectionViewController
@property (nonatomic, strong) PHFetchResult *assets;
@end
