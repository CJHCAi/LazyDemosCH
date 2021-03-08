//
//  SelectModelView.h
//  StudyDrive
//
//  Created by apple on 15/8/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    testModel,
    lookingModel
}SelectModel;
typedef void (^SelecTouch)(SelectModel model);
@interface SelectModelView : UIView
@property(nonatomic,assign)SelectModel model;
-(SelectModelView *)initWithFrame:(CGRect)frame addTouch:(SelecTouch)touch;
@end
