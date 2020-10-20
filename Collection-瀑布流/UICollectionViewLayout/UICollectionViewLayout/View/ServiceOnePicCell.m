//
//  ServiceOnePicCell.m
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/16.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "ServiceOnePicCell.h"

@interface ServiceOnePicCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ServiceOnePicCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        ViewBorder(self, 0.5, COLOR(235, 235, 235));
        
        self.imgView = [[UIImageView alloc]init];
        self.imgView.image = [UIImage imageNamed:@"ser_ser_ban"];
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end

