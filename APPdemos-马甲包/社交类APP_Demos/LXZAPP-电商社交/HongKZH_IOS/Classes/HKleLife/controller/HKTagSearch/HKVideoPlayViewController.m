//
//  HKVideoPlayViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoPlayViewController.h"
#import "HKVideoPlayView.h"
#import "HKVideoTagViewController.h"
#import "HKTagView.h"
#import "HKTagRightView.h"
#import "HKEnterpriseRecruitViewController.h"
#import "HKReleaseResumeViewController.h"
#import "HKPublishCommonModuleViewController.h"
#import "HKReleaseMarryViewController.h"
#import "HKReleasePhotographyViewController.h"
#import "HKReleaseResumeViewController.h"
#import "HKEditResumeViewController.h"
#import "HKUpdateReleaseRecruitViewController.h"
#import "HK_AllTags.h"
#import "HKCropImageViewController.h"
#import "UIImage+FixOrientation.h"
@interface HKVideoPlayViewController ()<HKVideoPlayViewDelegate,HKVideoTagViewControllerDelegate>

@property (nonatomic, strong) HKVideoPlayView *playView;
@property (nonatomic, strong) NSMutableArray *tagViews;
//@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation HKVideoPlayViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sx_disableInteractivePop = YES;
    }
    return self;
}
- (void)dealloc {
    DLog(@"%s",__func__);
    [self.playView releasePlayerAndTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}
-(void)back{
    [self.playView releasePlayerAndTimer];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)finishButtonClickBlock{
    //保存标签
    [self saveTags];
    //跳转发布页面
    [self gotoPublishViewController];
    
    //释放播放器
    [self.playView pause];
}
-(void)tagClickBlock:(id)tagValue{
    if (tagValue) {
        [self addTagView:tagValue];
    }
    //继续播放
    [self.playView resume];
}
-(void)tagButtonClickBlock{
    HKVideoTagViewController *vc = [[HKVideoTagViewController alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}
- (HKVideoPlayView *)playView {
    if (!_playView) {
        HKVideoPlayView* playView = [[HKVideoPlayView alloc] init];
        _playView = playView;
        _playView.delegate = self;
//        @weakify(self);
        playView.delegate = self;
       
    }
    return _playView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.playView) {
        if (self.playView.playerState == AliyunVodPlayerStatePause) {
            [self.playView resume];
        }else{
            [self.playView resume];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.playView) {
        if (self.playView.playerState == AliyunVodPlayerStatePlay) {
            [self.playView pause];
        }
    }
}

//跳转发布页面
- (void)gotoPublishViewController {
    HKReleaseVideoParam *releaseParm = [HKReleaseVideoParam shareInstance];
    ENUM_PublishType type = releaseParm.publishType;
    ;
    HKCropImageViewController *cropImg = [[HKCropImageViewController alloc] initWithCropImage:releaseParm.coverImgSrc];
    cropImg.type = type;
    [self.navigationController pushViewController:cropImg animated:YES];
    return;
    
}

//保存标签信息
- (void)saveTags {
    if ([self.tagViews count] == 0) {
        return;
    }
    //保存标签id数组
    NSMutableArray *tagIds = [NSMutableArray array];
    NSMutableArray *tagTypes = [NSMutableArray array];
    NSMutableArray *tagNames = [NSMutableArray array];
    NSMutableArray *tagXs = [NSMutableArray array];
    NSMutableArray *tagYs = [NSMutableArray array];
    NSMutableArray *orientations = [NSMutableArray array];
    for (HKTagView *tagView in self.tagViews) {
        id tagValue = tagView.tagValue;
        if ([tagValue isKindOfClass:[HK_AllTagsHis class]]) {
            HK_AllTagsHis *value = (HK_AllTagsHis *)tagValue;
            if ([value.type integerValue] == 3) {//自定义标签为null,传null过去
                [tagIds addObject:[NSNull null]];
            } else {
                [tagIds addObject:value.tagId];
            }
            [tagTypes addObject:value.type];
            [tagNames addObject:value.tag];
        } else if ([tagValue isKindOfClass:[HK_AllTagsCircles class]]) {
            HK_AllTagsCircles *value = (HK_AllTagsCircles *)tagValue;
            [tagIds addObject:value.tagId];
            [tagTypes addObject:value.type];
            [tagNames addObject:value.tag];
        } else if ([tagValue isKindOfClass:[HK_AllTagsRecommends class]]) {
            HK_AllTagsRecommends *value = (HK_AllTagsRecommends *)tagValue;
            if ([value.type integerValue] == 3) {//自定义标签为null,传null过去
                [tagIds addObject:[NSNull null]];
            }else {
                [tagIds addObject:value.tagId];
            }
            [tagTypes addObject:value.type];
            [tagNames addObject:value.tag];
        }
        [tagXs addObject:[NSString stringWithFormat:@"%f",tagView.mj_x]];
        [tagYs addObject:[NSString stringWithFormat:@"%f",tagView.mj_y]];
        [orientations addObject:[NSString stringWithFormat:@"%ld",tagView.direction]];
    }
    [HKReleaseVideoParam setObject:tagIds key:@"tagId"];
    [HKReleaseVideoParam setObject:tagTypes key:@"tagType"];
    [HKReleaseVideoParam setObject:tagNames key:@"tagName"];
    [HKReleaseVideoParam setObject:tagXs key:@"x"];
    [HKReleaseVideoParam setObject:tagYs key:@"y"];
    [HKReleaseVideoParam setObject:orientations key:@"orientation"];
}


- (void)addTagView:(id)tagValue {
    
    HKTagView *tagView = [[HKTagView alloc] init];
    tagView.tagValue = tagValue;
    tagView.cancelBlock = ^(HKTagView *tagView) {
        [self.tagViews removeObject:tagView];
        [tagView removeFromSuperview];
    };
    [self.view addSubview:tagView];
    [self.tagViews addObject:tagView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [tagView addGestureRecognizer:panGesture];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-40);
        make.centerX.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(24);
    }];
}

//标签位置
-(void) pan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat orginalX = recognizer.view.mj_x;
    CGFloat moveX = translation.x;
    CGFloat orginalY = recognizer.view.mj_y;
    DLog(@"拖动:===%f,原点:====%f,\ny:====%f",translation.x,recognizer.view.mj_x,orginalY);
    CGFloat moveY = translation.y;
    
    CGFloat width = recognizer.view.mj_w;
    CGFloat height = recognizer.view.mj_h;
    
    //限制拖动的边界
    if (orginalX+moveX < 0) {   //左边界
        moveX = orginalX;
    } else if (orginalX+width+moveX > kScreenWidth) { //右边界
        moveX = kScreenWidth-orginalX-width;
    } else if (orginalY+moveY < 0) {    //上边界
        moveY = orginalY;
    } else if (orginalY+height+moveY > (kScreenHeight-150)) {  //下边界
        moveY = kScreenHeight-150-orginalY-height;
    }
    //箭头方向
    HKTagView *tagView = (HKTagView *)recognizer.view;
    CGFloat right = orginalX+width;
    if (right < kScreenWidth/2) {
        if (right+moveX >= kScreenWidth/2) { //超过中间 调整箭头方向向左
            tagView.direction = 0;
            [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(20);
            }];
            [tagView remakeConstraintsWithDirection];
        }
    } else if(orginalX > kScreenWidth/2) {
        if (orginalX+moveX <= kScreenWidth/2) { //超过中间 调整箭头方向向右
            tagView.direction = 1;
            [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(-20);
            }];
            [tagView remakeConstraintsWithDirection];
        }
    }

    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, moveX, moveY);
    [recognizer setTranslation:CGPointZero inView:self.view];
}


- (NSMutableArray *)tagViews {
    if (!_tagViews) {
        _tagViews = [NSMutableArray array];
    }
    return _tagViews;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    self.playView.url = url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.playView];
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.playView prepareWithURL:self.url];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTag:) name:@"searchTags" object:nil];
}
-(void)handleTag:(NSNotification *)notifi {
    id object = notifi.object;
    [self addTagView:object];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
