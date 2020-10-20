//
//  ExpertRecommendEditViewController.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BaseViewController.h"

@class ExpertRecommendEditViewController;

@protocol ExpertRecommendEditViewControllerDelegate <NSObject>

-(void)sureToEdit:(NSString *)str withTitle:(NSString *)title;

@end

@interface ExpertRecommendEditViewController : BaseViewController
/** 代理人*/
@property (nonatomic, weak) id<ExpertRecommendEditViewControllerDelegate> delegate;
@end
