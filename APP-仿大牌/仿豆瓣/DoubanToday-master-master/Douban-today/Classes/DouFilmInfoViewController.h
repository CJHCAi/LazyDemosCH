//
//  DouFilmInfoViewController.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieInfoModel.h"

@interface DouFilmInfoViewController : UIViewController

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *titles;
@property (nonatomic, strong) NSString *titleTwo;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MovieInfoModel *model;


@end
