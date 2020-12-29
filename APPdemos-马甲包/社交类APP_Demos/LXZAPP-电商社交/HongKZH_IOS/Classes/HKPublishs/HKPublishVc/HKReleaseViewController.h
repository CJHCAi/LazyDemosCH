//
//  HKReleaseViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HKChooseChannelTableViewCell.h"
#import "HKRecruitIntroductionTableViewCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HKReleaseLocationCell.h"
#import "HKTitleAndContentCell.h"
#import "HKChooseChannelTableViewCell.h"
#import "HKImageAnnexCell.h"
#import "HKDisplayProductCell.h"
#import "HKReleaseVideoSaveDraft.h"
#import "HKReleaseVideoSaveDraftDao.h"
#import "HKReleaseVideoSaveDraftAdapter.h"
#import "HKSetMoneyViewController.h"
#import "HKMoneyPayCell.h"
#import "HKMoneyModel.h"
@interface HKReleaseViewController : HK_BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
//是否包含底部的发布按钮
@property (nonatomic, assign)BOOL hasNoBottomBar;

@property (nonatomic, weak) HKTitleAndContentCell *titleContentCell;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) HKReleaseLocationData *locationData;

//发红包
@property (nonatomic, strong)HKMoneyModel * model;

@property (nonatomic, assign)BOOL setMoney;


//商品
@property (nonatomic, strong) NSMutableArray *selectedItems;

@property (nonatomic, assign) NSInteger boothCount;

@property (nonatomic, strong) NSIndexPath *productCellIndexPath;   //商品cell的indexpath用来刷新cell

@property (nonatomic, strong) NSIndexPath *locationCellIndexPath;   //定位cell的indexpath用来刷新cell

@property (nonatomic, assign) NSInteger source;

@property (nonatomic, strong) HKReleaseVideoSaveDraft *saveDraft;

@property (nonatomic, strong) HKReleaseVideoSaveDraftDao *saveDraftDao;

- (void)uploadSuccess;

- (void)nextStep;

- (void)cancel;

- (void)requestLocation;

- (void)saveProducts;

//更改频道cell
- (HKChooseChannelTableViewCell *)createChooseChannelCell;

//标题和内容cell
- (HKTitleAndContentCell *)createTitleAndContentCell;

//图片附件cell
- (HKImageAnnexCell *)createImageAnnexCellWithTip:(NSString *)tip;

//定位cell
- (HKReleaseLocationCell *)createLocationCell:(NSIndexPath *)indexPath;

//商品cell
- (HKDisplayProductCell *)createDisplayProductCell:(NSIndexPath *)indexPath;

//发红包cell
-(UITableViewCell *)createMoneyCell:(NSIndexPath *)indexPath;

- (void)uploadData ;

- (void)buttonClick;

@end
