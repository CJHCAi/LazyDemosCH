//
//  WHFlowLayout.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const WHSectionHeader;
/// A supplementary view that identifies the footer for a given section.
extern NSString *const WHFallSectionFooter;
@interface WHFlowLayout : UICollectionViewFlowLayout
@property(nonatomic, assign) CGFloat sectionHeaderHeight;
@property(nonatomic, assign) CGFloat maxCellSpacing;
@property(nonatomic, assign) CGFloat maxCellSpacingH;

@property (nonatomic,assign) CGFloat maxY;
@property(nonatomic, assign) BOOL isRetrun;
@end
