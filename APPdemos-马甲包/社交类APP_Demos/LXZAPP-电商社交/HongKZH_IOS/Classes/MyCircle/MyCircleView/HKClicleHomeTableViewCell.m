//
//  HKClicleHomeTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKClicleHomeTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "HKCircleCategoryListModel.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIView+BorderLine.h"
@interface HKClicleHomeTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLebl;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation HKClicleHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addBtn.layer.cornerRadius = 13;
    self.addBtn.layer.masksToBounds = YES;
    [self.addBtn addTarget:self action:@selector(addGroupClick) forControlEvents:UIControlEventTouchUpInside];
}
+(instancetype)clicleHomeTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKClicleHomeTableViewCell";
    
    HKClicleHomeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKClicleHomeTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKCircleCategoryListModel *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.coverImgSrc forState:0 placeholder:kPlaceholderHeadImage];
    self.nameLebl.text = model. circleName;
    self.numLabel.text = [NSString stringWithFormat:@"%d人",model.circleCount.intValue];
    if (model.ucId==0) {
        self.addBtn.userInteractionEnabled = YES;
        [self.addBtn setTitle:@"+ 加入" forState:0];
        [self.addBtn setTitleColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] forState:0];
        [self.addBtn borderForColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
    }else{
        self.addBtn.userInteractionEnabled = NO;
        [self.addBtn setTitle:@"已加入" forState:0];
        [self.addBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:0];
        [self.addBtn borderForColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
    }
    self.numLabel.text = [NSString stringWithFormat:@"%@人",model.userCount];
    
}
-(void)addGroupClick{
    if ([self.delegate respondsToSelector:@selector(addGroupWithModel:)]) {
        [self.delegate addGroupWithModel:self.model];
    }
}
@end
