//
//  YIMEditerAccessoryMenuItem.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIMEditerProtocol.h"


@interface YIMEditerAccessoryMenuItem : NSObject
@property(nonatomic,strong)UIImage *image;
-(instancetype)initWithImage:(UIImage*)image;

/**默认返回nil，子类继承返回的view将在点击时切换至textView的inputView*/
-(UIView*)menuItemInputView;
/**用户点击该菜单时,返回值指示是否切换到该item*/
-(BOOL)clickAction;
@end
