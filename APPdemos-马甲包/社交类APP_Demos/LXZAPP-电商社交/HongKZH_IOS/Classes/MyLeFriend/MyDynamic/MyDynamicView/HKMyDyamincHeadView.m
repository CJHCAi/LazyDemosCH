//
//  HKMyDyamincHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDyamincHeadView.h"
#import "UIImage+YY.h"
@interface HKMyDyamincHeadView()
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *onlyBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (nonatomic, strong)NSMutableArray * btnArr;

@end

@implementation HKMyDyamincHeadView

-(NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr =[[NSMutableArray alloc] init];
    }
    return _btnArr;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKMyDyamincHeadView" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
        // TODO:init
        UIImage *image = [UIImage createImageWithColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1] size:CGSizeMake(91, 27)];
        image = [image zsyy_imageByRoundCornerRadius:13];
        [self.allBtn setBackgroundImage:image forState:0];
        [self.onlyBtn setBackgroundImage:image forState:0];
        [self.myBtn setBackgroundImage:image forState:0];
        [self.allBtn setTitleColor:[UIColor colorFromHexString:@"#ef593c"] forState:UIControlStateNormal];
        [self.btnArr addObject:self.allBtn];
        [self.btnArr addObject:self.onlyBtn];
        [self.btnArr addObject:self.myBtn];
    }
    return self;
}
- (IBAction)btnParamtersIndex:(UIButton *)sender {
    for (UIButton * btn in self.btnArr) {
        [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor colorFromHexString:@"#ef593c"] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(swichParamsWithSender:)]) {
        [self.delegate swichParamsWithSender:sender.tag];
    }
}
-(void)awakeFromNib{
    [super awakeFromNib];
   
}

- (IBAction)search:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoSearch)]) {
        [self.delegate gotoSearch];
    }
}



@end
