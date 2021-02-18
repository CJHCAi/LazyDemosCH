//
//  WApplyJoinView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

typedef enum : NSUInteger {
    WApplyJoinViewNeedCheck,
    WApplyJoinViewNeedlessCheck,
    
} WApplyJoinViewNeedCheckType;
#import <UIKit/UIKit.h>

@interface WApplyJoinView : UIView
@property (nonatomic,assign) WApplyJoinViewNeedCheckType checkType; /*申请家谱是否需要审核*/
- (instancetype)initWithFrame:(CGRect)frame checkType:(WApplyJoinViewNeedCheckType)checktype;
@end
