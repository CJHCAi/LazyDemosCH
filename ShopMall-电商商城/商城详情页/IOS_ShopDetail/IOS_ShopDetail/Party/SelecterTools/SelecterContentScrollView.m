//
//  SelecterContentScrollView.m
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "SelecterContentScrollView.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface SelecterContentScrollView ()<UIScrollViewDelegate>
@property(nonatomic,retain)NSArray *vcArr;
@property(nonatomic,copy)ScrollPage scrollPage;


@end

@implementation SelecterContentScrollView

-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)vcArr Bool:(BOOL)Bool andBtnBlock:(ScrollPage)page{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, SafeAreaTopHeight+Heightscrooler, SCREEN_WIDTH, SCREEN_HEIGHT-(SafeAreaTopHeight+Heightscrooler));
        self.backgroundColor = [UIColor whiteColor];
        _vcArr = vcArr;
        [self lazyLoadVcFromIndex:0];
        self.pagingEnabled = YES;
        if (Bool==YES) {
            self.contentSize = CGSizeMake(SCREEN_WIDTH * vcArr.count, self.frame.size.height);
        }
        self.delegate = self;
        self.scrollPage = page;
        
    }
    return self;


}
-(instancetype)initWithSeleterCondition:(NSArray *)vcArr Bool:(BOOL)Bool andBtnBlock:(ScrollPage)page{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(SafeAreaTopHeight));
        self.backgroundColor = [UIColor whiteColor];
        _vcArr = vcArr;
        [self lazyLoadVcFromIndex:0];
        self.pagingEnabled = YES;
        if (Bool==YES) {
            self.contentSize = CGSizeMake(SCREEN_WIDTH * vcArr.count, self.frame.size.height);
        }
        self.delegate = self;
        self.scrollPage = page;
        
    }
    return self;

    
}
-(instancetype)initWithSeleterinitWithSeleterWineWarehouse:(NSArray *)vcArr Bool:(BOOL)Bool andBtnBlock:(ScrollPage)page{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 53, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        _vcArr = vcArr;
        [self lazyLoadVcFromIndex:0];
        self.pagingEnabled = YES;
        if (Bool==YES) {
            self.contentSize = CGSizeMake(SCREEN_WIDTH * vcArr.count, self.frame.size.height);
        }
        self.delegate = self;
        self.scrollPage = page;
        
    }
    return self;
}


-(void)updateVCViewFromIndex:(NSInteger )index
{
//    [self lazyLoadVcFromIndex:index];
    [self setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
    
}
-(void)typeScrollview:(NSInteger)index{
    [self setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
}

//懒加载策略
-(void)lazyLoadVcFromIndex:(NSInteger )index
{
    UIViewController *vc = _vcArr[index];
    vc.view.frame = CGRectMake(SCREEN_WIDTH*index,0, SCREEN_WIDTH,self.frame.size.height);
    [self addSubview:vc.view];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
  
        [self lazyLoadVcFromIndex:page];

    
    self.scrollPage(page);
    
}


@end
