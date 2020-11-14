//
//  NormalCell.h
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface NormalCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;

@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)InfoModel *info;

@end
