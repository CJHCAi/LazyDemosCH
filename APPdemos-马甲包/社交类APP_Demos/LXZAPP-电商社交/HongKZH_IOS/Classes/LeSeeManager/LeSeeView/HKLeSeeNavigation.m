//
//  HKLeSeeNavigation.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeNavigation.h"
#import "HKNavScrollView.h"
#import "HKLeSeeSearchBtn.h"
@interface HKLeSeeNavigation()
@property (weak, nonatomic) IBOutlet HKLeSeeSearchBtn *searchView;
@property (weak, nonatomic) IBOutlet HKNavScrollView *categoryView;
@end

@implementation HKLeSeeNavigation
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKLeSeeNavigation" owner:self options:nil].lastObject;
        self.frame = frame;
           @weakify(self)
        self.categoryView.selectCategory = ^(int index) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(selectedWithIndex:)]) {
                [self.delegate selectedWithIndex:index];
            }
        };
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
       @weakify(self)
    self.categoryView.selectCategory = ^(int index) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(selectedWithIndex:)]) {
            [self.delegate selectedWithIndex:index];
        }
    };
}
-(void)setCategory:(NSMutableArray *)category{
    _category = category;
    self.categoryView.navArray = category;
}
- (IBAction)gotoEditNavigation:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoNavigation)]) {
        [self.delegate gotoNavigation];
    }
}
- (IBAction)gotoRelease:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoVcRelease)]) {
        [self.delegate gotoVcRelease];
    }
}
- (IBAction)historyWatching:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoWatchingHistory)]) {
        [self.delegate gotoWatchingHistory];
    }
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    self.categoryView.item = index;
}
@end
