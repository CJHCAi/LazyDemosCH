//
//  ToolBarView.h
//  TableviewLayout
//
//  Created by 闫继祥 on 2019/7/16.
//  Copyright © 2019 yang.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLCustomButton.h"

NS_ASSUME_NONNULL_BEGIN
//  声明协议
@protocol btnClickedDelegate <NSObject>

-(void)BtnLeftClicked;
-(void)BtnRightClicked;

@end

@interface YjxToolBarView : UIView
@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;
@property(nonatomic, strong)UIView *line;
@property(nonatomic, strong)UIView *line1;

@property(nonatomic, strong)YSLCustomButton *buttonLeft;
@property(nonatomic, strong)YSLCustomButton *buttonRight;

@end

NS_ASSUME_NONNULL_END
