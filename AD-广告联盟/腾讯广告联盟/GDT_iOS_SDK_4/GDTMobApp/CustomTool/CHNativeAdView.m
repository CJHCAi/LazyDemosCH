//
//  GDTNativeAdView.m
//  GDTMobSample
//
//  Created by 七啸网络 on 2018/4/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "CHNativeAdView.h"


@interface CHNativeAdView()
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIImageView *iconV;
@property(nonatomic,strong)UILabel *txt;
@property(nonatomic,strong)UILabel *desc;
@end
@implementation CHNativeAdView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
       
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    /*广告详情图*/
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 70, 316, 176)];
    [self addSubview:imgV];
    self.imgV=imgV;
    
    /*广告Icon*/
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    [self addSubview:iconV];
    self.iconV=iconV;
    /*广告标题*/
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 35)];
    [self addSubview:txt];
    self.txt=txt;
    /*广告描述*/
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 220, 20)];
    [self addSubview:desc];
    self.desc=desc;
}

-(void)setCurrentAdData:(GDTNativeAdData *)currentAdData{
    _currentAdData=currentAdData;
    
    NSURL *imageURL = [NSURL URLWithString:[currentAdData.properties objectForKey:GDTNativeAdDataKeyImgUrl]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgV.image = [UIImage imageWithData:imageData];
        });
    });
    
    NSURL *iconURL = [NSURL URLWithString:[currentAdData.properties objectForKey:GDTNativeAdDataKeyIconUrl]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            _iconV.image = [UIImage imageWithData:imageData];
        });
    });
    
    _txt.text = [currentAdData.properties objectForKey:GDTNativeAdDataKeyTitle];
    _desc.text = [currentAdData.properties objectForKey:GDTNativeAdDataKeyDesc];

}

@end
