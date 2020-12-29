//
//  HKSelectbaseViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelectbaseViewController.h"
#import "HKSelectBaseItem.h"
#import "HKInitializationRespone.h"
#import "HKWHUrl.h"
#import "HKChinaModel.h"
#import "HKProvinceModel.h"
#import "HKCityModel.h"
#import "getChinaList.h"
@interface HKSelectbaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HKSelectBaseItemDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)NSMutableArray *arrayM;
@property (nonatomic, strong)HKInitializationRespone*dataModel ;
//   HKChinaModel*
@property (nonatomic, strong)HKChinaModel *chinaM;
@property (nonatomic,assign) int row1;
@property (nonatomic,assign) int row2;
@property (nonatomic,assign) int row3;
@property (nonatomic, strong)UILabel *titleView;
@property (nonatomic,assign) CGFloat w;
@end

@implementation HKSelectbaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setUI{
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kScreenHeight-250);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(50);
        make.bottom.equalTo(self.collectionView.mas_top);
    }];
}
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag{
    if (tag == 0) {
        self.row1 = (int)indexPath.row;
    }else if (tag == 1){
        self.row2 = (int)indexPath.row;
    }else{
        self.row3 = (int)indexPath.row;
    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSelectBaseItem" bundle:nil] forCellWithReuseIdentifier:@"HKSelectBaseItem"];
        _collectionView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.questionArray.count;;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKSelectBaseItem*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSelectBaseItem" forIndexPath:indexPath];
    if (self.type == HKSelectbaseType_salary) {
        cell.isLeft = YES;
    }else{
        cell.isLeft = NO;
    }
    cell.tag = indexPath.item;
    
    if (indexPath.item == 0) {
        cell.row = self.row1;
    }else if (indexPath.item == 1){
        cell.row = self.row2;
    }else if (indexPath.item == 2){
        cell.row = self.row3;
    }else{
        cell.row = 0;
    }
    cell.dataArray = self.questionArray[indexPath.item];
    cell.delegate = self;
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.w-1, kScreenHeight-250);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setType:(HKSelectbaseType)type{
    _type = type;
    switch (type) {
        case HKSelectbaseType_position:
        {
            self.w = kScreenWidth/2;
            self.titleView.text = @"选择职业类别";
            NSMutableArray*array1 = [NSMutableArray array];
            NSMutableArray*arrayM1 = [NSMutableArray array];
            for (RecruitindustrysModel*model in self.dataModel.data.recruitIndustrys) {
                [array1 addObject:model.name];
                [arrayM1 addObject:model];
            }
            [self.questionArray addObject:array1];
            NSMutableArray*array2 = [NSMutableArray array];
            NSMutableArray*arrayM2 = [NSMutableArray array];
            for (RecruitcategorysModel*model in self.dataModel.data.recruitCategorys) {
                RecruitindustrysModel*recruitindustrys = arrayM1.firstObject;
                if ([model.parentId isEqualToString:recruitindustrys.parentId]) {
                    [array2 addObject:model.name];
                    [arrayM2 addObject:model];
                }
                
            }
            [self.questionArray addObject:array2];
            NSMutableArray*array3 = [NSMutableArray array];
            NSMutableArray*arrayM3 = [NSMutableArray array];
            for (RecruitcategorysModel*model in self.dataModel.data.recruitCategorys) {
                RecruitindustrysModel*recruitindustrys = arrayM2.firstObject;
                if ([model.parentId isEqualToString:recruitindustrys.ID]) {
                    [array3 addObject:model.name];
                    [arrayM3 addObject:model];
                }
                
            }
            [self.questionArray addObject:array3];
            [self.arrayM addObject:arrayM1];
            [self.arrayM addObject:arrayM2];
            [self.arrayM addObject:arrayM3];
        }
            break;
        case HKSelectbaseType_city:{
            self.w = kScreenWidth/2;
            self.titleView.text = @"选择地区";
            [self setCity];
        }
            break;
        case HKSelectbaseType_salary:{
            self.titleView.text = @"薪水（元）";
            self.w = kScreenWidth+1;
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *arrayM = [NSMutableArray array];
            
            for (DictModel*model in self.dataModel.data.dict) {
                if ([model.type isEqualToString:@"hk_recruit_salary"]) {
                    [array addObject:model.label];
                    [arrayM addObject:model];
                }
            }
            self.arrayM = arrayM;
            self.questionArray = [NSMutableArray arrayWithObject:array];
        }
            break;
        default:
            break;
    }
    
}
-(void)setCity{
    NSMutableArray*array1 =[NSMutableArray array];
    NSMutableArray*array2 =[NSMutableArray array];
    NSMutableArray*array3 =[NSMutableArray array];
    for (HKProvinceModel*pro in self.chinaM.provinces) {
        [array1 addObject:pro.name];
    }
    HKProvinceModel*pro = self.chinaM.provinces[self.row1];
    for (HKCityModel*city in pro.citys) {
        [array2 addObject:city.name];
    }
    HKCityModel*city = [self.chinaM.provinces[self.row1] citys][self.row2];
    
    for ( getChinaListAreas*ares in city.areas) {
        [array3 addObject:ares.name];
    }
    NSMutableArray*array = [NSMutableArray array];
    [array addObject:array1];
    [array addObject:array2];
    [array addObject:array3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.questionArray = array;
//        [self.collectionView reloadData];
    });
    
}
- (NSMutableArray *)arrayM
{
    if(_arrayM == nil)
    {
        _arrayM = [ NSMutableArray array];
    }
    return _arrayM;
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
-(void)setRow1:(int)row1{
    _row1 = row1;
    if (self.type == HKSelectbaseType_position) {
    
    NSMutableArray*array = [NSMutableArray array];
        NSMutableArray*arrM = [NSMutableArray array];
        NSMutableArray*dataArray = self.questionArray[0];
        [array addObject:dataArray];;
        [arrM addObject:self.arrayM[0]];
        NSMutableArray *array2 = [NSMutableArray array];;
        NSMutableArray *arrayM2 = [NSMutableArray array];;
    for (RecruitcategorysModel*model in self.dataModel.data.recruitCategorys) {
        RecruitindustrysModel*recruitindustrys = self.arrayM[0][row1];
        if ([model.parentId isEqualToString:recruitindustrys.parentId]) {
            [array2 addObject:model.name];
            [arrayM2 addObject:model];
        }
        
    }
        [arrM addObject:arrayM2];
        [array addObject:array2];
        NSMutableArray *array3 = [NSMutableArray array];;
        NSMutableArray*arrayM3 = [NSMutableArray array];
        for (RecruitcategorysModel*model in self.dataModel.data.recruitCategorys) {
            if (arrayM2.count==0) {
                break;
            }
            RecruitindustrysModel*recruitindustrys = arrayM2[0];
            if ([model.parentId isEqualToString:recruitindustrys.ID]) {
                [array3 addObject:model.name];
                [arrayM3 addObject:model];
            }
            
        }
        [array addObject:array3];
        [arrM addObject:arrayM3];
        self.arrayM = arrM;
        _row2 = 0;
        _row3 = 0;
        self.questionArray = array;
        
//        [self.collectionView reloadData];
    }else if (self.type == HKSelectbaseType_city){
        _row2 = 0;
        _row3 = 0;
        [self setCity];
        
    }else if (self.type == HKSelectbaseType_salary){
        if ([self.delegate respondsToSelector:@selector(gotoVc:type:)]) {
            [self.delegate gotoVc:[NSMutableArray arrayWithObject:self.arrayM[self.row1]] type:HKSelectbaseType_salary];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)setRow2:(int)row2{
    _row2 = row2;
    NSMutableArray*array = [NSMutableArray array];
    NSMutableArray*arrM = [NSMutableArray array];
    switch (self.type) {
        case HKSelectbaseType_position:
        {
            [array addObject:self.questionArray.firstObject];
            [array addObject:self.questionArray[1]];
            [arrM addObject:self.arrayM.firstObject];
            [arrM addObject:self.arrayM[1]];
            NSMutableArray *array3 = [NSMutableArray array];;
            NSMutableArray *arrayM3 = [NSMutableArray array];
            for (RecruitcategorysModel*model in self.dataModel.data.recruitCategorys) {
                if ([self.arrayM[1]count]==0) {
                    return;
                }
                RecruitindustrysModel*recruitindustrys = self.arrayM[1][row2];
                if ([model.parentId isEqualToString:recruitindustrys.ID]) {
                    [array3 addObject:model.name];
                    [arrayM3 addObject:model];
                }
                
            }
            [array addObject:array3];
            [arrM addObject:arrayM3];
            self.arrayM = arrM;
            _row3 = 0;
            self.questionArray = array ;
            
        }
            break;
        case HKSelectbaseType_city:{
            _row3 = 0;
            [self setCity];
            
        }
            break;
        case HKSelectbaseType_salary:{
    
        }
            break;
        default:
            break;
    }
}
-(void)setRow3:(int)row3{
    _row3 = row3;
    if (self.type == HKSelectbaseType_city) {
        if ([self.delegate respondsToSelector:@selector(gotoVc:type:)]) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:self.chinaM.provinces[self.row1]];
            [array addObject:[self.chinaM.provinces[self.row1] citys][self.row2]];
            [array addObject:[[self.chinaM.provinces[self.row1] citys][self.row2] areas][self.row3]];
            [self.delegate gotoVc:array type:self.type];
        }
    }else{
    if ([self.delegate respondsToSelector:@selector(gotoVc:type:)]) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:self.arrayM[0][self.row1]];
        [array addObject:self.arrayM[1][self.row2]];
        [array addObject:self.arrayM[2][self.row3]];
        [self.delegate gotoVc:array type:self.type];
    }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(HKInitializationRespone *)dataModel{
    if (!_dataModel) {
        _dataModel =  [NSKeyedUnarchiver unarchiveObjectWithFile:KinitDataPath];
    }
    return _dataModel;
}
-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.text = @"选择职位类别";
        _titleView.font = [UIFont systemFontOfSize:15];
        _titleView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.textAlignment = NSTextAlignmentCenter;
    }
    return _titleView;
}
-(HKChinaModel *)chinaM{
    if (!_chinaM) {
        _chinaM = [NSKeyedUnarchiver unarchiveObjectWithFile:KCityListData];
    }
    return _chinaM;
}
@synthesize questionArray = _questionArray;
-(void)setQuestionArray:(NSMutableArray *)questionArray{
    _questionArray = questionArray;
    [self.collectionView reloadData];
}
@end
