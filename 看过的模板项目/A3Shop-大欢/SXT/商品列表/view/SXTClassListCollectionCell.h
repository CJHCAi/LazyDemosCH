//
//  SXTClassListCollectionCell.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTClassListViewModel.h"
@interface SXTClassListCollectionCell : UICollectionViewCell

@property (strong, nonatomic)    SXTClassListViewModel *classModel;              /** 存储数据的model */

@end
