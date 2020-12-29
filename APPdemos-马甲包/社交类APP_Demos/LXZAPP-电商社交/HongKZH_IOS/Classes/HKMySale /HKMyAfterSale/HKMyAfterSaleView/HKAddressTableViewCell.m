//
//  HKAddressTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddressTableViewCell.h"
#import "UIImage+YY.h"
#import "ChinaArea.h"
@interface HKAddressTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *namePhone;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation HKAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image =   [UIImage createImageWithColor:[UIColor colorWithRed:212.0/255.0 green:80.0/255.0 blue:72.0/255.0 alpha:1] size:CGSizeMake(35, 16)];
    image = [image zsyy_imageByRoundCornerRadius:2];
    [self.iconView setBackgroundImage:image forState:0];
}
+(instancetype)addressTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKAddressTableViewCell";
    
    HKAddressTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKAddressTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setAddress:(HKAddressModel *)address{
    if (!address) {
        self.iconView.hidden =YES;
        return;
    }
    _address = address;
    if (address.isDefault.intValue == 1) {
        self.iconView.hidden = NO;
        self.nameLeft.constant = 55;
        self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:253.0/255.0 blue:229.0/255.0 alpha:1];
    }else{
        self.iconView.hidden = YES;
        self.nameLeft.constant = 15;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    self.namePhone.text = [NSString stringWithFormat:@"%@ %@",address.consignee,address.phone];
    NSString *addres = [ChinaArea getAddress:address.provinceId city:address.cityId area:address.areaId];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",addres,address.address];
}
- (IBAction)editAddress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotEditAddressWithModel:)]) {
        [self.delegate gotEditAddressWithModel:self.address];
    }
}
-(void)setIsRight:(BOOL)isRight{
    _isRight = isRight;
    if (isRight) {
        self.rightIcon.image = [UIImage imageNamed:@"list_right"];
        self.rightBtn.hidden = YES;
    }else{
        self.rightIcon.image = [UIImage imageNamed:@"dynamic_write"];
        self.rightBtn.hidden = NO;
    }
}
@end
