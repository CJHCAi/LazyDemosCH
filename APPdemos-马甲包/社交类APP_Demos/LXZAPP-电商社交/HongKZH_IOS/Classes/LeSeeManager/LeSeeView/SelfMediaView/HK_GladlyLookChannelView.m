//
//  HK_GladlyLookChannelView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_GladlyLookChannelView.h"
#import "XLChannelControl.h"
#import "XLChannelView.h"
#import "NK_ChannelTitleView.h"
#import "HK_BaseRequest.h"
#import "HKRecommendRespone.h"
#import "HKUserCategoryListRespone.h"
#import "XLChannelItem.h"
#import "HK_NetWork.h"
#import "HK_MediaMainAllCategoryModelData.h"
@interface HK_GladlyLookChannelView ()<HK_GladlyFriendTitleLeftDelegate,HK_GladlyFriendTitleSeachDelegate,HK_GladlyChannelTitleRightDelegate>
{
    VoidBlock _backBlock;
    NK_ChannelTitleView *titleNav;
    XLChannelView *menu;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation HK_GladlyLookChannelView

- (void)viewDidLoad {
    [ViewModelLocator sharedModelLocator].categoryIdArray = @"";
    [super viewDidLoad];
    [self addReRequest];
    [self initNav];
    [self buildUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
    menu = [[XLChannelView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    
    @weakify(self);
    [ menu setClickFinshBlock:^(NSMutableArray *arrayN){
        @strongify(self);
        [self addRequesd:arrayN];
        
    }];
    
    [self.view addSubview:menu];

}

-(void)updateView
{
  
    [self buildData];
}

-(void)addRequesd:(NSMutableArray *)arrayN
{
    
//    NSMutableString*string = [NSMutableString string];
//    for (XLChannelItem *item in arrayN) {
//        if(item.categoryId.length > 0)
//        {
//            [string appendFormat:@"%@&",item.categoryId];
//        }
//    }
//    if (string.length>1) {
//       string = [string substringToIndex:string.length-1];
//    }
    NSMutableArray*array = [NSMutableArray array];
    for (XLChannelItem *item in arrayN) {
        if (item.categoryId.length>0) {
            [array addObject:@{@"categoryId":item.categoryId}];
        }
        
    }
    [HK_NetWork postWithNewURL:get_addUserCategory parameters:@{@"loginUid":HKUSERLOGINID} formDataArray:array callback:^(id responseObject, NSError *error) {
        if ([responseObject[@"code"]intValue] == 0) {
                        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNavLoadData object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
            [[XLChannelControl shareControl].inUseItems removeAllObjects];
            [[XLChannelControl shareControl].unUseItems removeAllObjects];
        }else{
                         [SVProgressHUD showSuccessWithStatus:@"保存失败"];
                    }
    }];
//    [HK_BaseRequest buildPostRequest:get_addUserCategory body:@{@"loginUid":HKUSERLOGINID,@"categoryId":string} success:^(id  _Nullable responseObject) {
//        if ([responseObject[@"code"]intValue] == 0) {
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNavLoadData object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//             [SVProgressHUD showSuccessWithStatus:@"保存失败"];
//        }
//    } failure:^(NSError * _Nullable error) {
//
//    }];
}


-(void)addBackBlock:(VoidBlock)block
{
    _backBlock = block;
}

-(void)backMethod
{
    //回调返回block
    if (_backBlock) {_backBlock();}
    //返回
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)buildUI
{
    self.title = @"XLChannelControl";
    self.view.backgroundColor = [UIColor whiteColor];
}

//初始化数据
-(void)buildData
{
     NSMutableArray *itemArr1 = [NSMutableArray new];
    XLChannelModel *item = [XLChannelModel new];
    item.title = @"推荐";
    item.image = @"channel_commend";
    XLChannelModel *item2 = [XLChannelModel new];
    item2.title = @"广告";
    item2.image = @"channel_commend";
    [itemArr1 addObject:item];
    [itemArr1 addObject:item2];
   
    NSMutableArray *itemArr2 = [NSMutableArray new];
    for (HK_MediaMainAllCategoryModelData *model in self.dataArray) {
        XLChannelModel *item = [XLChannelModel new];
        item.title = model.name;
        item.image = model.imgSrc;
        item.categoryId = model.categoryId;
        BOOL isSelect = NO;
        for (HKUserCategoryListModel*listM in self.selectArray) {
            if ([listM.categoryId isEqualToString:model.categoryId]) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect) {
            [itemArr1 addObject:item];
        }else{
            [itemArr2 addObject:item];
        }
    }

    [XLChannelControl shareControl].inUseItems = itemArr1;
    [XLChannelControl shareControl].unUseItems = itemArr2;
    
}

-(void)showChannelControl
{
    [[XLChannelControl shareControl] showInViewController:self completion:^(NSArray *channels) {
        DLog(@"频道管理结束：%@",channels);
    }];
}

-(void)initNav
{
    titleNav = [[NK_ChannelTitleView alloc] init];
    titleNav.leftdelegate = self;
    titleNav.seachdelegate = self;
    titleNav.rightdelegate = self;
    titleNav.frame = CGRectMake(0, 20, kScreenWidth, 45);
    [self.view addSubview:titleNav];
}

-(void)gotoLeftView;
{
    //回调返回block
    if (_backBlock) {
        _backBlock();
        
    }
    //返回
      [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoRightView:(BOOL)isHiend
{
    [menu isChange:isHiend];
}

-(void)gotoSeachView;
{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addReRequest
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [HK_BaseRequest buildPostRequest:get_mainAllCategoryList body:dic success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"]intValue]==0) {
            self.dataArray = [HK_MediaMainAllCategoryModelData mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self updateView];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
//    [self Business_Request:BusinessRequestType_get_mainAllCategoryList dic:dic cache:NO];
}



@end
