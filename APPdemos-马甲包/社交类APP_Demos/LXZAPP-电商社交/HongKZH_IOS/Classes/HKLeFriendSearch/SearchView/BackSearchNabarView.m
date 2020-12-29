//
//  BackSearchNabarView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BackSearchNabarView.h"
#import "HKSearchView.h"
@interface BackSearchNabarView()<HKSearchViewDelegate>
@property (nonatomic, strong)HKSearchView *searchV;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end


@implementation BackSearchNabarView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"BackSearchNabarView" owner:self options:nil].lastObject;
        [self.searchView addSubview:self.searchV];
    }
    return self;
}
- (void)textChange:(UITextField *)textFile{
    if ([self.delegate respondsToSelector:@selector(textChangeWithText:)]) {
        [self.delegate textChangeWithText:textFile.text];
    }
}
- (IBAction)back:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}
- (IBAction)cancleClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cancleClick)]) {
        [self.delegate cancleClick];
    }
}

- (IBAction)textBtnClick:(UIButton *)sender {
    [self.searchV becomeFirstResponder];
}
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    self.searchV.searchText = searchText;
}
-(HKSearchView *)searchV{
    if (!_searchV) {
        _searchV = [HKSearchView searchView];
        _searchV.frame = CGRectMake(0, 0, kScreenWidth-60-15-24, 30);
        _searchV.intrinsicContentSize = CGSizeMake(kScreenWidth-60-15-24, 30);
        _searchV.delegate = self;
        [_searchV layoutSubviews];
    }
    return _searchV;
}
-(void)setPlaceHoder:(NSString *)placeHoder{
    _placeHoder = placeHoder;
    self.searchV.placeHoder = placeHoder;
}
@end
