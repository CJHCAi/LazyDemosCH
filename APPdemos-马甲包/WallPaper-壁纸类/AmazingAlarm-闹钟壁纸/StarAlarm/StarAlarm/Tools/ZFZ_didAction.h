//
//  ZFZ_didAction.h
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/13.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFZ_dataModel.h"

@protocol ZFZ_didActionDelegate <NSObject>

- (void)didActionWithModel:(ZFZ_dataModel *)dataModel;
- (void)deleteActionWittModel:(ZFZ_dataModel *)dataModel;

@end

@interface ZFZ_didAction : UIView

@property (nonatomic, copy) void(^blockOfRemoveBigView)();
@property (nonatomic, strong) id<ZFZ_didActionDelegate>delegate;
@property (nonatomic, strong) ZFZ_dataModel *dataModel;


@end
