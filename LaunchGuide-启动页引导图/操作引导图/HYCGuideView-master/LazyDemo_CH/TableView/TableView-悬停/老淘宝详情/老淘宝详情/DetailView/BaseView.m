//
//  BaseView.m
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/7.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "BaseView.h"
#import "ToolHeader.h"
@implementation BaseView

- (void)renderUIWithInfo:(NSDictionary *)info{
    self.info = info;
    NSNumber *position = info[@"position"];
    int num = [position intValue];
    
    self.frame = CGRectMake(num * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KTopBarHeight - KBottomBarHeight - kTabTitleViewHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:TABLETOP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:TABLELEAVETOP object:nil];
    
    
}

- (void)acceptMsg:(NSNotification *)notification{
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:TABLETOP]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
        
    }else if ([notificationName isEqualToString:TABLELEAVETOP]){
        
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.contentOffset = CGPointZero;
        
    }
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY < 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TABLELEAVETOP object:nil userInfo:@{@"canScroll": @"1"}];
        
    }
    
    
}


@end
