//
//  FamilyButton.h
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyModel.h"

@protocol FamilyButtonDelegate <NSObject>
- (void)buttonDidClickItemAtFamilyModel:(FamilyModel *)model;
@end

@interface FamilyButton : UIButton

@property (nonatomic, strong) FamilyModel *model;
@property (nonatomic, assign) BOOL isNullMate;
@property (nonatomic, assign) BOOL isMate;
@property (nonatomic, assign) BOOL isOriginalMate;
@property (nonatomic, copy) NSString *mateLinkId;
@property (nonatomic, copy) NSString *childLinkId;
@property (nonatomic, assign) BOOL isFirstChild;
@property (nonatomic, assign) BOOL isLastChild;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *avatarString;

@property (nonatomic, strong) UIColor *maleBorderColor;
@property (nonatomic, strong) UIColor *femaleBorderColor;

@property (nonatomic, weak) id <FamilyButtonDelegate> delegate;

@end
