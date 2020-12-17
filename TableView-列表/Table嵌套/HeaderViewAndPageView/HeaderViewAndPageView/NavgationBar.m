//
//  NavgationBar.m
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//

#import "NavgationBar.h"

@implementation NavgationBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)creatNavgationgBarWithTextColor:(UIColor *)color withTitleText:(NSString *)title{
    
    _title_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
    _title_label.text=title;
    _title_label.font=[UIFont systemFontOfSize:18];
    _title_label.textAlignment= NSTextAlignmentCenter;
    _title_label.textColor = color;
    _title_label.tag = 100;
    [self addSubview:_title_label];
}
@end
