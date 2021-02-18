//
//  CommentCell.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView{
    _headIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 25, 25)];
    [self.contentView addSubview:_headIV];
    _headIV.layer.cornerRadius = 12.5;

    _nameLb = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLb];
    _nameLb.font = MFont(11);
    _nameLb.textColor = LH_RGBCOLOR(130, 130, 130);

    _StarV = [[StarView alloc]initWithFrame:CGRectMake(CGRectXW(_nameLb)+5, 24, 60, 12)];
    [self.contentView addSubview:_StarV];
    _StarV.backgroundColor = [UIColor clearColor];

    _timeLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-75, 23, 65, 15)];
    [self.contentView addSubview:_timeLb];
    _timeLb.font = MFont(11);
    _timeLb.textColor = LH_RGBCOLOR(130, 130, 130);
    _timeLb.textAlignment = NSTextAlignmentLeft;

    _descLb = [[UILabel alloc]init];
    [self.contentView addSubview:_descLb];
    _descLb.font = MFont(13);
    _descLb.textAlignment = NSTextAlignmentLeft;
    _descLb.numberOfLines = 0;

    _infoLb = [[UILabel alloc]init];
    [self.contentView addSubview:_infoLb];
    _infoLb.font = MFont(12);
    _infoLb.textAlignment = NSTextAlignmentLeft;
    _infoLb.textColor = LH_RGBCOLOR(100, 100, 100);

}
/**
 *  更新约束
 */
-(void)updateFrame{
    [self widthWithLabel:_nameLb];
    _StarV.frame = CGRectMake(CGRectXW(_nameLb)+5, 24, 50, 10);
    _descLb.frame = CGRectMake(10, CGRectYH(_headIV)+10, __kWidth-20, [self heightWithLabel:_descLb]);
    _infoLb.frame = CGRectMake(10, CGRectYH(_descLb)+5, __kWidth-20, 20);
   
}

#pragma mark ==评价内容文本岁内容改变高度==
-(CGFloat)heightWithLabel:(UILabel *)sender{
    NSString *str = sender.text;
    CGFloat height = 0.0 ;
    if (str.length*14>__kWidth-20) {
        for (int i=1; i<10; i++) {
            if (str.length*14>(__kWidth-20)*i&&str.length*14<(__kWidth-20)*(i+1)) {
                height =(i+1)*16.0;
            }
        }
    }else{
        height = 15.0;
    }
    return height;
}

#pragma mark ==用户姓名文本随内容改变宽度==
-(void)widthWithLabel:(UILabel *)sender{
    NSString *str=sender.text;
    CGSize size = [str sizeWithFont:sender.font constrainedToSize:CGSizeMake(sender.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [sender setFrame:CGRectMake(CGRectXW(_headIV)+8, 23, size.width, 15)];

}

@end
