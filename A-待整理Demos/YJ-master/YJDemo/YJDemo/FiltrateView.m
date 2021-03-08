//
//  FiltrateView.m
//  JingBanYun
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import "FiltrateView.h"
#import "FiltrateCVCell.h"
#import "FiltrateReusableView.h"


@interface FiltrateView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectView;
@end


@implementation FiltrateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self loadData];
        [self makeUI];
    }
    return self;
}
-(void)loadData{
    self.dataArray = [NSMutableArray array];
    
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    mudic[@"switch"] = @"0";
    mudic[@"name"] = @"教材分册1";

    NSMutableArray *arr  = [NSMutableArray array];
    for(int i = 0;i<20;i++){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"name"]=[NSString stringWithFormat:@"第%d章",i];
        dic[@"id"]=[NSString stringWithFormat:@"%d",i];
        dic[@"showclose"]=@"0";
        [arr addObject:dic];
    }
    mudic[@"data"]=arr;
    
    //如果个数大于6个才显示右侧箭头
    if(arr.count>6){
        mudic[@"showRight"] = @"1";
    }else{
        mudic[@"showRight"] = @"0";
    }

    
    
    for(int i=0;i<10;i++){
        [self.dataArray addObject:mudic];
    }
    
    self.scrArray = [self.dataArray mutableCopy];
}
-(void)makeUI{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    float width = (SCREEN_WIDTH-50-40)/3;
    layout.itemSize =  CGSizeMake(width, width *0.35);
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing=10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-30-49) collectionViewLayout:layout];
    self.collectView.delegate=self;
    self.collectView.dataSource  =self;
    [self addSubview:self.collectView];
    self.collectView.backgroundColor=[UIColor whiteColor];
    [self.collectView registerNib:[UINib nibWithNibName:@"FiltrateCVCell" bundle:nil] forCellWithReuseIdentifier:@"FiltrateCVCell"];
    [self.collectView registerNib:[UINib nibWithNibName:@"FiltrateReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FiltrateReusableView"];
    
    [self addSubview:self.footerView];
    
}
-(UIView *)footerView{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-49, self.self.frame.size.width, 49)];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.self.frame.size.width, 1)];
    line.backgroundColor = GrayLine;
    [bgView addSubview:line];
    UIButton *leftBtn=[MyControl createButtonWithFrame:CGRectMake(0, 0, bgView.self.frame.size.width/2, 49) ImageName:nil Target:self Action:@selector(pressReset) Title:@"重置"];
    [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [bgView addSubview:leftBtn];
    
    UIButton *rightBtn=[MyControl createButtonWithFrame:CGRectMake(bgView.self.frame.size.width/2, 0, bgView.self.frame.size.width/2, 49) ImageName:nil Target:self Action:@selector(pressSure) Title:@"完成"];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    rightBtn.backgroundColor=GreenFont;
    [bgView addSubview:rightBtn];
    
    return bgView;
}
-(void)pressReset{
    //ze
    self.dataArray = [self.scrArray mutableCopy];
    [self.collectView reloadData];
}
-(void)pressSure{
    if(self.sendBlock){
        self.sendBlock();
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_HEIGHT-50, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    FiltrateReusableView *headReusableView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FiltrateReusableView" forIndexPath:indexPath];
    headReusableView.index = indexPath.section;
    headReusableView.dic = self.dataArray[indexPath.section];
    
    headReusableView.filtrateReusableViewBlock = ^(BOOL state,NSInteger index){
        NSDictionary *dic = self.dataArray[index];
        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *stateStr = @"0";
        if(state){
            stateStr = @"1";
        }
        mudic[@"switch"]=stateStr;
        [self.dataArray replaceObjectAtIndex:index withObject:mudic];
        
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self.collectView reloadSections:set];
        
    };
    return headReusableView;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *sedic = self.dataArray[section];
    NSArray *arr = sedic[@"data"];
   
    if([sedic[@"switch"] integerValue]==0&&arr.count>6){
        return 6;
    }
    return arr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FiltrateCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiltrateCVCell" forIndexPath:indexPath];
    NSDictionary *sedic = self.dataArray[indexPath.section];
    NSArray *arr  = sedic[@"data"];
    NSDictionary *item = arr[indexPath.row];
    
    cell.dic = item;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSMutableDictionary *musecDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSArray *arr  = musecDic[@"data"];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
    
    NSDictionary *item = muArr[indexPath.row];
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:item];
    
    //showRight
    if([mudic[@"showclose"] integerValue]==1){//已经选中的
        musecDic = [self.scrArray[indexPath.section] mutableCopy];
        NSArray *arr = musecDic[@"data"];
        if(arr.count>6){
            musecDic[@"showRight"] = @"1";
        }else{
            musecDic[@"showRight"] = @"0";
        }
    }else{
        mudic[@"showclose"]=@"1";
        
        musecDic[@"data"] = @[mudic];
        musecDic[@"showRight"]=@"0";
    }
    
    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:musecDic];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
    [self.collectView reloadSections:set];

}
@end
