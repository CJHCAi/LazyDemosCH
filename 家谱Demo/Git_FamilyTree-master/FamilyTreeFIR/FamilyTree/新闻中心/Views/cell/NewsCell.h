//
//  NewsCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyDTModel.h"

@interface NewsCell : UITableViewCell
/** 新闻列表模型*/
@property (nonatomic, strong) FamilyDTModel *familyDTModel;

@end
