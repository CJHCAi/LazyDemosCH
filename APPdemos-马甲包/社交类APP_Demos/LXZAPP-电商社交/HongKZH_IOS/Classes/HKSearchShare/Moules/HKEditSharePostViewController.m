//
//  HKEditSharePostViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditSharePostViewController.h"
#import "HKMyPostBaseTableViewCell.h"
#import "HKMyPostViewModel.h"
#import "HKFriendViewModel.h"
@interface HKEditSharePostViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation HKEditSharePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    self.tableVIew.estimatedRowHeight = 245;
    self.tableVIew.rowHeight = UITableViewAutomaticDimension;
    [self setrightBarButtonItemWithTitle:@"分享"];
}

-(void)rightBarButtonItemClick{
    [self shareModel];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postM?1:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyPostBaseTableViewCell *cell = [HKMyPostViewModel tableView:tableView cellForRowAtIndexPath:indexPath model:self.postM];
    cell.model = self.postM;
    cell.isHideTool = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setPostM:(HKMyPostModel *)postM{
    _postM = postM;
    [self.tableVIew reloadData];
    
}
-(void)shareModel{
    if (self.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入想说的话"];
        return;
    }
    [HKFriendViewModel shareForwardPost:@{kloginUid:HKUSERLOGINID,@"title":self.textField.text,@"model":@(4),@"modelId":self.postM.postId,@"circleId":self.circleId,@"modelName":self.postM.title.length>0?self.postM.title:@""} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            
            if ([self.delegate respondsToSelector:@selector(gotoBack)]) {
                [self.delegate gotoBack];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
        }
    }];
}
@end
