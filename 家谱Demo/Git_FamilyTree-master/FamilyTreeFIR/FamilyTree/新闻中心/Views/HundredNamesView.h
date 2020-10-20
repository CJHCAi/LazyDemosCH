//
//  HundredNamesView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HundredsNamesModel.h"

@interface HundredNamesView : UIView
/** 百家姓模型数组*/
@property (nonatomic, strong) NSArray<HundredsNamesModel *> *BJXArr;
/**集合视图*/
@property (nonatomic,strong) UICollectionView *collectionView;
@end
