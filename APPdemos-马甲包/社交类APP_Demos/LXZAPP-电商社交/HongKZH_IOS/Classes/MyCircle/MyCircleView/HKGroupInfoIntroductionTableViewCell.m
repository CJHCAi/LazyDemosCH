//
//  HKGroupInfoIntroductionTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGroupInfoIntroductionTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "HKHeadShowView.h"
#import "HKImageShowView.h"
#import "HKMyCircleData.h"
#import "HKProductsModel.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIImage+YY.h"
@interface HKGroupInfoIntroductionTableViewCell()<HKImageShowViewDelegate,BtnHeadClickDelegete>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *desclabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNum;
@property (weak, nonatomic) IBOutlet HKHeadShowView *memberList;
@property (weak, nonatomic) IBOutlet UILabel *commodity;
@property (weak, nonatomic) IBOutlet HKImageShowView *commodityList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commidttyH;
@property (weak, nonatomic) IBOutlet UIView *commidtyView;
@property (weak, nonatomic) IBOutlet UILabel *meberNum;
@property (weak, nonatomic) IBOutlet UILabel *commidtyNum;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UILabel *notifiLabel;
@property (weak, nonatomic) IBOutlet UIButton *swichNo;

@end

@implementation HKGroupInfoIntroductionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [UIImage createImageWithColor:[UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1] size:CGSizeMake(88, 27)];
    image = [image zsyy_imageByRoundCornerRadius:13];
    [self.addBtn setBackgroundImage:image forState:0];
    self.sw =[[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-40-20,CGRectGetMinY(self.notifiLabel.frame)-15,40,40)];
    self.sw.hidden =YES;
    self.sw.transform  = CGAffineTransformMakeScale(0.75, 0.75);
    [self.contentView addSubview:self.sw];
    self.commodityList.delegate = self;
    self.swichNo.hidden =YES;
    //点击圈子成员列表
    self.memberList.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapM =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponse)];
    [self.memberList addGestureRecognizer:tapM];
}
+(instancetype)groupInfoIntroductionTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKGroupInfoIntroductionTableViewCell";
    
    HKGroupInfoIntroductionTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKGroupInfoIntroductionTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKMyCircleData *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.coverImgSrc forState:0 placeholder:kPlaceholderImage];
    self.name.text = model.name;
    self.numLabel.text = [NSString stringWithFormat:@"%@∙%d人",model.categoryName,model.userCount];
    self.meberNum.text = [NSString stringWithFormat:@"%ld",model.members.count];
    if (model.products.count>0) {
        self.commidtyNum.text = [NSString stringWithFormat:@"%ld",model.products.count];
        self.commidttyH.constant = 158;
        self.commidtyView.hidden = NO;
        NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:model.products.count];
        for (HKProductsModel*pModel in model.products) {
            [imageArray addObject:pModel.imgSrc];
        }
        self.commodityList.imageArray = imageArray;
    }else{
        self.commidttyH.constant = 0;
        self.commidtyView.hidden = YES;
    }
   
    self.desclabel.text = model.introduction;
    self.memberList.imageArray = model.members;
    self.memberList.delegete = self;
    if (model.state == 1) {
        [self.addBtn setTitle:@"加入圈子" forState:0];
        self.addBtn.userInteractionEnabled = YES;
    }else{
        [self.addBtn setTitle:@"已加入" forState:0];
         self.addBtn.userInteractionEnabled = YES;
    }
    //群主.
    if (model.isMain == 1) {
        self.addBtn.hidden = YES;
    }else{
        self.addBtn.hidden = NO;
    }
}
- (IBAction)add:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addGroup:)]) {
        
        [self.delegate addGroup:self.model.state];
    }
}
-(void)tapResponse {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkCicleMember:)]) {
        [self.delegate checkCicleMember:self.model];
    }
}

-(void)clickHead {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkCicleMember:)]) {
        [self.delegate checkCicleMember:self.model];
    }
}
-(void)gotoShopping:(NSInteger)tag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushShopDetail:)]) {
        [self.delegate pushShopDetail:tag];
    }
}
@end
