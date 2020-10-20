//
//  MMEditView.h
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/21.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  图片编辑
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OperateType) {
    kOperateTypeCancel = 0, // 取消
    kOperateTypeFinish,     // 完成
};

@protocol MMEditViewDelegate;
@interface MMEditView : UIView

// 代理
@property (nonatomic,assign) id<MMEditViewDelegate> delegate;
@property (nonatomic,assign) UIImage *midImage;

@end

@protocol MMEditViewDelegate <NSObject>

@optional
- (void)editView:(MMEditView *)tabBar operateType:(OperateType)type;

@end
