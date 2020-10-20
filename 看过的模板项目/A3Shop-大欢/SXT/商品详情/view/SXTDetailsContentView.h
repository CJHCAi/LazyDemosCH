//
//  SXTDetailsContentView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/23.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnContentHeightBlock)(CGFloat height);

@interface SXTDetailsContentView : UIView

@property (strong, nonatomic)   NSArray *contentArray;/** 存放数据model的数组 */
@property (copy, nonatomic)    returnContentHeightBlock heightBlock;/**返回高度block*/
@end
