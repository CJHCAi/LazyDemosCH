//
//  DDViewController.m
//  DDPhotoBrowser
//
//  Created by liuhedong01@163.com on 10/22/2020.
//  Copyright (c) 2020 liuhedong01@163.com. All rights reserved.
//

#import "DDViewController.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <DDPhotoBrowser/DDPhotoBrowser.h>
#import "DDPhotoSDImageDownloadEngine.h"
#import "DDSDAnimatedImageView.h"

@interface DDViewController ()

@property (nonatomic, copy) NSArray * urls;

@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.urls = @[@"https://wx3.sinaimg.cn/mw690/6852466cly1gjxxryaucnj216o1ryhdt.jpg",
             @"http://ww3.sinaimg.cn/bmiddle/7ef8e115jw1f972pb91fng206o06odqk.gif",
             @"https://wx2.sinaimg.cn/mw1024/006II2JPgy1gjzg9bh7w6j33402c0x6q.jpg",
             @"https://wx2.sinaimg.cn/mw1024/001nd69sly1gin164qel1j61cb1sg7wi02.jpg",
             @"https://wx3.sinaimg.cn/mw1024/003yHo7Nly1gjhwrl2necj61o02yo1l302.jpg",
             @"http://ww3.sinaimg.cn/bmiddle/7ef8e115jw1f972pb91fng206o06odqk.gif",
             @"https://wx1.sinaimg.cn/mw1024/001Wnqitly1gk08f3hvikj656o3ggu1002.jpg",
             @"http://wx3.sinaimg.cn/bmiddle/b0af402fgy1ffwuzdav8xj20qo13w789.jpg",
             @"https://wx4.sinaimg.cn/mw1024/c260f7abgy1ghdf9fk362j21xg2h9u0z.jpg",
             @"http://ww3.sinaimg.cn/bmiddle/7ef8e115jw1f972pb91fng206o06odqk.gif",
             @"http://ww2.sinaimg.cn/bmiddle/7ef8e115jw1f972pdnt0tg206o06odq8.gif",
             @"http://wx3.sinaimg.cn/bmiddle/005FAKE1gy1ffxgx6rur3j30qo140q7t.jpg",
             @"http://ww1.sinaimg.cn/bmiddle/7ef8e115jw1f95qjargkzg20740740u8.gif",
             @"https://wx2.sinaimg.cn/mw690/6852466cly1gjxxru82uij216o1ryx4c.jpg"];
    
    CGFloat width = (self.view.bounds.size.width - 15*4)/3.0;
    for (NSInteger i = 0; i < self.urls.count; i++) {
        SDAnimatedImageView * imageView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(15+(width+15)*(i%3), 64+(width+15)*(i/3), width, width)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapClicked:)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1+i;
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urls[i]]];
        [self.view addSubview:imageView];
    }
    
}

- (void)imageTapClicked:(UITapGestureRecognizer *)tap
{
    NSMutableArray *imageDataArray = [NSMutableArray array];
    
    NSInteger startIndex = tap.view.tag - 1;
    

    [self.urls enumerateObjectsUsingBlock:^(NSString *   _Nonnull urlString, NSUInteger idx, BOOL * _Nonnull stop) {
                    
        UIImageView * imageView = [self.view viewWithTag:1+idx];
        
        DDPhotoItem *item = [DDPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:urlString] thumbImage:nil thumbImageUrl:nil];
        
        if (idx == startIndex) {
            item.firstShowAnimation = YES;
        }
        
        [imageDataArray addObject:item];

    }];

    DDPhotoSDImageDownloadEngine * downloadEngine = [DDPhotoSDImageDownloadEngine new];
    
    /** 图片选择器展示*/
    DDPhotoBrowser * b = [DDPhotoBrowser photoBrowserWithPhotoItems:imageDataArray currentIndex:startIndex getImageViewClass:DDSDAnimatedImageView.class downloadEngine:downloadEngine];
    
    /** 设置page类型 */
    b.pageIndicateStyle = DDPhotoBrowserPageIndicateStylePageLabel;
    
    b.longPressGestureClickedBlock = ^(DDPhotoBrowser * photoBrowser ,NSInteger index, DDPhotoItem *item,NSData * imageData) {
        NSLog(@"长按手势回调：%ld", index);
    };
        
    [b showFromVC:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
