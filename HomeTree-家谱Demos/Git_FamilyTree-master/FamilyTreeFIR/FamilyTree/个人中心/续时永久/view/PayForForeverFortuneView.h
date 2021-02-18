//
//  PayForForeverFortuneView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayForForeverFortuneView;

@protocol PayForForeverFortuneViewDelegate <NSObject>

-(void)clickPayForForeverFortuneSure;

@end


@interface PayForForeverFortuneView : UIView
/** 代理人*/
@property (nonatomic, weak) id<PayForForeverFortuneViewDelegate> delegate;
@end
