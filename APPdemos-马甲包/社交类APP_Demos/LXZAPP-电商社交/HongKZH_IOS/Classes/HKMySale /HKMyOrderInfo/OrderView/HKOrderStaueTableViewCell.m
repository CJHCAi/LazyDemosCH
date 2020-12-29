//
//  HKOrderStaueTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderStaueTableViewCell.h"
#import "HKMyOrderStaueView.h"
@interface HKOrderStaueTableViewCell()
@property (weak, nonatomic) IBOutlet HKMyOrderStaueView *staueView;

@end

@implementation HKOrderStaueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)orderStaueTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKOrderStaueTableViewCell";
    
    HKOrderStaueTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HKOrderStaueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKOrderStaueTableViewCell" owner:self options:nil].lastObject;
        [self setRestorationIdentifier:reuseIdentifier];
//        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}
-(void)setStaue:(OrderFormStatue)staue{
    _staue =staue;
    self.staueView.statue = staue;
}
@end
