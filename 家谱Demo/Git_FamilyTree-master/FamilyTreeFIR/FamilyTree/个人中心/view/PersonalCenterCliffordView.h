//
//  PersonalCenterCliffordView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemallInfoModel.h"

@interface PersonalCenterCliffordView : UIView
-(void)reloadData:(MemallInfoGrqwModel *)grqw;
-(void)reloadDevoutData:(DevoutModel *)devout;
@end
