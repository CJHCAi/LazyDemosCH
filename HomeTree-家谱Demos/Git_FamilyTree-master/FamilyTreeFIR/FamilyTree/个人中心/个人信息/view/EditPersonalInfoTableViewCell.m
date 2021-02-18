//
//  EditPersonalInfoTableViewCell.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "EditPersonalInfoTableViewCell.h"

@implementation EditPersonalInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithCustomStyle:(EditPersonalInfoTableViewCellCustomStyle)EditPersonalInfoTableViewCellCustomStyle{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //虚线
        self.dashLineLB = [[UILabel alloc]init];
        self.dashLineLB.text = @"---------------------------------------------------------";
        self.dashLineLB.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.dashLineLB];
        self.dashLineLB.sd_layout.leftSpaceToView(self.contentView,8).bottomSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,8).heightIs(2);
        //标题
        self.customTitleLB = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, 26)];
        [self.contentView addSubview:self.customTitleLB];
        self.customDetailLB = [[UILabel alloc]init];
        [self.contentView addSubview:self.customDetailLB];
        self.customDetailLB.sd_layout.leftSpaceToView(self.customTitleLB,5).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).widthIs(170);
        //根据不同样式设置不同按钮
        if (EditPersonalInfoTableViewCellCustomStyle == EditPersonalInfoTableViewCellStyleEdit) {
            self.editBtn = [[UIButton alloc]init];
            [self.editBtn setTitle:@"更改" forState:UIControlStateNormal];
            [self.editBtn setTitleColor:LH_RGBCOLOR(233, 124, 135) forState:UIControlStateNormal];
            self.editBtn.titleLabel.font = MFont(10);
            self.editBtn.layer.borderColor = LH_RGBCOLOR(233, 124, 135).CGColor;
            self.editBtn.layer.borderWidth = 1;
            self.editBtn.layer.cornerRadius = 3.0;
            [self.editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.editBtn];
            self.editBtn.sd_layout.topSpaceToView(self.contentView,6).bottomSpaceToView(self.contentView,6).rightSpaceToView(self.contentView,10).widthIs(35);
        }else if(EditPersonalInfoTableViewCellCustomStyle == EditPersonalInfoTableViewCellStyleArrow){
            self.editBtn = [[UIButton alloc]init];
            [self.editBtn setImage:MImage(@"geren_jiao") forState:UIControlStateNormal];
            [self.editBtn addTarget:self action:@selector(clickPullDownBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.editBtn];
            self.editBtn.sd_layout.topSpaceToView(self.contentView,6).bottomSpaceToView(self.contentView,6).rightSpaceToView(self.contentView,10).widthIs(35);
            self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        }
    }
    return self;
}

-(void)clickEditBtn:(UIButton *)sender{
    MYLog(@"更改");
    [self.delegate respondToEditBtn:sender];
    
}

-(void)clickPullDownBtn:(UIButton *)sender{
    MYLog(@"下拉");
    [self.delegate respondToPullDownBtn:sender];
}


@end
