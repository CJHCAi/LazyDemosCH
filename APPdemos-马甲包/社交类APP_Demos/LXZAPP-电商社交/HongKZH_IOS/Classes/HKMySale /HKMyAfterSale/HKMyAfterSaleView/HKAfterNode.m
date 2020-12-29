//
//  HKAfterNode.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAfterNode.h"
#import "UIView+Xib.h"
@interface HKAfterNode()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKAfterNode
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    UIImage*image = [UIImage createImageWithColor:[UIColor colorWithRed:247.0/255.0 green:102.0/255.0 blue:84.0/255.0 alpha:1] size:CGSizeMake(6, 6)];
    UIImage*selectImage = [UIImage createImageWithColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] size:CGSizeMake(6, 6)];
    [self.btn setBackgroundImage:selectImage forState:0];
    [self.btn setBackgroundImage:image forState:UIControlStateSelected];
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.btn.selected = isSelect;
    if (isSelect) {
        self.topView.hidden = YES;
    }else{
        self.topView.hidden = NO;
    }
}
@end
