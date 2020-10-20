//
//  TypeRankingView.m
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "TypeRankingView.h"
#import "RankingTableViewCell.h"
#import "ChooseBtnView.h"
#import "RankingModel.h"
typedef enum : NSUInteger {
    /** 活跃榜 */
    SelectedHYRankBTN,
    /** 人数榜 */
    SelectedRSRankBTN,
    /** 众筹榜 */
    SelectedZCRankBTN
   
} SelectedAruBTN;

@interface TypeRankingView()<UITableViewDelegate,UITableViewDataSource,ChooseBtnViewDelegate>
{
    SelectedAruBTN _selectedBtnType;
    NSArray *_headerArr;//榜单对应数据
    NSArray * _dataSource;
    
}
@property (strong,nonatomic) UITableView *listtableView;

@property (strong,nonatomic) ChooseBtnView *chooseBtnV;

@end

@implementation TypeRankingView

-(instancetype)initWithFrame:(CGRect)frame data:(RankingModel *)rankData{
    if (self = [super initWithFrame:frame]) {
        _headerArr = @[@"排名",@"用户",@"家族",@"活跃度",@"奖励"];
        _dataSource = rankData.hybr;
        _selectedBtnType = SelectedHYRankBTN;
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat w =self.frame.size.width;
    CGFloat h = self.frame.size.height;

    _chooseBtnV = [[ChooseBtnView alloc]initWithFrame:CGRectMake(0, 0, w, 34)];
    [self addSubview:_chooseBtnV];
    _chooseBtnV.backgroundColor = [UIColor clearColor];
    _chooseBtnV.delegate = self;

    _listtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, w, h-30)];
    [self addSubview:_listtableView];
    _listtableView.delegate = self;
    _listtableView.dataSource = self;
    _listtableView.backgroundColor = [UIColor clearColor];

}

-(void)chooseType:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            _selectedBtnType = SelectedHYRankBTN;
            _headerArr = @[@"排名",@"用户",@"家族",@"活跃度",@"奖励"];
            _dataSource = self.dataRank.hybr;
            
        }
            break;
        case 2:
        {
            _selectedBtnType = SelectedRSRankBTN;
            _headerArr = @[@"排名",@"家族",@"人数",@"奖励"];
            _dataSource = self.dataRank.rsbr;
        }
            break;
        case 3:
        {
            _selectedBtnType = SelectedZCRankBTN;
            _headerArr = @[@"排名",@"家族",@"金额",@"奖励"];
            _dataSource = self.dataRank.zcbr;
        }
            break;
        
            break;
        default:
            break;
    }
    
    [self.listtableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCodeRankingPorChange object:nil userInfo:@{@"tag":@(sender.tag)}];

}


#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource && _dataSource.count!=0) {
      return _dataSource.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingTableViewCell"];
    if (!cell) {
            cell = [[RankingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RankingTableViewCell"];
    }
    
    switch (_selectedBtnType) {
        case SelectedHYRankBTN:
        {
            cell.cellStyle = UITableViewCellStyleDefault;
            [cell initView];
            Hybr *hyItem = (Hybr *)_dataSource[indexPath.row];
            cell.nameLb.text = hyItem.mz;
            cell.familyLb.text = hyItem.jpm;
            cell.activenessLb.text = [NSString stringWithFormat:@"%ld",(long)hyItem.hyd];
           
            
        }
            break;
        case SelectedRSRankBTN:
        {
            cell.cellStyle = UITableViewCellStyleValue1;
            [cell initView];
            Rsbr *rsItem = (Rsbr *)_dataSource[indexPath.row];
            cell.familyLb.text =  rsItem.jpm;
            cell.activenessLb.text = [NSString stringWithFormat:@"%ld",(long)rsItem.rs];
            
        }
            break;
        case SelectedZCRankBTN:
        {
            
            cell.cellStyle = UITableViewCellStyleValue1;
            [cell initView];
            Zcbr *zcItem = (Zcbr *)_dataSource[indexPath.row];
            cell.familyLb.text = zcItem.jpm;
            cell.activenessLb.text = [NSString stringWithFormat:@"%ld",(long)zcItem.je];
        }
            break;
            
        default:
            break;
    }
    
    cell.numberLb.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];

    cell.rewardLb.text = @"20券";
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 38)];
    sectionV.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    
    NSInteger dataCount = _headerArr.count;
    
    for (int i =0; i<dataCount; i++) {
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0+self.frame.size.width/dataCount*i, 12, self.frame.size.width/dataCount, 20)];
        [sectionV addSubview:titleLb];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = MFont(14);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = _headerArr[i];
    }

    return sectionV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}



@end
