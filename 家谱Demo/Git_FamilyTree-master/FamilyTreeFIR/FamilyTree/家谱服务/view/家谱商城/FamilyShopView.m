//
//  FamilyShopView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FamilyShopView.h"
@interface FamilyShopView()
@property (nonatomic,strong) UIImageView *titleImage; /*商城Image*/
@property (nonatomic,strong) UIImageView *hornView; /*喇叭*/

@property (nonatomic,strong) UILabel *advLabel; /*广告Label*/



@end
@implementation FamilyShopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleImage];
        [self addSubview:self.hornView];
        [self addSubview:self.advLabel];
        
        //添加手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

#pragma mark *** 手势方法 ***

-(void)respondsToTapGesture{
    
    if (_delegate && [_delegate respondsToSelector:@selector(familyShopViewDidTapView:)]) {
        [_delegate familyShopViewDidTapView:self];
    }
}


#pragma mark *** getters ***

-(UIImageView *)titleImage{
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 49, SelfView_height)];
        _titleImage.image = MImage(@"jiapu_logo");
    }
    return _titleImage;
}
-(UIImageView *)hornView{
    if (!_hornView) {
        _hornView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+15,self.titleImage.center.y-8 , 16, 15)];
        _hornView.image = MImage(@"laBa");
    }
    return _hornView;
}

-(UILabel *)advLabel{
    if (!_advLabel) {
        _advLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hornView.frame)+10, 0, 200, SelfView_height)];
        _advLabel.font = MFont(11);
        _advLabel.text = @"云南普洱茶，传承经典\n热卖大促，包邮直达";
        
       
        _advLabel.numberOfLines = 2;
        //颜色不同
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_advLabel.text];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"热卖大促，包邮直达"].location, [[noteStr string] rangeOfString:@"热卖大促，包邮直达"].length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        
        //行间距调整为6
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:6];
        [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _advLabel.text.length)];
        [_advLabel setAttributedText:noteStr];

    }
    return _advLabel;
}
@end
