//
//  HKEditImageView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditImageView.h"
#import "UIView+Xib.h"
#import "MyGoodsRespone.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIImageView+WebCache.h"
#import "UIView+BorderLine.h"
@interface HKEditImageView()
@property (weak, nonatomic) IBOutlet UIView *iconListView;
@property (weak, nonatomic) IBOutlet UILabel *numLbel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation HKEditImageView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    [self.iconListView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconListView);
    }];
    self.maxNum = 5;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _scrollView;
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (imageArray.count < self.maxNum) {
        self.scrollView.contentSize = CGSizeMake(70*imageArray.count+(imageArray.count-1)*5, 70);
    }else{
        self.scrollView.contentSize = CGSizeMake(70*5+(5-1)*5, 70);
    }
    self.numLbel.text = [NSString stringWithFormat:@"%ld/%d",imageArray.count,self.maxNum];
    CGFloat w = 70;
    for (int i = 0; i<imageArray.count; i++) {
        ImagesModel *imageM = imageArray[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.height.width.mas_equalTo(w);
            make.left.equalTo(self.scrollView).offset(i*(w+5));
        }];
        if (imageM.image) {
            imageView.image = imageM.image;
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageM.imgSrc] placeholderImage:kPlaceholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                imageM.image = image;
            }];
        }
        if (i==0) {
            UILabel*lable = [[UILabel alloc]init];
            lable.text = @"主图";
            lable.font = [UIFont systemFontOfSize:10];
            lable.textAlignment  = NSTextAlignmentCenter;
            lable.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
            lable.textColor = [UIColor whiteColor];
            [self.scrollView addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(imageView);
                make.height.mas_equalTo(18);
            }];
        }
        UIButton *eliminatetn = [[UIButton alloc]init];
        eliminatetn.tag = i;
        [eliminatetn addTarget:self action:@selector(eliminatetn:) forControlEvents:UIControlEventTouchUpInside];
        [eliminatetn setBackgroundImage:[UIImage imageNamed:@"shanchu"] forState:0];
        [self.scrollView addSubview:eliminatetn];
        [eliminatetn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(15);
            make.top.equalTo(imageView).offset(5);
            make.right.equalTo(imageView).offset(-5);
        }];
    }
    if (imageArray.count<self.maxNum) {
        UIButton *btn = [[UIButton alloc]init];
        [self.scrollView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"look_more"] forState:0];
        [btn borderForColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1] borderWidth:0. borderType:UIBorderSideTypeAll];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(w);
            make.top.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView).offset((w+5)*imageArray.count);
        }];
        [btn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)addImage{
    if ([self.delegate respondsToSelector:@selector(imageUpdateWithIndex:)]) {
        [self.delegate imageUpdateWithIndex:-1];
    }
}
-(void)eliminatetn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(imageUpdateWithIndex:)]) {
        [self.delegate imageUpdateWithIndex:sender.tag];
    }
}
-(void)setType:(int)type{
    _type = type;
    if (type==1) {
        self.titleView.text = @"上传凭证（选填）";
        self.numLbel.hidden = YES;
    }else{
        self.numLbel.hidden = NO;
        self.titleView.text = @"我的商品";
    }
}
@end
