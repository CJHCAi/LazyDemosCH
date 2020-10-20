//
//  NameBeginView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NameBeginView.h"
#import "NSString+arabicToChinese.h"

@implementation NameBeginView
-(instancetype)initWithFrame:(CGRect)frame Index:(int)index text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *indexLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 125*AdaptationWidth(), 40*AdaptationWidth())];
        indexLB.text = [NSString stringWithFormat:@"源流%@:",[NSString translation:index]];
        indexLB.font = WFont(30);
        indexLB.textColor = LH_RGBCOLOR(238, 132, 139);
        [self addSubview:indexLB];
        self.infoLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(indexLB)+2, self.size.width, 360*AdaptationWidth())];
        self.infoLB.text = text;
        self.infoLB.numberOfLines = 0;
        self.infoLB.font = WFont(25);
        [self.infoLB sizeToFit];
        [self addSubview:self.infoLB];
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = LH_RGBCOLOR(217, 219, 218);
        [self addSubview:self.lineView];
        self.lineView.sd_layout.widthIs(self.frame.size.width).heightIs(1).topSpaceToView(self.infoLB,10);
    }
    return self;
}



@end
