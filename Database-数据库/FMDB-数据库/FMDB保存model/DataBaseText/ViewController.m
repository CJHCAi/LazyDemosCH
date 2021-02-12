//
//  ViewController.m
//  DataBaseText
//
//  Created by 劳景醒 on 16/11/30.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "LJXFMDBManager.h"
#import "CheckinModel.h"
#import "CheckinCell.h"

#define  FMDBManager  [LJXFMDBManager ShareFMDBManager]

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *_dataArray;
    NSString *_cellIdentifier;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *tableName;
- (IBAction)inserModelArray:(id)sender;

- (IBAction)createTableAction:(id)sender;
- (IBAction)deleteTableData:(id)sender;
- (IBAction)dorpTableAction:(id)sender;
@property (nonatomic, strong) FMDatabase *dataBaseManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 一般保存到cache目录里面
    NSString *dataPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    dataPath = [dataPath stringByAppendingPathComponent:@"MyDB.sqlite"];
    NSLog(@"%@",dataPath);
    // 创建数据库
    [FMDBManager createDataBaseWithPath:dataPath];
 
    [self _initData];
    
}

- (void)_initData
{
    _dataArray = [NSMutableArray array];
    _tableName.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"checkin" ofType:@"json"];
    NSData *jsData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = dataDic[@"data"];
    for (NSDictionary *subDic in dataArray) {
        CheckinModel *model = [CheckinModel initWithDic:subDic];
        [_dataArray addObject:model];
    }
    
    _cellIdentifier = NSStringFromClass([CheckinCell class]);
    UINib *nib = [UINib nibWithNibName:_cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:_cellIdentifier];
}


#pragma mark - Action
- (IBAction)inserModelArray:(id)sender {
    [_tableName resignFirstResponder];

    NSMutableArray *muta = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"checkin" ofType:@"json"];
    NSData *jsData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = dataDic[@"data"];
    for (NSDictionary *subDic in dataArray) {
        CheckinModel *model = [CheckinModel initWithDic:subDic];
        [muta addObject:model];
    }
    /// 插入
    if ([FMDBManager insterModelArray:muta toTable:_tableName.text]) {
        [self showMessage:@"插入成功"];
        NSArray *all = [FMDBManager searchAllModel:[CheckinModel class] tableName:_tableName.text];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:all];
        [self.tableView reloadData];
        NSLog(@"个数%ld", all.count);
        
    } else {
        [self showMessage:@"插入失败"];
    }
    
    

}

- (IBAction)createTableAction:(id)sender {
    // 创建表
    if ([_tableName.text isEqualToString:@""]) {
        NSLog(@"请输入表名");
        return;
    }
    NSString *tableName =_tableName.text;
    Class modelClass = [CheckinModel class];
    if ([FMDBManager createTableWithName:tableName model:modelClass primaryKey:@"flightCode123"]) {
      [self showMessage:@"创表成功"];
    } else {
        [self showMessage:@"创表失败"];
    }
}

- (IBAction)deleteTableData:(id)sender {
    if ([FMDBManager truncateTable:_tableName.text]) {
        [self showMessage:@"删除成功"];
    } else {
        [self showMessage:@"删除失败"];
    }
}

- (IBAction)dorpTableAction:(id)sender {
    if ([FMDBManager dropTable:_tableName.text]) {
        [self showMessage:@"删除成功"];
    } else {
       [self showMessage:@"删除失败"];
    }
}


#pragma mark - showMessage
- (void)showMessage:(NSString *)message
{
    UIAlertController *alerContrl = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfireAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alerContrl addAction:comfireAction];
    [self presentViewController:alerContrl animated:YES completion:nil];
}


#pragma mark - UITableView DataSource && Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class modelClass = [CheckinModel class];
    NSArray * searchArray = [FMDBManager searchModel:modelClass WithKey:@"flightPhone" value:@"028-66668888" inTable:_tableName.text];
    NSLog(@"%lu",(unsigned long)searchArray.count);
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        // 删除
        CheckinModel *model = _dataArray[indexPath.row];
        if ([FMDBManager deleteModelColumnName:@"flightCode" columnValue:model.flightCode tableName:_tableName.text]) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            NSLog(@"laojingxingjiixingjidngaj%@", @(indexPath.row));
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    
    return @[deleteAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
