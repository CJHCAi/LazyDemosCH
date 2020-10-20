//
//  SXTLandingInPutView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^nextViewControllerBlock)(NSDictionary *dic);
@interface SXTLandingInPutView : UIView

@property (copy, nonatomic) nextViewControllerBlock nextBlock;//去往下一个页面回调的block

@end
