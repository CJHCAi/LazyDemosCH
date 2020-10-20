//
//  BookingBtn.m
//  FamilyTree
//
//  Created by 王子豪 on 16/8/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BookingBtn.h"

@implementation BookingBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bookingBtn];
    }
    return self;
}
-(void)respondsToBooking:(UIButton *)sender{
    MyOrdersViewController *orVc = [[MyOrdersViewController alloc] initWithTitle:@"我的订单" image:nil];
    [self.viewController.navigationController pushViewController:orVc animated:true];
}
-(UIButton *)bookingBtn{
    if (!_bookingBtn) {
        _bookingBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [_bookingBtn setImage:MImage(@"chec") forState:0];
        [_bookingBtn addTarget:self action:@selector(respondsToBooking:) forControlEvents:UIControlEventTouchUpInside];
        _bookingBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bookingBtn;
}
@end
