//
//  HKHotTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHotTableViewCell.h"
#import "HKHostView.h"
@interface HKHotTableViewCell()<HKHostViewDelegate>
@property (weak, nonatomic) IBOutlet HKHostView *hotView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotH;

@end

@implementation HKHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)hotTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKHotTableViewCell";
    
    HKHotTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKHotTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hotView.delegate = cell;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    self.hotView.dataArray =dataArray;
    CGFloat w = (kScreenWidth - 30 - 5)*0.5;
    CGFloat h = w*97/170+39;
   self.hotH.constant = (h+15+39)*2+15;
}
-(void)toCellHot:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(clickHot:)]) {
        [self.delegate clickHot:tag];
    }
}
@end
