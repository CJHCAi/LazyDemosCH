//
//  FindPassView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/30.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FindPassView.h"
@implementation FindPassView

- (instancetype)initWithFrame:(CGRect)frame headImage:(UIImage *)image isSafe:(BOOL)Safe hasArrows:(BOOL)hasArrows withplaceholderStr:(NSString *)str
{
    self = [super initWithFrame:frame headImage:image isSafe:Safe hasArrows:hasArrows];
    if (self) {

        
        [self.verticalLine removeFromSuperview];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
        
        self.headView.frame = CGRectMake(5, 9, 22, 22);
        
        self.inputTextView.center = CGPointMake(32+self.inputTextView.bounds.size.width/2, self.headView.center.y);

        self.inputTextView.placeholder = str;
        
    }
    return self;
}

@end
