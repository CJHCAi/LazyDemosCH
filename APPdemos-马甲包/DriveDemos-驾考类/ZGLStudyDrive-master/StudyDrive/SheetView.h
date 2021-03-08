//
//  SheetView.h
//  StudyDrive
//
//  Created by zgl on 16/1/23.
//  Copyright © 2016年 sj. All rights reserved.
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
- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuesCount:(int)count;

@end
