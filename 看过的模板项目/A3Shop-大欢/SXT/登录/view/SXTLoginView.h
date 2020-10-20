//
//  SXTLoginView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/21.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginMethodBlock)(NSDictionary *dic);

@interface SXTLoginView : UIView


@property (copy, nonatomic) loginMethodBlock loginBlock;//登录信息返回

@end
