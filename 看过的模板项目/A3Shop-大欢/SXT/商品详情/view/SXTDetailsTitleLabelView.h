//
//  SXTDetailsTitleLabelView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/23.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTDetailsTitleModel.h"

typedef void(^returnViewHeightBlock)(CGFloat height);

@interface SXTDetailsTitleLabelView : UIView

@property (strong, nonatomic)   SXTDetailsTitleModel *titleModel;              /** titleView存储数据的model */
@property (copy, nonatomic)   returnViewHeightBlock heightBlock;/**返回view最终高度*/
@end
