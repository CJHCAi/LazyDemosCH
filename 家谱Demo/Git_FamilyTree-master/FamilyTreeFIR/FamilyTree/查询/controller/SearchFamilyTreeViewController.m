//
//  SearchFamilyTreeViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "SearchFamilyTreeViewController.h"
#import "SearchTableViewCell.h"
#import "CommonNavigationViews.h"
#import "WSearchResultView.h"
#import "WSearchDetailViewController.h"
@interface SearchFamilyTreeViewController()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isMyGen;
}
/** 搜索栏*/
@property (nonatomic, strong) UIView *searchView;
/**宗亲table*/
@property (nonatomic,strong) UITableView *tableView;
/**搜索textField*/
@property (nonatomic,strong) UITextField *searchTextField;

/**搜索结果view*/
@property (nonatomic,strong) WSearchResultView *searchTable;


@end

@implementation SearchFamilyTreeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    //导航栏
    //[self initNavi];
    CommonNavigationViews *navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:@"查询" image:MImage(@"chec")];
    [self.view addSubview:navi];
    //搜索栏
    [self initSearchBar];
    //添加表格
    [self initTableView];
    //搜索结果
    [self.view addSubview:self.searchTable];
    
}

//导航栏
-(void)initNavi{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    topView.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [self.view addSubview:topView];
    
    CGFloat topLabelWidth = 40;
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake((Screen_width-topLabelWidth)/2, StatusBar_Height, topLabelWidth, NavigationBar_Height)];
    topLabel.text = @"查询";
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, 22, 22)];
    [leftButton setBackgroundImage:MImage(@"fanhui.png") forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width-38, 32, 20, 20)];
    [rightButton setBackgroundImage:MImage(@"chec.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}
//搜索栏
-(void)initSearchBar{
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(12, NavigationBar_Height+StatusBar_Height+8, Screen_width-24, 30)];
    _searchView.layer.cornerRadius = 30/2.0f;
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    UITextField *searchTF = [[UITextField alloc]initWithFrame:CGRectMake(25, NavigationBar_Height+StatusBar_Height+8, Screen_width-50, 30)];
    searchTF.backgroundColor = [UIColor whiteColor];
    searchTF.placeholder = @"输入关键词";
    searchTF.font = MFont(13);
    self.searchTextField = searchTF;
    [self.view addSubview:self.searchTextField];
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(searchTF)-13, CGRectY(searchTF)+8-3, 20, 20)];
    searchImageView.image = MImage(@"search");
    searchImageView.contentMode = UIViewContentModeScaleAspectFill;
    searchImageView.userInteractionEnabled = true;
    [self.view addSubview:searchImageView];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSearch)];
    [searchImageView addGestureRecognizer:searchTap];
    
}
//添加表格
-(void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectYH(_searchView)+10, Screen_width, 120)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}
//返回按钮
-(void)clickLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏右侧菜单
-(void)clickRightButton{
    MYLog(@"点击右侧菜单");
}

//点击搜索图标
-(void)clickSearch{
    [self searchGemIsMyGen:false];
}
#pragma mark *** 网络请求 ***
/** 搜索信息 */
-(void)searchGemIsMyGen:(BOOL)mygen{
    /** 获取搜索信息 */
    [TCJPHTTPRequestManager POSTWithParameters:@{@"query":self.searchTextField.text,
                                                 @"pagenum":@"1",
                                                 @"pagesize":@"20",
                                                 @"ismygen":mygen?@"1":@"0"
                                                 } requestID:GetUserId requestcode:kRequestCodequerygenandgemelist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            WSearchModel *searchModel = [WSearchModel modelWithJSON:jsonDic[@"data"]];
            
            [WSearchModel shardSearchModel].genlist = searchModel.genlist;
            [WSearchModel shardSearchModel].datatype = searchModel.datatype;
            [WSearchModel shardSearchModel].page = searchModel.page;
            //赋值完过后跳转
            [self.searchTable.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
/** 附近宗亲 */
-(void)getNearGemPersonPositon{
    WholeWorldViewController *who = [[WholeWorldViewController alloc] initWithTitle:@"四海同宗"];
    who.queryString = self.searchTextField.text;
    [self.navigationController pushViewController:who animated:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!cell) {
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    if (indexPath.row == 0) {
        cell.imageV.image = MImage(@"find");
        cell.titleLB.text = @"同支宗亲";
        cell.detailLB.text = @"查找同支宗亲";
    }else{
        cell.imageV.image = MImage(@"adress");
        cell.titleLB.text = @"附近宗亲";
        cell.detailLB.text = @"查找附近宗亲";
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self searchGemIsMyGen:true];
    }else{
        [self getNearGemPersonPositon];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark *** getters ***
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectYH(self.tableView), Screen_width, 600*AdaptationWidth())];
        
    }
    return _searchView;
}
-(WSearchResultView *)searchTable{
    if (!_searchTable) {
        _searchTable = [[WSearchResultView alloc] initWithFrame:CGRectMake(30*AdaptationWidth(), CGRectYH(self.tableView)+20*AdaptationWidth(), Screen_width, 666*AdaptationWidth())];
    }
    return _searchTable;
}
@end
