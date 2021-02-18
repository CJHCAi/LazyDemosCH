//
//  DivinationViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/17.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "DivinationViewController.h"
#import "UseItemView.h"
#import "WAfterDivinationViewController.h"
#import "CliffordTributeModel.h"
#import <AVFoundation/AVFoundation.h>
//#import <CoreMotion/CoreMotion.h>

#define AnimationTime 3.0f
enum {
    //本身btntag
    XZBtnTag = 10,
    XLBtnTag,
    YBBtnTag,
    //点击详情道具的tag
    XZUseItemClick,
    XLUseItemClick,
    YBUseItemClick
    
};

@interface DivinationViewController ()<UseItemViewDelegate>
@property (nonatomic,strong) UIImageView *imageView; /*背景图*/

@property (nonatomic,strong) UIButton *firBtn; /*香烛*/
@property (nonatomic,strong) UIButton *senBtn; /*牲礼*/
@property (nonatomic,strong) UIButton *thrBtn; /*元宝*/

@property (nonatomic,strong) UseItemView *userItem; /*详细道具图*/

@property (nonatomic,strong) UIImageView *diviAnimations; /*求签动画*/

/**祈福商品modelArr*/
@property (nonatomic,strong) NSArray *cliModelArr;
/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;
///** 重力感应*/
//@property (nonatomic, strong) CMMotionManager *cmMotionManager;

@end

@implementation DivinationViewController

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initBackGround];
   
    [self initThreeBtn];
    
    //支持摇一摇
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
//背景图
-(void)initBackGround{
    
    UIImageView *imagView = [[UIImageView alloc] init];
    imagView.image = MImage(@"qiuQian_bg");
    imagView.userInteractionEnabled = YES;
    [self.view addSubview:imagView];
    imagView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    self.imageView = imagView;
    self.imageView.userInteractionEnabled = YES;
    
    //摇晃提示
    UIImageView *deVieView = [[UIImageView alloc] init];
    deVieView.image  = MImage(@"qiuQian_ft_q");
    deVieView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDivinationBtn)];
    
    [deVieView addGestureRecognizer:tap];
    
    [self.imageView addSubview:deVieView];
    
    deVieView.sd_layout.leftSpaceToView(self.imageView,125*AdaptationWidth()).heightIs(90*AdaptationWidth()).widthIs(540*AdaptationWidth()).bottomSpaceToView(self.firBtn,40*AdaptationWidth());
    //求签动画
    [self.imageView addSubview:self.diviAnimations];
}
-(void)initThreeBtn{
    [self.imageView addSubview:self.firBtn];
    [self.imageView addSubview:self.senBtn];
    [self.imageView addSubview:self.thrBtn];
    
    self.firBtn.sd_layout.leftSpaceToView(self.imageView,45*AdaptationWidth()).bottomSpaceToView(self.imageView,60*AdaptationWidth()).heightIs(150*AdaptationWidth()).widthIs(200*AdaptationWidth());
    
    self.senBtn.sd_layout.leftSpaceToView(self.firBtn,25*AdaptationWidth()).heightIs(150*AdaptationWidth()).widthIs(200*AdaptationWidth()).bottomEqualToView(self.firBtn);
    
    self.thrBtn.sd_layout.leftSpaceToView(self.senBtn,25*AdaptationWidth()).heightIs(150*AdaptationWidth()).widthIs(200*AdaptationWidth()).bottomEqualToView(self.firBtn);
}
#pragma mark *** 请求 ***
/**
 *  搜索商品
 *
 *  @param name 商品名
 *  @param back 结束搜索
 */
-(void)postGoodsListWithGoodsName:(NSString *)name WhileComplete:(void (^)())back{
    NSDictionary *dic = [WShopCommonModel shareWShopCommonModel].typeIdDic;
    [TCJPHTTPRequestManager POSTWithParameters:@{@"pagenum":@"1",
                                                 @"pagesize":@"20",
                                                 @"type":dic[@"祈福虚拟"],
                                                 @"label":@"",
                                                 @"coname":name,
                                                 @"shoptype":@"QF",
                                                 @"qsj":@"",
                                                 @"jwj":@"",
                                                 @"px":@"ZH",
                                                 @"issx":@"1",
                                                 } requestID:GetUserId requestcode:kRequestCodegetcomlist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"--goods--%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
                                                         NSDictionary *dic = [NSString jsonDicWithDic:jsonDic[@"data"]];
//                                                         NSArray <CliffordTributeModel *>*arr = [NSArray modelWithJSON:dic[@"datalist"]];
                                                         [CliffordTributeModel shareClifordArr].cliffordArr = dic[@"datalist"];
                                                         back();
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
}
/** 获取所有商品类型以及id */
-(void)postGetSyntypeWhileComplete:(void (^)())back{
    [TCJPHTTPRequestManager POSTWithParameters:@{@"typeval":@"SPFL"} requestID:GetUserId requestcode:kRequestCodeGetsyntype success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"--%@",[NSString jsonArrWithArr:jsonDic[@"data"]]);
            
            NSArray *arr = [NSString jsonArrWithArr:jsonDic[@"data"]];
            NSMutableDictionary *alldic = [NSMutableDictionary dictionary];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = arr[idx];
                [alldic setObject:dic[@"syntypeval"] forKey:dic[@"syntype"]];
            }];
            [WShopCommonModel shareWShopCommonModel].typeIdDic = alldic;
            back();
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark *** Events ***
-(void)respondsToDivAllBtn:(UIButton *)sender{
   
    [self postGetSyntypeWhileComplete:^{
        [self postGoodsListWithGoodsName:@"" WhileComplete:^{
            
            NSArray *arr = [CliffordTributeModel shareClifordArr].cliffordArr;
            NSString *urlStr = arr[sender.tag-10][@"CoCover"];
            NSString *price =  arr[sender.tag-10][@"CoprMoney"];
            self.userItem.goodsImage.imageURL = [NSURL URLWithString:urlStr];
            self.userItem.priceLabel.text = [NSString stringWithFormat:@"%@元/天",price];
            
            switch (sender.tag) {
                case XZBtnTag:
                {
                    self.userItem.tag = XZUseItemClick;
                    [self.imageView addSubview:self.userItem];
                }
                    break;
                case XLBtnTag:
                {
                    self.userItem.tag = XLUseItemClick;
                    [self.imageView addSubview:self.userItem];
                }
                    break;
                case YBBtnTag:
                {
                    self.userItem.tag = YBUseItemClick;
                    [self.imageView addSubview:self.userItem];
                }
                    break;
                    
                default:
                    break;
            }
   
        }];
    }];
    
    
}
#pragma mark *** useritemDelegate ***
-(void)UseItemViewDidRespondsToUseBtn:(UseItemView *)useView{
    
    UIImageView *addView = [self.userItem.goodsImage deepCopy];
    addView.frame = AdaptationFrame(65, 50, 75, 52);
    switch (useView.tag) {
        case XZUseItemClick:
        {
            [self.firBtn addSubview:addView];
        }
            break;
        case XLUseItemClick:
        {
            [self.senBtn addSubview:addView];

        }
            break;
        case YBUseItemClick:
        {
            [self.thrBtn addSubview:addView];

        }
            break;
            
        default:
            break;
    }
}
#pragma mark *** 摇一摇 ***
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [self.diviAnimations startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WAfterDivinationViewController *afterVc = [[WAfterDivinationViewController alloc] initWithTitle:@"灵签" image:nil];
        [self.navigationController pushViewController:afterVc animated:YES];
    });
}

-(void)clickDivinationBtn{
    MYLog(@"点击求签");
    [self.diviAnimations startAnimating];
    
    //1.获得音效文件的全路径
    
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"qiuqian.mp3" withExtension:nil];
    
    //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    //把需要销毁的音效文件的ID传递给它既可销毁
    //AudioServicesDisposeSystemSoundID(soundID);
    
    //3.播放音效文件
    //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        AudioServicesPlaySystemSound(soundID);
    } repeats:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer.fireDate = [NSDate distantFuture];
    });
    
    
    CABasicAnimation *moveXAnimation = [CABasicAnimation animation];
    moveXAnimation.keyPath = @"position.x";
    moveXAnimation.fromValue = @(self.diviAnimations.center.x -25);
    moveXAnimation.toValue = @(self.diviAnimations.center.x+25);
    moveXAnimation.duration = 1;
    moveXAnimation.repeatCount = 2;
    [self.diviAnimations.layer addAnimation:moveXAnimation forKey:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WAfterDivinationViewController *afterVc = [[WAfterDivinationViewController alloc] initWithTitle:@"灵签" image:nil];
        [self.navigationController pushViewController:afterVc animated:YES];
    });

}

#pragma mark *** getters ***

-(UIButton *)firBtn{
    if (!_firBtn) {
        _firBtn = [UIButton new];
        [_firBtn setImage:MImage(@"qiuQian_sm_xz") forState:0];
        _firBtn.tag = XZBtnTag;
        [_firBtn addTarget:self action:@selector(respondsToDivAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _firBtn;
}
-(UIButton *)senBtn{
    if (!_senBtn) {
        _senBtn = [UIButton new];
        [_senBtn setImage:MImage(@"qiuQian_sm_xl") forState:0];
        _senBtn.tag = XLBtnTag;
        
        [_senBtn addTarget:self action:@selector(respondsToDivAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _senBtn;
}
-(UIButton *)thrBtn{
    if (!_thrBtn) {
        _thrBtn = [UIButton new];
        [_thrBtn setImage:MImage(@"qiuQian_sm_yb") forState:0];
        _thrBtn.tag = YBBtnTag;
        [_thrBtn addTarget:self action:@selector(respondsToDivAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thrBtn;
}
-(UseItemView *)userItem{
    if (!_userItem) {
        _userItem =[[UseItemView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, HeightExceptNaviAndTabbar)];
        _userItem.delegate = self;
    }
    return _userItem;
}

-(UIImageView *)diviAnimations{
    if (!_diviAnimations) {
        _diviAnimations = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600*AdaptationWidth(), 700*AdaptationWidth())];
        _diviAnimations.contentMode = UIViewContentModeScaleAspectFill;
        _diviAnimations.image = MImage(@"qj_left1");
        _diviAnimations.center = CGPointMake(self.view.center.x, self.view.center.y-250*AdaptationWidth());
        
        NSMutableArray *imageArrs = [@[] mutableCopy];
        for (int j = 0; j < 2; j++) {
            for (int idx = 1; idx < 6; idx++) {
                NSString *imStr = [NSString stringWithFormat:@"qj_left%d",idx];
                [imageArrs addObject:MImage(imStr)];
            }
            for (int idx = 5; idx > 0; idx--) {
                NSString *imStr = [NSString stringWithFormat:@"qj_left%d",idx];
                [imageArrs addObject:MImage(imStr)];
            }

            for (int idx = 1; idx < 6; idx++) {
                NSString *imStr = [NSString stringWithFormat:@"qj_right%d",idx];
                [imageArrs addObject:MImage(imStr)];
            }
            for (int idx = 5; idx > 0; idx--) {
                NSString *imStr = [NSString stringWithFormat:@"qj_right%d",idx];
                [imageArrs addObject:MImage(imStr)];
            }
        }
        [imageArrs removeObjectsInRange:NSMakeRange(16, 5)];
        for (int i = 6; i < 11; i++) {
            NSString *imStr = [NSString stringWithFormat:@"qj_right%d",i];
            [imageArrs addObject:MImage(imStr)];
        }
        
        for (int i = 1; i < 18; i++) {
            NSString *imStr = [NSString stringWithFormat:@"qj_chuqian%d",i];
            [imageArrs addObject:MImage(imStr)];
        }
        
        
        _diviAnimations.animationImages = imageArrs;
        _diviAnimations.animationDuration = AnimationTime;
        _diviAnimations.animationRepeatCount = 1;
        
    }
    return _diviAnimations;
}



@end
