//
//  LHPhotosView.m
//  LHand
//
//  Created by 小华 on 15/5/15.
//  Copyright (c) 2015年 chenstone. All rights reserved.
//  整张大图片
#define LHStatusPhotosMaxCount 9
//#define LHStatusPhotosMaxCols(photosCount) ((photosCount==4)?2:3)
#define LHStatusPhotosMaxCols(photosCount) ((photosCount==4)?3:3)
#define LHStatusPhotoMargin 7
#define LHStatusPhotoW(viewTag)((viewTag==2017)?(kScreenWidth- 4*LHStatusPhotoMargin - 60)/3:(kScreenWidth- 2*LHStatusPhotoMargin - 20)/3)
#define LHStatusPhotoH LHStatusPhotoW

#import "LHPhotosView.h"
#import "LHPhotoView.h"
#import "UIView+Frame.h"
#import "LHPhotoModel.h"
#import "ImageListModel.h"

#import "UIImage+Extend.h"

@interface LHPhotosView ()

@end


@implementation LHPhotosView

//static CGFloat discoverCellPhotoWidth;


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initPhotoView];

    }
    return self;
}

- (instancetype)initWithCount:(BOOL)isLargen
{
    self = [super init];
    if (self) {
        self.isLargen = isLargen;
        [self initPhotoView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initPhotoView];
}

+(instancetype)lhPhotoViewWithCount:(BOOL)isLargen{
    
    LHPhotosView *photosView = [[LHPhotosView alloc]initWithCount:isLargen];
  
    return photosView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self){
        [self initPhotoView];
       
    }
    return self;
}


- (void)initPhotoView
{
    self.userInteractionEnabled=YES;
    // 预先创建9个图片控件
    for (int i = 0; i<LHStatusPhotosMaxCount; i++) {
        LHPhotoView *photoView = [[LHPhotoView alloc] init];
        [self addSubview:photoView];
        photoView.tag = i;
        // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(tapPhoto:)];
        [photoView addGestureRecognizer:recognizer];
    }
}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
       DLog(@"%@",recognizer.view);
    
    if ([self.delegate respondsToSelector:@selector(tapPhotoWithArray:index:sourceImageView:)]) {
        [self.delegate tapPhotoWithArray:self.pic_urls index:(int)recognizer.view.tag sourceImageView:self];
    }
 

}

- (void)setPic_urls:(NSArray *)pic_urls
{
    _pic_urls = pic_urls;
        
    for (int i = 0; i<LHStatusPhotosMaxCount; i++) {
        LHPhotoView *photoView = self.subviews[i];
        
        if (i < pic_urls.count) { // 显示图片
            photoView.photo = pic_urls[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat PhotoW;
    CGFloat photoH ;


    PhotoW=LHStatusPhotoW(self.tag);
    
    NSUInteger count = self.pic_urls.count;
    
    photoH = PhotoW;
        
    if(count ==1) {
        
        PhotoW=200;
        photoH=200;
        
    }
    
    if (PhotoW == 0) {
    
        PhotoW= self.bounds.size.width;
        photoH = self.bounds.size.height;
    }
    if (count == 2) {
        PhotoW = (kScreenWidth - 7)*0.5;
        photoH = (kScreenWidth - 7)*0.5;
    }
    int maxCols = LHStatusPhotosMaxCols(count);
    for (int i = 0; i<count; i++) {
        LHPhotoView *photoView = self.subviews[i];
        photoView.width = PhotoW;
        photoView.height = photoH;
        photoView.x = (i % maxCols) * (PhotoW + LHStatusPhotoMargin);
        photoView.y = (i / maxCols) * (PhotoW + LHStatusPhotoMargin);
    }
    
    
}

+ (CGSize)sizeWithPhotosCount:(int)photosCount andTag:(int)tag
{    

    int maxCols = LHStatusPhotosMaxCols(photosCount);
    
    // 总列数
    int totalCols = photosCount >= maxCols ?  maxCols : photosCount;
    
    // 总行数
    int totalRows = (photosCount + maxCols - 1) / maxCols;
    
    // 计算尺寸
    CGFloat photosW = totalCols * LHStatusPhotoW(tag) + (totalCols - 1) * LHStatusPhotoMargin;
    CGFloat photosH = totalRows * LHStatusPhotoH(tag) + (totalRows - 1) * LHStatusPhotoMargin;

    return CGSizeMake(photosW, photosH);
}


@end
