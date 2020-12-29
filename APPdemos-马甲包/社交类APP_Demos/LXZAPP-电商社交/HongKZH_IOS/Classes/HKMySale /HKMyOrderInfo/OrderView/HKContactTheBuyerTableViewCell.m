//
//  HKContactTheBuyerTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKContactTheBuyerTableViewCell.h"
#import "HKContactTheBuyerView.h"
@interface HKContactTheBuyerTableViewCell()<HKContactTheBuyerViewDelegate>
@property (weak, nonatomic) IBOutlet HKContactTheBuyerView *theBuyeer;

@end

@implementation HKContactTheBuyerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.theBuyeer.delegate = self;
}
+(instancetype)contactTheBuyerTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKContactTheBuyerTableViewCell";
    
    HKContactTheBuyerTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKContactTheBuyerTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)toCellContact{
    if ([self.delegate respondsToSelector:@selector(contactTheBuyer)]) {
        [self.delegate contactTheBuyer];
    }
}
@end
