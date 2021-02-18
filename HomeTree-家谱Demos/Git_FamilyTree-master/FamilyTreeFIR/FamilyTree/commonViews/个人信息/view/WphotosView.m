//
//  WphotosView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WphotosView.h"
@interface WphotosView()
{
    NSArray *_urlArr;
}
/**背景滚动*/
@property (nonatomic,strong) UIScrollView *scrollView;

@end
@implementation WphotosView
- (instancetype)initWithFrame:(CGRect)frame photosUrlStringArray:(NSArray *)Urlarray
{
    self = [super initWithFrame:frame];
    if (self) {
        _urlArr = Urlarray;
        [self addSubview:self.scrollView];
        [self initAllPhotos];
    }
    return self;
}
-(void)initAllPhotos{
    [_urlArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:AdaptationFrame(40+idx*200, 20, 190, 143)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.imageURL = [NSURL URLWithString:obj];
        [self.scrollView addSubview:imageView];
    }];
}
#pragma mark *** getters ***
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.contentSize = CGSizeMake(_urlArr.count*190*AdaptationWidth(), self.bounds.size.height);
        
    }
    return _scrollView;
}

@end
