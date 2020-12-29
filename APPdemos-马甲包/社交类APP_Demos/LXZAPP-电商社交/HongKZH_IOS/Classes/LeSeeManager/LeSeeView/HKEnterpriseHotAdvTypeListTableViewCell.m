//
//  HKEnterpriseHotAdvTypeListTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseHotAdvTypeListTableViewCell.h"
#import "EnterpriseHotAdvTypeListRedpone.h"
#import "ZSUserHeadBtn.h"
#import "HKHotAdvTypeListView.h"
#import "UIImage+YY.h"
@interface HKEnterpriseHotAdvTypeListTableViewCell()<HKHotAdvTypeListViewDelegate>
@property (weak, nonatomic) IBOutlet HKHotAdvTypeListView *listView;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *hour;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *minute;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *second;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellH;
@property (weak, nonatomic) IBOutlet UILabel *colon;
@property (weak, nonatomic) IBOutlet UILabel *colon2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sjLeft;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation HKEnterpriseHotAdvTypeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hour.layer.cornerRadius = 9;
    self.hour.layer.masksToBounds = YES;
    self.minute.layer.cornerRadius = 9;
    self.minute.layer.masksToBounds = YES;
    self.second.layer.cornerRadius = 9;
    self.second.layer.masksToBounds = YES;
    self.listView.delegate = self;
}
-(void)setRespone:(EnterpriseHotAdvTypeListRedpone *)respone{
    _respone = respone;
    self.listView.model = respone;
 EnterpriseHotAdvTypeListModel*model =   respone.data[respone.selectItem];
    CGFloat w = kScreenWidth*0.25;
    UIImage *image = [UIImage imageNamed:@"sjleSee"];
    self.sjLeft.constant = w*respone.selectIndex+w*0.5-image.size.width*0.5;
    [_timer invalidate];
    _timer = nil;
    if (model.sortDate >= 0) {
        self.hour.hidden = NO;
        self.minute.hidden = NO;
        self.second.hidden = NO;
        self.colon2.hidden = NO;
        self.colon.hidden = NO;
        self.endLabel.hidden = NO;
    NSArray*array = [model.currentTime componentsSeparatedByString:@":"];
    NSInteger cursecond = 0;
    if (array.count == 3) {
        cursecond =   [array.firstObject intValue]*60*60+[array[1]intValue]*60+[array.lastObject intValue];
    }
    NSInteger difference = model.endDate*60*60 - cursecond;
    respone.difference = difference;
    [self setTimeWithModel:respone];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(createPersonLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }else{
        self.endLabel.hidden = YES;
        self.colon.hidden = YES;
        self.colon2.hidden = YES;
        self.hour.hidden = YES;
        self.minute.hidden = YES;
        self.second.hidden = YES;
    }
}
-(void)createPersonLayer{
    self.respone.difference --;
    [self setTimeWithModel:self.respone];
}
-(void)setTimeWithModel:(EnterpriseHotAdvTypeListRedpone *)respone{
    NSInteger difference = respone.difference;
    NSInteger hour = difference/3600;
    NSInteger minute = (difference - hour*3600)/60;
    NSInteger second = difference - hour*3600 - minute*60;
    if (hour>9) {
        [self.hour setTitle:[NSString stringWithFormat:@"%ld",hour] forState:0];
    }else{
        [self.hour setTitle:[NSString stringWithFormat:@"0%ld",hour] forState:0];
    }
    if (second>9) {
        [self.second setTitle:[NSString stringWithFormat:@"%ld",second] forState:0];
    }else{
        [self.second setTitle:[NSString stringWithFormat:@"0%ld",second] forState:0];
    }
    if (minute>9) {
        [self.minute setTitle:[NSString stringWithFormat:@"%ld",minute] forState:0];
    }else{
        [self.minute setTitle:[NSString stringWithFormat:@"0%ld",minute] forState:0];
    }
}
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}
-(void)clickType:(NSInteger)tag{
     CGFloat w = kScreenWidth*0.25;
    UIImage *image = [UIImage imageNamed:@"sjleSee"];
    self.sjLeft.constant = w*tag+w*0.5-image.size.width*0.5;
    if ([self.delegate respondsToSelector:@selector(updatetypeWithTag:)]) {
        [self.delegate updatetypeWithTag:tag];
    }
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 0) {
        self.contentView.hidden = NO;
        self.cellH.constant = 126.5;
    }else{
        self.contentView.hidden = YES;
        self.cellH.constant = 0;
    }
}
@end
