//
//  SelectModelView.h
//  DriverAssistant
//
//  Created by C on 16/3/31.
//  Copyright © 2016年 C. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectTouch)(UIButton *btn);
@interface SelectModelView : UIView
- (SelectModelView *)initWithFrame:(CGRect)frame andTouch:(SelectTouch)touch;
@end
