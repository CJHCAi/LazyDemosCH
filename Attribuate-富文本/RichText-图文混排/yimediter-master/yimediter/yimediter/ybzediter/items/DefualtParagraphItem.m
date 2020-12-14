//
//  DefualtParagraphItem.m
//  yimediter
//
//  Created by ybz on 2017/12/1.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "DefualtParagraphItem.h"

@implementation DefualtParagraphItem

-(instancetype)init{
    return [self initWithImage:[UIImage imageNamed:@"yimediter.bundle/paragraph"]];
}
-(UIView*)menuItemInputView{
    return self.paragraphView;
}
-(YIMEditerParagraphView*)paragraphView{
    if (!_paragraphView) {
        _paragraphView = [[YIMEditerParagraphView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 280)];
        _paragraphView.paragraphStyle = [YIMEditerParagraphStyle createDefualtStyle];
    }
    return _paragraphView;
}

@end
