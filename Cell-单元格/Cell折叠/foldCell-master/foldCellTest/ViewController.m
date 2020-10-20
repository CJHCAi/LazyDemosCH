//
//  ViewController.m
//  foldCellTest
//
//  Created by gouzi on 2016/12/2.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "ViewController.h"
#import "wjFirstFoldView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

static BOOL isFirstSelected = NO;


@interface ViewController () <UIGestureRecognizerDelegate>

/* 第一级*/
@property (nonatomic, strong) wjFirstFoldView *firstFoldView;

/* 第三级*/
@property (nonatomic, strong) UITableView *eachCell;


/* 第一级的时间数据源*/
@property (nonatomic, strong) NSMutableArray *dateArray;

/* 第一级列表的单击手势*/
@property (nonatomic, strong) UITapGestureRecognizer *singleFingerTap;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 第一级列表的界面
    [self creatFirstCellUIWithData];
    
    
}

// 第一级列表中事件的数据数组
- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 5; i++) {
            [_dateArray addObject:[NSString stringWithFormat:@"2015 - 10 - 2%d", i]];
        }
    }
    return _dateArray;
}

// UI界面的创建
- (void)creatFirstCellUIWithData {
    
    // 可以放置View进行设置
    for (int idx = 0; idx < self.dateArray.count; idx ++) {
        self.firstFoldView = [[wjFirstFoldView alloc] init];
        self.firstFoldView.frame = CGRectMake(0, idx * 50, screenWidth, 50);
        self.firstFoldView.dateLabel.text = self.dateArray[idx];
        [self.view addSubview:self.firstFoldView];
        
        self.singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
        self.singleFingerTap.numberOfTapsRequired = 1;
        [self.firstFoldView addGestureRecognizer:self.singleFingerTap];
    }
}


// 第一级的点击操作
- (void)singleTapClick:(UITapGestureRecognizer *)tap {
    wjFirstFoldView *firstView = (wjFirstFoldView *)tap.view;
    isFirstSelected = !isFirstSelected;
    NSLog(@"%d",isFirstSelected);
    // 首先更改第一级的图标
    if (isFirstSelected) {
        NSLog(@"%@", tap.view);
        [self firstImageIndicateRotateWithAngle:90 withView:firstView.indicateImageView];
        // 这里会展开第二级的cell
    } else {
        [self firstImageIndicateRotateWithAngle:0 withView:firstView.indicateImageView];
        // 这里会收起第二级的cell
    }
}

// 第一级点击事件：图标旋转:
- (void)firstImageIndicateRotateWithAngle:(int)angle withView:(UIView *)view {
    
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
        /**
         这里的是把旋转的图片添加到第一级的视图中
         
         @param view.superview 指的就是第一级的视图
         @param view 这里的view指的就是旋转的图片
         */
        [view.superview addSubview:view];
    }];
}



@end
