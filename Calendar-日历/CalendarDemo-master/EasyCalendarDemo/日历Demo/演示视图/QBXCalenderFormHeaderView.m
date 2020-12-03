//
//  QBXCalenderFormHeaderView.m
//  QianBuXian_V2
//
//  Created by YangTianCi on 2018/4/3.
//  Copyright © 2018年 qbx. All rights reserved.
//

#import "QBXCalenderFormHeaderView.h"

#import "CalendarManager.h"
#import "CalenderObject.h"

#define collection_Height 300.0

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kIdentifierCell @"kIdentifierCell"

@interface QBXCalenderFormHeaderView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) NSMutableArray *weekLableArray;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UICollectionViewFlowLayout *leftLayout;
@property (nonatomic, strong) UICollectionView *leftCView;

@property (nonatomic, strong) UICollectionViewFlowLayout *middleLayout;
@property (nonatomic, strong) UICollectionView *minddleCView;

@property (nonatomic, strong) UICollectionViewFlowLayout *rightLayout;
@property (nonatomic, strong) UICollectionView *rightCView;


#pragma mark --- DataDomin

@property (nonatomic, strong) CalendarManager *manager;

@property (nonatomic, strong) CalenderObject *lastData;
@property (nonatomic, strong) CalenderObject *CurrentData;
@property (nonatomic, strong) CalenderObject *nextData;

@end

@implementation QBXCalenderFormHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy年MM月";
        NSString *currentString = [formatter stringFromDate:[NSDate date]];
        
        [self ConfigUI];
        
        self.manager = [[CalendarManager alloc]init];
        [self Refresh_DataMethodWithCurrentDateString:currentString];
    }
    return self;
}

#pragma mark >>> 数据刷新
-(void)Refresh_DataMethodWithCurrentDateString:(NSString*)String{
    
    NSArray *arrArray = [self.manager CaculateCurrentMonthWithString:String];
    self.lastData = arrArray.firstObject;
    self.CurrentData = arrArray[1];
    self.nextData = arrArray.lastObject;
    
    self.headerLabel.text = self.CurrentData.title;
    
}

#pragma mark >>> 界面刷新
-(void)Refresh_CollectionView{
    [self.leftCView reloadData];
    [self.minddleCView reloadData];
    [self.rightCView reloadData];
}

#pragma mark >>> 开始布局
-(void)ConfigUI{
    [self ConfigHeader];
    
    //MainScrollView
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, self.frame.size.height - 100)];
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 300);
    [self addSubview:self.mainScrollView];
    self.mainScrollView.backgroundColor = [UIColor blueColor];
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    
#pragma mark >>> middle
    //flowLayout
    self.middleLayout = [[UICollectionViewFlowLayout alloc]init];
    self.middleLayout.minimumLineSpacing = 0;
    self.middleLayout.minimumInteritemSpacing = 0;
    CGFloat itemWidth = kScreenWidth/7;
    CGFloat itemHeight = collection_Height / 6;
    self.middleLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //MiddleCollectionView
    self.minddleCView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, collection_Height) collectionViewLayout:self.middleLayout];
    [self.mainScrollView addSubview:self.minddleCView];
    self.minddleCView.delegate = self;
    self.minddleCView.dataSource = self;
    self.minddleCView.backgroundColor = [UIColor whiteColor];
    [self.minddleCView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifierCell];
    
#pragma mark >>> left
    //flowLayout
    self.leftLayout = [[UICollectionViewFlowLayout alloc]init];
    self.leftLayout.minimumLineSpacing = 0;
    self.leftLayout.minimumInteritemSpacing = 0;
    self.leftLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //MiddleCollectionView
    self.leftCView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, collection_Height) collectionViewLayout:self.leftLayout];
    [self.mainScrollView addSubview:self.leftCView];
    self.leftCView.delegate = self;
    self.leftCView.dataSource = self;
    self.leftCView.backgroundColor = [UIColor whiteColor];
    [self.leftCView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifierCell];
    
#pragma mark >>> right
    //flowLayout
    self.rightLayout = [[UICollectionViewFlowLayout alloc]init];
    self.rightLayout.minimumLineSpacing = 0;
    self.rightLayout.minimumInteritemSpacing = 0;
    self.rightLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //MiddleCollectionView
    self.rightCView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, collection_Height) collectionViewLayout:self.rightLayout];
    [self.mainScrollView addSubview:self.rightCView];
    self.rightCView.delegate = self;
    self.rightCView.dataSource = self;
    self.rightCView.backgroundColor = [UIColor whiteColor];
    [self.rightCView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifierCell];
}

#pragma mark >>> 布局头部
-(void)ConfigHeader{
    
    self.headerLabel = [[UILabel alloc]init];
    [self addSubview:self.headerLabel];
    CGFloat X = (kScreenWidth - 100)/2;
    self.headerLabel.frame = CGRectMake(X, 15, 100, 30);
    self.headerLabel.font = [UIFont systemFontOfSize:16];
    self.headerLabel.textColor = [UIColor darkTextColor];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat itemWidth = kScreenWidth / 7;
    self.weekLableArray = [NSMutableArray array];
    NSArray *weekTitleArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < 7; i++) {
        UILabel *weekLabe = [[UILabel alloc]init];
        [self addSubview:weekLabe];
        weekLabe.frame = CGRectMake(itemWidth * i, 65, itemWidth, 20);
        [self.weekLableArray addObject:weekLabe];
        weekLabe.text = weekTitleArray[i];
        weekLabe.font = [UIFont systemFontOfSize:13];
        weekLabe.textColor = [UIColor darkTextColor];
        weekLabe.textAlignment = NSTextAlignmentCenter;
        [self.weekLableArray addObject:weekLabe];
    }
    
}


#pragma mark =========== CollecitonView_Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count;
    if (collectionView == self.leftCView) {
        count = self.lastData.DayArray.count;
    }else if (collectionView == self.minddleCView){
        count = self.CurrentData.DayArray.count;
    }else{
        count = self.nextData.DayArray.count;
    }
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCell forIndexPath:indexPath];
    
    NSArray *dayArray;
    if (collectionView == self.leftCView) {
        dayArray = self.lastData.DayArray;
    }else if (collectionView == self.minddleCView){
        dayArray = self.CurrentData.DayArray;
    }else{
        dayArray = self.nextData.DayArray;
    }
    
    CalenderObject *dayObjc = dayArray[indexPath.row];
    
    for (UIView *obj in cell.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
        }
    }
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    lable.font = [UIFont systemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:lable];
    lable.text = dayObjc.DayString;
    if (dayObjc.isCurrentMonth) {
        lable.textColor = [UIColor darkTextColor];
    }else{
        lable.textColor = [UIColor redColor];
    }
    
    return cell;
    
}


#pragma mark =========== ScrollView_Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger direction;
    CGFloat X = self.mainScrollView.contentOffset.x;
    if (X == 0) {
        direction = 1;// >>> left
    }else if (X == kScreenWidth){
        direction = 2;// >>> middle
    }else{
        direction = 3;// >>> right
    }
    
    if (direction == 1) {
        //左翻
        NSString *title = self.lastData.title;
        [self Refresh_DataMethodWithCurrentDateString:title];
    }else if (direction == 3){
        //右翻
        NSString *title = self.nextData.title;
        [self Refresh_DataMethodWithCurrentDateString:title];
    }
    
    [self Refresh_CollectionView];
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);

}



@end
