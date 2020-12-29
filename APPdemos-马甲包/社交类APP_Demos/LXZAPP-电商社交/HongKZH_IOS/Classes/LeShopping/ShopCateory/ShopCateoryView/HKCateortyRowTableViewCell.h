//
//  HKCateortyRowTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HKCateortyRowTableViewCell : BaseTableViewCell
@property (nonatomic,assign) BOOL selectRow;
@property (nonatomic, copy)NSString *titleText;
@end
