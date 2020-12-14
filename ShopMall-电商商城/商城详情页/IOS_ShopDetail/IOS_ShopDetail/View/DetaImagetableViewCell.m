//
//  DetaImagetableViewCell.m
//  LD_app_ios_NetWin
//
//  Created by 苟应航 on 2018/7/6.
//  Copyright © 2018年 lddtgroup. All rights reserved.
//

#import "DetaImagetableViewCell.h"

@implementation DetaImagetableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *image=[UIImageView new];
//        image.clipsToBounds=YES;
        image.contentMode=UIViewContentModeScaleAspectFit;
        image.userInteractionEnabled=YES;
        image.image=GHImage(@"logbackimags");
        [self.contentView addSubview:image];
        _image=image;
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}
+(instancetype)WithDetaImagetableViewCell:(UITableView *)tableview{
    NSString *const ID = @"DetaImagetableViewCellID";
    DetaImagetableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[DetaImagetableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
