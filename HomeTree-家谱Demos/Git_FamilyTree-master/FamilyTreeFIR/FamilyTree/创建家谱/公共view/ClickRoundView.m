//
//  ClickRoundView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ClickRoundView.h"

#define RoundSize 5
@interface ClickRoundView()
{
    BOOL _isStar;
}

@property (nonatomic,strong) UIButton *roundBtn; /*圆点*/

@property (nonatomic,strong) UIView *blackPointView; /*黑点*/

@property (nonatomic,strong) UILabel *titleLabel; /*标题*/


@end
@implementation ClickRoundView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title isStar:(BOOL)star
{
    self = [super initWithFrame:frame];
    if (self) {
        _isStar = star;
        _marked = false;
        [self addSubview:self.roundBtn];
        [self addSubview:self.titleLabel];
        
        self.titleLabel.text = title;
        
        self.titleLabel.sd_layout.leftSpaceToView(self.roundBtn,-5).bottomEqualToView(self.roundBtn).topEqualToView(self.roundBtn).widthIs(title.length*37*AdaptationWidth());
    }
    return self;
}

#pragma mark *** Events ***

-(void)respondsToBlackPointBtn:(UIButton *)sender{
    MYLog(@"黑点");
    _marked = !_marked;
    if (_marked) {
        self.blackPointView.hidden = false;
        
    }else{
        self.blackPointView.hidden = true;
    }
    
}
#pragma mark *** getters ***

-(UIButton *)roundBtn{
    if (!_roundBtn) {
        _roundBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
        
        NSInteger gapSize = 12;
        
        UIView *rouView = [[UIView alloc] initWithFrame:CGRectMake(gapSize, gapSize, self.bounds.size.height-gapSize*2, self.bounds.size.height-gapSize*2)];
        rouView.layer.borderColor = BorderColor;
        rouView.layer.borderWidth = 1.0f;
        rouView.layer.cornerRadius = rouView.bounds.size.width/2;
        rouView.layer.masksToBounds = YES;
        rouView.backgroundColor = [UIColor whiteColor];
        
        rouView.userInteractionEnabled = NO;
        
        [_roundBtn addSubview:rouView];
        
        CGFloat pointSize = rouView.bounds.size.height/3;
        
//        UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(pointSize, pointSize, pointSize, pointSize)];
        UIView *pointView = [UIView new];
        pointView.layer.cornerRadius =  2.8;
        pointView.layer.borderWidth = 1.0f;
        pointView.layer.masksToBounds = YES;
        pointView.backgroundColor = [UIColor blackColor];
        
        [rouView addSubview:pointView];
        pointView.sd_layout.leftSpaceToView(rouView,pointSize).topSpaceToView(rouView,pointSize).rightSpaceToView(rouView,pointSize).bottomSpaceToView(rouView,pointSize);
        self.blackPointView = pointView;
        self.blackPointView.hidden = YES;
        
        [_roundBtn addTarget:self action:@selector(respondsToBlackPointBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _roundBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font  = WFont(35);
        if (_isStar) {
            UILabel *starLabel = [UILabel new];
            starLabel.font = MFont(16);
            starLabel.text = @"*";
            starLabel.textColor = [UIColor redColor];
            [self addSubview:starLabel];
            starLabel.sd_layout.leftSpaceToView(_roundBtn,130*AdaptationWidth()).topEqualToView(_titleLabel).widthIs(10).heightIs(self.bounds.size.height);
            
            
        }
        
        
    }
    return _titleLabel;
}


@end
