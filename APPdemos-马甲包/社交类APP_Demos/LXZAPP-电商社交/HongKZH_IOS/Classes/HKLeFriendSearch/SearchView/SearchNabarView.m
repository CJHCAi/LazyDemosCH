//
//  SearchNabarView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "SearchNabarView.h"
#import "HKSearchView.h"
@interface SearchNabarView()<HKSearchViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong)HKSearchView *searchV;
@end

@implementation SearchNabarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SearchNabarView" owner:self options:nil].lastObject;
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

- (IBAction)textBtnClick:(UIButton *)sender {
    [self.searchV becomeFirstResponder];
}

-(HKSearchView *)searchV{
    if (!_searchV) {
        _searchV = [HKSearchView searchView];
        _searchV.frame = CGRectMake(0, 0, kScreenWidth-60-15, 30);
        _searchV.intrinsicContentSize = CGSizeMake(kScreenWidth-60-15, 30);
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
