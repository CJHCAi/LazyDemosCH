//
//  HKMyReplisePostInfoView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyReplisePostInfoView.h"
@interface HKMyReplisePostInfoView()
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation HKMyReplisePostInfoView

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKMyReplisePostInfoView" owner:self options:nil].lastObject;
    if (self) {
        
    }
    return self;
}
-(void)setModel:(MyRepliesPostsListModel *)model{
    _model = model;
    self.titleView.text = [NSString stringWithFormat:@"原贴：%@",model.title];
}
@end
