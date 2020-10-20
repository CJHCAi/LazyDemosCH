//
//  LineageCellView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "LineageCellView.h"

@interface LineageCellView ()
/** 头像视图*/
@property (nonatomic, strong) UIImageView *headIV;

/** 关系标签*/
@property (nonatomic, strong) UILabel *relationLB;
@end


@implementation LineageCellView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headIV];
        [self addSubview:self.nameLB];
        //[self addSubview:self.relationLB];
    }
    return self;
}

-(void)setModel:(LineageDatalistModel *)model{
    _model = model;
    [_headIV setImageWithURL:[NSURL URLWithString:model.head] placeholder:[model.sex isEqualToString:@"男"]?MImage(@"man"):MImage(@"woman")];
    _headIV.backgroundColor = [model.sex isEqualToString:@"男"]?LH_RGBCOLOR(235, 247, 242):LH_RGBCOLOR(251, 246, 245);
    _nameLB.text = model.username;
}


#pragma mark - lazyLoad
-(UIImageView *)headIV{
    if (!_headIV) {
        _headIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self), CGRectH(self)/3*2)];
        _headIV.contentMode = UIViewContentModeScaleAspectFit;
        _headIV.image = MImage(@"man");
        _headIV.layer.cornerRadius = CGRectW(self)/2;
        _headIV.layer.masksToBounds = YES;
        _headIV.backgroundColor = LH_RGBCOLOR(235, 247, 242);
    }
    return _headIV;
}

-(UILabel *)nameLB{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectH(self)/3*2, CGRectW(self), CGRectH(self)/5+CGRectH(self)/15*2)];
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.font = MFont(12);
        _nameLB.text = @"姓名";
    }
    return _nameLB;
}

//-(UILabel *)relationLB{
//    if (!_relationLB) {
//        _relationLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectH(self)/15*13, CGRectW(self), CGRectH(self)/15*2)];
//        _relationLB.textAlignment = NSTextAlignmentCenter;
//        _relationLB.font = MFont(9);
//        _relationLB.text = @"(关系)";
//    }
//    return _relationLB;
//}
@end
