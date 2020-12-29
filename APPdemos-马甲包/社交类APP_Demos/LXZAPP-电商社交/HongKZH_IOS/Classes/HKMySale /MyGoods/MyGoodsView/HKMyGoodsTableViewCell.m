//
//  HKMyGoodsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsTableViewCell.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKMyGoodsTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downIcon;
@property (weak, nonatomic) IBOutlet UILabel *upperLowerProduct;
@property (weak, nonatomic) IBOutlet UILabel *downVisitor;
@property (weak, nonatomic) IBOutlet UILabel *downVolume;
@property (weak, nonatomic) IBOutlet UILabel *downStock;
@property (weak, nonatomic) IBOutlet UIView *oneVIew;
@property (weak, nonatomic) IBOutlet UIView *thressView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@end
@implementation HKMyGoodsTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)myGoodsTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKMyGoodsTableViewCell";
    
    HKMyGoodsTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKMyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
- (IBAction)editMyGoods:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoEditWithModel:indexPath:)]) {
        [self.delegate gotoEditWithModel:self.goodsM indexPath:self.indexPath];
    }
}
- (IBAction)upperLowerProduct:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoUpperLowerProductWithModel:indexPath:state:)]) {
        [self.delegate gotoUpperLowerProductWithModel:self.goodsM indexPath:self.indexPath state:self.type];
    }
}
-(void)setType:(int)type{
    _type = type;
    if (self.type == 0) {
        self.downIcon.image = [UIImage imageNamed:@"i5411_xj"];
        self.upperLowerProduct.text = @"下架";
    }else{
        self.downIcon.image = [UIImage imageNamed:@"i5411_sj"];
        self.upperLowerProduct.text = @"上架";
    }
}
-(void)setGoodsM:(HKMyGoodsModel *)goodsM{
    _goodsM = goodsM;
    self.goodsName.text = goodsM.title;
    [self.iconBtn hk_setBackgroundImageWithURL:goodsM.imgSrc forState:0 placeholder:kPlaceholderImage];
    self.priceLable.text = [NSString stringWithFormat:@"%ld",goodsM.price];
    self.orderNumLabel.text = [NSString stringWithFormat:@"销量：%ld",goodsM.orderNum];
    self.downVolume.text = [NSString stringWithFormat:@"今日销量：%ld件",goodsM.orderNum];
    self.moneyLabel.text = [NSString stringWithFormat:@"成交额：%ld",goodsM.money];
    self.numLabel.text = [NSString stringWithFormat:@"库存：%ld",goodsM.num];
    self.downStock.text = [NSString stringWithFormat:@"库存：%ld",goodsM.num];
    self.downVisitor.text =  [NSString stringWithFormat:@"金额访客：%ld",goodsM.dayVisitor];
    self.createDateLabel.text = [NSString stringWithFormat:@"添加：%@",goodsM.createDate];
}
-(void)setShowType:(int)showType{
    _showType = showType;
    if (showType == 0) {
        self.oneVIew.hidden = NO;
        self.twoView.hidden = NO;
        self.thressView.hidden = NO;
        self.orderNumLabel.hidden = NO;
        self.moneyLabel.hidden = NO;
        self.numLabel.hidden = NO;
        self.createDateLabel.hidden = NO;
    }else{
        self.oneVIew.hidden = YES;
        self.twoView.hidden = YES;
        self.thressView.hidden = YES;
        self.orderNumLabel.hidden = YES;
        self.moneyLabel.hidden = YES;
        self.numLabel.hidden = YES;
        self.createDateLabel.hidden = YES;
    }
}
- (IBAction)shareBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareWithModel:)]) {
        [self.delegate shareWithModel:self.goodsM];
    }
}
@end
