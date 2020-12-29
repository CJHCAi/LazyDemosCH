//
//  HKCounSuccessCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCounSuccessCell.h"

@interface HKCounSuccessCell ()

@property (weak, nonatomic) IBOutlet UIView *ContentV;

@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;
@property (weak, nonatomic) IBOutlet UILabel *inforabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberCoinLabel;

@end

@implementation HKCounSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =[UIColor whiteColor];
   //加虚线边框..
    [self addBottedlineWidth:1 lineColor:[UIColor colorFromHexString:@"666666"] andViews:self.ContentV];
    
    self.numberCoinLabel.attributedText =[self configuLabelImageWith:10];
}

-(NSMutableAttributedString *)configuLabelImageWith:(NSInteger)count {
    NSString *countStr =[NSString stringWithFormat:@"%zdLB",count];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"yhq_lb"];
    attch.bounds = CGRectMake(0,-4,20,20);
    //创建带有图片的富文本
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",countStr]];
    [attri insertAttributedString:string atIndex:0];
    return  attri;
}
-(void)addBottedlineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor andViews:(UIView *)view{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = lineColor.CGColor;
    border.fillColor = nil;
    CGRect rect = CGRectMake(0,0,kScreenWidth-30,CGRectGetHeight(view.frame));
    
    border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    border.frame =rect;
    border.lineWidth = lineWidth;
    border.lineCap = @"square";
    //设置线宽和线间距
    border.lineDashPattern = @[@4, @5];
    [view.layer addSublayer:border];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
