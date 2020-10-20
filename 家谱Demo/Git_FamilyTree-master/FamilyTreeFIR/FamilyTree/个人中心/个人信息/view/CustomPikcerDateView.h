//
//  CustomPikcerDateView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/17.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPikcerDateView;

@protocol CustomPikcerDateViewDelegate <NSObject>

-(void)getCustomPickerDateViewYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day andHour:(NSInteger)hour;

@end

@interface CustomPikcerDateView : UIView
/** 代理人*/
@property (nonatomic, weak) id<CustomPikcerDateViewDelegate> delegate;

@end
