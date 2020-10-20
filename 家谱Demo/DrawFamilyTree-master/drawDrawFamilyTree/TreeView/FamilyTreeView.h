//
//  FamilyTreeView.h
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyModel.h"
#import "FamilyButton.h"
@protocol FamilyTreeViewDelegate <NSObject>
- (void)familyTreeButtonDidClickedItemAtIndex:(FamilyModel *)model;
@end

@interface FamilyTreeView : UIView <UIScrollViewDelegate,FamilyButtonDelegate> {
    UIScrollView *mainScrollView;
    UIView *containerView;
    NSMutableDictionary *lastColumnsInRow;
    NSMutableArray *rowContainerViews;
}

@property (nonatomic, strong) FamilyModel *model;
@property (nonatomic, weak) id<FamilyTreeViewDelegate> delegate;

@property (nonatomic, strong) UIColor *personViewBackgroundColor;
@property (nonatomic, strong) UIColor *maleBorderColor;
@property (nonatomic, strong) UIColor *femaleBorderColor;

@end
