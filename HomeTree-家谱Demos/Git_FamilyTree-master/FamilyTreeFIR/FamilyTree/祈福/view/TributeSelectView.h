//
//  TributeSelectView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CliffordTributeModel.h"

@class TributeSelectView;

@protocol TributeSelectViewDelegate <NSObject>

-(void)buyOneTribute:(CliffordTributeModel *)tributeModel;

@end


@interface TributeSelectView : UIView
/** 获取贡品的三种商品数组*/
@property (nonatomic, strong) NSArray<CliffordTributeModel *> *tributeArr;
/** 代理人*/
@property (nonatomic, weak) id<TributeSelectViewDelegate> delegate;
@end
