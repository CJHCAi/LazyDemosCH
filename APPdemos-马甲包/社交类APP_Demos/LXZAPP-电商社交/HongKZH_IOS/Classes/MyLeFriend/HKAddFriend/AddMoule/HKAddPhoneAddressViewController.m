//
//  HKAddPhoneAddressViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddPhoneAddressViewController.h"
#import <Contacts/Contacts.h>
#import "PPAddressBookHandle.h"
#import "PPPersonModel.h"
#import "PPGetAddressBook.h"
#import "HKAddHeadViewModel.h"
#import "HKMobileRequestModel.h"
#import "HKAddreesTableViewCell.h"
#import "HKTableViewSessionHeadView.h"
@interface HKAddPhoneAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSArray *perDataArray;
@end

@implementation HKAddPhoneAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)loadData{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        [SVProgressHUD showSuccessWithStatus:@"您禁止了访问通讯录"];
        return ;
    }
    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
        if (!addressBookArray.count) {
            [EasyShowTextView showText:@"您没有通讯录好友"];
            return;
        }
        self.perDataArray = addressBookArray;
        NSMutableString*string = [NSMutableString string];
        for (PPPersonModel*model in addressBookArray) {
            if (model.mobileString.length>0) {
                [string appendString:model.mobileString];
                [string appendString:@","];
            }
        }
        if (string.length>0) {
            NSRange deleteRange = { [string length] - 1, 1 };
            
            [string deleteCharactersInRange:deleteRange];
        }
        [HKAddHeadViewModel loadMobile:@{@"loginUid":HKUSERLOGINID,@"mobile":string} success:^(HKMobileRequestModel *model) {
            self.dataArray  = [NSMutableArray arrayWithArray:model.data] ;
            [self.tableView reloadData];
        }];
    } authorizationFailure:^{
        
    }];

}
-(void)setUI{
    self.title = @"添加通讯录好友";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKTableViewSessionHeadView *view = [[HKTableViewSessionHeadView alloc]init];
    NSMutableArray *invateUser =[[NSMutableArray alloc] init];
    if (self.dataArray.count>0) {
        for (HKMobileModel * model in self.dataArray) {
            if (model.state.intValue!=2) {
                [invateUser addObject:model];
            }
        }
        view.titleText = [NSString stringWithFormat:@"%ld个好友可邀请",invateUser.count];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        HKAddreesTableViewCell*cell = [HKAddreesTableViewCell addreesTableViewCellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        cell.name = [self.perDataArray[indexPath.row] name];
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [ NSMutableArray array];
    }
    return _dataArray;
}
@end
