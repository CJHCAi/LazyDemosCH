//
//  ZJAddHeaderForCollectionReusableView.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJAddHeaderForCollectionReusableView.h"

@implementation ZJAddHeaderForCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageV.layer.borderWidth = 1.0;
    self.imageV.layer.cornerRadius = 5.0;
    self.imageV.layer.masksToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.titleL.text = dict[@"title"];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:dict[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"name"]];
    self.detailL.text = dict[@"detail"];
}


@end
