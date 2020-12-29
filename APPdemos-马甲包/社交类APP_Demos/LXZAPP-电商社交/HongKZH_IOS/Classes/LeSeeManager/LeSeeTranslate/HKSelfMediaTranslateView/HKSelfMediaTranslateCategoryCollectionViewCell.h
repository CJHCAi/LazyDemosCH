//
//  HKSelfMediaTranslateCategoryCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMainAllCategoryListRespone.h"
@interface HKSelfMediaTranslateCategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)MainAllCategoryListData *model;
@property (nonatomic,assign) BOOL isSelect;
@end
