//
//  ShowSmartAblumTableViewController.h
//  TestPhotoKit
//
//  Created by admin on 17/6/12.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowSmartAblumTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger albumCount;
@property (nonatomic, strong) NSMutableArray *albumNameArr;
@property (nonatomic, strong) NSMutableArray *albumAssetsArr;
- (instancetype)initWithAlbumCount:(NSInteger)albumCount;

@end
