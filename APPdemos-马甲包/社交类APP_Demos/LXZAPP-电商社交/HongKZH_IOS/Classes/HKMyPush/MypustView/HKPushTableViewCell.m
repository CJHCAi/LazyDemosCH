//
//  HKPushTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPushTableViewCell.h"
#import "HKMyPostNameView.h"
#import "HKPushModel.h"
#import "UIImage+YY.h"
#import "HKMyPostsRespone.h"
@interface HKPushTableViewCell()
@property (weak, nonatomic) IBOutlet HKMyPostNameView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *ignore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolH;
@property (weak, nonatomic) IBOutlet UIButton *agree;

@end

@implementation HKPushTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = [UIImage createImageWithColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] size:CGSizeMake(88, 27)];
    image = [image zsyy_imageByRoundCornerRadius:13];
    [self.agree setBackgroundImage:image forState:0];
    UIImage *ignore = [UIImage createImageWithColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1] size:CGSizeMake(88, 27)];
    ignore = [ignore zsyy_imageByRoundCornerRadius:13];
    [self.ignore setBackgroundImage:ignore forState:0];
}
+(instancetype)pushTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKPushTableViewCell";
    
    HKPushTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKPushTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKPushModel *)model{
    _model = model;
    if (model.type>0) {
        self.toolH.constant = 67;
        self.toolView.hidden = NO;
    }else{
        self.toolH.constant = 0;
        self.toolView.hidden = YES;
    }
    self.titleView.text = model.title;
    HKMyPostModel*postM = [[HKMyPostModel alloc]init];
    postM.name = model.uname;
    postM.title = model.name;
    postM.headImg = model.headImg;
    postM.createDate = model.createDate;
    postM.isShowLabel = YES;
    self.nameView.model = postM;
}
@end
