//
//  CustonCollectionViewCell.h
//  UI-14.集合视图 UICollectionView
//
//  Created by saberLily on 16/1/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HundredsNamesModel.h"

@interface CustonCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *displayLabel; /**< 文本显示 */
/** 百家姓模型*/
@property (nonatomic, strong) HundredsNamesModel *hundredsNamesModel;

- (instancetype)initWithFrame:(CGRect)frame;
@end
