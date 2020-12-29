//
//  HKHistoryTagCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_AllTags.h"
typedef void(^HistoryTagCellBlock)(HK_AllTagsHis *tagHis);

@interface HKHistoryTagCell : UITableViewCell

@property (nonatomic, strong) NSArray *tagItems;

@property (nonatomic, copy) HistoryTagCellBlock block;
@end
