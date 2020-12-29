//
//  HKGameNavView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGameNavView.h"
#import "UIView+Xib.h"
@interface HKGameNavView()
@property (nonatomic,weak) IBOutlet UILabel *titleView;
@end

@implementation HKGameNavView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSelfNameXibOnSelf];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSelfNameXibOnSelf];
        self.frame = frame;
    }
    return self;
}
- (IBAction)backClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backVc)]) {
        [self.delegate backVc];
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleView.text = title;
}
@end
