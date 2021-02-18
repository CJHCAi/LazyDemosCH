//
//  AllLucyNum.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "AllLucyNum.h"

@interface AllLucyNum()
{
    NSInteger _iconNumbers;
}

@end

@implementation AllLucyNum
- (instancetype)initWithFrame:(CGRect)frame TitleImage:(UIImage *)titleImage title:(NSString *)title lucyIconImage:(UIImage *)image nullImage:(UIImage *)nullImage iconAmount:(NSInteger)number detailDsc:(NSString *)detailDesc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        self.titleImage.image = titleImage;
        [self addSubview:self.titleImage];
        self.titleImage.sd_layout.leftSpaceToView(self,10).topSpaceToView(self,10).heightIs(22).widthIs(22);
        
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.leftSpaceToView(self.titleImage,5).topEqualToView(self.titleImage).bottomEqualToView(self.titleImage).widthIs(4*15);
        //五个小图
        [self creatFinvImageViewWithImage:image nullImage:nullImage fullNumber:number];
        
        //虚线
        [self addSubview:self.lineView];
        self.lineView.sd_layout.leftEqualToView(self.titleImage).rightSpaceToView(self,10).topSpaceToView(self.titleImage,4).heightIs(1);
        //内容
//        [self addSubview:self.detailText];
        
        //行间距调整
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        [paragraphStyle setLineSpacing:8];
//        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_detailText.text];
//        [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _detailText.text.length)];
//        [_detailText setAttributedText:noteStr];
        [self setupLabelWithStr:detailDesc];
        
    }
    return self;
}

-(void)creatFinvImageViewWithImage:(UIImage *)image nullImage:(UIImage *)nullImage fullNumber:(NSInteger)number {
    for (int idx = 0; idx<number; idx++) {
        UIImageView *imageViews = [UIImageView new];
        imageViews.image = image;
        [self addSubview:imageViews];
        imageViews.sd_layout.leftSpaceToView(self.titleLabel, 8+ idx*(self.titleLabel.font.pointSize +3)).topSpaceToView(self,13).heightIs(self.titleLabel.font.pointSize).widthIs(self.titleLabel.font.pointSize);
    }
    
    for (int idx = 0; idx<5-number; idx++) {
        UIImageView *imageViews2 = [UIImageView new];
        imageViews2.image = nullImage;
          [self addSubview:imageViews2];
        imageViews2.sd_layout.leftSpaceToView(self.titleLabel,8+  ((number)+idx) *(self.titleLabel.font.pointSize +3)).topSpaceToView(self,13).heightIs(self.titleLabel.font.pointSize).widthIs(self.titleLabel.font.pointSize);
      
    }
}

#pragma mark *** 高度自适应 ***

- (void)setupLabelWithStr:(NSString *)string {
    //准备工作
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = string;
    textLabel.font = MFont(14);
    textLabel.numberOfLines = 0;//根据最大行数需求来设置
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(self.bounds.size.width-20, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label
    textLabel.frame = CGRectMake(10, CGRectYH(self.titleImage)+0.03*Screen_height, expectSize.width, expectSize.height);
   
    
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, expectSize.height+self.titleImage.bounds.size.height+0.045*Screen_height);

    
    
    
    self.detailText = textLabel;
    [self addSubview:textLabel];
 }


#pragma mark *** getters ***

-(UIImageView *)titleImage{
    if (!_titleImage) {
        _titleImage = [UIImageView new];
        
    }
    return _titleImage;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = MFont(15);
    }
    return _titleLabel;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LH_RGBCOLOR(225, 225, 225);
    }
    return _lineView;
}



-(UILabel *)detailText{
    if (!_detailText) {
        _detailText = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectYH(self.titleImage)+0.1*Screen_height, self.bounds.size.width-20, 20)];
        _detailText.text = @"今天出门上班前要多检查随身物品，不要忘记带重要文件，记忆力可是有点不太靠谱破！工作期间会遇到不少的困难阻碍这你向前，但版是非常积极。个人身体状态不错，弹药多留言九中女性长辈的健康。";
        _detailText.numberOfLines = 0;
        _detailText.font = MFont(14);
        
        [_detailText sizeToFit];
   
    }
    return _detailText;
}

@end
