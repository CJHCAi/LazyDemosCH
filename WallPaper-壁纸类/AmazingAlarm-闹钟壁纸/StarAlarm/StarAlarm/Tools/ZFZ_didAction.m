//
//  ZFZ_didAction.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/13.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "ZFZ_didAction.h"

@implementation ZFZ_didAction

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //编辑
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        removeButton.frame = CGRectMake(50, 5, 30,30);
        [removeButton setImage:[UIImage imageNamed:@"yumao"] forState:UIControlStateNormal];
        [self addSubview:removeButton];
        [removeButton addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
        //删除
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(100, 5, 30,30);
        [deleteButton setImage:[UIImage imageNamed:@"sanchu"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];

    }
    return self;
}

- (void)deleteAction:(UIButton *)yy {
    NSLog(@"删除");
    [self removeFromSuperview];
    self.blockOfRemoveBigView();
    [self.delegate deleteActionWittModel:_dataModel];
    
}

- (void)removeAction:(UIButton *)yy {
    [self removeFromSuperview];
    self.blockOfRemoveBigView();
    [self.delegate didActionWithModel:_dataModel];
 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点xiaoview");

    [self removeFromSuperview];
    self.blockOfRemoveBigView();
    
}

@end
