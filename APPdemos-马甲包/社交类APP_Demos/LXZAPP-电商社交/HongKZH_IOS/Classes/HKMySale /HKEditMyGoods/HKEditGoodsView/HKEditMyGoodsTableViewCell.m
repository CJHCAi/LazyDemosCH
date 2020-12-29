//
//  HKEditMyGoodsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditMyGoodsTableViewCell.h"
#import "HKEditImageView.h"
@interface HKEditMyGoodsTableViewCell()<HKEditImageViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleL;
@property (weak, nonatomic) IBOutlet HKEditImageView *iconListView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *freightName;


@end

@implementation HKEditMyGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconListView.delegate = self;
    [self.titleL addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)passConTextChange:(UITextField*)textField{
    self.model.title = textField.text;
}
+(instancetype)editMyGoodsTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKEditMyGoodsTableViewCell";
    
    HKEditMyGoodsTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKEditMyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)imageUpdateWithIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(dataUpdatedWithIndex:)]) {
        [self.delegate dataUpdatedWithIndex:index];
    }
}
-(void)setModel:(MyGoodsInfo *)model{
    _model = model;
    self.titleL.text = model.title;
    self.iconListView.imageArray = [NSMutableArray arrayWithArray:model.images];
    self.categoryName.text = model.categoryName;
    self.freightName.text = model.freightName;

    
}
- (IBAction)freight:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectFFreight)]) {
        [self.delegate selectFFreight];
    }
}
- (IBAction)category:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(category)]) {
        [self.delegate category];
    }
}
@end
