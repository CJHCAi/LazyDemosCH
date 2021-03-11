//
//  SelectModelView.h
//  75AG驾校助手
//
//  Created by again on 16/4/9.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    testModel,
    lookingModel
}SelectModel;
typedef void (^SelectTouch)(SelectModel model);
@interface SelectModelView : UIView
@property (assign,nonatomic) SelectModel model;
- (SelectModelView *)initWithFrame:(CGRect)frame addTouch:(SelectTouch)touch;
@end
