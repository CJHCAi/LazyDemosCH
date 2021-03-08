//
//  SheetView.h
//  StudyDrive
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SheetViewDelegate
-(void)SheetViewClick:(int)index;
@end

@interface SheetView : UIView
{
    @public
    UIView * _backView;
}
@property(nonatomic,weak)id<SheetViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuesCount:(int)count title:(NSString*)title;
@end
