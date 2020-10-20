//
//  SPContractsViewController.m
//  SalesPo_iOS
//
//  Created by 甘萌 on 16/5/21.
//  Copyright © 2016年 Ganmeng. All rights reserved.
//

#import "SPContractsViewController.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool

@interface SPContractsViewController ()
<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation SPContractsViewController

#pragma mark - dataArr(模拟从服务器获取到的数据)
- (NSArray *)serverDataArr{
    if (!_serverDataArr) {
        _serverDataArr=@[@{@"portrait":@"1",@"name":@"1"},
                         @{@"portrait":@"2",@"name":@"花无缺"},
                         @{@"portrait":@"3",@"name":@"东方不败"},
                         @{@"portrait":@"4",@"name":@"任我行"},
                         @{@"portrait":@"5",@"name":@"逍遥王"},
                         @{@"portrait":@"6",@"name":@"阿离"},
                        @{@"portrait":@"13",@"name":@"百草堂"},
                        @{@"portrait":@"8",@"name":@"三味书屋"},
                        @{@"portrait":@"9",@"name":@"彩彩"},
                        @{@"portrait":@"10",@"name":@"陈晨"},
                        @{@"portrait":@"11",@"name":@"多多"},
                        @{@"portrait":@"12",@"name":@"峨嵋山"},
                        @{@"portrait":@"7",@"name":@"哥哥"},
                        @{@"portrait":@"14",@"name":@"林俊杰"},
                        @{@"portrait":@"15",@"name":@"足球"},
                        @{@"portrait":@"16",@"name":@"58赶集"},
                        @{@"portrait":@"17",@"name":@"搜房网"},
                        @{@"portrait":@"18",@"name":@"欧弟"}];
    }
    return _serverDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.dataArr=[NSMutableArray array];
    self.selectedArr = [NSMutableArray array];
    
    for (NSDictionary *subDic in self.serverDataArr) {
        ContactModel *model=[[ContactModel alloc]init];
        model.name = subDic[@"name"];
        model.portrait = subDic[@"portrait"];
        model.isSelected = @"0";
        [self.dataArr addObject:model];
    }
    
    _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
    _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
    
    //假设传值了
    
    
    if (self.datasource.count) {
        for (ContactModel *contactPush in self.datasource) {
            for (NSArray *arr in _rowArr) {
                
                for (ContactModel *model in arr) {
                
                    //匹配就替换
                    if ([contactPush.portrait isEqualToString:model.portrait]) {
                        NSLog(@"%@", model.name);
                        model.isSelected = @"1";
                        //注意这个也要加
                        [self.selectedArr addObject:model];
                    }
                }
            }
        }

    }
    

    //configNav
    [self configNav];
    [self.view addSubview:self.tableView];
    
}


- (void)configNav{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0, 0.0, 60.0, 30.0)];
    [btn setTitle:@"回掉" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:btn]];
}



#pragma mark - setUpView


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight-49.0) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
        //cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
    }
    return _tableView;
}


- (void)selectedAction{
    NSLog(@"%@",self.selectedArr);

    !_callback ?: _callback(self.selectedArr);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //section
    return _rowArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_rowArr[section] count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor redColor]];
    }
    [label setText:[NSString stringWithFormat:@"  %@",_sectionArr[section+1]]];
    return label;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(ContactTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *contactArrs = _rowArr[indexPath.section];
//    ContactModel *model = contactArrs[indexPath.row];
//    
//    
//    if ([self.selectedArr containsObject:model]) {
//        [cell.selectButton setTitle:@"🔴" forState:UIControlStateNormal];
//
//    }else{
//        [cell.selectButton setTitle:@"⚪️" forState:UIControlStateNormal];
//    }
//    
//
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{        return _sectionArr;

}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 22.0;
    
}

#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    ContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    

    ContactModel *model=_rowArr[indexPath.section][indexPath.row];
    cell.contact = model;
    
    //加入选择数组中
    
    __weak typeof(self)weakSelf = self;
    cell.selectedBlock = ^(ContactModel *contact){
        
        if ([contact.isSelected isEqualToString:@"1"]) {
            [weakSelf.selectedArr addObject:contact];
        }else{
            if ([weakSelf.selectedArr containsObject:contact])
                [weakSelf.selectedArr removeObject:contact];
        }
        
    };
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

