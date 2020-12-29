//
//  HKLocationCategoryCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLocationCategoryCollectionViewCell.h"
#import "HKAdvertisementCityInfo.h"

@interface HKLocationCategoryCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end

@implementation HKLocationCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.categoryView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.categoryView);
    }];
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _scrollView;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.questionArray removeAllObjects];
    CGFloat w = kScreenWidth/(dataArray.count+1);
    for ( int i =0; i< dataArray.count+1;i++) {
        
        UIButton*btn = [[UIButton alloc]init];
        [self.scrollView addSubview:btn];
        btn.titleLabel.font = PingFangSCMedium13;
        [btn setTitleColor:[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:64.0/255.0 green:147.0/255.0 blue:247.0/255.0 alpha:1] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            [btn setTitle:@"全部" forState:UIControlStateSelected];
            btn.selected = YES;
        }else{
            AdvertisementsCategorys*model = dataArray[i-1];
            [btn setTitle:model.categoryName forState:UIControlStateNormal];
            [btn setTitle:model.categoryName forState:UIControlStateSelected];
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(w*i);
            make.top.bottom.equalTo(self.scrollView);
            make.width.mas_equalTo(w-1);
        }];
        btn.tag = i;
        UIView*view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(13);
            make.centerY.equalTo(btn);
        }];
        [self.questionArray addObject:btn];
    }
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    for (UIButton*btn in self.questionArray) {
        if (btn.tag == selectIndex) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}
-(void)btnClick:(UIButton*)sender{
    self.selectIndex = sender.tag;
    if ([self.delegate respondsToSelector:@selector(categoryWithTag:)]) {
        [self.delegate categoryWithTag:sender.tag];
    }
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end
