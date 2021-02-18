//
//  HeadImageView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "HeadImageView.h"

@implementation HeadImageView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.headInsideIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.137*CGRectW(self), 0.0967*CGRectH(self), 0.7100*CGRectW(self), 0.7100*CGRectH(self))];
        self.image = MImage(@"xiuGaitouxiang_tx");
        if (self.headInsideIV.image == nil) {
            self.headInsideIV.image = MImage(@"tx_1");
        }
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.headInsideIV.layer.cornerRadius = 0.7500*CGRectW(self)/2;
        self.headInsideIV.layer.masksToBounds = YES;
        self.headInsideIV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.headInsideIV];
        
    }
    return self;
}
@end
