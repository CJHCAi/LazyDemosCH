//
//  YXWHardView.m
//  StarAlarm
//
//  Created by dllo on 16/4/1.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWHardView.h"

@interface YXWHardView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *starView;
@property (nonatomic, strong) UIImageView *starOne;
@property (nonatomic, strong) UIImageView *starTwo;
@property (nonatomic, strong) UIImageView *starThree;
@property (nonatomic, strong) UIImageView *starFour;
@property (nonatomic, strong) UIImageView *starFive;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation YXWHardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
        [self creatTitle];
        [self creatStar];
    }
    return self;
}

- (void)creatTitle {
    self.title = [UILabel new];
    self.title.text = @"难度:";
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.textColor = [UIColor whiteColor];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.centerX.equalTo(self.mas_centerX).offset(-50);
        make.width.equalTo(@35);
    }];
    
    self.starView = [UIView new];
    [self addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.centerX.equalTo(self.mas_centerX).offset(+30);
        make.width.equalTo(@110);
    }];
}

- (void)setHard:(Hard)hard {
    _hard = hard;
    
    switch (self.hard) {
        case ONESTAR:
            [self setOneStar];
            break;
        case TWOSTAR:
            [self setTwoStar];
            break;
        case THREESTAR:
            [self setThreeStar];
            break;
        case FOURSTAR:
            [self setFourStar];
            break;
        case FIVESTAR:
            [self setFiveStar];
            break;
        default:
            break;
    }
}

- (void)creatStar {
    self.starOne = [[UIImageView alloc] init];
    self.starOne.frame = CGRectMake(1, 5, 20, 20);
    [self.starView addSubview:self.starOne];
    
    self.starTwo = [[UIImageView alloc] init];
    self.starTwo.frame = CGRectMake(23, 5, 20, 20);
    [self.starView addSubview:self.starTwo];
    
    self.starThree = [[UIImageView alloc] init];
    self.starThree.frame = CGRectMake(45, 5, 20, 20);
    [self.starView addSubview:self.starThree];
    
    self.starFour = [[UIImageView alloc] init];
    self.starFour.frame = CGRectMake(67, 5, 20, 20);
    [self.starView addSubview:self.starFour];
    
    self.starFive = [[UIImageView alloc] init];
    self.starFive.frame = CGRectMake(89, 5, 20, 20);
    [self.starView addSubview:self.starFive];
}

- (void)creatImageView:(UIImageView *)iamgeView {
    iamgeView = [[UIImageView alloc] init];
    [self.starView addSubview:iamgeView];
}

- (void)setOneStar {
    [self.starOne setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starTwo setImage:[UIImage imageNamed:@"starWhite"]];
    [self.starThree setImage:[UIImage imageNamed:@"starWhite"]];
    [self.starFour setImage:[UIImage imageNamed:@"starWhite"]];
    [self.starFive setImage:[UIImage imageNamed:@"starWhite"]];
}

- (void)setTwoStar {
    [self.starOne setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starTwo setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starThree setImage:[UIImage imageNamed:@"starWhite"]];
    [self.starFour setImage:[UIImage imageNamed:@"starWhite"]];
    [self.starFive setImage:[UIImage imageNamed:@"starWhite"]];
}

- (void)setThreeStar {
    [self.starOne setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starTwo setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starThree setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starFour setImage:[UIImage imageNamed:@"starWhite"]];
    [self.starFive setImage:[UIImage imageNamed:@"starWhite"]];
}

- (void)setFourStar {
    [self.starOne setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starTwo setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starThree setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starFour setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starFive setImage:[UIImage imageNamed:@"starWhite"]];
}

- (void)setFiveStar {
    [self.starOne setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starTwo setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starThree setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starFour setImage:[UIImage imageNamed:@"starBlue"]];
    [self.starFive setImage:[UIImage imageNamed:@"starBlue"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
