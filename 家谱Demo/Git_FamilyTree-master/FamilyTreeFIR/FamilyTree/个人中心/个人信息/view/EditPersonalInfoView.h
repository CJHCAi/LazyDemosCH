//
//  EditPersonalInfoView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"
@interface EditPersonalInfoView : UIScrollView
/** 账户信息详细数组*/
@property (nonatomic, strong) NSMutableArray *accountInfoDetailArr;
/** 个人信息详细数组*/
@property (nonatomic, strong) NSMutableArray *personalInfoDetailArr;
-(void)reloadEditPersonalInfoData:(QueryModel *)queryModel;
-(NSMutableString *)getInterestStr;
@end
