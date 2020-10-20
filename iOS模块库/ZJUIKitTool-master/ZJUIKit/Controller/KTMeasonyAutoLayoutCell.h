//
//  KTMeasonyAutoLayoutCell.h
//  ZJUIKit
//
//  Created by keenteam on 2018/4/3.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTCommit;
@interface KTMeasonyAutoLayoutCell : UITableViewCell

@property(nonatomic ,strong) KTCommit           *model;

//+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic ,weak) UIViewController      *weakSelf;

@end
