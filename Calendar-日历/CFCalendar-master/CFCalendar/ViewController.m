//
//  ViewController.m
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//
#define kMainWidth [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "CFCalendarView.h"
#import "Masonry.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger    currentYear;
@property (nonatomic, assign) NSInteger    currentmonth;
@property (nonatomic, strong) UILabel      *currentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentLabel = [[UILabel alloc]init];
    self.currentLabel.textAlignment = 1;
    [self.view addSubview:self.currentLabel];
    
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    for (int i=0; i<7; i++) {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainWidth/7*i, 70, kMainWidth/7, 30)];
        weekLabel.textAlignment = 1;
        weekLabel.text  = weekArr[i];
        [self.view addSubview:weekLabel];
    }
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kMainWidth, 300)];
    self.scrollView.contentSize = CGSizeMake(3*kMainWidth, 300);
    self.scrollView.contentOffset = CGPointMake(kMainWidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal fromDate:date];
    self.currentYear = comps.year;
    self.currentmonth = comps.month;
    
    [self setupButtonWithFrame:CGRectMake((kMainWidth-300)/4.0, 420, 100, 60) tag:100 title:[NSString stringWithFormat:@"%ld-%ld",[[self lastYearMonth][0] integerValue],[[self lastYearMonth][1] integerValue]]];
    
    [self setupButtonWithFrame:CGRectMake(100+(kMainWidth-300)/2.0, 420, 100, 60) tag:101 title:[NSString stringWithFormat:@"%ld-%ld",self.currentYear,self.currentmonth]];
    
    [self setupButtonWithFrame:CGRectMake(200+3*(kMainWidth-300)/4.0, 420, 100, 60) tag:102 title:[NSString stringWithFormat:@"%ld-%ld",[[self nextYearMonth][0] integerValue],[[self nextYearMonth][1] integerValue]]];
    
    [self setupCalendarView];
   
}

- (UIButton *)setupButtonWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)setupCalendarView {
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CFCalendarView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [CFCalendarView initWithFrame:CGRectMake(0, 0, kMainWidth, 300) year:[[self lastYearMonth][0] integerValue] month:[[self lastYearMonth][1] integerValue] superView:self.scrollView selectedDateBlock:nil];
    
    [CFCalendarView initWithFrame:CGRectMake(kMainWidth, 0, kMainWidth, 300) year:self.currentYear month:self.currentmonth superView:self.scrollView selectedDateBlock:^(NSInteger year, NSInteger month, NSInteger day) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,month,day] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }];
    
    [CFCalendarView initWithFrame:CGRectMake(2*kMainWidth, 0, kMainWidth, 300) year:[[self nextYearMonth][0] integerValue] month:[[self nextYearMonth][1] integerValue] superView:self.scrollView selectedDateBlock:nil];
    
    self.currentLabel.text = [NSString stringWithFormat:@"当前:%ld年%ld月",(long)self.currentYear,(long)self.currentmonth];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x==0) {
        //上一月
        [((UIButton *)[self.view viewWithTag:100]) sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    } else if (scrollView.contentOffset.x == 2*kMainWidth) {
        //下一月
        [((UIButton *)[self.view viewWithTag:102]) sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [scrollView setContentOffset:CGPointMake(kMainWidth, 0) animated:NO];
}

- (void)buttonClick:(UIButton *)button {
    
    NSInteger tag = button.tag;
    
    if (tag == 100) {
        //上一月
        if (self.currentmonth==1) {
            self.currentYear = self.currentYear-1;
            self.currentmonth = 12;
        } else {
            self.currentYear = self.currentYear;
            self.currentmonth = self.currentmonth-1;
        }
        
    } else if(tag == 101) {
        //当前月
        
    } else if (tag == 102) {
        //下一月
        if (self.currentmonth==12) {
            self.currentYear = self.currentYear+1;
            self.currentmonth = 1;
        } else {
            self.currentYear = self.currentYear;
            self.currentmonth = self.currentmonth+1;
        }
    }
    
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            
            if (button.tag==100) {
                
                [button setTitle:[NSString stringWithFormat:@"%ld-%ld",[[self lastYearMonth][0] integerValue],[[self lastYearMonth][1] integerValue]] forState:UIControlStateNormal];
                
            } else if (button.tag==101) {
                
                [button setTitle:[NSString stringWithFormat:@"%ld-%ld",self.currentYear,self.currentmonth] forState:UIControlStateNormal];
                
            } else {
                
                [button setTitle:[NSString stringWithFormat:@"%ld-%ld",[[self nextYearMonth][0] integerValue],[[self nextYearMonth][1] integerValue]] forState:UIControlStateNormal];
            }
        }
    }
    
    [self setupCalendarView];
}

- (NSArray *)lastYearMonth {
    
    NSInteger year = 0;
    NSInteger month = 0;
    
    if (self.currentmonth==1) {
        year = self.currentYear-1;
        month = 12;
    } else {
        year = self.currentYear;
        month = self.currentmonth-1;
    }
    return @[@(year),@(month)];
}

- (NSArray *)nextYearMonth {
    
    NSInteger year = 0;
    NSInteger month = 0;
    if (self.currentmonth==12) {
        year = self.currentYear+1;
        month = 1;
    } else {
        year = self.currentYear;
        month = self.currentmonth+1;
    }
    return @[@(year),@(month)];
}



@end
