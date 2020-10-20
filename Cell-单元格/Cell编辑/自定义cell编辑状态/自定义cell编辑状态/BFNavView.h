//
//  BFNavView.h
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFNavView : UIView
/** 标题 */
@property(nonatomic,weak) UILabel *titleLabel;
///** 左上角按钮 */
//@property(nonatomic,weak) UIButton *leftBtn;
/** 右上角按钮 */
@property(nonatomic,weak) UIButton *rightBtn;

/** init方法,isRight右上角按钮存在标识 */
- (instancetype)initWithRight:(BOOL)isRight;
@end
