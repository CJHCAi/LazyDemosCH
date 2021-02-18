//
//  ExpertRecommendAddView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpertRecommendAddView;

@protocol ExpertRecommendAddViewDelegate <NSObject>

-(void)expertRecommendAddView:(ExpertRecommendAddView *)exView clickBtn:(UIButton *)sender;

@end

@interface ExpertRecommendAddView : UIView
/** 代理人*/
@property (nonatomic, weak) id<ExpertRecommendAddViewDelegate> delegate;
@end
