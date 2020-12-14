//
//  ViewController.m
//  CollectionVIewDemo
//
//  Created by 栗子 on 2017/12/13.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CollectionModel.h"

@interface ViewController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *changeIndexArr;
@property (nonatomic,assign) NSInteger     currentSelectCnt; //当前选择的那天

@end

static NSString *cellID = @"CollectionViewCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
      [self initData];
    UICollectionViewFlowLayout *layout= [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    layout.minimumLineSpacing =  0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellID];
    self.currentSelectCnt = 0;
  
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count) {
        return self.dataSource.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSString *index = [NSString stringWithFormat:@"%@",self.changeIndexArr[indexPath.row]];
    CollectionModel *model = [self.dataSource objectAtIndex:[index intValue]];
    [cell cellIndexPathRow:indexPath.row rowCount:self.dataSource.count-1];
    cell.dataModel = model;
    cell.statueModel = model;
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *index = [NSString stringWithFormat:@"%@",self.changeIndexArr[indexPath.row]];
    self.currentSelectCnt = [index intValue];
    NSInteger indexUnSelect = [self firstUnCompleteIndex];
    if (indexUnSelect == [index intValue]) {
        [self taskModel];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *failed_msg =@"签到失败";
            NSString *failed_order_msg;
            if (indexUnSelect >= [index intValue]) {
                failed_order_msg = @"请误重复签到" ;
            }else{
                failed_order_msg =  @"请依次签到";
            }
            [self showFailed:failed_msg withMessage:failed_order_msg];
        });
    }
    
}
-(void)taskModel{
    if (self.currentSelectCnt+1 < self.dataSource.count) {
        CollectionModel *statue = [self.dataSource objectAtIndex:self.currentSelectCnt+1];
        statue.isSelected = YES;//选中
        [self.dataSource replaceObjectAtIndex:self.currentSelectCnt+1 withObject:statue];
    }
    CollectionModel *statueModel = [self.dataSource objectAtIndex:self.currentSelectCnt];
    statueModel.isComplete = YES;//任务完成
    [self.dataSource replaceObjectAtIndex:self.currentSelectCnt withObject:statueModel];
   
     [_collectionView reloadData];
    NSInteger haveComplete = [self haveCheckCount];
    if (haveComplete == self.dataSource.count) {
         [self showFailed:@"恭喜您" withMessage:@"全部以签到"];
    }else{
         [self showFailed:@"恭喜您" withMessage:@"签到成功"];
    }
}
- (void)showFailed:(NSString *)failed_msg withMessage:(NSString*)message
{
    
    FailedView *failed=[[FailedView alloc]initCustomFailedTitle:failed_msg contentStr:message andTop:240 Alpha:0.5];
    [failed show:YES];
    
}
#pragma mark 数据处理
-(void)initData{
    self.dataSource = [NSMutableArray array];
    self.changeIndexArr = [NSMutableArray array];
    for (NSInteger i=0; i<9; i++) {
        CollectionModel *model = [[CollectionModel alloc]init];
        model.isComplete = NO;
        if (i==0) {
            model.isSelected = YES;
        }else{
        model.isSelected = NO;
        }
        model.image      = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i]];
        model.text       = [NSString stringWithFormat:@"第%ld天",i+1];
        [self.dataSource addObject:model];
        [self.changeIndexArr addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    if (self.dataSource.count==9) {
        for (int i=0; i<self.dataSource.count; i++) {//替换位置
            NSInteger a  = i%3;// i%6 !=0 第三行不交换
            if (i>2 && a==0 && i+2< self.dataSource.count && i%6 !=0 ) {
                [self.changeIndexArr exchangeObjectAtIndex:i withObjectAtIndex:i+2];
            }
        }
    }
  
    [_collectionView reloadData];
}
//找到第一个未签到的
-(NSInteger)firstUnCompleteIndex{
    
    NSInteger index = 10000;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        CollectionModel *model = self.dataSource[i];
        if (!model.isComplete) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - 计算已签到数
- (NSInteger)haveCheckCount
{
    NSInteger allPoint = 0;//已签到数
    for (int i = 0; i < self.dataSource.count; i++)
    {
        CollectionModel *model = [self.dataSource objectAtIndex:i];
        if (model.isComplete)
        {
            allPoint ++;
        }
    }
    return allPoint;
}
@end
