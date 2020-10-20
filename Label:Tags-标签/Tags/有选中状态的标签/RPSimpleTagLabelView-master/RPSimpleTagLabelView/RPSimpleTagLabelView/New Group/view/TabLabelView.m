//
//  TabLabelView.m
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import "TabLabelView.h"
#import "NSString+Extension.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation TabLabelView

- (instancetype)initWithFrame:(CGRect)frame andTabsArray:(NSArray *)array andBackgroundColor:(nonnull UIColor *)backColor{
    self.getArray = [NSMutableArray array];
    if (self = [super initWithFrame:frame]) {
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
        
        for (int i= 0; i<array.count; i++) {
            CGSize tagTextSize = [[array[i] valueForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(SCREEN_WIDTH - 30 - 30 , 30)];
            if (tagBtnX+tagTextSize.width + 30 > SCREEN_WIDTH - 30) {
                tagBtnX = 0;
                tagBtnY += 30 + 15;
            }
            self.tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.tagBtn.tag = 100 + i;
            self.backColor = backColor;
            self.tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width + 30, 30);
            [self.tagBtn setTitle:[array[i] valueForKey:@"name"] forState:UIControlStateNormal];
           
            if ([[array[i] valueForKey:@"type"]integerValue] == 0) {
                [self.tagBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.tagBtn.layer.borderColor = self.tagBtn.titleLabel.textColor.CGColor;
                self.tagBtn.backgroundColor = [UIColor whiteColor];
            } else {
                [self.tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.tagBtn.layer.borderColor = [UIColor clearColor].CGColor;
                self.tagBtn.backgroundColor = [NSString colorWithHexString:@"#3997fd"];
            }
            
            
            self.tagBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            self.tagBtn.layer.cornerRadius = 15;
            self.tagBtn.layer.masksToBounds = YES;
            self.tagBtn.layer.borderWidth = 1;
            [self.tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.tagBtn];
            tagBtnX = CGRectGetMaxX(self.tagBtn.frame)+10;
        }
        self.heightAll = CGRectGetMaxY(self.tagBtn.frame) + 10;
    }
    return self;
}

- (void)tagBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(showTipMessageWithButton:)]) {
        [self.delegate showTipMessageWithButton:btn];
    }
}
- (CGFloat)setCell {
    return self.heightAll;
}

@end

