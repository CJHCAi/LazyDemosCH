//
//  HK_FriendUserVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FriendUserVc.h"
#import "HKFrindInfoHeaderView.h"
#import "HKFriendPhotoCell.h"
#import "HKFrindActiveCell.h"
#import "HKFriendBaseInfoCell.h"
#import "HKFriendTagCell.h"
#import "HKFriendAttentionCell.h"
#import "HKFriendUserCell.h"
#import "HKFrindCicleCell.h"
#import "HKFrindCicleInfoCell.h"
#import "HKCicleMemberVc.h"
@interface HK_FriendUserVc ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AttentionFllowDelegete>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKFrindInfoHeaderView *head;
@property (nonatomic, strong)HKMediaInfoResponse *response;
@property (nonatomic, assign)CGFloat offset;
@end
@implementation HK_FriendUserVc

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
    [self.view addSubview:self.tableView];
    [self getUserInfoData
     ];
}
-(void)getUserInfoData {
    [HKMyFriendListViewModel getUserMediaInfoByUid:self.uid.length>0?self.uid:@"" successBlock:^(HKMediaInfoResponse *response) {
        self.response = response;
        if (self.delegete && [self.delegete respondsToSelector:@selector(updateUserHeaderInfoWith:)]) {
            [self.delegete updateUserHeaderInfoWith:self.response];
        }
        [self.tableView reloadData];
    } fial:^(NSString *error) {
        
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        if ([[LoginUserData sharedInstance].chatId isEqualToString:self.uid]) {
             _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-210-45-45-SafeAreaBottomHeight) style:UITableViewStylePlain];
        }else {
               _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-260-45-45-SafeAreaBottomHeight) style:UITableViewStylePlain];
        }
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.bounces = NO;
        _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator =NO;
        [_tableView registerClass:[HKFrindCicleCell class] forCellReuseIdentifier:@"cicle"];
        
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==5) {
        if (self.response.data.circles.count) {
            return 1+self.response.data.circles.count;
        }
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case  0:
            return  self.response.data.albums.count>0?110:0;
            break;
        case 1:
            return self.response.data.dynamics.count>0?140:54;
            break;
        case 2:
            return 200;
            break;
        case 3:
            return 165;
            break;
         case 4:
            return self.response.data.follows.count> 0?130:54;
            break;
        default:
        {
            //return   self.response.data.circles.count>0?
            //48+self.response.data.circles.count*6:54;
            if (indexPath.row) {
                return 60;
            }
            return 46;
        }
            break;
     }
    return  0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        HKFriendPhotoCell * pcell =[tableView dequeueReusableCellWithIdentifier:@"pCell"];
        if (pcell==nil) {
            pcell =[[HKFriendPhotoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"pCell"];
        }
        pcell.response = self.response;
        return pcell;
    }else if (indexPath.section==1) {
        HKFrindActiveCell *aCell =[tableView dequeueReusableCellWithIdentifier:@"aCell"];
        if (aCell==nil) {
            aCell =[[HKFrindActiveCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aCell"];
            aCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
        aCell.response =self.response;
        return aCell;
    }else if (indexPath.section==2) {
        HKFriendBaseInfoCell *bCell =[tableView dequeueReusableCellWithIdentifier:@"bCell"];
        if (bCell==nil) {
            bCell =[[HKFriendBaseInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"bCell"
                    ];
        }
        bCell.response = self.response;
        return bCell;
    }else if (indexPath.section==3) {
        HKFriendTagCell *tCell =[tableView dequeueReusableCellWithIdentifier:@"tCell"];
        if (tCell == nil) {
            tCell =[[HKFriendTagCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tCell"
                    ];
        }
        tCell.response= self.response;
        return tCell;
        
    }else if (indexPath.section==4) {
        HKFriendAttentionCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell==nil) {
            cell =[[HKFriendAttentionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.response =self.response;
        cell.delegete = self;
        return cell;
    }
    if (indexPath.row) {
        HKFrindCicleInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fCell"];
        if (cell==nil) {
            cell =[[HKFrindCicleInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"fCell"];
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
        HKMediaCicleData *data =self.response.data.circles[indexPath.row-1];
        cell.response = data;
        return cell;
    }
     HKFrindCicleCell *cicleCell =[tableView dequeueReusableCellWithIdentifier:@"cicle" forIndexPath:indexPath];
     cicleCell.response =self.response;
     return  cicleCell;

}
-(void)pushUserDetailWithModel:(HKmediaInfoFollows *)model {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.uid =model.uid;
    list.headImg =model.headImg;
    list.name =model.name;
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==5 && indexPath.row>0) {
        HKMediaCicleData *data =self.response.data.circles[indexPath.row-1];
        [AppUtils pushCicleMainContentWithCicleId:data.circleId andCurrentVc:self];
    }else if (indexPath.section==4) {
       //成员列表
        HKCicleMemberVc *cicleM =[[HKCicleMemberVc alloc] init];
        cicleM.infoData = self.response;
        [self.navigationController pushViewController:cicleM animated:YES];
        
    }
}
@end
