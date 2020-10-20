//
//  SXTBottomImageView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnImageHeightBlock)(CGFloat height);
@interface SXTBottomImageView : UIView

@property (strong, nonatomic)   NSArray *imageArray;              /** 接受存储图片信息的数组 */
@property (copy, nonatomic) returnImageHeightBlock imageHeightBlock;/** 返回图片高度block */
@end
