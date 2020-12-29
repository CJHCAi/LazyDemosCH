//
//  HK_baseVideoConrtoller.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_baseVideoConrtoller.h"
#import "HK_SubMyVideoVc.h"
#import "ZWMSegmentController.h"
#import "HK_MyVideoTool.h"
@interface HK_baseVideoConrtoller ()
@property (nonatomic, strong) ZWMSegmentController *segmentVC;
@property (nonatomic, strong)NSMutableArray *caterArr;
@end

@implementation HK_baseVideoConrtoller

-(NSMutableArray *)caterArr {
    if (!_caterArr) {
        _caterArr =[[NSMutableArray alloc] init];
    }
    return _caterArr;
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
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}
-(instancetype)init {
    self =[super init];
    if (self) {
        self.sx_disableInteractivePop = YES;
    }
    return  self;
}
-(void)initNav {
    switch (self.videoType) {
        case Cater_priseCaterGory:
             self.title =@"我的点赞";
            break;
        case Cater_collectionCaterGory:
             self.title =@"我的收藏";
            break;
        case Cater_videoCatergory:
             self.title =@"我的视频";
            break;
        default:
            break;
    }
    [self setShowCustomerLeftItem:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    [self getCaterGoryForVideo];
}
#pragma mark 获取视频分类的ID
-(void)getCaterGoryForVideo {
    
    [HK_MyVideoTool getMyVideoCaterGoryInfoMationWithType:self.videoType SucceeBlcok:^(id responseJson) {
        HKMyVideoCategory *caterGory =[HKMyVideoCategory mj_objectWithKeyValues:responseJson];
        if (caterGory.data.count) {
            for (HKMyVideoCategoryData * data in caterGory.data) {
                if (data.categoryId.length) {
                    [self.caterArr addObject:data];
                }
            }
        }
        HKMyVideoCategoryData *fistModel =[[HKMyVideoCategoryData alloc] init];
        fistModel.name =@"全部视频";
        fistModel.categoryId =@"";
        [self.caterArr insertObject:fistModel atIndex:0];
        
        [self creatSubViewControllers];
    } Failed:^(NSString *error) {
         [EasyShowTextView showText:error];
    }];
}
-(void)creatSubViewControllers {
    
    NSMutableArray *vcArray=[[NSMutableArray alloc] init];
    NSMutableArray *titleArr =[[NSMutableArray alloc] init];
   
    for (int i=0; i<self.caterArr.count;i++) {
        HKMyVideoCategoryData *fistModel =[self.caterArr objectAtIndex:i];
        HK_SubMyVideoVc *pageVc = [[HK_SubMyVideoVc alloc] init];
        pageVc.caterId = fistModel.categoryId;
        pageVc.caterType = self.videoType;
        [titleArr addObject:fistModel.name];
        
        [vcArray addObject:pageVc];
    }
    self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:self.view.bounds titles:titleArr];
    self.segmentVC.segmentView.segmentTintColor = [UIColor colorFromHexString:@"333333"];
    self.segmentVC.segmentView.segmentNormalColor =[UIColor colorFromHexString:@"7c7c7c"];
    self.segmentVC.viewControllers = vcArray;
    self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
    //指示条和按钮文字对其
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
}

@end
