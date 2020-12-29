//
//  HKBaseTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseTableViewCell.h"
@interface HKBaseTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HKBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
+(instancetype)baseTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKBaseTableViewCell";
    
    HKBaseTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKBaseTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setImage:(NSString *)image{
    _image = image;
    [self.headImage setBackgroundImage:[UIImage imageNamed:image] forState:0];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.label.text = title;
}
@end
