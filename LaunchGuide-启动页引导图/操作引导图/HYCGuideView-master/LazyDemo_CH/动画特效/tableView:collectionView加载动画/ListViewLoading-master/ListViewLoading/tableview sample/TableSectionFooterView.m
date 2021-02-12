//
//  TableSectionFooterView.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "TableSectionFooterView.h"

@implementation TableSectionFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UILabel *)tip {
    if (!_tip) {
        for (__kindof UIView *sub in self.subviews) {
            if (sub.tag == 300) {
                _tip = sub;
            }
        }
    }
    return _tip;
}

@end
