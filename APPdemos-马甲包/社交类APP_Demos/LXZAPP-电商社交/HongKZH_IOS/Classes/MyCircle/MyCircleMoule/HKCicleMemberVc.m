//
//  HKCicleMemberVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCicleMemberVc.h"
#import "HKMyCircleData.h"
#import "HKMyCircleMemberModel.h"
#import "HKFrindCicleInfoCell.h"
#import "HKMyCircleViewModel.h"
#import "HKMediaInfoResponse.h"
@interface HKCicleMemberVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation HKCicleMemberVc

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MainColor;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.rowHeight =60;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"成员列表";
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.members.count) {
         return  self.model.members.count;
    }
    return self.infoData.data.follows.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKFrindCicleInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fCell"];
    if (cell==nil) {
        cell =[[HKFrindCicleInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"fCell"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.tagLabel.hidden =YES;
    }
    if (self.model.members.count) {
        HKMyCircleMemberModel *data = self.model.members[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.headImg] placeholderImage:[UIImage imageNamed:@"back3.jpg"]];
        cell.cicleNameLabel.text =data.uName;
    }else {
        HKmediaInfoFollows *followData= self.infoData.data.follows[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:followData.headImg] placeholderImage:[UIImage imageNamed:@"back3.jpg"]];
        cell.cicleNameLabel.text =followData.name;
    }
    cell.cicleNameLabel.frame = CGRectMake(cell.cicleNameLabel.frame.origin.x,CGRectGetMinY(cell.iconImageView.frame),cell.cicleNameLabel.frame.size.width,CGRectGetHeight(cell.iconImageView.frame));
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    if (self.model.members.count) {
        HKMyCircleMemberModel *lisM =self.model.members[indexPath.row];
        list.uid =lisM.uid;
        list.name =lisM.uName;
        list.headImg =lisM.headImg;
    }else {
        HKmediaInfoFollows *followData= self.infoData.data.follows[indexPath.row];
        list.uid = followData.uid;
        list.name = followData.name;
        list.headImg = followData.headImg;
    }
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isMain) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyCircleMemberModel * model  =[self.model.members objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"您确定要从圈子中踢出该成员吗"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"踢出" action:^{
            [HKMyCircleViewModel kickOutMemberWithUid:model.uid andCilceId:self.cicleId success:^(HKBaseResponeModel *responde) {
                if (responde.responeSuc) {
                                    [self.model.members removeObjectAtIndex:indexPath.row];
                                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                    [self.tableView reloadData];
                }else {
                    [EasyShowTextView showText:@"操作失败"];
                }
            }];
        }], nil] show];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"踢出圈子";
}
@end
