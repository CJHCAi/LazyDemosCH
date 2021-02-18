//
//  PrivateWorshipTableViewCell.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PrivateWorshipTableViewCell.h"


@interface PrivateWorshipTableViewCell()
/** 墓园名称标签*/
@property (nonatomic, strong) UILabel *cemeterialNameLB;

/** 浏览人数标签*/
@property (nonatomic, strong) UILabel *visitorNumberLB;
/** 扫墓人标签*/
@property (nonatomic, strong) UILabel *cemeterialPeopleLB;
/** 扫墓礼物标签*/
@property (nonatomic, strong) UILabel *drinkLB;
/** 扫墓时间标签*/
@property (nonatomic, strong) UILabel *timeLB;

@end

@implementation PrivateWorshipTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initImageView];
        //添加编辑删除按钮
        [self initEditAndDeleteBtn];
        //添加若干标签
        [self initLBs];
    }
    return self;
}

-(void)setWorshipDatalistModel:(WorshipDatalistModel *)worshipDatalistModel{
    _worshipDatalistModel = worshipDatalistModel;
    self.cemeterialNameLB.text = [NSString stringWithFormat:@"%@之祭陵",worshipDatalistModel.CeName];
    self.cemeterialIDLB.text =[NSString stringWithFormat:@"园号%ld",(long)worshipDatalistModel.CeId];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld人浏览",(long)worshipDatalistModel.CeReadcount]];
    
    NSRange blueRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"人"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(19, 154, 219) range:blueRange];
    [self.visitorNumberLB setAttributedText:noteStr];
    
    if ([worshipDatalistModel.Smr isEqualToString:@""]) {
        self.cemeterialPeopleLB.text = @"";
    }else{
        self.cemeterialPeopleLB.text = [NSString stringWithFormat:@"%@扫墓",worshipDatalistModel.Smr];
    }
    
    
    self.drinkLB.text = worshipDatalistModel.Lp;
    self.timeLB.text = worshipDatalistModel.Sj;
    
    self.editBtn.hidden = !worshipDatalistModel.worshipDatalistModelEdit;
    
    self.deleteBtn.hidden = !worshipDatalistModel.worshipDatalistModelEdit;
    
    [self.cemeterialImageView setImageWithURL:[NSURL URLWithString:worshipDatalistModel.CeCover] placeholder:MImage(@"mcGuanli_mudi")];
}


-(void)initImageView{
    self.cemeterialImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 120, 70)];
    [self addSubview:self.cemeterialImageView];
    
    CGRect frame = [self frame];
    frame.size.height = 70+10;
    self.frame = frame;
}

-(void)initEditAndDeleteBtn{
    self.editBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width/6*5, 10, Screen_width/8, 25)];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:LH_RGBCOLOR(128, 205, 145) forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = MFont(12);
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.borderColor = LH_RGBCOLOR(128, 205, 145).CGColor;
    self.editBtn.layer.cornerRadius = 25/5.0f;
    [self.editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn.hidden = YES;
    [self addSubview:self.editBtn];
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width/6*5, 10+30+5, Screen_width/8, 25)];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:LH_RGBCOLOR(241, 154, 162) forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = MFont(12);
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = LH_RGBCOLOR(241, 154, 162).CGColor;
    self.deleteBtn.layer.cornerRadius = 25/5.0f;
    [self.deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.hidden = YES;
    [self addSubview:self.deleteBtn];
}

-(void)initLBs{
    //祭陵名字
    self.cemeterialNameLB = [[UILabel alloc]init];
    self.cemeterialNameLB.textAlignment = NSTextAlignmentLeft;
    self.cemeterialNameLB.font = MFont(12);
    [self addSubview:self.cemeterialNameLB];
    self.cemeterialNameLB.sd_layout.leftSpaceToView(self.cemeterialImageView,8).topSpaceToView(self,8).heightIs(20).widthIs(100);
    
    //园号
    self.cemeterialIDLB = [[UILabel alloc]init];
    self.cemeterialIDLB.textAlignment = NSTextAlignmentLeft;
    self.cemeterialIDLB.font = MFont(10);
    [self addSubview:self.cemeterialIDLB];
    self.cemeterialIDLB.sd_layout.leftSpaceToView(self.cemeterialImageView,8).topSpaceToView(self.cemeterialNameLB,2).heightIs(10).widthIs(60);
    //浏览人数
    self.visitorNumberLB = [[UILabel alloc]init];
    self.visitorNumberLB.textAlignment = NSTextAlignmentLeft;
    self.visitorNumberLB.font = MFont(10);
    [self addSubview:self.visitorNumberLB];
    self.visitorNumberLB.sd_layout.leftSpaceToView(self.cemeterialIDLB,5).topSpaceToView(self.cemeterialNameLB,2).heightIs(10).widthIs(80);

    //某某扫墓
    self.cemeterialPeopleLB =[[UILabel alloc]init];
    self.cemeterialPeopleLB.textAlignment = NSTextAlignmentLeft;
    self.cemeterialPeopleLB.font = MFont(10);
    self.cemeterialPeopleLB.textColor = [UIColor redColor];
    [self addSubview:self.cemeterialPeopleLB];
    self.cemeterialPeopleLB.sd_layout.leftSpaceToView(self.cemeterialImageView,8).topSpaceToView(self.cemeterialIDLB,4).widthIs(40).heightIs(10);
    
    //酒水
    self.drinkLB =[[UILabel alloc]init];
    self.drinkLB.textAlignment = NSTextAlignmentLeft;
    self.drinkLB.font = MFont(10);
    self.drinkLB.textColor = [UIColor redColor];
    [self addSubview:self.drinkLB];
    self.drinkLB.sd_layout.leftSpaceToView(self.cemeterialPeopleLB,5).topSpaceToView(self.cemeterialIDLB,4).widthIs(40).heightIs(10);
    
    //时间
    self.timeLB =[[UILabel alloc]init];
    self.timeLB.textAlignment = NSTextAlignmentLeft;
    self.timeLB.font = MFont(10);
    self.timeLB.textColor = [UIColor redColor];
    [self addSubview:self.timeLB];
    self.timeLB.sd_layout.leftSpaceToView(self.cemeterialImageView,8).topSpaceToView(self.cemeterialPeopleLB,4).widthIs(100).heightIs(10);

}



-(void)clickEditBtn:(UIButton *)sender{
    MYLog(@"编辑");
    [self.delegate cemeterialDidEdit:self];
}

-(void)clickDeleteBtn:(UIButton *)sender{
    MYLog(@"删除");
    [self.delegate cemeterialDidDelete:self];
}


@end
