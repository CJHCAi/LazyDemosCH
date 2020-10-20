//
//  WSearchResultView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSearchResultView.h"
#import "WSearchViewCell.h"
#import "WSearchDetailViewController.h"
static NSString *const kReusableSearchCellIdentifier = @"SearchCellIdentifier";


@interface WSearchResultView()<UITableViewDelegate,UITableViewDataSource>


/**搜索结果model*/
@property (nonatomic,strong) WSearchModel *searchModel;
/**搜索结果不存在label*/
@property (nonatomic,strong) UILabel *searchNoneLabel;


@end
@implementation WSearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark *** TableViewDataSource ***

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.searchModel.datatype) {
        [self addSubview:self.searchNoneLabel];
        self.tableView.frame = CGRectMake(0, 50*AdaptationWidth(), self.bounds.size.width, self.bounds.size.height);
    }
    
    if (self.searchModel&&self.searchModel.genlist.count!=0) {
        return self.searchModel.genlist.count;
    }

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableSearchCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[WSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReusableSearchCellIdentifier];
       
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.famName.text = self.searchModel.genlist[indexPath.row].GeName;
    
    NSString *imageUrlStr = self.searchModel.genlist[indexPath.row].GeCover;
    if (imageUrlStr && imageUrlStr.length!=0) {
        cell.portraitView.imageURL = [NSURL URLWithString:imageUrlStr];
    }else{
        cell.portraitView.image = MImage(@"news_touxiang.png");
    }
    cell.famId = [NSString stringWithFormat:@"%ld",(long)self.searchModel.genlist[indexPath.row].GeId];
    
    return cell;
}
#pragma mark *** TableViewDelegate ***
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    
    WSearchViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //将点击的cell的家谱id存入model
    [WSearchModel shardSearchModel].selectedFamilyID = cell.famId;
    [WSearchModel shardSearchModel].selectedFamilyName = cell.famName.text;
    WSearchDetailViewController *reslutView = [[WSearchDetailViewController alloc] initWithTitle:cell.famName.text image:nil];
    [[self viewController].navigationController pushViewController:reslutView animated:YES];
}

#pragma mark *** getters ***

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 154*AdaptationWidth();
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[WSearchViewCell class] forCellReuseIdentifier:kReusableSearchCellIdentifier];
        
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}
-(WSearchModel *)searchModel{
    if (!_searchModel) {
        _searchModel = [WSearchModel shardSearchModel];
        
    }
    return _searchModel;
}
-(UILabel *)searchNoneLabel{
    if (!_searchNoneLabel) {
        _searchNoneLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(0, 0, 700, 50)];
        _searchNoneLabel.text = @"很抱歉，您搜索的家谱暂时没有收录，为您推荐以下家谱。";
        _searchNoneLabel.font = WFont(25);
        _searchNoneLabel.textAlignment = 0;
    }
    return _searchNoneLabel;
}
@end
