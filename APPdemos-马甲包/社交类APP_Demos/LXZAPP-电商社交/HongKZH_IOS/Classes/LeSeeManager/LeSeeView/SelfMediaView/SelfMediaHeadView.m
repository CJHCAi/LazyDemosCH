//
//  SelfMediaHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "SelfMediaHeadView.h"
#import "HKCtyItemListView.h"
#import "HKTitleAndImageBtn.h"
#import "HKSowingRespone.h"
#import "HKSowingModel.h"
@interface SelfMediaHeadView()<HKCtyItemListViewDelegate,HKTitleAndImageBtnDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;
@property (weak, nonatomic) IBOutlet HKCtyItemListView *itemListView;
@property (weak, nonatomic) IBOutlet HKTitleAndImageBtn *screenBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twobtn;

@end

@implementation SelfMediaHeadView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.screenBtn.delegate = self;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SelfMediaHeadView" owner:self options:nil].lastObject;
        [self.screenBtn setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1] title:@"筛选" imageName:@"zmt_sx" cornerRadius:13];
        self.itemListView.delegate = self;
        self.numLabel.textColor = keyColor;
        self.frame = frame;
    }
    return self;
}
-(void)setSowM:(HKSowingRespone *)sowM{
    _sowM = sowM;
    NSMutableArray *image = [NSMutableArray arrayWithCapacity:sowM.data.count];
    for (HKSowingModel*model in sowM.data) {
        [image addObject:model.imgSrc];
    }
    self.scrollView.imageURLStringsGroup = image;
}
-(void)setTop10:(CategoryTop10ListRespone *)top10{
    _top10 = top10;
    self.itemListView.selfMediaArray = top10.data;
}
- (IBAction)btnClick:(UIButton *)sender {
    self.oneBtn.selected = !self.oneBtn.selected;
    self.twobtn.selected = !self.twobtn.selected;
    if ([self.delegate respondsToSelector:@selector(selectWithTag:)]) {
        [self.delegate selectWithTag:sender.tag];
    }
}
-(void)itemClick:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(clickItme:)]) {
        [self.delegate clickItme:self.top10.data[index]];
    }
}
-(void)setNum:(NSInteger)num {
    self.numLabel.text =[NSString stringWithFormat:@"%zd",num];
}
-(void)setIsHideDown:(BOOL)isHideDown{
    _isHideDown = isHideDown;
    self.downView.hidden = isHideDown;
    UIImage*image = [UIImage imageNamed:@"zmt_rdph"];
//    if (isHideDown) {
//        self.topH.constant = (kScreenWidth-10)/3-10+20+20+20+image.size.height;
//    }else{
//        self.topH.constant = (kScreenWidth-10)/3-10+20+20+image.size.height;
//    }
}
@end
