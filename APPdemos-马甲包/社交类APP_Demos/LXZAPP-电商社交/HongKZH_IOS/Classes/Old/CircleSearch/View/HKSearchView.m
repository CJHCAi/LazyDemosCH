//
//  HKSearchView.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchView.h"
@interface HKSearchView ()
@property (weak, nonatomic) IBOutlet UITextField *terxtF;

@end
@implementation HKSearchView
-(void)awakeFromNib{
    [super awakeFromNib];
    UIImageView*imagev = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
    imagev.image = [UIImage imageNamed:@"class_search"];
    self.terxtF.leftViewMode = UITextFieldViewModeAlways;
    [self.terxtF addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.terxtF.leftView = imagev;
    self.terxtF.returnKeyType =UIReturnKeySearch;
    self.terxtF.clearButtonMode =UITextFieldViewModeAlways;
    self.tf = self.terxtF;
}
+(instancetype)searchView{
    HKSearchView*searchV = [[NSBundle mainBundle]loadNibNamed:@"HKSearchView" owner:self options:nil].lastObject;
    return searchV;
}
-(void)setIntrinsicContentSize:(CGSize)intrinsicContentSize{
    _intrinsicContentSize = intrinsicContentSize;
    self.frame = CGRectMake(0, 0, intrinsicContentSize.width, 30);
}
-(void)passConTextChange:(UITextField*)textFile{
    if ([self.delegate respondsToSelector:@selector(textChange:)]) {
        [self.delegate textChange:textFile];
    }
}
-(BOOL)becomeFirstResponder{
    [self.terxtF becomeFirstResponder];
    return [super becomeFirstResponder];
}
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    if (searchText.length>0) {
        self.terxtF.text = searchText;
        [self passConTextChange:self.terxtF];
        
    }
}

-(void)setPlaceHoder:(NSString *)placeHoder {
    if (placeHoder.length>0) {
        self.terxtF.placeholder =placeHoder;
    }
}
-(void)setResignResponder:(BOOL)resignResponder {
    if (resignResponder) {
        [self.terxtF resignFirstResponder];
    }
}

@end
