//
//  LHListCell.h
//  LHRichEditor
//
//  Created by 刘昊 on 2018/5/9.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSIndexModel.h"
@interface LHListCell : UITableViewCell
@property (nonatomic,strong)XSIndexModel *model;
@property (nonatomic,strong)UILabel *titleLab;;
@end
