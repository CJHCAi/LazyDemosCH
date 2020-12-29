//
//  HKSearchTagController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchTagController.h"
#import "HKSearchView.h"
#import "HKVideoTagCell.h"
#import "HK_VideoConfogueTool.h"
@interface HKSearchTagController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)HKSearchView * searchV;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSources;
@property (nonatomic, strong)NSString * searchText;

@end

@implementation HKSearchTagController

-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGBA(238, 238, 238, 0.5);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView registerNib:[UINib nibWithNibName:@"HKVideoTagCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVideoTagCell class])];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
    
}

#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self initNav];
}
-(void)initNav {
    HKSearchView * search =[HKSearchView searchView];
    search.placeHoder =@"搜索标签,好友或圈子";
    search.intrinsicContentSize =CGSizeMake(280,30);
    self.searchV = search;
    self.navigationItem.titleView = search;
    self.searchV.tf.delegate = self;
    [AppUtils addBarButton:self title:@"取消" action:@selector(pushSearchVc) position:PositionTypeRight];
}
-(void)pushSearchVc {
    self.searchV.resignResponder =YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)searchClick {
    [HK_VideoConfogueTool seachVideoTagsWithTagName:self.searchText successBlock:^(HK_TagSeachResponse *response) {
        [self.dataSources removeAllObjects];
        NSArray *seachData = response.data;
        if (seachData.count) {
            for (HK_SeachData *data in seachData) {
                [self.dataSources addObject:data];
            }
        }else {
            HK_SeachData * cusData =[[HK_SeachData alloc] init];
            cusData.tag  = self.searchText;
            cusData.type = @"3";
            [self.dataSources addObject:cusData];
        }
        [self.tableView reloadData];
        
    } fial:^(NSString *fials) {
        [EasyShowTextView showText:fials];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //搜索标签..
    self.searchText = textField.text;
    if (self.searchText.length) {
         [self searchClick];
    }else {
        [self.dataSources removeAllObjects];
        [self.tableView reloadData];
    }
    return  YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKVideoTagCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVideoTagCell class])];
    NSObject *value = [self.dataSources objectAtIndex:indexPath.row];
    cell.itemValue = value;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_SeachData *data =[self.dataSources objectAtIndex:indexPath.row];
    
    //发送通知...并且pop到指定界面...
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchTags" object:data];
   
    Class  vc = NSClassFromString(@"HKVideoPlayViewController");
  
    for(UIViewController *temVC in self.navigationController.viewControllers)
    {
        if ([temVC  isKindOfClass:vc]) {
            
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 71;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text = @"标签结果";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [HKComponentFactory labelWithFrame:CGRectMake(16, 21, 300, 14) textColor:RGB(102, 102, 102) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14 text:text supperView:nil];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSources.count) {
          return 35;
    }
    return  0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
