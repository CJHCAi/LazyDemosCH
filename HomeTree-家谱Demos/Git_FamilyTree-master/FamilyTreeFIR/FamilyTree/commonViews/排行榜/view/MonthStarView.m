//
//  MonthStarView.m
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "MonthStarView.h"

@interface MonthStarView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MonthStarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.8;
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat w = self.frame.size.width;
    CGFloat f = 12;
    if (__kHeight >__k5Height) {
        f=14;
    }
    _headIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, (w-50)/14*5, (w-50)/14*5)];
    [self addSubview:_headIV];
    _headIV.backgroundColor = [UIColor redColor];
    
    _surnameLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+10, 8, (w-50)/14*3, (w-50)/14)];
    [self addSubview:_surnameLb];
    _surnameLb.font = MFont(f);
    _surnameLb.textAlignment = NSTextAlignmentLeft;
    
    _generationLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+10, CGRectYH(_surnameLb), (w-50)/14*3, (w-50)/14)];
    [self addSubview:_generationLb];
    _generationLb.font = MFont(f);
    _generationLb.textAlignment = NSTextAlignmentLeft;
    
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+10, CGRectYH(_generationLb), (w-50)/14*3, (w-50)/14)];
    [self addSubview:_nameLb];
    _nameLb.font = MFont(f);
    _nameLb.textAlignment = NSTextAlignmentLeft;
    
    _characterLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+10, CGRectYH(_nameLb), (w-50)/14*3, (w-50)/14)];
    [self addSubview:_characterLb];
    _characterLb.font = MFont(f);
    _characterLb.textAlignment = NSTextAlignmentLeft;
    
    _rankingLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+10, CGRectYH(_characterLb), (w-50)/14*3, (w-50)/14)];
    [self addSubview:_rankingLb];
    _rankingLb.font = MFont(f);
    _rankingLb.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *lineV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(_rankingLb)+11, 8, 2, (w-50)/14*5+4)];
    [self addSubview:lineV];
    lineV.backgroundColor = LH_RGBCOLOR(200, 200, 200);
    
    _pastTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectXW(lineV)+12, 10, (w-50)/14*6, 100)];
    [self addSubview:_pastTableView];
    _pastTableView.delegate = self;
    _pastTableView.dataSource = self;
    _pastTableView.scrollEnabled = NO;
    _pastTableView.backgroundColor = [UIColor clearColor];
    
    
    UILabel *ruleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectYH(_headIV)+10, w-40, 30)];
    [self addSubview:ruleLb];
    ruleLb.font = MFont(15);
    ruleLb.textAlignment = NSTextAlignmentLeft;
    ruleLb.text = @"奖励规则";
    NSArray *ruleArr = @[@"1.每月之星奖励20券。",@"2.个排行榜前10名最高奖励20券。",@"3.10-20名奖励10券。",@"4.20-50名奖励5券。"];
    for (int i=0; i<4; i++) {
        UILabel *titleLb  = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectYH(ruleLb)+(w*25/33-(w-50)*5/14-15-20-10)/4*i, w-40, 20)];
        [self addSubview:titleLb];
        titleLb.font = MFont(14);
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.textColor = LH_RGBCOLOR(100, 100, 100);
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.text = ruleArr[i];
    }
    
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.textColor = LH_RGBCOLOR(100, 100, 100);
    cell.textLabel.text = self.dataArr[indexPath.row].yf;
    cell.textLabel.font = MFont(12);
    cell.detailTextLabel.textColor = LH_RGBCOLOR(100, 100, 100);
    cell.detailTextLabel.text = self.dataArr[indexPath.row].xm;
    cell.detailTextLabel.font = MFont(12);
    NSLog(@"%ld",(long)indexPath.row%2);
    if ((indexPath.row+1)%2) {
        cell.contentView.backgroundColor = LH_RGBCOLOR(200, 200, 200);
    }else{
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    sectionV.backgroundColor = [UIColor clearColor];
    UILabel *sectionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    [sectionV addSubview:sectionLb];
    sectionLb.font = MFont(14);
    sectionLb.text = @"往期每月之星";
    sectionLb.textAlignment = NSTextAlignmentLeft;
    return sectionV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

@end
