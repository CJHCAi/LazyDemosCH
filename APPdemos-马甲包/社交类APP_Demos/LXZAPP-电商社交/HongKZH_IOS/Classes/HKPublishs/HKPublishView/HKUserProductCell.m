//
//  HKUserProductCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserProductCell.h"
@interface HKUserProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productTitle;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *displayButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation HKUserProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.displayButton.layer.cornerRadius = 4.f;
    self.displayButton.layer.masksToBounds = YES;
    self.editButton.layer.cornerRadius = 4.f;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.layer.borderColor = RGB(204, 204, 204).CGColor;
    self.editButton.layer.borderWidth = 1.f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


/**
 设置我的商品属性

 @param userProduct 我的商品
 */
- (void)setUserProduct:(HKUserProduct *)userProduct {
    if (userProduct) {
        _userProduct = userProduct;
        //商品图片
        [self.productImage sd_setImageWithURL:[NSURL URLWithString:userProduct.imgSrc]];
        //标题
        self.productTitle.text = userProduct.title;
        //价格
        self.priceLabel.text = [NSString stringWithFormat:@"%ld",userProduct.price];
        //库存
        self.numLabel.text = [NSString stringWithFormat:@"库存：%ld件",userProduct.num];
        
        if (userProduct.isShow) {
            [self.displayButton setTitle:@"取消展示" forState:UIControlStateNormal];
            self.displayButton.backgroundColor = [UIColor whiteColor];
            [self.displayButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
            self.displayButton.layer.borderColor = RGB(204, 204, 204).CGColor;
            self.displayButton.layer.borderWidth = 1.f;
        } else {
            [self.displayButton setTitle:@"展示" forState:UIControlStateNormal];
            self.displayButton.backgroundColor = RGB(38, 147, 229);
            [self.displayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)displayButtonClick:(UIButton *)sender {
    if (self.block) {
        self.block(self.userProduct,!self.userProduct.isShow);
    }
    if (self.delegete && [self.delegete respondsToSelector:@selector(selectProductWithModel:)]) {
        [self.delegete selectProductWithModel:self.userProduct];
    }
}

- (IBAction)editButtonClick:(UIButton *)sender {
}

@end
