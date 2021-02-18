//
//  PjView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/18.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PjView;
@protocol PjViewDelegate <NSObject>

-(void)clickBtnToPjZcVC;

@end

@interface PjView : UIView
/** 代理人*/
@property (nonatomic, weak) id<PjViewDelegate> delegate;
@end
