//
//  SelectModelView.h
//  StudyDrive
//
//  Created by zgl on 16/1/23.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    testModel,
    lookingModel
}SelectModel;
typedef void (^SelectTouch)(SelectModel model);

@interface SelectModelView : UIView

@property(nonatomic,assign)SelectModel model;
-(SelectModelView *)initWithFrame:(CGRect)frame addTouch:(SelectTouch)touch;

@end
