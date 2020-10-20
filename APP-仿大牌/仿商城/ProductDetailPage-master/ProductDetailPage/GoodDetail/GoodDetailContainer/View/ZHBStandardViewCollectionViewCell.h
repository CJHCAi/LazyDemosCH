//
//  ZHBStandardViewCollectionViewCell.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/28.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBBottonsValueModel;

@interface ZHBStandardViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *standardLabel; // 属性标签standardBtn
@property (nonatomic, strong) ZHBBottonsValueModel *bottonsValue;
@end
