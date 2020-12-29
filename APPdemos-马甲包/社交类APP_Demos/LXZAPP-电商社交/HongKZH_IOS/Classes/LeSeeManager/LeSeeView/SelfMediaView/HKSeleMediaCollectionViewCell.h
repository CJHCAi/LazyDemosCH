//
//  HKSeleMediaCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfMediaRespone.h"
#import "CategoryCirclesListRespone.h"
#import "CityHomeRespone.h"
@interface HKSeleMediaCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)SelfMediaModelList *model;
@property (nonatomic, strong)CategoryCirclesListModel *circlesListModel;
@property (nonatomic, strong)CityHomeModel *cityM;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property(nonatomic, assign) CGFloat headH;

@property(nonatomic, assign) BOOL isTop;
@end
