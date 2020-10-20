//
//  MeituImageEditView.h
//  TestAPP
//
//  Created by yangyong on 14-6-4.
//  Copyright (c) 2014年 gainline. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MeituImageEditViewDelegate;
@interface MeituImageEditView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView  *contentView;
@property (nonatomic, retain) UIBezierPath  *realCellArea;
@property (nonatomic, retain) UIImageView   *imageview;
@property (nonatomic, assign) id<MeituImageEditViewDelegate> tapDelegate;
@property (nonatomic, assign) CGRect        oldRect;
- (void)setImageViewData:(UIImage *)imageData;
- (void)setImageViewData:(UIImage *)imageData rect:(CGRect)rect;

- (void)setNotReloadFrame:(CGRect)frame;
@end


@protocol MeituImageEditViewDelegate <NSObject>

- (void)tapWithEditView:(MeituImageEditView *)sender;
@end