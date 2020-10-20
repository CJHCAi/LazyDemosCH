//
//  WSWTableViewFoldOpen.m
//  WSWTableViewFoldOpen
//
//  Created by WSWshallwe on 2017/5/25.
//  Copyright © 2017年 shallwe. All rights reserved.
//

#import "WSWTableViewFoldOpen.h"
#import "WSWTableViewCell.h"
#import "HeaderView.h"

@interface WSWTableViewFoldOpen ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionStatus;//开关状态

@end

@implementation WSWTableViewFoldOpen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认打开第二section
    _sectionStatus = [NSMutableArray arrayWithObjects:@3,@1,@3,@3,@3, nil];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[WSWTableViewCell class] forCellReuseIdentifier:@"WSWTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_sectionStatus[section] isEqualToNumber:@3] || [_sectionStatus[section] isEqualToNumber:@2]) {
        return 0;
    }else {
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSWTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WSWTableViewCell"];
    if (!cell) {
        cell = [[WSWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WSWTableViewCell"];
    }
    return cell;
}

#pragma mark - 区视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
    
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    header.backgroundColor = [UIColor lightTextColor];
    int status = [_sectionStatus[section] intValue];
    [header updateWithStatus:status];
    __weak typeof (self)blockSelf = self;
    header.block =^{
        for (int i = 0; i < blockSelf.sectionStatus.count; i ++) {
            if (i != section ) {
                if ([blockSelf.sectionStatus[i] isEqualToNumber:@1]) {
                    [blockSelf.sectionStatus replaceObjectAtIndex:i withObject:@2];//close others
                    [blockSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationAutomatic];//优化刷新,防止动画
                    break;
                }
            }
        }
        int status = [blockSelf.sectionStatus[section] intValue];
        NSNumber *num = (status == 3 || status == 2 )? @1 :@2;
        [blockSelf.sectionStatus replaceObjectAtIndex:section withObject:num];
        //重新加载当前区
        [blockSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return header;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
