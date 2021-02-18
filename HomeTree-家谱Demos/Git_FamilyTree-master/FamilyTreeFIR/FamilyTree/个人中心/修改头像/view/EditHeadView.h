//
//  EditHeadView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditHeadView;

@protocol EditHeadViewDelegate <NSObject>

- (void)editHeadView:(EditHeadView *)editHeadView HeadInsideImage:(UIImage *)headInsideImage;

@end

@interface EditHeadView : UIView
/** 代理人*/
@property (nonatomic, weak) id<EditHeadViewDelegate> delegate;
@end
