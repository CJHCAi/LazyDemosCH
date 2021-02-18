//
//  GennerationViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "GennerationViewController.h"
#import "GennerTableViewCell.h"
static NSString *const kGennerCellIdentifier = @"GennercellIdentifier";

@interface GennerationViewController ()<TopBackSearchDelegate,UITableViewDelegate,UITableViewDataSource,TopSearchViewDelegate>

{
    NSMutableArray *_allInfoArr; //名字array
    NSMutableArray *_detailInfo; //字辈array
    NSMutableArray *_genNameArr; //详情array
    NSMutableArray *_imageUrlArr; //图片url
    NSMutableArray *_dsArr;/** 代数arr */
    /** 成员idArr */
    NSMutableArray *_genIdArr;
    NSString *_queryZbStr;/** 查询字辈的字段 */
}


@property (nonatomic,strong) TopBackSearch *topView; /*头部搜索带返回键*/
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) WGennerationModel *gennerModel; /*字辈model*/


@end

@implementation GennerationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self PostGennerInfomationWhileComplete:^{
        [self initUI];
        
    }];

    
}
#pragma mark *** 初始化数据 ***
-(void)initData{

    _allInfoArr = [@[] mutableCopy];
    
    _detailInfo = [@[]mutableCopy];
    
    _genNameArr = [@[]mutableCopy];
    
    _imageUrlArr = [@[] mutableCopy];
    
    _dsArr = [@[] mutableCopy];
    
    _queryZbStr = @"";
    
    _genIdArr = [@[] mutableCopy];
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self.view addSubview:self.tableView];
}

#pragma mark *** 网络请求字辈列表 ***

-(void)PostGennerInfomationWhileComplete:(void (^)())back{
    WK(weakSelf)
    if (![[NSString stringWithFormat:@"%@",[WFamilyModel shareWFamilModel].myFamilyId] isEqualToString:@""]) {
        [TCJPHTTPRequestManager POSTWithParameters:@{@"geid":[WFamilyModel shareWFamilModel].myFamilyId,@"query":_queryZbStr,
                                                     @"pagenum":@"1",
                                                     @"pagesize":@"20",
                                                     @"ds":@""} requestID:GetUserId requestcode:kRequestCodequeryzbgemelist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                         if (succe) {
                                                             
                                                             weakSelf.gennerModel = [WGennerationModel modelWithJSON:jsonDic[@"data"]];
                                                             
                                                             [_genNameArr removeAllObjects];
                                                             [_allInfoArr removeAllObjects];
                                                             [_detailInfo removeAllObjects];
                                                             [_imageUrlArr removeAllObjects];
                                                             [_dsArr removeAllObjects];
                                                             [_genIdArr removeAllObjects];
                                                             //更新所有数据源取model里面的数据
                                                             for (int idx = 0; idx<self.gennerModel.datalist.count; idx++) {
                                                                 NSString *ziBei = [self.gennerModel.datalist[idx].zb stringByReplacingOccurrencesOfString:@"," withString:@""];
                                                                 [_genNameArr addObject:ziBei];
                                                                 
                                                                 NSString *genNum = [NSString stringWithFormat:@"第%ld代",(long)self.gennerModel.datalist[idx].ds];
                                                                 [_dsArr addObject:genNum];
                                                                 NSMutableArray *nameArr = [@[] mutableCopy];
                                                                 NSMutableArray *urlArr = [@[] mutableCopy];
                                                                 NSMutableArray *cyIDArr = [@[] mutableCopy];
                                                                 for (int ij = 0; ij<self.gennerModel.datalist[idx].datas.count; ij++) {
                                                                     [nameArr addObject:self.gennerModel.datalist[idx].datas[ij].name];
                                                                     [urlArr addObject:self.gennerModel.datalist[idx].datas[ij].photo];
                                                                     [cyIDArr addObject:[NSString stringWithFormat:@"%ld",(long)self.gennerModel.datalist[idx].datas[ij].gemeid]];
                                                                 }
                                                                 [_allInfoArr addObject:nameArr];
                                                                 [_imageUrlArr addObject:urlArr];
                                                                 [_genIdArr addObject:cyIDArr];
                                                                 
                                                                 
                                                                 NSMutableArray *detailArr = [@[] mutableCopy];
                                                                 for (int index2 = 0; index2<self.gennerModel.datalist[idx].datas.count; index2++) {
                                                                     NSMutableArray *okuArr = [@[] mutableCopy];
                                                                     [okuArr addObject:@"无"];
                                                                     [okuArr addObject:self.gennerModel.datalist[idx].datas[index2].father];
                                                                     
                                                                     [okuArr addObject:self.gennerModel.datalist[idx].datas[index2].mother];
                                                                     
                                                                     [detailArr addObject:okuArr];
                                                                 }
                                                                 [_detailInfo addObject:detailArr];
                                                                 
                                                             }
                                                             
                                                             back();
                                                             
                                                         }
                                                     } failure:^(NSError *error) {
                                                         
                                                     }];

    }
}
//点击我的家谱的处理
#pragma mark *** TopDelegate ***

-(void)didTapMySeletedFamWithNumber:(NSString *)sender{
    WK(Wkself)
    [self PostGennerInfomationWhileComplete:^{
        [Wkself.tableView reloadData];
    }];
}
#pragma mark *** events ***

-(void)respondsToTopSearchView:(UIButton *)sender{
    MYLog(@"返回");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark *** tableViewDataSource,Delegate ***

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.gennerModel.datalist) {
        return self.gennerModel.datalist.count;
    }
    return _allInfoArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GennerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGennerCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[GennerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGennerCellIdentifier];
    }
    [CALayer drawTopBorder:cell];
    [CALayer drawBottomBorder:cell];
    
    cell.nameArr = _allInfoArr[indexPath.row];
    
    cell.idArr = _detailInfo[indexPath.row];
    
    cell.proImageUrlArr = _imageUrlArr[indexPath.row];
    cell.genIdArr = _genIdArr[indexPath.row];

    [cell initPorInfo];
    cell.generNumber.text = _dsArr[indexPath.row];
    cell.personNumber.text = [NSString stringWithFormat:@"%ld人",(unsigned long)((NSArray *)_allInfoArr[indexPath.row]).count];
    
    cell.perName.text =  [NSString verticalStringWith:_genNameArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark *** TopDelegate ***

-(void)TopSearchViewDidTapView:(TopSearchView *)topSearchView{
    
    MYLog(@"查询字辈");
    _queryZbStr = topSearchView.searchLabel.text;
    WK(Wkself)
    [self PostGennerInfomationWhileComplete:^{
        [Wkself.tableView reloadData];
    }];
}


#pragma mark *** getters ***
-(TopBackSearch *)topView{
    if (!_topView) {
        
        _topView = [[TopBackSearch alloc] initWithFrame:CGRectMake(0, 0, Screen_width, StatusBar_Height+NavigationBar_Height)];
        _topView.delegate = self;
        _topView.delegateBak = self;
        [_topView.backBtn addTarget:self action:@selector(respondsToTopSearchView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-self.tabBarController.tabBar.bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[GennerTableViewCell class] forCellReuseIdentifier:kGennerCellIdentifier];
        _tableView.rowHeight = 334*AdaptationWidth();
        _tableView.separatorColor = [UIColor clearColor];
        
    }
    return _tableView;
}

@end




