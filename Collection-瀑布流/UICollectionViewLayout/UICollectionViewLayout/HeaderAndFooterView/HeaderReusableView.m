//
//  HeaderReusableView.m
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/16.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "HeaderReusableView.h"

@implementation HeaderReusableView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        if (frame.size.height >0) {
            
            self.imgView = [[UIImageView alloc]init];
            self.imgView.contentMode = UIViewContentModeCenter;
            [self addSubview:self.imgView];
            [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
            
        }else {
            
            [self.imgView removeFromSuperview];
            
        }
       
        
    }
    return self;
}

@end
