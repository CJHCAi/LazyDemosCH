//
//  MainViewController.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/23.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "MainViewController.h"
#import "SettingView.h"
#import "PaiView.h"
#import "GXFButton.h"
#import "SystemServices.h"
#import "ViewController.h"

#define selectButtonMargin 10

/**
    用于我点不叫，判断是否已有别人叫
 */
static NSInteger bujiao;
static NSInteger nong1fen;
static NSInteger nong2fen;

// 设置底分和倍数
static NSInteger difen;
static NSInteger beishu = 1;

typedef enum {
    DiZhuNong1,
    DiZhuNong2,
    DiZhuWo
} DiZhuState;

@interface MainViewController () <SettingViewDelegate, PaiViewDelegate, POPAnimationDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) UIImageView *moneyView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *levelImageView;
@property (nonatomic, strong) UIImageView *levelJindu;
@property (nonatomic, strong) UILabel *diFenLabel;
@property (nonatomic, strong) UILabel *beiShuLabel;

@property (nonatomic, strong) UIImageView *leftTopView;
@property (nonatomic, strong) UIImageView *leftBottomView;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIButton *prepareButton;
@property (nonatomic, strong) UIButton *leftPangButton;
@property (nonatomic, strong) UIButton *rightPangButton;

@property (nonatomic, assign) NSInteger diFen;
@property (nonatomic, assign) NSInteger beiShu;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) NSMutableArray *cardArray; // 所有的降序的牌的所有图片

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) SettingView *settingView;

@property (nonatomic, strong) UIVisualEffectView *veView;

@property (nonatomic, strong) UIView *fenView;

@property (nonatomic, strong) UIImageView *beiImageView;

@property (nonatomic, strong) NSMutableArray *array; // 17张降序的随机数数组，刚开始点了准备之后

@property (nonatomic, strong) NSMutableArray *arrayNong1; // 农民1的17个随机数 降序

@property (nonatomic, strong) NSMutableArray *arrayNong2; // 农民2的17个随机数 降序

@property (nonatomic, strong) NSMutableArray *currentCardArray; // 当前牌的按钮数组

@property (nonatomic, strong) PaiView *paiView;

@property (nonatomic, strong) NSMutableArray *array2; // 3张底牌的随机数

@property (nonatomic, strong) UIButton *chuButton;

@property (nonatomic, strong) UIView *diPai3View;

@property (nonatomic, strong) UIImageView *jishiView;

@property (nonatomic, strong) NSMutableArray *upArray; // 我出的所有牌的按钮，无序

@property (nonatomic, assign) NSInteger foreNum; // 用于跟牌时作比较

@property (nonatomic, strong) POPAnimation *selfAnimation;

@property (nonatomic, strong) POPAnimation *nong1Animation;

@property (nonatomic, strong) POPAnimation *nong2Animation;

@property (nonatomic, strong) NSMutableArray *nong1ChuArray; // 农民1出的牌，需要移除它

@property (nonatomic, strong) NSMutableArray *nong2ChuArray; // 农民2出的牌，需要移除它

@property (nonatomic, strong) NSMutableArray *selfChuArray; // 自己出的牌，需要移除它

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImageView *duihuaViewZuo1;
@property (nonatomic, strong) UIImageView *duihuaViewZuo2;
@property (nonatomic, strong) UIImageView *duihuaContentView1;
@property (nonatomic, strong) UIImageView *duihuaContentView2;
@property (nonatomic, strong) UIImageView *duihuaContentView3;
@property (nonatomic, strong) UIImageView *duihuaViewYou;

@property (nonatomic, assign) NSInteger nong1Num;
@property (nonatomic, assign) NSInteger nong2Num;

@property (nonatomic, strong) UIImageView *successView;

@property (nonatomic, strong) NSString *sex; // 用于区分男女

@property (nonatomic, assign) DiZhuState diZhuState;

@property (nonatomic, assign) NSInteger fenShu; // 分数

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    bujiao = 0;
    
    difen = 0;
    
    beishu = 1;
}

- (void)setupUI {
    
    // 背景大图
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 顶部信息栏
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    // 添加下面地主和农民
    [self.view addSubview:self.leftTopView];
    [self.leftTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.top.equalTo(self.topView.mas_bottom).offset(2);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(60);
    }];
    [self.view addSubview:self.leftPangButton];
    [self.leftPangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTopView.mas_right).offset(2);
        make.top.equalTo(self.leftTopView).offset(5);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(32);
    }];
    
    [self.view addSubview:self.leftBottomView];
    [self.leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.top.equalTo(self.leftTopView.mas_bottom).offset(50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(60);
    }];
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.topView.mas_bottom).offset(2);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(60);
    }];
    [self.view addSubview:self.rightPangButton];
    [self.rightPangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_left).offset(-2);
        make.top.equalTo(self.rightView).offset(5);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(32);
    }];
    
    // 添加准备按钮
    [self.view addSubview:self.prepareButton];
    [self.prepareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(35);
    }];
    
    // 添加底部工具栏
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
}

- (PaiView *)paiView {
    
    if (!_paiView) {
        _paiView = [PaiView new];
        _paiView.numArray = self.array;
        _paiView.cardArray = self.cardArray;
        _paiView.delegate = self;
    }
    return _paiView;
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"spr_bg_game_scene.jpg"];
    }
    return _bgImageView;
}

- (UIView *)topView {
    
    if (!_topView) {
        _topView = [[UIView alloc] init];
        
        // 顶部背景图
        [_topView addSubview:self.topBgImageView];
        [self.topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_topView);
        }];
        
        // 钱币图片和数量
        [_topView addSubview:self.moneyView];
        [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView).offset(50);
            make.top.equalTo(_topView);
            make.width.height.mas_equalTo(_topView.mas_height);
        }];
        [_topView addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moneyView.mas_right);
            make.top.bottom.equalTo(_topView);
        }];
        
        // 等级和进度
        [_topView addSubview:self.levelImageView];
        [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moneyLabel.mas_right).offset(20);
            make.top.bottom.equalTo(_topView);
            make.width.mas_equalTo(60);
        }];
        [_topView addSubview:self.levelJindu];
        [self.levelJindu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.levelImageView.mas_right).offset(5);
            make.centerY.equalTo(_topView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(10);
        }];
        
        // 电池和时间
        NSString *time = [[SystemServices sharedServices] carrierName];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *dateString = [dateFormatter stringFromDate:date];
        GXFLog(@"%@", dateString);
        CGFloat batery = [SSBatteryInfo batteryLevel];
        GXFLog(@"%f", batery);
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.text = dateString;
        timeLabel.textColor = [UIColor colorWithRed:231/255.0 green:186/255.0 blue:43/255.0 alpha:1.0];
        [_topView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_topView).offset(-50);
            make.top.bottom.equalTo(_topView);
            make.width.mas_equalTo(40);
        }];
        UIImageView *bateryView = [UIImageView new];
        bateryView.backgroundColor = [UIColor grayColor];
        UIImageView *bateryLevelView = [UIImageView new];
        bateryLevelView.image = [UIImage imageNamed:@"dianchi2"];
        [bateryView addSubview:bateryLevelView];
        [bateryLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(bateryView);
            make.width.mas_equalTo(35.0/100*batery);
        }];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // 更新时间和电量
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm";
            NSString *dateString = [dateFormatter stringFromDate:date];
            timeLabel.text = dateString;
            
            [bateryLevelView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(35.0/100*batery);
            }];
        }];
        self.timer = timer;
        
        [_topView addSubview:bateryView];
        [bateryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(timeLabel.mas_left).offset(-3);
            make.top.equalTo(_topView).offset(2);
            make.bottom.equalTo(_topView).offset(-3);;
            make.width.mas_equalTo(35);
        }];
        
        // 低分和倍数
        [_topView addSubview:self.beiShuLabel];
        [self.beiShuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bateryView.mas_left).offset(-10);
            make.top.bottom.equalTo(_topView);
            make.width.mas_equalTo(50);
        }];
        [_topView addSubview:self.diFenLabel];
        [self.diFenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.beiShuLabel.mas_left);
            make.top.bottom.equalTo(_topView);
            make.width.equalTo(self.beiShuLabel);
        }];
        
        
        
    }
    return _topView;
}

- (UIImageView *)leftTopView {
    
    if (!_leftTopView) {
        _leftTopView = [UIImageView new];
        _leftTopView.image = [UIImage imageNamed:@"nongl"];
    }
    return _leftTopView;
}

- (UIImageView *)leftBottomView {
    
    if (!_leftBottomView) {
        _leftBottomView = [UIImageView new];
        _leftBottomView.image = [UIImage imageNamed:@"nongl"];
    }
    return _leftBottomView;
}

- (UIImageView *)rightView {
    
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"nongr"];
    }
    return _rightView;
}

- (UIButton *)prepareButton {
    
    if (!_prepareButton) {
        _prepareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_prepareButton setImage:[UIImage imageNamed:@"ready"] forState:UIControlStateNormal];
        [_prepareButton addTarget:self action:@selector(prepareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prepareButton;
}

#pragma mark - 准备按钮点击
- (void)prepareButtonClick:(UIButton *)button {
    
    // 播放发牌音效
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playYinXiaoWithFileName:@"card_deal.mp3"];
    });
    
    
    // 暂时选分按钮不能点击
    self.selectView.userInteractionEnabled = NO;
    
    // 显示背面54张
    [self.view addSubview:self.fenView];
    [self.fenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(70);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (NSInteger i = 0; i<54; i++) {
            
            UIImageView *imageView = self.fenView.subviews[i];
            
            [UIView animateWithDuration:1.5 animations:^{
                
                if (i%3 == 0) {
                    
                    imageView.frame = CGRectMake(320, 0, 0, 0);
                } else if (i%3 == 1) {
                    imageView.frame = CGRectMake(0, 100, 0, 0);
                } else {
                    imageView.frame = CGRectMake(-100, 0, 0, 0);
                }
            }];
        }
        
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.selectView.userInteractionEnabled = YES;
        
        // 显示3张底牌
        [self.fenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
#warning 添加diPaiView
        [self.view addSubview:self.diPai3View];
        [self.diPai3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fenView);
        }];
        
//        for (NSInteger i = 0; i<3; i++) {
//            
//            UIImageView *imageView = [UIImageView new];
//            imageView.image = [UIImage imageNamed:@"cbei"];
//            CGFloat imageViewW = _fenView.bounds.size.width - 53 * 4;
//            CGFloat imageViewH = self.fenView.bounds.size.height;
//            CGFloat imageViewX = self.fenView.bounds.size.width * 0.5 - imageViewW * 0.5 - 10 - imageViewW + (imageViewW + 10) * i;
//            CGFloat imageViewY = 0;
//            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//            [self.fenView addSubview:imageView];
//            imageView.tag = i + 100;
//            
//        }
        
        
        
    });
    
    // 改变pang数字
    self.nong1Num = 17;
    self.nong2Num = 17;
    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
    
    // 移除准备按钮
    self.prepareButton.hidden = YES;;
    
    // 添加不叫、一分、三分等按钮
    [self.view addSubview:self.selectView];
    //    self.selectView.backgroundColor = GXFRandomColor;
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(10);
        make.centerY.equalTo(self.view);
        make.width.mas_equalTo(400);
        make.height.mas_equalTo(35);
    }];
    
    
#warning dddddddd
    // 切图
    self.cardArray = [self getImageWithOriginalImageName:@"cardList"];
    GXFLog(@"%zd", self.cardArray.count);
    // 分牌
    
    
    // 产生1-54随机数
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSInteger i = 0; i<54; i++) {
        
        [array1 addObject:@(i)];
    }
    NSMutableArray *array2 = [NSMutableArray array];
    
    while (array2.count != 17) {
        
        NSInteger currentNum = arc4random_uniform(54);
        
        if ([array1 containsObject:@(currentNum)]) {
            // 添加到新数组
            [array2 addObject:@(currentNum)];
            [array1 removeObject:@(currentNum)];
        }
    }
    
        // 对array2进行降序排序
    NSArray *array3 = [self sortDescWithArray:array2];
    NSMutableArray *array = [NSMutableArray arrayWithArray:array3];
    self.array = array;
    
    // 添加paiView
    [self.view addSubview:self.paiView];
    [self.paiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(98);
    }];
    
    
    
    
}

- (void)playYinXiaoWithFileName:(NSString *)fileName {
    
    [[GXFPlayerManager sharePlayerManager] playMusicWithfileName:fileName];
}  

- (NSArray *)sortDescWithArray:(NSArray *)array {
    
    //数组排序
    
    //定义一个数字数组
    
//    NSArray *array = @[@(3),@(4),@(2),@(1)];
    
    //对数组进行排序
    
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        
        return [obj2 compare:obj1]; //降序
        
    }];
    
    return result;
    
}

- (NSArray *)getImageWithOriginalImageName:(NSString *)originalImageName {
    
    UIImage *image = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i< 55; i++) {
        
        // 加载原图
        UIImage *originalImage = [UIImage imageNamed:originalImageName];
         //152 210
        CGFloat imageW = 152;
        CGFloat imageH = 210;
        CGFloat imageX = (i % 11) * imageW;
        CGFloat imageY = (i / 11) * imageH;
        
        CGImageRef cgImage = CGImageCreateWithImageInRect(originalImage.CGImage, CGRectMake(imageX, imageY, imageW, imageH));
        image = [UIImage imageWithCGImage:cgImage];
        
        // 手动释放
        CGImageRelease(cgImage);
        
        if (i == 1) {
            
//            [array insertObject:image atIndex:0];3
            [self saveCard:image withKey:0];
        } else if (i == 2) {
//            [array addObject:image];
//            [array insertObject:image atIndex:1];3
            [self saveCard:image withKey:1];
            
        } else if (i == 13) {
//            array[2] = image;
//            [array insertObject:image atIndex:2];3
            [self saveCard:image withKey:2];
            
        } else if (i == 24) {
//            array[3] = image;
//            [array insertObject:image atIndex:3];3
            [self saveCard:image withKey:3];
        } else if (i == 35) {
//            array[4] = image;
//            [array insertObject:image atIndex:4];4
            [self saveCard:image withKey:4];
        } else if (i == 46) {
//            array[5] = image; // 梅花4
//            [array insertObject:image atIndex:5];4
            [self saveCard:image withKey:5];
        } else if (i == 51) {
//            array[6] = image;
//            [array insertObject:image atIndex:6];4
            [self saveCard:image withKey:6];
        } else if (i == 52) {
//            array[7] = image;
//            [array insertObject:image atIndex:7];4
            [self saveCard:image withKey:7];
        } else if (i == 53) {
//            array[8] = image;
//            [array insertObject:image atIndex:8];5
            [self saveCard:image withKey:8];
        } else if (i == 54) {
//            array[9] = image;
//            [array insertObject:image atIndex:9];5
            [self saveCard:image withKey:9];
        } else if (i == 3) {
//            array[10] = image;
//            [array insertObject:image atIndex:10];5
            [self saveCard:image withKey:10];
        } else if (i == 4) {
//            array[11] = image;
//            [array insertObject:image atIndex:11];5kkkkkkkkkkkkk
            [self saveCard:image withKey:11];
        } else if (i == 5) {
//            array[12] = image;
//            [array insertObject:image atIndex:12];6
            [self saveCard:image withKey:12];
        } else if (i == 6) {
//            array[13] = image;
//            [array insertObject:image atIndex:13];6
            [self saveCard:image withKey:13];
        } else if (i == 7) {
//            array[14] = image;
//            [array insertObject:image atIndex:14];6
            [self saveCard:image withKey:14];
        } else if (i == 8) {
//            array[15] = image;
//            [array insertObject:image atIndex:15];6
            [self saveCard:image withKey:15];
        } else if (i == 9) {
//            array[16] = image;
//            [array insertObject:image atIndex:16];7
            [self saveCard:image withKey:16];
        } else if (i == 10) { // 梅花7
//            array[17] = image;
//            [array insertObject:image atIndex:17];7
            [self saveCard:image withKey:17];
        } else if (i == 11) {
//            array[18] = image;
//            [array insertObject:image atIndex:18];7
            [self saveCard:image withKey:18];
        } else if (i == 12) {
//            array[19] = image;
//            [array insertObject:image atIndex:19];7
            [self saveCard:image withKey:19];
        } else if (i == 14) {
//            array[20] = image; // 梅花4
//            [array insertObject:image atIndex:20];8
            [self saveCard:image withKey:20];
        } else if (i == 15) {
//            array[21] = image;
//            [array insertObject:image atIndex:21];8
            [self saveCard:image withKey:21];
        } else if (i == 16) {
//            array[22] = image;
//            [array insertObject:image atIndex:22];8
            [self saveCard:image withKey:22];
        } else if (i == 17) {
//            array[23] = image;
//            [array insertObject:image atIndex:23];8
            [self saveCard:image withKey:23];
        } else if (i == 18) {
//            array[24] = image;
//            [array insertObject:image atIndex:24];9
            [self saveCard:image withKey:24];
            
        } else if (i == 19) {
//            array[25] = image; // 梅花4
//            [array insertObject:image atIndex:25];9
            [self saveCard:image withKey:25];
        } else if (i == 20) {
//            array[26] = image;
//            [array insertObject:image atIndex:26];9
            [self saveCard:image withKey:26];
        } else if (i == 21) { // 黑桃9
//            array[27] = image;
//            [array insertObject:image atIndex:27];9
            [self saveCard:image withKey:27];
        } else if (i == 22) {
//            array[28] = image;
//            [array insertObject:image atIndex:28];10
            [self saveCard:image withKey:28];
        } else if (i == 23) {
//            array[29] = image;
//            [array insertObject:image atIndex:29];10
            [self saveCard:image withKey:29];
        } else if (i == 25) {
//            array[30] = image; // 梅花4
//            [array insertObject:image atIndex:30];10
            [self saveCard:image withKey:30];
        } else if (i == 26) {
//            array[31] = image;
//            [array insertObject:image atIndex:31];10
            [self saveCard:image withKey:31];
        } else if (i == 27) {
//            array[32] = image;
//            [array insertObject:image atIndex:32];11
            [self saveCard:image withKey:32];
        } else if (i == 28) {
//            array[33] = image;
//            [array insertObject:image atIndex:33];11
            [self saveCard:image withKey:33];
        } else if (i == 29) {
//            array[34] = image;
//            [array insertObject:image atIndex:34];11
            [self saveCard:image withKey:34];
        } else if (i == 30) {
//            array[35] = image; // 梅花4
//            [array insertObject:image atIndex:35];11
            [self saveCard:image withKey:35];
        } else if (i == 31) {
//            array[36] = image;
//            [array insertObject:image atIndex:36];12
            [self saveCard:image withKey:36];
        } else if (i == 32) { // 梅花12
//            array[37] = image;
//            [array insertObject:image atIndex:37];12
            [self saveCard:image withKey:37];
        } else if (i == 33) {
//            array[38] = image;
//            [array insertObject:image atIndex:38];12
            [self saveCard:image withKey:38];
        } else if (i == 34) {
//            array[39] = image;
//            [array insertObject:image atIndex:39];12
            [self saveCard:image withKey:39];
        } else if (i == 36) {
//            array[40] = image; // 梅花4
//            [array insertObject:image atIndex:40];13
            [self saveCard:image withKey:40];
        } else if (i == 37) {
//            array[41] = image;
//            [array insertObject:image atIndex:41];13
            [self saveCard:image withKey:41];
        } else if (i == 38) {
//            array[42] = image;
//            [array insertObject:image atIndex:42];13
            [self saveCard:image withKey:42];
        } else if (i == 39) {
//            array[43] = image;
//            [array insertObject:image atIndex:43];13
            [self saveCard:image withKey:43];
        } else if (i == 40) {
//            array[44] = image;
//            [array insertObject:image atIndex:44];A
            [self saveCard:image withKey:44];
        } else if (i == 41) {
//            array[45] = image; // 梅花4
//            [array insertObject:image atIndex:45];A
            [self saveCard:image withKey:45];
        } else if (i == 42) {
//            array[46] = image;
//            [array insertObject:image atIndex:46];A
            [self saveCard:image withKey:46];
        } else if (i == 43) { // 黑桃A
//            array[47] = image;
//            [array insertObject:image atIndex:47];A
            [self saveCard:image withKey:47];
        } else if (i == 44) {
//            array[48] = image;
//            [array insertObject:image atIndex:48];2
            [self saveCard:image withKey:48];
        } else if (i == 45) {
//            array[49] = image;
//            [array insertObject:image atIndex:49];2
            [self saveCard:image withKey:49];
        } else if (i == 47) {
//            array[50] = image; // 梅花4
//            [array insertObject:image atIndex:50];2
            [self saveCard:image withKey:50];
        } else if (i == 48) {
//            array[51] = image;
//            [array insertObject:image atIndex:51];2
            [self saveCard:image withKey:51];
        } else if (i == 49) {
//            array[52] = image;
//            [array insertObject:image atIndex:52];小
            [self saveCard:image withKey:52];
        } else if (i == 50) {
//            array[53] = image;
//            [array insertObject:image atIndex:53];大
            [self saveCard:image withKey:53];
        }
    }
    
    for (NSInteger i = 0; i<54; i++) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%zd", i]];
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            
            [array addObject:image];
            
        }
        
    }
    
    
    return array;
}

- (UIImageView *)topBgImageView {
    
    if (!_topBgImageView) {
        _topBgImageView = [[UIImageView alloc] init];
        _topBgImageView.image = [UIImage imageNamed:@"top"];
    }
    return _topBgImageView;
}

- (UIImageView *)moneyView {
    
    if (!_moneyView) {
        _moneyView = [[UIImageView alloc] init];
        _moneyView.image = [UIImage imageNamed:@"money"];
    }
    return _moneyView;
}

- (UILabel *)moneyLabel {
    
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor yellowColor];
        // 从本地区分数
        NSInteger updateFenShu = [[NSUserDefaults standardUserDefaults] integerForKey:@"FENSHU"];
        _moneyLabel.text = [NSString stringWithFormat:@"%zd", updateFenShu];
        self.fenShu = updateFenShu;
    }
    return _moneyLabel;
}

- (UIImageView *)levelImageView {
    
    if (!_levelImageView) {
        _levelImageView = [[UIImageView alloc] init];
        _levelImageView.image = [UIImage imageNamed:@"level1"];
    }
    return _levelImageView;
}

- (UIImageView *)levelJindu {
    
    if (!_levelJindu) {
        _levelJindu = [[UIImageView alloc] init];
        _levelJindu.image = [UIImage imageNamed:@"jinduhui"];
        UIImageView *currentLevel = [[UIImageView alloc] init];
        currentLevel.image = [UIImage imageNamed:@"jindu"];
        [_levelJindu addSubview:currentLevel];
        [currentLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_levelJindu);
            make.width.mas_equalTo(20);
        }];
    }
    return _levelJindu;
}

- (UILabel *)diFenLabel {
    // 212 173 60
    if (!_diFenLabel) {
        _diFenLabel = [[UILabel alloc] init];
        _diFenLabel.text = [NSString stringWithFormat:@"底分: %zd", difen];
        _diFenLabel.font = [UIFont systemFontOfSize:14];
        _diFenLabel.textColor = [UIColor colorWithRed:231/255.0 green:186/255.0 blue:43/255.0 alpha:1.0];
    }
    return _diFenLabel;
}

- (UILabel *)beiShuLabel {
    
    if (!_beiShuLabel) {
        _beiShuLabel = [[UILabel alloc] init];
        _beiShuLabel.text = [NSString stringWithFormat:@"倍数: %zd", beishu];
        _beiShuLabel.font = [UIFont systemFontOfSize:14];
        _beiShuLabel.textColor = [UIColor colorWithRed:231/255.0 green:186/255.0 blue:43/255.0 alpha:1.0];
    }
    return _beiShuLabel;
}

- (UIButton *)leftPangButton {
    
    if (!_leftPangButton) {
        _leftPangButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftPangButton setBackgroundImage:[UIImage imageNamed:@"pang"] forState:UIControlStateNormal];
        [_leftPangButton setTitle:@"0" forState:UIControlStateNormal];
        [_leftPangButton setTitleColor:[UIColor colorWithRed:212/255.0 green:173/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    return _leftPangButton;
}

- (UIButton *)rightPangButton {
    
    if (!_rightPangButton) {
        _rightPangButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightPangButton setBackgroundImage:[UIImage imageNamed:@"pang"] forState:UIControlStateNormal];
        [_rightPangButton setTitle:@"0" forState:UIControlStateNormal];
        [_rightPangButton setTitleColor:[UIColor colorWithRed:212/255.0 green:173/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    return _rightPangButton;
}


- (UIView *)selectView {
    
    if (!_selectView) {
        _selectView = [UIView new];
//        _selectView.backgroundColor = GXFRandomColor;
        for (NSInteger i = 0; i<4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"select%zd", i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = GXFRandomColor;
//            CGFloat buttonW = (_selectView.bounds.size.width + 20) / 4;// 60 * 4 - 20
//            CGFloat buttonH = _selectView.bounds.size.height;
//            CGFloat buttonX = i * buttonW + 20;
//            CGFloat buttonY = 0;
//            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            [_selectView addSubview:button];
            button.tag = i;
        }
    }
    return _selectView;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [UIView new];
//        _bottomView.backgroundColor = GXFRandomColor;
        
        // 社区
        UIButton *shequButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shequButton setImage:[UIImage imageNamed:@"shequ"] forState:UIControlStateNormal];
        [shequButton addTarget:self action:@selector(shequButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:shequButton];
        [shequButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_bottomView);
            make.width.mas_equalTo(_bottomView.mas_height);
        }];
        // 记牌器
        UIButton *jipaiqiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [jipaiqiButton setImage:[UIImage imageNamed:@"jipaiqi"] forState:UIControlStateNormal];
        [jipaiqiButton addTarget:self action:@selector(jipaiqiButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:jipaiqiButton];
        [jipaiqiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.left.equalTo(shequButton.mas_right).offset(5);
            make.width.mas_equalTo(_bottomView.mas_height);
        }];
        // 设置
        UIButton *shezhiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shezhiButton setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
        [shezhiButton addTarget:self action:@selector(shezhiButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:shezhiButton];
        [shezhiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_bottomView);
            make.width.mas_equalTo(_bottomView.mas_height);
        }];
        // 商店
        UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shopButton setImage:[UIImage imageNamed:@"shop"] forState:UIControlStateNormal];
        [shopButton addTarget:self action:@selector(shopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:shopButton];
        [shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.right.equalTo(shezhiButton.mas_left).offset(-5);
            make.width.mas_equalTo(_bottomView.mas_height);
        }];
        
    }
    return _bottomView;
}

- (UIView *)fenView {
    
    if (!_fenView) {
        _fenView = [UIView new];
//        _fenView.backgroundColor = GXFRandomColor;
        for (NSInteger i = 0; i<54; i++) {
            
            UIImageView *beiImageView = [UIImageView new];
            beiImageView.image = [UIImage imageNamed:@"cbei"];
            
            
            [_fenView addSubview:beiImageView];
        }
        
    }
    return _fenView;
}

- (SettingView *)settingView {
    
    if (!_settingView) {
        _settingView = [[SettingView alloc] init];
        _settingView.delegate = self;
    }
    return _settingView;
}


- (void)shequButtonClick {
    
    
}

- (void)jipaiqiButtonClick {
    
    
}

- (void)shezhiButtonClick {
    
    // 毛玻璃效果
//    UIToolbar *toolBar = [[UIToolbar alloc] init];
//    toolBar.barStyle = UIBarStyleBlack;
//    [self.view addSubview:toolBar];
//    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.veView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.view addSubview:self.veView];
    [self.veView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 动画弹出
    [self.view addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(250);
    }];
    self.settingView.hidden = NO;
}

- (void)settingView:(SettingView *)settingView didClickBackButton:(UIButton *)backButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shopButtonClick {
    
}

- (void)viewDidLayoutSubviews {
    
    NSInteger i = 0;
    for (UIButton *button in self.selectView.subviews) {
        
        CGFloat buttonW = 92;
        CGFloat buttonH = self.selectView.bounds.size.height;
        CGFloat margin = (self.selectView.bounds.size.width - _selectView.subviews.count * buttonW) / (_selectView.subviews.count + 1);
        CGFloat buttonX = margin + (buttonW + margin) * i;
        CGFloat buttonY = 0;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//        NSLog(@"%@", NSStringFromCGRect(button.frame));
        
        i++;
    }
    
    NSInteger j = 0;
    for (UIImageView *imageView in self.fenView.subviews) {
        CGFloat beiImageX = j * 4;
        CGFloat beiImageY = 0;
        CGFloat beiImageW = _fenView.bounds.size.width - 53 * 4;
        CGFloat beiImageH = _fenView.bounds.size.height;
//        UIImageView *beiImageView = self.fenView.subviews[i];
        imageView.frame = CGRectMake(beiImageX, beiImageY, beiImageW, beiImageH);
        
        j++;
    }
    
    for (NSInteger i = 0; i<3; i++) {
        
        CGFloat imageViewW = _diPai3View.bounds.size.width - 53 * 4;
        CGFloat imageViewH = _diPai3View.bounds.size.height;
        CGFloat imageViewX = _diPai3View.bounds.size.width * 0.5 - imageViewW * 0.5 - 10 - imageViewW + (imageViewW + 10) * i;
        CGFloat imageViewY = 0;
        UIImageView *imageView = self.diPai3View.subviews[i];
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
    
    
    GXFLog(@"%@ %zd", self.fenView.subviews, self.fenView.subviews.count);
    
    
    
}

- (void)selectButtonClick:(UIButton *)button {
    
    if (button.tag == 0
        ) {
        GXFLog(@"不叫");
        
        self.selectView.hidden = YES;
        // 我的不叫音效
        [self qiangDiZhuWhere:@"wo" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
        // 农民1有可能抢，有可能不抢，农民2也是，随机数吧，并且农民1、2都有可能叫1分、2分或者3分
        
        if (bujiao == 1) { // 我点过1分，再点不叫的话，谁大谁是地主
            
            if (nong1fen == 3) {
                [self diZhuWhere:@"nong1"];
                [self qiangDiZhuWhere:@"nong1" imageName:nil fenShu:3 isBigger:YES isSound:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nong1AutoChuWithArray:self.arrayNong1];
                });
            } else if (nong1fen == 2) {
                if (nong2fen <= 2) {
                    [self diZhuWhere:@"nong1"];
                    [self qiangDiZhuWhere:@"nong1" imageName:nil fenShu:3 isBigger:YES isSound:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong1];
                    });
                } else {
                    
                    [self diZhuWhere:@"nong2"];
                    [self qiangDiZhuWhere:@"nong2" imageName:nil fenShu:3 isBigger:YES isSound:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong2];
                    });
                }
            } else if (nong1fen == 0) {
                
                if (nong2fen > 0) {
                    
                    [self diZhuWhere:@"nong2"];
                    [self qiangDiZhuWhere:@"nong2" imageName:nil fenShu:3 isBigger:YES isSound:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong2];
                    });
                } else {
                    
                }
            }
            
        } else { // 没点过不叫，首次点的话，走下面的代码
            
            static NSInteger fenshu = 0;
            static NSInteger fenshu2 = 0;
            NSInteger nong1 = arc4random_uniform(2);
            NSInteger nong2 = arc4random_uniform(2);
            NSInteger nong1Fen = arc4random_uniform(3) + 1;
            NSInteger nong2Fen = arc4random_uniform(3) + 1;
            NSString *imageName;
//            NSInteger fenshu;
            BOOL isBigger = NO;
            if (nong1 == 1) { // 1叫
                if (nong1Fen == 2) {
                    imageName = @"2fen";
                    fenshu = 2;
                } else if (nong1Fen == 3){
                    imageName = @"3fen";
                    fenshu = 3;
                    isBigger = YES;
                } else {
                    imageName = @"1fen";
                    fenshu = 1;
                }
            } else { // 1不叫
                imageName = @"bujiao";
                fenshu = 0;
            }
            
            NSString *imageName2;
//            NSInteger fenshu2;
            BOOL isBigger2 = NO;
            if (nong2 == 1) { // 2叫
                if (nong2Fen == 2) {
                    imageName2 = @"2fen";
                    fenshu2 = 2;
                } else if (nong2Fen == 3){
                    imageName2 = @"3fen";
                    fenshu2 = 3;
                    isBigger2 = YES;
                } else {
                    imageName2 = @"1fen";
                    fenshu2 = 1;
                }
                if (nong1 == 0) { // 1没叫，2叫了
                    isBigger2 = YES;
                }
                
            } else { // 2不叫
                imageName2 = @"bujiao";
                fenshu2 = 0;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self qiangDiZhuWhere:@"nong1" imageName:imageName fenShu:fenshu isBigger:isBigger isSound:YES];
                if (fenshu == 0) { // 1不叫，让2叫
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (fenshu2 > 0) {
                            
                            [self qiangDiZhuWhere:@"nong2" imageName:imageName2 fenShu:fenshu2 isBigger:isBigger2 isSound:YES];
                        } else {
                            [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                        }
                        
                        if (fenshu2 == 0) { // 2不叫，1也没叫
                            [self qiangDiZhuWhere:@"wo" imageName:nil fenShu:1 isBigger:YES isSound:NO];
                            [self diZhuWhere:@"wo"];
                        } else { // 1不叫，2叫了，2是地主
                            [self diZhuWhere:@"nong2"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                // 2自动出牌
                                [self nong1AutoChuWithArray:self.arrayNong2];
                            });
                        }
                    });
                    
                } else if (fenshu == 1) { // 1叫1分，让2叫
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (fenshu2 > 1) {
                            
                            [self qiangDiZhuWhere:@"nong2" imageName:imageName2 fenShu:fenshu2 isBigger:isBigger2 isSound:YES];
                        } else {
                            [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                        }
                        if (fenshu2 == 0) { // 2不叫，1是地主
                            [self qiangDiZhuWhere:@"nong1" imageName:nil fenShu:1 isBigger:YES isSound:NO];
                            [self diZhuWhere:@"nong1"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                // 1自动出牌
                                [self nong1AutoChuWithArray:self.arrayNong1];
                            });
                        } else if (fenshu2 == 1) { // 2也叫1分，1是地主
                            [self qiangDiZhuWhere:@"nong1" imageName:nil fenShu:1 isBigger:YES isSound:NO];
                            [self diZhuWhere:@"nong1"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                // 1自动出牌
                                [self nong1AutoChuWithArray:self.arrayNong1];
                            });
                        } else if (fenshu2 >= 2) { // 2叫2分或3分，2是地主
                            [self diZhuWhere:@"nong2"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                // 1自动出牌
                                [self nong1AutoChuWithArray:self.arrayNong2];
                            });
                        }
                        
                    });
                    
                    
                } else if (fenshu == 2) { // 1叫2分，让2叫
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (fenshu2 > 2) {
                            
                            [self qiangDiZhuWhere:@"nong2" imageName:imageName2 fenShu:fenshu2 isBigger:isBigger2 isSound:YES];
                        } else {
                            [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                        }
                    });
                    if (fenshu2 <= 2) { // 1是地主
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self qiangDiZhuWhere:@"nong1" imageName:nil fenShu:2 isBigger:YES isSound:NO];
                            [self diZhuWhere:@"nong1"];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // 1自动出牌
                            [self nong1AutoChuWithArray:self.arrayNong1];
                        });
                    } else { // 2叫3分，2是地主
                        [self diZhuWhere:@"nong2"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // 1自动出牌
                            [self nong1AutoChuWithArray:self.arrayNong2];
                        });
                    }
                    
                    
                } else { // 1叫3分，
                    [self diZhuWhere:@"nong1"];
                    
                    // 过1s让1自动出牌
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong1];
                    });
                }
            });
            
        }
        
        
    } else if (button.tag == 1) {
        
        bujiao++;
        GXFLog(@"一分");
        // 首先移除selectView
//        [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.selectView.hidden = YES;
        
        // 我的1分音效
        [self qiangDiZhuWhere:@"wo" imageName:@"1fen" fenShu:1 isBigger:NO isSound:YES];
        
        // 农民1有可能抢，有可能不抢，农民2也是，随机数吧，并且农民1、2都有可能叫2分或者3分
        NSInteger nong1 = arc4random_uniform(2);
        NSInteger nong2 = arc4random_uniform(2);
        NSInteger nong1Fen = arc4random_uniform(2) + 2;
        NSInteger nong2Fen = arc4random_uniform(2) + 2;
        if (nong1 == 1) {
            
            nong1fen = nong1Fen;
        } else {
            nong1fen = 0;
        }
        if (nong2 == 1) {
            
            nong2fen = nong2Fen;
        } else {
            nong2fen = 0;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (nong1 == 1) {
                if (nong1Fen == 3) { // 3分
                    
                    [self qiangDiZhuWhere:@"nong1" imageName:@"3fen" fenShu:3 isBigger:YES isSound:YES];
                    [self diZhuWhere:@"nong1"];
                    // 1秒之后让农民1自动出牌
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong1];
                    });
                    return ;
                } else { // 2分
                    
                    [self qiangDiZhuWhere:@"nong1" imageName:@"2fen" fenShu:2 isBigger:NO isSound:YES];
                    
                    // 1秒之后让农民2叫
                    if (nong2 == 1) { // 2叫，只能叫3分
                        if (nong2Fen == 3) {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [self qiangDiZhuWhere:@"nong2" imageName:@"3fen" fenShu:3 isBigger:YES isSound:YES];
                                [self diZhuWhere:@"nong2"];
                            });
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                // 2自动出牌
                                [self nong1AutoChuWithArray:self.arrayNong2];
                            });
                            
                            return ;
                        } else { // 2叫2分不行，只能不叫
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                                
                                // 显示selectView，让我抢地主
                                self.selectView.hidden = NO;
                                
                                // 显示时需要判断哪个按钮不能点，但是这里只可能1、2都不能点
                                for (NSInteger i = 0; i<self.selectView.subviews.count; i++) {
                                    if (i<3 && i>0) {
                                        UIButton *button = self.selectView.subviews[i];
                                        button.selected = YES;
                                        button.userInteractionEnabled = NO;
                                    }
                                }
                            });
                        }
                        
                    } else { // 2不叫
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                            
                            // 显示selectView
                            // 显示selectView，让我抢地主
                            self.selectView.hidden = NO;
                            
                            // 显示时需要判断哪个按钮不能点，但是这里只可能1、2都不能点
                            for (NSInteger i = 0; i<self.selectView.subviews.count; i++) {
                                if (i<3 && i>0) {
                                    UIButton *button = self.selectView.subviews[i];
                                    button.selected = YES;
                                    button.userInteractionEnabled = NO;
                                }
                            }
                        });
                    }
                }
                
                
            } else { // 1不叫
                [self qiangDiZhuWhere:@"nong1" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                
                // 让2叫
                if (nong2 == 1) { // 2叫
                    
                    if (nong2Fen == 3) { // 2叫3分
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self qiangDiZhuWhere:@"nong2" imageName:@"3fen" fenShu:3 isBigger:YES isSound:YES];
                            [self diZhuWhere:@"nong2"];
                        });
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // 2自动出牌
                            [self nong1AutoChuWithArray:self.arrayNong2];
                            
                        });
                    } else { // 2叫2分
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self qiangDiZhuWhere:@"nong2" imageName:@"2fen" fenShu:2 isBigger:NO isSound:YES];
                            
                            // 显示selectVeiw
                            // 显示selectView，让我抢地主
                            self.selectView.hidden = NO;
                            
                            // 显示时需要判断哪个按钮不能点，但是这里只可能1、2都不能点
                            for (NSInteger i = 0; i<self.selectView.subviews.count; i++) {
                                if (i<3 && i>0) {
                                    UIButton *button = self.selectView.subviews[i];
                                    button.selected = YES;
                                    button.userInteractionEnabled = NO;
                                }
                            }
                            
                        });
                        
                    }
                    
                    
                } else { // 2不叫
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                        
                        // 显示selectView
                        // 显示selectView，让我抢地主
                        [self diZhuWhere:@"wo"];
                        [self qiangDiZhuWhere:@"wo" imageName:nil fenShu:1 isBigger:YES isSound:NO];
                        
                    });
                }
            }
        });
        
        if (nong1 == 0 && nong2 == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                [self diZhuWhere:@"wo"];
            });
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 显示selectView，让我抢地主
                self.selectView.hidden = NO;
                
                // 显示时需要判断哪个按钮不能点，但是这里只可能1、2都不能点
                for (NSInteger i = 0; i<self.selectView.subviews.count; i++) {
                    if (i<3 && i>0) {
                        UIButton *button = self.selectView.subviews[i];
                        button.selected = YES;
                        button.userInteractionEnabled = NO;
                    }
                }
                
            });
        }
        
        
    } else if (button.tag == 2) {
        
        // 首先移除selectView
//        [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.selectView.hidden = YES;
        
        GXFLog(@"二分");
        // 我的2分音效
        [self qiangDiZhuWhere:@"wo" imageName:@"2fen" fenShu:2 isBigger:NO isSound:YES];
        
        // 农民1有可能抢，有可能不抢，农民2也是，随机数吧
        NSInteger nong1 = 1;
        NSInteger nong2 = arc4random_uniform(2);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (nong1 == 1) {
                [self qiangDiZhuWhere:@"nong1" imageName:@"3fen" fenShu:3 isBigger:YES isSound:YES];
                [self diZhuWhere:@"nong1"];
                // 1秒之后让农民1自动出牌
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nong1AutoChuWithArray:self.arrayNong1];
                });
                return ;
                
            } else { // 不叫
                [self qiangDiZhuWhere:@"nong1" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
            }
        });
        
        // 走到这里说明农民1不叫
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (nong1 == 1) {
                return ;
            } else {
                if (nong2 == 1) {
                    [self qiangDiZhuWhere:@"nong2" imageName:@"3fen" fenShu:3 isBigger:YES isSound:YES];
                    [self diZhuWhere:@"nong2"];
                    // 1秒之后让农民2自动出牌
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong2];
                    });
                    return ;
                    
                } else { // 不叫
                    [self qiangDiZhuWhere:@"nong2" imageName:@"bujiao" fenShu:0 isBigger:NO isSound:YES];
                }
            }
        });
        
        // 走到这里说明农民2也不叫
        if (nong1 == 0 && nong2 == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (nong2 == 1) {
                    return ;
                } else {
                    
                    [self diZhuWhere:@"wo"];
                }
            });
        }
        
        
    } else {
        
        [self qiangDiZhuWhere:@"wo" imageName:@"3fen" fenShu:3 isBigger:YES isSound:YES];
        
        [self diZhuWhere:@"wo"];
        
    }
    
}

- (void)qiangDiZhuWhere:(NSString *)where imageName:(NSString *)imageName fenShu:(NSInteger)fenShu isBigger:(BOOL)isBigger isSound:(BOOL)isSound {
    
    // 设置叫3分对话框
    [self where:where addDuiHuaWithImageName:imageName isBigger:isBigger];
    
    
    // 播放声音，男女声音通过随机数确定
    if (isSound == YES) {
        
        NSInteger temp = arc4random_uniform(2);
        if (temp == 1) {
            if (fenShu != 0) {
                NSString *string = [NSString stringWithFormat:@"dz_score%zd_M.mp3", fenShu];
                [[GXFPlayerManager sharePlayerManager] playMusicWithfileName:string];
            } else {
                [[GXFPlayerManager sharePlayerManager] playMusicWithfileName:@"dz_bj_M.mp3"];
            }
        } else {
            if (fenShu != 0) {
                NSString *string = [NSString stringWithFormat:@"dz_score%zd_W.mp3", fenShu];
                [[GXFPlayerManager sharePlayerManager] playMusicWithfileName:string];
            } else {
                [[GXFPlayerManager sharePlayerManager] playMusicWithfileName:@"dz_bj_W.mp3"];
            }
        }
    }
    
    
    
    //        GXFLog(@"三分");
    
    // 修改底分
    if (fenShu > difen) {
        difen = fenShu;
    }
    self.diFenLabel.text = [NSString stringWithFormat:@"底分: %zd", difen];
}

// 是地主，叫的有可能是1、2、3分
- (void)diZhuWhere:(NSString *)where{
    
    self.selectView.hidden = NO;
    
    for (NSInteger i = 0; i<self.paiView.subviews.count; i++) {
        GXFButton *button = self.paiView.subviews[i];
        button.userInteractionEnabled = YES;
    }
    
    self.arrayNong1 = [NSMutableArray array];
    self.arrayNong2 = [NSMutableArray array];// 产生1-54随机数
    NSMutableArray *arraySuiji = [NSMutableArray array];
    for (NSInteger i = 0; i<54; i++) {
        
        [arraySuiji addObject:@(i)];
    }
    // 移除随机17个数，再移除底牌3个数
    [arraySuiji removeObjectsInArray:self.array];
    [arraySuiji removeObjectsInArray:self.array2];
    
    while (self.arrayNong1.count != 17) {
        
        NSInteger currentNum = arc4random_uniform(54);
        
        if ([arraySuiji containsObject:@(currentNum)]) {
            // 添加到新数组
            [self.arrayNong1 addObject:@(currentNum)];
            [arraySuiji removeObject:@(currentNum)];
        }
    }
    while (self.arrayNong2.count != 17) {
        
        NSInteger currentNum = arc4random_uniform(54);
        
        if ([arraySuiji containsObject:@(currentNum)]) {
            // 添加到新数组
            [self.arrayNong2 addObject:@(currentNum)];
            [arraySuiji removeObject:@(currentNum)];
        }
    }
    
    self.arrayNong1 = [NSMutableArray arrayWithArray:[self sortDescWithArray:self.arrayNong1]];
    self.arrayNong2 = [NSMutableArray arrayWithArray:[self sortDescWithArray:self.arrayNong2]];
    GXFLog(@"%@ %@", self.arrayNong1, self.arrayNong2);
    
    // 从剩余牌中选择3张
//    [self.cardArray removeObjectsInArray:self.currentCardArray];
    
    // 产生1-54随机数
    NSMutableArray *array1 = [NSMutableArray array];
    for (NSInteger i = 0; i<54; i++) {
        
        [array1 addObject:@(i)];
    }
    self.array2 = [NSMutableArray array];
    
    while (self.array2.count != 3) {
        
        NSInteger currentNum = arc4random_uniform(54);
        
        if ([array1 containsObject:@(currentNum)]) {
            if ([self.array containsObject:@(currentNum)]) {
                continue;
            }
            // 添加到新数组
            [self.array2 addObject:@(currentNum)];
            [array1 removeObject:@(currentNum)];
        }
    }
    
    if ([where isEqualToString:@"wo"]) {
        self.diZhuState = DiZhuWo;
        // array2就是3个随机数
        for (NSInteger i = 0; i<3; i++) {
            
            // 创建3个底牌按钮
            GXFButton *button = [GXFButton new];
            NSInteger num = [self.array2[i] integerValue];
            UIImage *image = self.cardArray[num];
            [button setImage:image forState:UIControlStateNormal];
            
            [self.paiView.currentCardArray addObject:button];
        }
        
        // paiView添加3张并重新布局
        [self.paiView resetMasonryWithThreeNumArray:self.array2];
    } else if ([where isEqualToString:@"nong1"]) {
        self.diZhuState = DiZhuNong1;
        [self.arrayNong1 addObjectsFromArray:self.array2];
    } else if ([where isEqualToString:@"nong2"]) {
        self.diZhuState = DiZhuNong2;
        [self.arrayNong2 addObjectsFromArray:self.array2];
    }
    
    // 底牌旋转并移到顶部
    [self rotateDipaiAndMoveToTop];
    
    // 移除selectView的选分按钮，添加出牌按钮
    [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([where isEqualToString:@"wo"]) {
        [self.selectView addSubview:self.chuButton];
    }
    if (self.chuButton.selected == YES) {
        self.chuButton.userInteractionEnabled = NO;
    }
    // 刷新之前需要移除fenView的子控件，否则所有的子控件重新布局显示出来
    for (UIImageView *imageView in self.fenView.subviews) {
        
        if (imageView.tag == 0) {// 进行了选择后不一定有这步，但是选了3分必然走这里
            
            [imageView removeFromSuperview];
        }
    }
    [self viewDidLayoutSubviews];
    //        [self.chuButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.center.equalTo(self.selectView);
    //
    //        }];
    
    
    // 进行了选择后不一定有这步，但是选了3分必然走这里
    
    
    // 修改头像和剩余的牌数
    if ([where isEqualToString:@"wo"]) {
        
        self.leftBottomView.image = [UIImage imageNamed:@"dil"];
    } else if ([where isEqualToString:@"nong1"]) {
        self.rightView.image = [UIImage imageNamed:@"dil"];
        [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.arrayNong1.count] forState:UIControlStateNormal];
        self.nong1Num = 20;
    } else {
        self.leftTopView.image = [UIImage imageNamed:@"dil"];
        [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.arrayNong2.count] forState:UIControlStateNormal];
        self.nong2Num = 20;
    }
}

- (UIView *)diPai3View {
    
    if (!_diPai3View) {
        _diPai3View = [UIView new];
//        _diPai3View.backgroundColor = GXFRandomColor;
        
        for (NSInteger i = 0; i<3; i++) {
            
            UIImageView *imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:@"cbei"];
            
            [_diPai3View addSubview:imageView];
            imageView.tag = 100 + i;
            
        }
    }
    return _diPai3View;
}

- (UIButton *)chuButton {
    
    if (!_chuButton) {
        _chuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chuButton setImage:[UIImage imageNamed:@"zchupai"] forState:UIControlStateNormal];
        [_chuButton setImage:[UIImage imageNamed:@"chudisable"] forState:UIControlStateSelected];
        [_chuButton addTarget:self action:@selector(chuButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        _chuButton.selected = YES;
    }
    return _chuButton;
}

- (void)chuButtonClcik:(UIButton *)button {
    
    
    // 移除出牌按钮
    [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加出的牌按钮
    NSArray *upArray = self.paiView.upArray;
//    self.upArray = [NSMutableArray arrayWithArray:upArray];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:NO];
    NSArray *array = [NSArray arrayWithObject:descriptor];
    NSArray *descArray = [upArray sortedArrayUsingDescriptors:array];
    NSLog(@"%@", descArray);
    for (NSInteger i = 0; i<descArray.count; i++) {
        
        GXFButton *button = descArray[i];
        [self.selfChuArray addObject:button];
        CGRect rect = button.frame;
        button.frame = CGRectMake(rect.origin.x, rect.origin.y + (self.paiView.frame.origin.y - 15), rect.size.width, rect.size.height);
        [self.view addSubview:button];
        [UIView animateWithDuration:2.0 animations:^{
            
//            button.transform = CGAffineTransformScale(button.transform, 0.7, 0.7);
//            button.transform = CGAffineTransformTranslate(button.transform, 0, -150);
            
            POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim1.delegate = self;
//            anim1.springBounciness = 1.0;
            anim1.springSpeed = 9;
            // CGPointMake(button.center.x - (rect.origin.x - kScreenWidth * 0.5 - i * 20), button.center.y - 50)
            anim1.toValue = [NSValue valueWithCGRect:CGRectMake(rect.origin.x - (rect.origin.x - kScreenWidth * 0.5 - i * 20), button.center.y - 100, rect.size.width * 0.7, rect.size.height * 0.7)];
            [button pop_addAnimation:anim1 forKey:nil];
            self.selfAnimation = anim1;
            
//            POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//            anim2.springBounciness = 1.0;
//            anim2.springSpeed = 10.0;
//            anim2.toValue = [NSValue valueWithCGPoint:CGPointMake(button.center.x - (rect.origin.x - kScreenWidth * 0.5 - i * 20), button.center.y - 50)];
//            [button pop_addAnimation:anim2 forKey:nil];
        }];
    }
    
    // 让paiView发出音效
    [self.paiView chuPaiSoundWithArray:self.paiView.upArray];
    
    // 出牌按钮状态
    self.chuButton.selected = YES;
    if (self.chuButton.selected == YES) {
        self.chuButton.userInteractionEnabled = NO;
    }
    // 让paiView移动牌到桌面
    [self.paiView movePaiToDeskTop];
    
    
    GXFLog(@"xxxx");
    
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    // 出牌完毕加载音效
    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
    
    // 移除农民1的出牌
    if (self.nong1ChuArray.count > 0) {
        
        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
            
            GXFButton *button = self.nong1ChuArray[i];
            [button removeFromSuperview];
        }
        self.nong1ChuArray = nil;
        
    }
    
    // 让下一个开始计时
    if (anim == self.selfAnimation) {
        
        [self.jishiView removeFromSuperview];
        [self.view addSubview:self.jishiView];
        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightPangButton.mas_left).offset(-5);
            make.centerY.equalTo(self.rightPangButton);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(21);
        }];
        // 动画完毕，下一个跟牌
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.paiView.subviews.count == 0) {
                [self loadVictory];
                
            } else {
                if (self.paiView.subviews.count == 2) {
                    [self ShengYinXiaoWithNum:2];
                } else if (self.paiView.subviews.count == 1) {
                    [self ShengYinXiaoWithNum:1];
                }
                
                if (self.diZhuState == DiZhuWo) {
                    
                    [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
                } else if (self.diZhuState == DiZhuNong1) {
                    [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
                } else {
                    [self nong1BuYao];
                }
                
            }
            
        });
        
    } else if (anim == self.nong1Animation) {
        
        
    }
    
}

- (void)genPaiWithArray:(NSMutableArray *)array foreNum:(NSInteger)foreNum {
    
    // 单张
    // 我出的牌按钮
    // 如果点的是提示，则button不对
    if ([array isEqualToArray:self.nong1ChuArray]) {
        // 如果我出了牌，并且2是地主，只有这种情况1不要压
        if (self.diZhuState == DiZhuNong2 && self.selfChuArray.count > 0) {
            
            [self nong1BuYao];
            return;
        }
    }
    GXFButton *button;
    if (self.selfChuArray.count > 0) {
        button = self.selfChuArray[0];
        self.upArray = self.selfChuArray;
    } else {
        if (self.nong2ChuArray.count > 0) {
            
            button = self.nong2ChuArray[0];
            self.upArray = self.nong2ChuArray;
        } else if (self.nong1ChuArray.count > 0) {
            button = self.nong1ChuArray[0];
            self.upArray = self.nong1ChuArray;
        } else {
            
            
        }
    }
    
    if ([array isEqualToArray:self.arrayNong1]) {
        
        GXFLog(@"xxxx");
        
    } else {
        // 点提示，这里需要判断跟农民1还是农民2，还是他们都没压
//        if (self.nong1ChuArray.count > 0) {
//            
//            button = self.nong2ChuArray[0];
//        } else if (self.nong2ChuArray.count == 0) {
//            if (self.nong1ChuArray.count != 0) { // 跟农民1，但是三带一需要取出三张一样的牌
//                button = self.nong1ChuArray[0];
//            } else if (self.nong2ChuArray.count == 0) { // 他们俩都没压
//                // 这时只需要显示出牌按钮，隐藏不出、提示按钮
//                [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//                [self.selectView addSubview:self.chuButton];
//            }
//        }
        
        if (self.nong2ChuArray.count == 0) {
            if (self.nong1ChuArray.count == 0) { // 他们都没压
                // 这时只需要显示出牌按钮，隐藏不出、提示按钮
                [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.selectView addSubview:self.chuButton];
                if (self.chuButton.selected == YES) {
                    self.chuButton.userInteractionEnabled = NO;
                }
            } else { // 压农民1
                if (self.nong1ChuArray.count == 4) {
                    // 找到我出的牌中三张一样大的牌
                    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:NO];
                    NSArray *arraytemp = [NSArray arrayWithObject:descriptor];
                    NSArray *descArray = [self.nong1ChuArray sortedArrayUsingDescriptors:arraytemp];
//                    NSInteger ThreeButtonTag;
                    if (descArray[0] == descArray[1]) { // 第一个就是三张一样的牌，button不变
                        button = descArray[0];
                        
                    } else { // 第二个是三张一样的牌
                        
                        button = descArray[1];
                    }
                } else if (self.nong1ChuArray.count < 4) {
                    button = self.nong1ChuArray[0];
                } else if (self.nong1ChuArray.count == 5) {
                    
                }
                
            }
        } else { // 压农民2
            if (self.nong2ChuArray.count == 4) {
                // 找到我出的牌中三张一样大的牌
                NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:NO];
                NSArray *arraytemp = [NSArray arrayWithObject:descriptor];
                NSArray *descArray = [self.nong2ChuArray sortedArrayUsingDescriptors:arraytemp];
                //                    NSInteger ThreeButtonTag;
                if (descArray[0] == descArray[1]) { // 第一个就是三张一样的牌，button不变
                    button = descArray[0];
                    
                } else { // 第二个是三张一样的牌
                    
                    button = descArray[1];
                }
            } else if (self.nong2ChuArray.count < 4) {
                button = self.nong2ChuArray[0];
            } else if (self.nong2ChuArray.count == 5) {
                
            }
        }
    }
    if (self.upArray.count == 1) {
        
        // 遍历农民1
        for (NSInteger i = array.count - 1; i>=0; i--) {
            NSInteger num = [array[i] integerValue];
            NSInteger next;
            NSInteger shang;
            if (i != 0) {
                
                next = [array[i-1] integerValue];
            } else {
                // num已是最大，
                next = -999;
            }
            if (i!=array.count-1) {
                shang = [array[i+1] integerValue];
            } else {
                shang = -1111;
            }
//            next = [self.arrayNong1[i-1] integerValue];
            
            GXFLog(@"%zd %zd", num, next);
            if (num > button.tag) {
                
                // 看看是否是单张，如果是单张就出吧
                if (num < 4) {
                    
                    // 3，不可能3压3
                    
                } else if (num >= 4 && num <= 7) {
                    
                    // 4
                    if ((next >= 4 && next <= 7) || (shang >= 4 && shang <= 7)) { // 是对，不能出，进行下一个遍历
                        continue;
                        
                    } else { // 单张，可以跟
                        
                        // 但是要判断是否和我出的牌一样大
                        if (button.tag < 4) { // 我出的是3
                            
                            // 根据num创建出牌按钮
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            button.tag = num;
                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            [self.view addSubview:button];
                            
                            
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 农民1跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                
                                // 改变旁的数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                [self.nong1ChuArray addObject:button];
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    CGRect rect = button.frame;
                                    button.frame = CGRectMake(rect.origin.x - 50, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                    
#warning 用于农民2压
                                    self.foreNum = num;
#warning 如果是提示，再次touchesBegin的话，num就没有了，所以需要在touchesBegain中添加num
                                    [array removeObject:@(num)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            } else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            
//                            break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                            
                        } else if (button.tag >= 4 && button.tag <= 7) { // 我出的也是4
                            continue;
                        }
                    }
                    
                } else if (num >= 8 && num <= 11) {
                    
                    // 5
                    if ((next >= 8 && next <= 11) || (shang >= 8 && shang <= 11)) { // 是对，不能出，进行下一个遍历
                        continue;
                        
                    } else { // 单张，可以跟
                        
                        // 判断和我出的牌是否一样大
                        if (button.tag >= 8 && button.tag <= 11) { // 我出的也是5
                            continue;
                        } else {
                            
                            // 根据num创建出牌按钮
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            button.tag = num;
                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            [self.view addSubview:button];
                            
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 农民1跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                
                                // 改变pang数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                [self.nong1ChuArray addObject:button];;
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    CGRect rect = button.frame;
                                    button.frame = CGRectMake(rect.origin.x - 50, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            } else { // 我点提示
                                
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.upArray addObject:@(num)];
                                [self.paiView upTishiPai];
                            }
                            
                            self.upArray = self.nong1ChuArray;
//                            break;
                            
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                        }
                        
                    }
                    
                } else if (num >= 52) {
                    
                    // 直接出
                    // 根据num创建出牌按钮
                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                    button.tag = num;
                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                    [self.view addSubview:button];
                    if ([array isEqualToArray:self.arrayNong1]) {
                        
                        // 农民1跟牌音效
                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                        [self playYinXiaoWithFileName:name];
                        
                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                        [self.nong1ChuArray addObject:button];
                        
                        // 动画到桌面
                        [UIView animateWithDuration:0.8 animations:^{
                            
                            // 改变pang数字
                            self.nong1Num -= self.nong1ChuArray.count;
                            [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                            
                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                            CGRect rect = button.frame;
                            button.frame = CGRectMake(rect.origin.x - 50, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                            
                            self.foreNum = num;
                            [array removeObject:@(num)];
                            
                        } completion:^(BOOL finished) {
                            
                            // 计时器移到农民2
                            [self.jishiView removeFromSuperview];
                            [self.view addSubview:self.jishiView];
                            [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                make.centerY.equalTo(self.rightPangButton);
                                make.width.mas_equalTo(20);
                                make.height.mas_equalTo(21);
                            }];
                            
                            // 隐藏农民2的出牌
                            if (self.nong2ChuArray.count > 0) {
                                
                                [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                self.nong2ChuArray = nil;
                            }
                            
                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                            
                            // 等1s让农民2跟牌
                            if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                });
                            } else if (self.diZhuState == DiZhuWo) {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self nong2BuYao];
                                });
                            }
                        }];
                    } else { // 点提示
                        [self.paiView.upArray removeAllObjects];
                        [self.paiView.tiShiNumArray addObject:@(num)];
                        [self.paiView upTishiPai];
                    }
                    self.upArray = self.nong1ChuArray;
//                    break;
                    if (self.nong1Num < 0) {
                        [self loadFail];
                    } else if (self.nong1Num == 2) {
                        [self ShengYinXiaoWithNum:2];
                    } else if (self.nong1Num == 1) {
                        [self ShengYinXiaoWithNum:1];
                    }
                    
                    return;
                    
                } else {
                    if (num >= 48 && num <= 51) { // 2，直接用2压
                        if (button.tag /4 + 3 != num / 4 + 3) {
                            
                            // 根据num创建出牌按钮
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            button.tag = shang;
                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            [self.view addSubview:button];
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 农民1跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                
                                button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                [self.nong1ChuArray addObject:button];;
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    CGRect rect = button.frame;
                                    button.frame = CGRectMake(rect.origin.x - 50, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            } else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            //                            break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            
                            return;
                        }
                        
                    } else {
                        if ((next / 4 + 3 == num / 4 + 3) || (shang / 4 + 3 == num / 4 + 3)) { // 是对，不能出，进行下一个遍历
                            continue;
                            
                        } else { // 单张，可以跟
                            
                            if (button.tag / 4 + 3 == num /4 + 3) {
                                continue;
                            } else {
                                
                                // 根据num创建出牌按钮
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                button.tag = num;
                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                [self.view addSubview:button];
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 农民1跟牌音效
                                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                    [self playYinXiaoWithFileName:name];
                                    
                                    button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong1ChuArray addObject:button];;
                                    
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        // 改变pang数字
                                        self.nong1Num -= self.nong1ChuArray.count;
                                        [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x - 50, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                        
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView upTishiPai];
                                }
                                self.upArray = self.nong1ChuArray;
                                //                            break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                
                                return;
                            }
                        }
                    }
                    
                    // i / 4 + 3;
                    
                }
            }
        }
        if ([array isEqualToArray:self.arrayNong1]) {
            
            [self nong1BuYao];
        } else { // 提示，没有可以出的
            // 设置不要音效
            NSInteger num = arc4random_uniform(4);
            // card_pass_M_0.mp3
            
            NSString *buyao;
            if (num == 4) {
                buyao = @"card_pass_M.mp3";
            } else {
                buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
            }
            
            // 添加不要对话框
            [self where:@"wo" addDuiHuaWithImageName:@"buchu" isBigger:NO];
            
            [self playYinXiaoWithFileName:buyao];
            [self chuButtonClcik:nil];
            
            if (self.nong2ChuArray.count > 0) {
                
                if (self.diZhuState == DiZhuNong2) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
                    });
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1BuYao];
                    });
                }
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nong1AutoChuWithArray:self.arrayNong1];
                });
            }
            
            
            [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.nong1ChuArray = nil;
            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.nong2ChuArray = nil;
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.nong2ChuArray.count > 0) { // 农民2出了，我不压，农民1也别压
//                    
//                    [self nong1BuYao];
//                    
//                    [self nong1AutoChuWithArray:self.arrayNong2];
//                    
//                } else { // 农民1出了，农民2没出，我也没压
//                    [self nong1AutoChuWithArray:self.arrayNong1];
//                }
//            });
        }
        
#pragma mark - 2张
    } else if (self.upArray.count == 2) {
        
        GXFLog(@"%@", self.arrayNong1);
        
        // 遍历农民1
        // 如果next = -1， num最大，如果three = -1，next最大
        for (NSInteger i = array.count - 1; i>=0; i--) {
            NSInteger num = [array[i] integerValue];
            NSInteger next;
            NSInteger three = 0;
            if (i != 0) {
                
                next = [array[i-1] integerValue];
            } else {
                // num已是最大
                next = -888;
                
            }
            //            next = [self.arrayNong1[i-1] integerValue];
            
            if (i>=2) {
                three = [array[i-2] integerValue];
            } else {
//                if (next == -1) {
//                    // num是最大
//                    three = 777;
//                } else {
//                    // next是最大
//                    three = 777;
//                }
                
                three = -777;
            }
            
            GXFLog(@"%zd %zd", num, next);
            if (num > button.tag) {
                
                // 看看是否是单张，如果是单张就出吧
                if (num < 4) {
                    
                    // 3，不可能3压3
                    
                } else if (num >= 4 && num <= 7) {
                    
                    // 4
                    if (next >= 4 && next <= 7) { // 是对，可以出，但是需要注意是不是三个一样的牌，三带一
                        if (three >= 4 && three <= 7) { // 是三带一，不能出
                            continue;
                        } else {
                            
                            // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            if (button.tag < 4) { // 我出的是对3，可以压
                                
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<2; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                        [self.nong1ChuArray addObject:button];
                                    }
                                    
                                }
                                
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 农民1跟牌音效
                                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                    [self playYinXiaoWithFileName:name];
                                    
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        // 改变pang数字
                                        self.nong1Num -= self.nong1ChuArray.count;
                                        [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                            
                                            GXFButton *button = self.nong1ChuArray[i];
                                            CGRect rect = button.frame;
                                            button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                            
                                        }
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView.tiShiNumArray addObject:@(next)];
                                    [self.paiView upTishiPai];
                                }
                                self.upArray = self.nong1ChuArray;
//                                break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                return;
                                
                            } else {
                                
                                continue;
                            }
                            
                        }
                        
                    } else { // 单张，压不起
                        continue;
                    }
                    
                } else if (num >= 8 && num <= 11) {
                    
                    // 5
                    if (next >= 8 && next <= 11) { // 是对，可以出，但是需要判断是否是三带一
                        if (three >= 4 && three <= 7) { // 是三带一，不能出
                            continue;
                        } else { // 只有两张牌，可以出，但是需要判断是否和我出的牌一样大
                            
                            // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            if (button.tag < 4) { // 我出的是对3，可以压
                                
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<2; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 农民1跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                        [self.nong1ChuArray addObject:button];
                                    }
                                    
                                }
                                
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                            
                                            GXFButton *button = self.nong1ChuArray[i];
                                            CGRect rect = button.frame;
                                            button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                            
                                        }
                                        
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView.tiShiNumArray addObject:@(next)];
                                    [self.paiView upTishiPai];
                                }
                                
                                self.upArray = self.nong1ChuArray;
//                                break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                return;
                                
                            } else {
                                
                                continue;
                            }
                        }
                        
                    } else { // 单张，不可以压
                        
                        continue;
                    }
                    
                } else if (num >= 52) {
                    
                    // 只有两张王可以压
                    if (next >= 52) { // 火箭
                        
                        
                        for (NSInteger i = 0; i<2; i++) {
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            if (i == 0) {
                                
                                button.tag = next;
                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                            } else {
                                button.tag = num;
                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            }
                            [self.view addSubview:button];
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 农民1跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                
                                button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                [self.nong1ChuArray addObject:button];
                            }
                        }
                        
                        if ([array isEqualToArray:self.arrayNong1]) {
                            
                            // 改变pang数字
                            self.nong1Num -= self.nong1ChuArray.count;
                            [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                            
                            // 动画到桌面
                            [UIView animateWithDuration:0.8 animations:^{
                                
                                //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                    
                                    GXFButton *button = self.nong1ChuArray[i];
                                    CGRect rect = button.frame;
                                    button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                }
                                
                                self.foreNum = num;
                                [array removeObject:@(num)];
                                [array removeObject:@(next)];
                                
                            } completion:^(BOOL finished) {
                                
                                // 计时器移到农民2
                                [self.jishiView removeFromSuperview];
                                [self.view addSubview:self.jishiView];
                                [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                    make.centerY.equalTo(self.rightPangButton);
                                    make.width.mas_equalTo(20);
                                    make.height.mas_equalTo(21);
                                }];
                                
                                // 隐藏农民2的出牌
                                if (self.nong2ChuArray.count > 0) {
                                    
                                    [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                    self.nong2ChuArray = nil;
                                }
                                [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                
                                // 等1s让农民2跟牌
                                if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        
                                        [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                    });
                                } else if (self.diZhuState == DiZhuWo) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self nong2BuYao];
                                    });
                                }
                            }];
                        } else { // 点提示
                            [self.paiView.upArray removeAllObjects];
                            [self.paiView.tiShiNumArray addObject:@(num)];
                            [self.paiView.tiShiNumArray addObject:@(next)];
                            [self.paiView upTishiPai];
                        }
                        
                        self.upArray = self.nong1ChuArray;
//                        break;
                        if (self.nong1Num < 0) {
                            [self loadFail];
                        } else if (self.nong1Num == 2) {
                            [self ShengYinXiaoWithNum:2];
                        } else if (self.nong1Num == 1) {
                            [self ShengYinXiaoWithNum:1];
                        }
                        return;
                        
                    } else {
                        continue;
                    }
                    
                } else {
                    
                    // i / 4 + 3;
                    if (next / 4 + 3 == num / 4 + 3) { // 是对，可以出，但是需要判断是否是三带一
                        if (three / 4 + 3 == num / 4 + 3) { // 是三带一，不能出
                            continue;
                        } else { // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            if (num/4+3 != button.tag/4+3) { // 可以压
                                
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<2; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 农民1跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                        [self.nong1ChuArray addObject:button];
                                    }
                                    
                                }
                                
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                            
                                            GXFButton *button = self.nong1ChuArray[i];
                                            CGRect rect = button.frame;
                                            button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                            
                                        }
                                        
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView.tiShiNumArray addObject:@(next)];
                                    [self.paiView upTishiPai];
                                }
                                self.upArray = self.nong1ChuArray;
//                                break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                return;
                                
                            } else {
                                continue;
                            }
                        }
                        
                    } else { // 是单，压不起
                        continue;
                        
                    }
                }
            }
        }
        if ([array isEqualToArray:self.arrayNong1]) {
            [self nong1BuYao];
        } else {
            
            // 设置不要音效
            NSInteger num = arc4random_uniform(4);
            // card_pass_M_0.mp3
            
            NSString *buyao;
            if (num == 4) {
                buyao = @"card_pass_M.mp3";
            } else {
                buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
            }
            [self playYinXiaoWithFileName:buyao];
            
            // 添加不要对话框
            [self where:@"wo" addDuiHuaWithImageName:@"buchu" isBigger:NO];
            
            [self chuButtonClcik:nil];
            
            if (self.nong2ChuArray.count > 0) {
                
                if (self.diZhuState == DiZhuNong2) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
                    });
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1BuYao];
                    });
                }
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nong1AutoChuWithArray:self.arrayNong1];
                });
            }
            
            
            [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.nong1ChuArray = nil;
            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.nong2ChuArray = nil;
            //
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.nong2ChuArray.count > 0) { // 农民2出了，我不压，农民1也别压
//                    
//                    [self nong1BuYao];
//                    
//                    [self nong1AutoChuWithArray:self.arrayNong2];
//                    
//                } else { // 农民1出了，农民2没出，我也没压
//                    [self nong1AutoChuWithArray:self.arrayNong1];
//                }
//            });
        }
        
#pragma mark - 3张
    } else if (self.upArray.count == 3) {
        
        GXFLog(@"%@", self.arrayNong1);
        
        // 遍历农民1
        // 如果next = -1， num最大，如果three = -1，next最大
        for (NSInteger i = array.count - 1; i>=0; i--) {
            NSInteger num = [array[i] integerValue];
            NSInteger next;
            NSInteger three = 0;
            NSInteger forth = 0;
            if (i != 0) {
                
                next = [array[i-1] integerValue];
            } else {
                // num已是最大
                next = -888;
                
            }
            //            next = [self.arrayNong1[i-1] integerValue];
            
            if (i>=2) {
                three = [array[i-2] integerValue];
            } else {
                //                if (next == -1) {
                //                    // num是最大
                //                    three = 777;
                //                } else {
                //                    // next是最大
                //                    three = 777;
                //                }
                
                three = -777;
            }
            
            if (i>=3) {
                forth = [array[i-3] integerValue];
            } else {
                forth = -222;
            }
            
            GXFLog(@"%zd %zd", num, next);
            if (num > button.tag) {
                
                // 看看是否是单张，如果是单张就出吧
                if (num < 4) {
                    
                    // 3，不可能3压3
                    
                } else if (num >= 4 && num <= 7) {
                    
                    // 4
                    if (next >= 4 && next <= 7) { // 是对，可以出，但是需要注意是不是三个一样的牌，三带一
                        if (three >= 4 && three <= 7) { // 是三张，可以出，但是要判断是不是炸，是炸就不压
                            if (forth >= 4 && forth <= 7) { // 是炸，不压
                                continue;
                            } else { // 是三张，也不是炸，可以压，这时不需要判断与我出的牌是否一样大，肯定比我出的牌要大
                                
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 农民1跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                        [self.nong1ChuArray addObject:button];
                                    }
                                    
                                }
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                            
                                            GXFButton *button = self.nong1ChuArray[i];
                                            CGRect rect = button.frame;
                                            button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                            
                                        }
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView.tiShiNumArray addObject:@(next)];
                                    [self.paiView.tiShiNumArray addObject:@(three)];
                                    [self.paiView upTishiPai];
                                }
                                self.upArray = self.nong1ChuArray;
                                //                                break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                return;
                                
                            }
                        } else { // 不是三张，继续遍历
                            
                            continue;
                        }
                        
                    } else { // 不是对，继续遍历
                        
                        continue;
                    }
                    
                } else if (num >= 8 && num <= 11) {
                    
                    // 5
                    if (next >= 8 && next <= 11) { // 是对
                        if (three >= 4 && three <= 7) { // 是三张，但需要判断是否是炸，是炸就不压
                            if (forth >= 4 && forth <= 7) { // 是炸，不压
                                continue;
                            } else { // 是三张，也不是炸，可以压，同样不用判断与我出的牌是否一样大
                                
                                
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 农民1跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                        [self.nong1ChuArray addObject:button];
                                        
                                    }
                                    
                                }
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                            
                                            GXFButton *button = self.nong1ChuArray[i];
                                            CGRect rect = button.frame;
                                            button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                            
                                        }
                                        
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        [array removeObject:@(three)];
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView.tiShiNumArray addObject:@(next)];
                                    [self.paiView.tiShiNumArray addObject:@(three)];
                                    [self.paiView upTishiPai];
                                }
                                self.upArray = self.nong1ChuArray;
                                //                                break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                return;
                                
                            }
                            
                            
                        } else { // 不是三张，继续遍历
                            
                            continue;
                        }
                        
                    } else { // 不是对，继续遍历
                        
                        continue;
                    }
                    
                } else if (num >= 52) {
                    
                    // 只有两张王可以压
                    if (next >= 52) { // 火箭
                        
                        
                        for (NSInteger i = 0; i<2; i++) {
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            if (i == 0) {
                                
                                button.tag = next;
                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                            } else {
                                button.tag = num;
                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            }
                            [self.view addSubview:button];
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                [self.nong1ChuArray addObject:button];
                            }
                        }
                        if ([array isEqualToArray:self.arrayNong1]) {
                            
                            // 农民1跟牌音效
                            NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                            [self playYinXiaoWithFileName:name];
                            // 改变pang数字
                            self.nong1Num -= self.nong1ChuArray.count;
                            [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                            
                            // 动画到桌面
                            [UIView animateWithDuration:0.8 animations:^{
                                
                                //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                    
                                    GXFButton *button = self.nong1ChuArray[i];
                                    CGRect rect = button.frame;
                                    button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                }
                                
                                self.foreNum = num;
                                [array removeObject:@(num)];
                                [array removeObject:@(next)];
                                
                            } completion:^(BOOL finished) {
                                
                                // 计时器移到农民2
                                [self.jishiView removeFromSuperview];
                                [self.view addSubview:self.jishiView];
                                [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                    make.centerY.equalTo(self.rightPangButton);
                                    make.width.mas_equalTo(20);
                                    make.height.mas_equalTo(21);
                                }];
                                
                                // 隐藏农民2的出牌
                                if (self.nong2ChuArray.count > 0) {
                                    
                                    [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                    self.nong2ChuArray = nil;
                                }
                                [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                
                                // 等1s让农民2跟牌
                                if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        
                                        [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                    });
                                } else if (self.diZhuState == DiZhuWo) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self nong2BuYao];
                                    });
                                }
                            }];
                        } else { // 点提示
                            [self.paiView.upArray removeAllObjects];
                            [self.paiView.tiShiNumArray addObject:@(num)];
                            [self.paiView.tiShiNumArray addObject:@(next)];
                            [self.paiView upTishiPai];
                        }
                        self.upArray = self.nong1ChuArray;
                        //                        break;
                        if (self.nong1Num < 0) {
                            [self loadFail];
                        } else if (self.nong1Num == 2) {
                            [self ShengYinXiaoWithNum:2];
                        } else if (self.nong1Num == 1) {
                            [self ShengYinXiaoWithNum:1];
                        }
                        return;
                        
                    } else {
                        continue;
                    }
                    
                } else {
                    
                    // i / 4 + 3;
                    if (next / 4 + 3 == num / 4 + 3) { // 是对
                        if (three / 4 + 3 == num / 4 + 3) { // 是三张，可以出，但需要判断是否是炸，是炸不压
                            if (forth / 4 + 3 == num / 4 + 3) { // 是炸，不压
                                continue;
                            } else { // 是三张，也不是炸，可以压
                                
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 农民1跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                        [self.nong1ChuArray addObject:button];
                                    }
                                    
                                }
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 改变pang数字
                                    self.nong1Num -= self.nong1ChuArray.count;
                                    [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                    
                                    // 动画到桌面
                                    [UIView animateWithDuration:0.8 animations:^{
                                        
                                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                        for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                            
                                            GXFButton *button = self.nong1ChuArray[i];
                                            CGRect rect = button.frame;
                                            button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                            
                                        }
                                        
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        [array removeObject:@(three)];
                                        
                                    } completion:^(BOOL finished) {
                                        
                                        // 计时器移到农民2
                                        [self.jishiView removeFromSuperview];
                                        [self.view addSubview:self.jishiView];
                                        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                            make.centerY.equalTo(self.rightPangButton);
                                            make.width.mas_equalTo(20);
                                            make.height.mas_equalTo(21);
                                        }];
                                        
                                        // 隐藏农民2的出牌
                                        if (self.nong2ChuArray.count > 0) {
                                            
                                            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                            self.nong2ChuArray = nil;
                                        }
                                        
                                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                        
                                        // 等1s让农民2跟牌
                                        if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                            });
                                        } else if (self.diZhuState == DiZhuWo) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self nong2BuYao];
                                            });
                                        }
                                    }];
                                } else { // 点提示
                                    [self.paiView.upArray removeAllObjects];
                                    [self.paiView.tiShiNumArray addObject:@(num)];
                                    [self.paiView.tiShiNumArray addObject:@(next)];
                                    [self.paiView.tiShiNumArray addObject:@(three)];
                                    [self.paiView upTishiPai];
                                }
                                self.upArray = self.nong1ChuArray;
                                //                                break;
                                if (self.nong1Num < 0) {
                                    [self loadFail];
                                } else if (self.nong1Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong1Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                                return;
                            }
                            
                        } else { // 只有两张，压不起
                            
                            continue;
                        }
                        
                    } else { // 是单张，压不起
                        continue;
                        
                    }
                }
            }
        }
        
        if ([array isEqualToArray:self.arrayNong1]) {
            [self nong1BuYao];
        } else {
            
            // 设置不要音效
            NSInteger num = arc4random_uniform(4);
            // card_pass_M_0.mp3
            
            NSString *buyao;
            if (num == 4) {
                buyao = @"card_pass_M.mp3";
            } else {
                buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
            }
            [self playYinXiaoWithFileName:buyao];
            
            // 添加不要对话框
            [self where:@"wo" addDuiHuaWithImageName:@"buchu" isBigger:NO];
            
            [self chuButtonClcik:nil];
            
            if (self.nong2ChuArray.count > 0) {
                
                if (self.diZhuState == DiZhuNong2) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
                    });
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1BuYao];
                    });
                }
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nong1AutoChuWithArray:self.arrayNong1];
                });
            }
            
            [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.nong1ChuArray = nil;
            [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.nong2ChuArray = nil;
            //
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.nong2ChuArray.count > 0) { // 农民2出了，我不压，农民1也别压
//                    
//                    [self nong1BuYao];
//                    
//                    [self nong1AutoChuWithArray:self.arrayNong2];
//                    
//                } else { // 农民1出了，农民2没出，我也没压
//                    [self nong1AutoChuWithArray:self.arrayNong1];
//                }
//            });
        }
        
#pragma mark - 4张
    } else if (self.upArray.count == 4) { // 可能是三带一，也可能是炸
        // 这时就不能取出upArray的第一个GXFButton来比较了，需要判断是炸还是三带一，即判断4张牌是否一样大
        // upArray是GXFButton数组，不能排序
//        if ([array isEqualToArray:self.arrayNong1]) {
//            
//        } else {
//            // 点提示，这里需要判断跟农民1还是农民2，还是他们都没压
//            
//            if (self.nong2ChuArray.count == 0) {
//                if (self.nong1ChuArray.count == 0) { // 他们都没压
//                    // 这时只需要显示出牌按钮，隐藏不出、提示按钮
//                    [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//                    [self.selectView addSubview:self.chuButton];
//                } else { // 压农民1
//                    if (self.nong1ChuArray.count == 4) {
//                        // 找到我出的牌中三张一样大的牌
//                        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:NO];
//                        NSArray *array = [NSArray arrayWithObject:descriptor];
//                        NSArray *descArray = [self.nong1ChuArray sortedArrayUsingDescriptors:array];
//                        //                    NSInteger ThreeButtonTag;
//                        if (descArray[0] == descArray[1]) { // 第一个就是三张一样的牌，button不变
//                            button = descArray[0];
//                            
//                        } else { // 第二个是三张一样的牌
//                            
//                            button = descArray[1];
//                        }
//                    } else if (self.nong1ChuArray.count < 4) {
//                        button = self.nong1ChuArray[0];
//                    } else if (self.nong1ChuArray.count == 5) {
//                        
//                    }
//                    
//                }
//            } else { // 压农民2
//                if (self.nong2ChuArray.count == 4) {
//                    // 找到我出的牌中三张一样大的牌
//                    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:NO];
//                    NSArray *array = [NSArray arrayWithObject:descriptor];
//                    NSArray *descArray = [self.nong2ChuArray sortedArrayUsingDescriptors:array];
//                    //                    NSInteger ThreeButtonTag;
//                    if (descArray[0] == descArray[1]) { // 第一个就是三张一样的牌，button不变
//                        button = descArray[0];
//                        
//                    } else { // 第二个是三张一样的牌
//                        
//                        button = descArray[1];
//                    }
//                } else if (self.nong2ChuArray.count < 4) {
//                    button = self.nong2ChuArray[0];
//                } else if (self.nong2ChuArray.count == 5) {
//                    
//                }
//            }
//        }
        
        NSMutableArray *arrayTemp = [NSMutableArray array ];
        for (NSInteger i = 0; i<self.upArray.count; i++) {
            GXFButton *buttonTemp = self.upArray[i];
            [arrayTemp addObject:@(buttonTemp.tag)];
        }
        
        NSArray *descUpArray = [self sortDescWithArray:arrayTemp];
        
        BOOL zha = [self MyPaiIsZha];
        
        if (zha == YES) { // 炸
            
            GXFLog(@"%@", self.arrayNong1);
            
            // 遍历农民1
            // 如果next = -1， num最大，如果three = -1，next最大
            for (NSInteger i = array.count - 1; i>=0; i--) {
                NSInteger num = [array[i] integerValue];
                NSInteger next;
                NSInteger three = 0;
                NSInteger forth = 0;
                if (i != 0) {
                    
                    next = [array[i-1] integerValue];
                } else {
                    // num已是最大
                    next = -888;
                    
                }
                //            next = [self.arrayNong1[i-1] integerValue];
                
                if (i>=2) {
                    three = [array[i-2] integerValue];
                } else {
                    //                if (next == -1) {
                    //                    // num是最大
                    //                    three = 777;
                    //                } else {
                    //                    // next是最大
                    //                    three = 777;
                    //                }
                    
                    three = -777;
                }
                
                if (i>=3) {
                    forth = [array[i-3] integerValue];
                } else {
                    forth = -222;
                }
                
                GXFLog(@"%zd %zd", num, next);
                if (num > button.tag) {
                    
                    if (num < 4) {
                        
                        // 3，不可能3压3
                        
                    } else if (num >= 4 && num <= 7) {
                        
                        // 4，不用判断是否与我出的牌一样，肯定不一样，只需要判断4张牌是否一样大
                        if (forth >= 4 && forth <= 7) { // 最大的一个都是4，说明是炸，压
                            
                            
                            // 根据num创建出牌按钮
                            for (NSInteger i = 0; i<4; i++) {
                                
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                if (i==0) {
                                    button.tag = forth;
                                    [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                } else if (i==1) {
                                    button.tag = three;
                                    [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                } else if (i==2) {
                                    button.tag = next;
                                    [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                } else {
                                    button.tag = num;
                                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                }
                                [self.view addSubview:button];
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 农民1跟牌音效
                                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                    [self playYinXiaoWithFileName:name];
                                    
                                    button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong1ChuArray addObject:button];
                                }
                                
                            }
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 改变pang数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong1ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                        
                                    }
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                                self.foreNum = num;
                                [array removeObject:@(num)];
                                [array removeObject:@(next)];
                                [array removeObject:@(three)];
                                [array removeObject:@(forth)];
                            } else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView.tiShiNumArray addObject:@(next)];
                                [self.paiView.tiShiNumArray addObject:@(three)];
                                [self.paiView.tiShiNumArray addObject:@(forth)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            //                                break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                            
                        } else { // 不是炸，压不起
                            
                            continue;
                        }
                        
                    } else if (num >= 8 && num <= 11) {
                        
                        // 5，但需要判断4张牌是否一样大
                        if (forth >= 8 && forth <= 11) { // 炸，压
                            
                            
                            // 根据num创建出牌按钮
                            for (NSInteger i = 0; i<4; i++) {
                                
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                if (i==0) {
                                    button.tag = forth;
                                    [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                } else if (i==1) {
                                    button.tag = three;
                                    [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                } else if (i==2) {
                                    button.tag = next;
                                    [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                } else {
                                    button.tag = num;
                                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                }
                                [self.view addSubview:button];
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 农民1跟牌音效
                                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                    [self playYinXiaoWithFileName:name];
                                    
                                    button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong1ChuArray addObject:button];
                                }
                                
                            }
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 改变pang数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong1ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                        
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    [array removeObject:@(forth)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            }  else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView.tiShiNumArray addObject:@(next)];
                                [self.paiView.tiShiNumArray addObject:@(three)];
                                [self.paiView.tiShiNumArray addObject:@(forth)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            //                                break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                            
                            
                        } else { // 不是炸，压不起
                            
                            continue;
                        }
                        
                        
                    } else if (num >= 52) {
                        
                        // 只有两张王可以压
                        if (next >= 52) { // 火箭
                            
                            
                            for (NSInteger i = 0; i<2; i++) {
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                if (i == 0) {
                                    
                                    button.tag = next;
                                    [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                } else {
                                    button.tag = num;
                                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                }
                                [self.view addSubview:button];
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong1ChuArray addObject:button];
                                }
                            }
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 农民1跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong1ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            } else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView.tiShiNumArray addObject:@(next)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            //                        break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                            
                        } else {
                            continue;
                        }
                        
                    } else {
                        
                        // 只需要判断4张牌是否一样
                        if (forth/4+3 == num/4+3) { // 是炸，压
                            
                            
                            // 根据num创建出牌按钮
                            for (NSInteger i = 0; i<4; i++) {
                                
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                if (i==0) {
                                    button.tag = forth;
                                    [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                } else if (i==1) {
                                    button.tag = three;
                                    [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                } else if (i==2) {
                                    button.tag = next;
                                    [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                } else {
                                    button.tag = num;
                                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                }
                                [self.view addSubview:button];
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 农民1跟牌音效
                                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                    [self playYinXiaoWithFileName:name];
                                    
                                    button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong1ChuArray addObject:button];
                                }
                                
                            }
                            if ([array isEqualToArray:self.arrayNong1]) {
                                
                                // 改变pang数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong1ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                        
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    [array removeObject:@(forth)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            } else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView.tiShiNumArray addObject:@(next)];
                                [self.paiView.tiShiNumArray addObject:@(three)];
                                [self.paiView.tiShiNumArray addObject:@(forth)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            //                                break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                            
                        } else { // 不是炸，压不起
                            
                            continue;
                        }
                    }
                }
            }
            
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1BuYao];
            } else {
                
                // 设置不要音效
                NSInteger num = arc4random_uniform(4);
                // card_pass_M_0.mp3
                
                NSString *buyao;
                if (num == 4) {
                    buyao = @"card_pass_M.mp3";
                } else {
                    buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
                }
                [self playYinXiaoWithFileName:buyao];
                
                [self chuButtonClcik:nil];
            }
            
            
        } else { // 三带一
            
            NSInteger smallestSingle;
            
            GXFLog(@"%@", self.arrayNong1);
            
            // 遍历农民1
            // 如果next = -1， num最大，如果three = -1，next最大
            for (NSInteger i = array.count - 1; i>=0; i--) {
                NSInteger num = [array[i] integerValue];
                NSInteger next;
                NSInteger three = 0;
                NSInteger forth = 0;
                if (i != 0) {
                    
                    next = [array[i-1] integerValue];
                } else {
                    // num已是最大
                    next = -888;
                    
                }
                //            next = [self.arrayNong1[i-1] integerValue];
                
                if (i>=2) {
                    three = [array[i-2] integerValue];
                } else {
                    //                if (next == -1) {
                    //                    // num是最大
                    //                    three = 777;
                    //                } else {
                    //                    // next是最大
                    //                    three = 777;
                    //                }
                    
                    three = -777;
                }
                
                if (i>=3) {
                    forth = [array[i-3] integerValue];
                } else {
                    forth = -222;
                }
                
                GXFLog(@"%zd %zd", num, next);
#warning - 这里就不能根据第一个来判断了，需要找到三张一样大的那个来和我出的三带一中三张一样大的比较
                // 找到我出的牌中三张一样大的牌
//                NSInteger ThreeButtonTag;
//                if (descUpArray[0] == descUpArray[1]) { // 第一个就是三张一样的牌，button不变
//                    ThreeButtonTag = [descUpArray[0] integerValue];
//                    
//                } else { // 第二个是三张一样的牌
//                    
//                    ThreeButtonTag = [descUpArray[1] integerValue];
//                }
                
                // 找到跟牌中三张一样大的牌，来做比较
                
                if (num > button.tag) {
                    
                    if (num < 4) {
                        
                        // 3，三带一不可能走到这里
                        
                    } else if (num >= 4 && num <= 7) {
                        
                        // 4，需要判断next、three是否是4
                        if (next >= 4 && next <= 7) { // next也是4，说明有两张4了，再看three是不是4，如果是4，则就有三带一，可以压，但是还得看是不是一炸，即forth是不是4，forth是4不压，forth不是4才压
                            if (three >= 4 && three <= 7) { // 三张一样的，是三带一，压
                                if (forth >= 4 && forth <= 7) { // 是炸，不压
                                    continue;
                                } else {
                                   
                                    
                                    // 根据num创建出牌按钮
                                    for (NSInteger i = 0; i<4; i++) {
                                        
                                        GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                        if (i==0) {
                                            button.tag = three;
                                            [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                        } else if (i==1) {
                                            button.tag = next;
                                            [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                        } else if (i==2) {
                                            button.tag = num;
                                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                        } else {
#warning - 这里的第4个牌不再是forth，而是从单牌中找到最小的
                                            NSInteger smallestSingle = [self findSmallestSingleInArray:array];
                                            button.tag = smallestSingle;
                                            [button setImage:self.cardArray[smallestSingle] forState:UIControlStateNormal];
                                        }
                                        [self.view addSubview:button];
                                        if ([array isEqualToArray:self.arrayNong1]) {
                                            
                                            // 农民1跟牌音效
                                            NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                            [self playYinXiaoWithFileName:name];
                                            
                                            button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                            [self.nong1ChuArray addObject:button];
                                        }
                                        
                                    }
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 改变pang数字
                                        self.nong1Num -= self.nong1ChuArray.count;
                                        [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                        
                                        // 动画到桌面
                                        [UIView animateWithDuration:0.8 animations:^{
                                            
                                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                            for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                                
                                                GXFButton *button = self.nong1ChuArray[i];
                                                CGRect rect = button.frame;
                                                button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                                
                                            }
                                        } completion:^(BOOL finished) {
                                            
                                            // 计时器移到农民2
                                            [self.jishiView removeFromSuperview];
                                            [self.view addSubview:self.jishiView];
                                            [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                                make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                                make.centerY.equalTo(self.rightPangButton);
                                                make.width.mas_equalTo(20);
                                                make.height.mas_equalTo(21);
                                            }];
                                            
                                            // 隐藏农民2的出牌
                                            if (self.nong2ChuArray.count > 0) {
                                                
                                                [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                                self.nong2ChuArray = nil;
                                            }
                                            
                                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                            
                                            // 等1s让农民2跟牌
                                            if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                                
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    
                                                    [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                                });
                                            } else if (self.diZhuState == DiZhuWo) {
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    [self nong2BuYao];
                                                });
                                            }
                                        }];
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        [array removeObject:@(three)];
                                        [array removeObject:@(smallestSingle)];
                                    } else { // 点提示
                                        [self.paiView.upArray removeAllObjects];
                                        [self.paiView.tiShiNumArray addObject:@(num)];
                                        [self.paiView.tiShiNumArray addObject:@(next)];
                                        [self.paiView.tiShiNumArray addObject:@(three)];
                                        [self.paiView.tiShiNumArray addObject:@(smallestSingle)];
                                        [self.paiView upTishiPai];
                                    }
                                    self.upArray = self.nong1ChuArray;
                                    //                                break;
                                    if (self.nong1Num < 0) {
                                        [self loadFail];
                                    } else if (self.nong1Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong1Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                    return;
                                    
                                }
                                
                            } else { // 没有三带一，继续遍历
                                continue;
                            }
                            
                            
                        } else { // next不是4，说明没有三带一，继续往下遍历
                            continue;
                        }
                        
                    } else if (num >= 8 && num <= 11) {
                        
                        // 5，需要判断next、three是否是5
                        if (next >= 8 && next <= 11) { // next也是5，说明有两张5了，再看three是不是5，如果是5，则就有三带一，可以压，但是还得看是不是一炸，即forth是不是5，forth是5不压，forth不是5才压
                            if (three >= 4 && three <= 7) { // 三张一样的，是三带一，压
                                if (forth >= 4 && forth <= 7) { // 是炸，不压
                                    continue;
                                } else {
                                    
                                    
                                    // 根据num创建出牌按钮
                                    for (NSInteger i = 0; i<4; i++) {
                                        
                                        GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                        if (i==0) {
                                            button.tag = three;
                                            [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                        } else if (i==1) {
                                            button.tag = next;
                                            [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                        } else if (i==2) {
                                            button.tag = num;
                                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                        } else {
#warning - 这里的第4个牌不再是forth，而是从单牌中找到最小的
                                            NSInteger smallestSingle = [self findSmallestSingleInArray:array];
                                            button.tag = smallestSingle;
                                            [button setImage:self.cardArray[smallestSingle] forState:UIControlStateNormal];
                                        }
                                        [self.view addSubview:button];
                                        if ([array isEqualToArray:self.arrayNong1]) {
                                            
                                            // 农民1跟牌音效
                                            NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                            [self playYinXiaoWithFileName:name];
                                            
                                            button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                            [self.nong1ChuArray addObject:button];
                                        }
                                        
                                    }
                                    
                                    
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 改变pang数字
                                        self.nong1Num -= self.nong1ChuArray.count;
                                        [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                        
                                        // 动画到桌面
                                        [UIView animateWithDuration:0.8 animations:^{
                                            
                                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                            for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                                
                                                GXFButton *button = self.nong1ChuArray[i];
                                                CGRect rect = button.frame;
                                                button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                                
                                            }
                                        } completion:^(BOOL finished) {
                                            
                                            // 计时器移到农民2
                                            [self.jishiView removeFromSuperview];
                                            [self.view addSubview:self.jishiView];
                                            [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                                make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                                make.centerY.equalTo(self.rightPangButton);
                                                make.width.mas_equalTo(20);
                                                make.height.mas_equalTo(21);
                                            }];
                                            
                                            // 隐藏农民2的出牌
                                            if (self.nong2ChuArray.count > 0) {
                                                
                                                [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                                self.nong2ChuArray = nil;
                                            }
                                            
                                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                            
                                            // 等1s让农民2跟牌
                                            if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                                
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    
                                                    [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                                });
                                            } else if (self.diZhuState == DiZhuWo) {
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    [self nong2BuYao];
                                                });
                                            }
                                        }];
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        [array removeObject:@(three)];
                                        [array removeObject:@(smallestSingle)];
                                    } else { // 点提示
                                        [self.paiView.upArray removeAllObjects];
                                        [self.paiView.tiShiNumArray addObject:@(num)];
                                        [self.paiView.tiShiNumArray addObject:@(next)];
                                        [self.paiView.tiShiNumArray addObject:@(three)];
                                        [self.paiView.tiShiNumArray addObject:@(smallestSingle)];
                                        [self.paiView upTishiPai];
                                    }
                                    self.upArray = self.nong1ChuArray;
                                    //                                break;
                                    if (self.nong1Num < 0) {
                                        [self loadFail];
                                    } else if (self.nong1Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong1Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                    return;
                                    
                                }
                                
                            } else { // 没有三带一，继续遍历
                                continue;
                            }
                            
                            
                        } else { // next不是4，说明没有三带一，继续往下遍历
                            continue;
                        }
                        
                    } else if (num >= 52) {
                        
                        // 只有两张王可以压
                        if (next >= 52) { // 火箭
                            
                            
                            for (NSInteger i = 0; i<2; i++) {
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                if (i == 0) {
                                    
                                    button.tag = next;
                                    [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                } else {
                                    button.tag = num;
                                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                }
                                [self.view addSubview:button];
                                if ([array isEqualToArray:self.arrayNong1]) {
                                    
                                    // 农民1跟牌音效
                                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                    [self playYinXiaoWithFileName:name];
                                    
                                    button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong1ChuArray addObject:button];
                                }
                            }
                            if ([array isEqualToArray:self.arrayNong1]) {
                                // 改变pang数字
                                self.nong1Num -= self.nong1ChuArray.count;
                                [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong1ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 计时器移到农民2
                                    [self.jishiView removeFromSuperview];
                                    [self.view addSubview:self.jishiView];
                                    [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                        make.centerY.equalTo(self.rightPangButton);
                                        make.width.mas_equalTo(20);
                                        make.height.mas_equalTo(21);
                                    }];
                                    
                                    // 隐藏农民2的出牌
                                    if (self.nong2ChuArray.count > 0) {
                                        
                                        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                        self.nong2ChuArray = nil;
                                    }
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    
                                    // 等1s让农民2跟牌
                                    if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                        });
                                    } else if (self.diZhuState == DiZhuWo) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self nong2BuYao];
                                        });
                                    }
                                }];
                            } else { // 点提示
                                [self.paiView.upArray removeAllObjects];
                                [self.paiView.tiShiNumArray addObject:@(num)];
                                [self.paiView.tiShiNumArray addObject:@(next)];
                                [self.paiView upTishiPai];
                            }
                            self.upArray = self.nong1ChuArray;
                            //                        break;
                            if (self.nong1Num <= 0) {
                                [self loadFail];
                            } else if (self.nong1Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong1Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                            return;
                            
                        } else {
                            continue;
                        }
                        
                    } else {
                        
                        // 5，需要判断next、three是否和num一样大
                        if (num/4+3 == next/4+3) { // next和num一样大，说明有两张一样大的了，再看three是不是和num一样大，如果一样大，则就有三带一，可以压，但是还得看是不是一炸，即forth是不是和num一样大，一样大是炸不压，不一样大才压
                            if (three/4+3 == num/4+3) { // 三张一样的，是三带一，压
                                if (forth/4+3 == num/4+3) { // 是炸，不压
                                    continue;
                                } else {
                                    
                                    
                                    // 根据num创建出牌按钮
                                    for (NSInteger i = 0; i<4; i++) {
                                        
                                        GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                        if (i==0) {
                                            button.tag = three;
                                            [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                        } else if (i==1) {
                                            button.tag = next;
                                            [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                        } else if (i==2) {
                                            button.tag = num;
                                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                        } else {
#warning - 这里的第4个牌不再是forth，而是从单牌中找到最小的
                                            smallestSingle = [self findSmallestSingleInArray:array];
                                            button.tag = smallestSingle;
                                            [button setImage:self.cardArray[smallestSingle] forState:UIControlStateNormal];
                                        }
                                        [self.view addSubview:button];
                                        if ([array isEqualToArray:self.arrayNong1]) {
                                            
                                            button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                            [self.nong1ChuArray addObject:button];
                                        }
                                        
                                    }
                                    if ([array isEqualToArray:self.arrayNong1]) {
                                        
                                        // 农民1跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        // 改变pang数字
                                        self.nong1Num -= self.nong1ChuArray.count;
                                        [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
                                        
                                        // 动画到桌面
                                        [UIView animateWithDuration:0.8 animations:^{
                                            
                                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                            for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                                                
                                                GXFButton *button = self.nong1ChuArray[i];
                                                CGRect rect = button.frame;
                                                button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                                                
                                            }
                                        } completion:^(BOOL finished) {
                                            
                                            // 计时器移到农民2
                                            [self.jishiView removeFromSuperview];
                                            [self.view addSubview:self.jishiView];
                                            [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                                                make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                                                make.centerY.equalTo(self.rightPangButton);
                                                make.width.mas_equalTo(20);
                                                make.height.mas_equalTo(21);
                                            }];
                                            
                                            // 隐藏农民2的出牌
                                            if (self.nong2ChuArray.count > 0) {
                                                
                                                [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                                self.nong2ChuArray = nil;
                                            }
                                            
                                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                            
                                            // 等1s让农民2跟牌
                                            if (self.diZhuState == DiZhuNong1 || self.diZhuState == DiZhuNong2) {
                                                
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    
                                                    [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
                                                });
                                            } else if (self.diZhuState == DiZhuWo) {
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    [self nong2BuYao];
                                                });
                                            }
                                        }];
                                        self.foreNum = num;
                                        [array removeObject:@(num)];
                                        [array removeObject:@(next)];
                                        [array removeObject:@(three)];
                                        [array removeObject:@(smallestSingle)];
                                    } else { // 点提示
                                        [self.paiView.upArray removeAllObjects];
                                        [self.paiView.tiShiNumArray addObject:@(num)];
                                        [self.paiView.tiShiNumArray addObject:@(next)];
                                        [self.paiView.tiShiNumArray addObject:@(three)];
                                        [self.paiView.tiShiNumArray addObject:@(smallestSingle)];
                                        [self.paiView upTishiPai];
                                    }
                                    self.upArray = self.nong1ChuArray;
                                    //                                break;
                                    if (self.nong1Num < 0) {
                                        [self loadFail];
                                    } else if (self.nong1Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong1Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                    return;
                                    
                                }
                                
                            } else { // three和num不一样大，继续遍历
                                continue;
                            }
                            
                            
                        } else { // next和num不一样大，继续遍历
                            continue;
                        }
                        
                    }
                }
            }
            
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1BuYao];
            } else {
                
                // 设置不要音效
                NSInteger num = arc4random_uniform(4);
                // card_pass_M_0.mp3
                
                NSString *buyao;
                if (num == 4) {
                    buyao = @"card_pass_M.mp3";
                } else {
                    buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
                }
                [self playYinXiaoWithFileName:buyao];
                
                // 添加不要对话框
                [self where:@"wo" addDuiHuaWithImageName:@"buchu" isBigger:NO];
                
                [self chuButtonClcik:nil];
                if (self.nong2ChuArray.count > 0) {
                    
                    if (self.diZhuState == DiZhuNong2) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
                        });
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self nong1BuYao];
                        });
                    }
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nong1AutoChuWithArray:self.arrayNong1];
                    });
                }
                
                [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.nong1ChuArray = nil;
                [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.nong2ChuArray = nil;
                //
                
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (self.nong2ChuArray.count > 0) { // 农民2出了，我不压，农民1也别压
//                        
//                        [self nong1BuYao];
//                        
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            
//                            [self nong1AutoChuWithArray:self.arrayNong2];
//                        });
//                        
//                    } else { // 农民1出了，农民2没出，我也没压
//                        [self nong1AutoChuWithArray:self.arrayNong1];
//                    }
//                });
            }
            
        }
    }
}

- (BOOL)MyPaiIsZha {
    
    NSMutableArray *arrayTemp = [NSMutableArray array ];
    for (NSInteger i = 0; i<self.upArray.count; i++) {
        GXFButton *buttonTemp = self.upArray[i];
        [arrayTemp addObject:@(buttonTemp.tag)];
    }
    
    // 我出的牌的降序数组
    NSArray *descUpArray = [self sortDescWithArray:arrayTemp];
    
    NSInteger num = [descUpArray[0] integerValue];
    NSInteger last = [descUpArray[3] integerValue];
    
    if (num < 4) {
        
        // 3
        if (last < 4) {
            return YES;
        }
        
    } else if (num >= 4 && num <= 7) {
        
        // 4
        if (last >= 4 && last <= 7) {
            return YES;
        }
        
        
    } else if (num >= 8 && num <= 11) {
        // 5
        if (last >= 8 && num <= 11) {
            return YES;
        }
        
        
    } else if (num >= 52) {
        
        // 这里不可能是炸
        return NO;
    } else {
        
        if (num/4+3 == last/4+3) {
            return YES;
        }
            
    }
    
    return NO;
}

- (NSInteger)findSmallestSingleInArray:(NSArray *)array {
    
    for (NSInteger i = array.count - 1; i>=0; i--) {
        
        // 如果不一样大小，则返回最小的那个即可
        if (i>1 && i<array.count-1) {
            if ([array[i] integerValue] < 4) {
                // 3
                if ([array[i-1] integerValue] >= 4) {
                    return [array[i+1] integerValue];
                }
                
            } else if ([array[i] integerValue] >= 4 && [array[i] integerValue] <= 7) {
                
                // 4
                if ([array[i-1] integerValue] > 7 && [array[i+1] integerValue] < 4) {
                    return [array[i+1] integerValue];
                }
                
                
            } else if ([array[i] integerValue] >= 8 && [array[i] integerValue] <= 11) {
                
                // 5
                if ([array[i-1] integerValue] > 11 && [array[i+1] integerValue] < 8) {
                    return [array[i+1] integerValue];
                }
                
                
            } else if ([array[i] integerValue] >= 52) {
                
                
                
            } else {
                
                // i / 4 + 3;
                if ([array[i-1] integerValue] / 4 + 3 != [array[i] integerValue] / 4 + 3 && [array[i+1] integerValue] !=[array[i] integerValue]) { // 是对，不能出，进行下一个遍历
                    return [array[i+1] integerValue];
                }
                
            }
        }
        
        
    }
    
    // 只有对，返回最小的即可
    GXFButton *button = array.lastObject;
    return button.tag;
}

- (void)nong1BuYao {
    // 不要
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nong1ChuArray = nil;
        
        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nong2ChuArray = nil;
        
        // 添加不要对话框
        [self where:@"nong1" addDuiHuaWithImageName:@"buchu" isBigger:NO];
        
        // 设置不要音效
        NSInteger num = arc4random_uniform(4);
        // card_pass_M_0.mp3
        
        NSString *buyao;
        if (num == 4) {
            buyao = @"card_pass_M.mp3";
        } else {
            buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
        }
        [self playYinXiaoWithFileName:buyao];
        
        // 计时器移到农民2
        [self.jishiView removeFromSuperview];
        [self.view addSubview:self.jishiView];
        [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftPangButton.mas_right).offset(5);
            make.centerY.equalTo(self.rightPangButton);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(21);
        }];
        
        //                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
        // 等1s让农民2跟牌
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            // 此时应该传入我出牌的索引
////            GXFButton *button;
////            if (self.upArray.count > 1) {
////
////                NSArray *descUpArray = [self sortDescWithArray:self.upArray];
////                button = descUpArray[0];
////            } else {
////                button = self.upArray[0];
////            }
//#pragma mark - 如果只是单张或两张，取出第一个即可，但是如果是顺子或三带一，另行判断
//            GXFButton *button = self.upArray[0];
//
//            [self genPai2WithArray:self.arrayNong2 foreNum:button.tag];
//
//        });
        
        
        // 不用等1s
        // 此时应该传入我出牌的索引
        //            GXFButton *button;
        //            if (self.upArray.count > 1) {
        //
        //                NSArray *descUpArray = [self sortDescWithArray:self.upArray];
        //                button = descUpArray[0];
        //            } else {
        //                button = self.upArray[0];
        //            }
#pragma mark - 如果只是单张或两张或三张，取出第一个即可，但是如果是顺子或三带一或炸，另行判断
//        GXFButton *button = self.upArray[0];
        NSInteger chuanRuIndex = 0;
        if (self.upArray.count == 4) {
            // 判断是炸还是三带一
            NSMutableArray *arrayTemp = [NSMutableArray array ];
            for (NSInteger i = 0; i<self.upArray.count; i++) {
                GXFButton *buttonTemp = self.upArray[i];
                [arrayTemp addObject:@(buttonTemp.tag)];
            }
            
            NSArray *descUpArray = [self sortDescWithArray:arrayTemp];
            BOOL zha = [self MyPaiIsZha];
            
            if (zha == YES) { // 炸，第一个button即可
                GXFButton *button = self.upArray[0];
                chuanRuIndex = button.tag;
                
            } else { // 三带一，选出我出的upArray中三个一样的牌
                
//                NSInteger ThreeButtonTag;
                if (descUpArray[0] == descUpArray[1]) { // 第一个就是三张一样的牌，button不变
                    chuanRuIndex = [descUpArray[0] integerValue];
                    
                } else { // 第二个是三张一样的牌
                    
                    chuanRuIndex = [descUpArray[1] integerValue];
                }
            }
        } else {
            
            if (self.selfChuArray.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self nong1AutoChuWithArray:self.arrayNong2];
                    return ;
                });
            } else {
                GXFButton * button = self.selfChuArray[0];
                chuanRuIndex = button.tag;
            }
        }
        
        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nong2ChuArray = nil;
        
        if (self.selfChuArray.count > 0 || self.nong1ChuArray.count > 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self genPai2WithArray:self.arrayNong2 foreNum:chuanRuIndex identifier:NO];
            });
        } else {
            
            // 2自动出牌
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self nong1AutoChuWithArray:self.arrayNong2];
            });
        }
        
//        if (self.selfChuArray.count == 0) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [self nong1AutoChuWithArray:self.arrayNong2];
//            });
//        } else {
//            
//        }
        
        
    });
}

- (void)nong2BuYao {
    
    // 不要
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nong2ChuArray = nil;
        // 添加不要对话框
        [self where:@"nong2" addDuiHuaWithImageName:@"buchu" isBigger:NO];
        
        // 设置不要音效
        NSInteger num = arc4random_uniform(5);
        // card_pass_M_0.mp3
        
        NSString *buyao;
        if (num == 4) {
            buyao = @"card_pass_M.mp3";
        } else {
            buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
        }
        [self playYinXiaoWithFileName:buyao];
        
        // 移除计时器
        [self.jishiView removeFromSuperview];
        
//        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
        // 移除自己的出牌
        [self.selfChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.selfChuArray = nil;
        
        // 显示不出、提示、出牌按钮
        for (NSInteger i = 0; i<3; i++) {
            
            if (i == 2) {
                [self.selectView addSubview:self.chuButton];
                self.chuButton.selected = YES;
                if (self.chuButton.selected == YES) {
                    self.chuButton.userInteractionEnabled = NO;
                } else {
                    self.chuButton.userInteractionEnabled = YES;
                }
                
            } else if (i == 1) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                [self.selectView addSubview:button];
                [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
            } else if (i == 0) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                [self.selectView addSubview:button];
                [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        [self viewDidLayoutSubviews];
        
    });
}

- (void)tishiButtonClick:(UIButton *)button {
    
    // 其实提示也就是判断能不能压，能压得话用那些牌压，再把这些牌点一下
    // 可以调用农民1的跟牌方法
    // 但是涉及到PaiView的GXFButton点击，交给PaiView去做行不行
    
    [self genPaiWithArray:self.paiView.numArray foreNum:0];
    
    // 让出牌按钮可用
    self.chuButton.selected = NO;
    if (self.chuButton.selected == YES) {
        self.chuButton.userInteractionEnabled = NO;
    } else {
        self.chuButton.userInteractionEnabled = YES;
    }
    
    if (self.upArray.count > 0) {
        button.selected = YES;
    }
}

- (void)buchuButtonClick:(UIButton *)button {
    
    // 添加不要对话框
    [self where:@"wo" addDuiHuaWithImageName:@"buchu" isBigger:NO];
    
    // 移除农民1出的牌
    [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.nong1ChuArray = nil;
    
    // 移除自己的出牌，以便判断农民1自动出还是农民2自动出
    [self.selfChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.selfChuArray = nil;
    
    // 设置不要音效
    NSInteger num = arc4random_uniform(5);
    // card_pass_M_0.mp3
    
    NSString *buyao;
    if (num == 4) {
        buyao = @"card_pass_M.mp3";
    } else {
        buyao = [NSString stringWithFormat:@"card_pass_M_%zd.mp3", num];
    }
    [self playYinXiaoWithFileName:buyao];
    
    //
    [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //
    if (self.nong2ChuArray.count > 0) {
        
        if (self.diZhuState == DiZhuNong2 || self.diZhuState == DiZhuNong1) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self genPaiWithArray:self.arrayNong1 foreNum:self.foreNum];
            });
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self nong1BuYao];
            });
        }
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self nong1AutoChuWithArray:self.arrayNong1];
        });
    }
    
}

- (void)genPai2WithArray:(NSMutableArray *)array foreNum:(NSInteger)foreNum identifier:(BOOL)identifier{
    
    // 我出的牌按钮
    //    GXFButton *button = self.upArray[0];
    // 这时button应该是农民1出的button
    // 如果我出了牌，并且2是地主，只有这种情况1不要压
    if (self.diZhuState == DiZhuNong1 && self.selfChuArray.count > 0 && self.nong1ChuArray.count == 0) {
        // 如果我出了牌，农民1不要，并且地主是1，只有这时1不要压我
        [self nong2BuYao];
        return;
    }
    if (self.nong1ChuArray.count == 0) {
        self.upArray = self.selfChuArray;
        GXFButton *button = self.selfChuArray[0];
        foreNum = button.tag;
    } else {
        self.upArray = self.nong1ChuArray;
        GXFButton *button = self.nong1ChuArray[0];
        foreNum = button.tag;
    }
    
    if (self.upArray.count == 1) {
        // 单张
        // 遍历农民1
        for (NSInteger i = array.count - 1; i>=0; i--) {
            NSInteger num = [array[i] integerValue];
            NSInteger next;
            NSInteger shang;
            if (i != 0) {
                
                next = [array[i-1] integerValue];
            } else {
                next = -666;
            }
            if (i != array.count - 1) {
                shang = [array[i+1] integerValue];
            } else {
                shang = -2222;
            }
            //            next = [self.arrayNong1[i-1] integerValue];
            
            GXFLog(@"%zd %zd", num, next);
            if (num > foreNum) {
                
                // 看看是否是单张，如果是单张就出吧
                if (num < 4) {
                    
                    // 3，不可能3压3
                    
                } else if (num >= 4 && num <= 7) {
                    
                    // 4
                    if ((next >= 4 && next <= 7) || (shang >= 4 && shang <= 7)) { // 是对，不能出，进行下一个遍历
                        continue;
                        
                    } else { // 单张，可以跟
                        
                        // 但是要判断是否和我出的牌一样大
                        if (foreNum < 4) { // 我出的是3
                            
                            // 农民2跟牌音效
                            NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                            [self playYinXiaoWithFileName:name];
                            // 改变pang数字
                            self.nong2Num -= self.nong2ChuArray.count;
                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                            
                            // 根据num创建出牌按钮
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            [self.view addSubview:button];
                            button.tag = num;
                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                            
                            [self.nong2ChuArray addObject:button];;
                            // 设置2旁的数字
                            if (self.nong2ChuArray.count > 0) {
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                            }
                            
                            // 动画到桌面
                            [UIView animateWithDuration:0.8 animations:^{
                                
                                
                                //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                CGRect rect = button.frame;
                                button.frame = CGRectMake(rect.origin.x + 40, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
                            } completion:^(BOOL finished) {
                                
                                // 移除计时器
                                [self.jishiView removeFromSuperview];
                                
                                [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                // 移除自己的出牌
                                for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                    
                                    GXFButton *button = self.selfChuArray[i];
                                    [button removeFromSuperview];
                                }
                                self.selfChuArray = nil;
                                
                                // 显示不出、提示、出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    if (i == 2) {
                                        [self.selectView addSubview:self.chuButton];
                                        if (self.chuButton.selected == YES) {
                                            self.chuButton.userInteractionEnabled = NO;
                                        }
                                        
                                    }  else if (i == 1) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                        [self.selectView addSubview:button];
                                        [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                    } else if (i == 0) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                        [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                        [self.selectView addSubview:button];
                                        [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    }
                                }
                                
                                [self viewDidLayoutSubviews];
                                
                                
                            }];
                            
#pragma mark - 用于我压农民2
                            self.foreNum = num;
                            [array removeObject:@(num)];
                            
                            self.upArray = self.nong2ChuArray;
//                            break;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                if (self.nong2Num <= 0) {
                                    [self loadFail];
                                } else if (self.nong2Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong2Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                            });
                            return;
                            
                        } else if (foreNum >= 4 && foreNum <= 7) { // 我出的也是4
                            continue;
                        }
                    }
                    
                } else if (num >= 8 && num <= 11) {
                    
                    // 5
                    if ((next >= 8 && next <= 11) || (shang >= 8 && shang <= 11)) { // 是对，不能出，进行下一个遍历
                        continue;
                        
                    } else { // 单张，可以跟
                        
                        // 判断和我出的牌是否一样大
                        if (foreNum >= 8 && foreNum <= 11) { // 我出的也是5
                            continue;
                        } else {
                            
                            // 农民2跟牌音效
                            NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                            [self playYinXiaoWithFileName:name];
                            // 改变pang数字
                            self.nong2Num -= self.nong2ChuArray.count;
                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                            
                            // 根据num创建出牌按钮
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            [self.view addSubview:button];
                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                            button.tag = num;
                            [self.nong2ChuArray addObject:button];;
                            // 设置2旁的数字
                            if (self.nong2ChuArray.count > 0) {
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                            }
                            
                            // 动画到桌面
                            [UIView animateWithDuration:0.8 animations:^{
                                
                                
                                //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                CGRect rect = button.frame;
                                button.frame = CGRectMake(rect.origin.x + 40, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                            } completion:^(BOOL finished) {
                                
                                // 移除计时器
                                [self.jishiView removeFromSuperview];
                                
                                [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                // 移除自己的出牌
                                for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                    
                                    GXFButton *button = self.selfChuArray[i];
                                    [button removeFromSuperview];
                                }
                                self.selfChuArray = nil;
                                
                                // 显示不出、提示、出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    if (i == 2) {
                                        [self.selectView addSubview:self.chuButton];
                                        if (self.chuButton.selected == YES) {
                                            self.chuButton.userInteractionEnabled = NO;
                                        }
                                        
                                    }  else if (i == 1) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                        [self.selectView addSubview:button];
                                        [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                    } else if (i == 0) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                        [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                        [self.selectView addSubview:button];
                                        [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    }
                                }
                                
                                
                                [self viewDidLayoutSubviews];
                                
                            }];
                            POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                            anim1.delegate = self;
                            //            anim1.springBounciness = 1.0;
                            anim1.springSpeed = 9;
                            // CGPointMake(button.center.x - (rect.origin.x - kScreenWidth * 0.5 - i * 20), button.center.y - 50)
                            anim1.toValue = [NSValue valueWithCGRect:CGRectMake(button.frame.origin.x, button.frame.origin.y, 60 * 0.7, 80 * 0.7)];
                            //                            [button pop_addAnimation:anim1 forKey:nil];
                            anim1.delegate = self;
                            self.nong1Animation = anim1;
                            
                            self.foreNum = num;
                            [array removeObject:@(num)];
                            self.upArray = self.nong2ChuArray;
//                            break;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                if (self.nong2Num <= 0) {
                                    [self loadFail];
                                } else if (self.nong2Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong2Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                            });
                            return;
                        }
                        
                    }
                    
                } else if (num >= 52) {
                    
                    // 农民2跟牌音效
                    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                    [self playYinXiaoWithFileName:name];
                    // 改变pang数字
                    self.nong2Num -= self.nong2ChuArray.count;
                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                    
                    // 直接出
                    // 根据num创建出牌按钮
                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                    [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                    [self.view addSubview:button];
                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                    button.tag = num;
                    [self.nong2ChuArray addObject:button];;
                    
                    // 设置2旁的数字
                    if (self.nong2ChuArray.count > 0) {
                        self.nong2Num -= self.nong2ChuArray.count;
                        [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                    }
                    // 动画到桌面
                    [UIView animateWithDuration:0.8 animations:^{
                        
                        //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                        CGRect rect = button.frame;
                        button.frame = CGRectMake(rect.origin.x + 40, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                    } completion:^(BOOL finished) {
                        
                        // 移除计时器
                        [self.jishiView removeFromSuperview];
                        
                        [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                        // 移除自己的出牌
                        for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                            
                            GXFButton *button = self.selfChuArray[i];
                            [button removeFromSuperview];
                        }
                        self.selfChuArray = nil;
                        
                        // 显示不出、提示、出牌按钮
                        for (NSInteger i = 0; i<3; i++) {
                            
                            if (i == 2) {
                                [self.selectView addSubview:self.chuButton];
                                if (self.chuButton.selected == YES) {
                                    self.chuButton.userInteractionEnabled = NO;
                                } else {
                                    self.chuButton.userInteractionEnabled = YES;
                                }
                                
                            } else if (i == 1) {
                                
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                [self.selectView addSubview:button];
                                [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                
                            } else if (i == 0) {
                                
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                [self.selectView addSubview:button];
                                [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                            }
                        }
                        
                        
                        [self viewDidLayoutSubviews];
                        
                    }];
                    POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    anim1.delegate = self;
                    //            anim1.springBounciness = 1.0;
                    anim1.springSpeed = 9;
                    // CGPointMake(button.center.x - (rect.origin.x - kScreenWidth * 0.5 - i * 20), button.center.y - 50)
                    anim1.toValue = [NSValue valueWithCGRect:CGRectMake(button.frame.origin.x, button.frame.origin.y, 60 * 0.7, 80 * 0.7)];
                    //                    [button pop_addAnimation:anim1 forKey:nil];
                    anim1.delegate = self;
                    self.nong1Animation = anim1;
                    
                    self.foreNum = num;
                    [array removeObject:@(num)];
                    self.upArray = self.nong2ChuArray;
//                    break;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        if (self.nong2Num <= 0) {
                            [self loadFail];
                        } else if (self.nong2Num == 2) {
                            [self ShengYinXiaoWithNum:2];
                        } else if (self.nong2Num == 1) {
                            [self ShengYinXiaoWithNum:1];
                        }
                    });
                    return;
                    
                } else {
                    
                    
                    if (num >= 48 && num <= 51) { // 2，直接用2压
                        if (num /4 + 3 != foreNum / 4 + 3) {
                            
                            // 农民2跟牌音效
                            NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                            [self playYinXiaoWithFileName:name];
                            // 改变pang数字
                            self.nong2Num -= self.nong2ChuArray.count;
                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                            
                            // 根据num创建出牌按钮
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            [self.view addSubview:button];
                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                            button.tag = num;
                            [self.nong2ChuArray addObject:button];
                            // 设置2旁的数字
                            if (self.nong2ChuArray.count > 0) {
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                            }
                            
                            // 动画到桌面
                            [UIView animateWithDuration:0.8 animations:^{
                                
                                //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                CGRect rect = button.frame;
                                button.frame = CGRectMake(rect.origin.x + 40, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                            } completion:^(BOOL finished) {
                                
                                // 移除计时器
                                [self.jishiView removeFromSuperview];
                                
                                [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                // 移除自己的出牌
                                for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                    
                                    GXFButton *button = self.selfChuArray[i];
                                    [button removeFromSuperview];
                                }
                                self.selfChuArray = nil;
                                
                                // 显示不出、提示、出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    if (i == 2) {
                                        [self.selectView addSubview:self.chuButton];
                                        if (self.chuButton.selected == YES) {
                                            self.chuButton.userInteractionEnabled = NO;
                                        }
                                        
                                    } else if (i == 1) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                        [self.selectView addSubview:button];
                                        [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        
                                    } else if (i == 0) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                        [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                        [self.selectView addSubview:button];
                                        [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    }
                                }
                                
                                [self viewDidLayoutSubviews];
                            }];
                            
#pragma mark - 用于以后判断农民1是否压农民2
                            self.foreNum = num;
                            [array removeObject:@(num)];
                            
                            self.upArray = self.nong2ChuArray;
                            //                            break;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                if (self.nong2Num <= 0) {
                                    [self loadFail];
                                } else if (self.nong2Num == 2) {
                                    [self ShengYinXiaoWithNum:2];
                                } else if (self.nong2Num == 1) {
                                    [self ShengYinXiaoWithNum:1];
                                }
                            });
                            return;
                        }
                    } else {
                        
                        // i / 4 + 3;
                        if ((next / 4 + 3 == num / 4 + 3) || (shang / 4 + 3) == num / 4 + 3) { // 是对，不能出，进行下一个遍历
                            continue;
                            
                        } else { // 单张，可以跟
                            
                            if (foreNum / 4 + 3 == num /4 + 3) {
                                continue;
                            } else {
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                [self.view addSubview:button];
                                button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                button.tag = num;
                                [self.nong2ChuArray addObject:button];
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    CGRect rect = button.frame;
                                    button.frame = CGRectMake(rect.origin.x + 40, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                
#pragma mark - 用于以后判断农民1是否压农民2
                                self.foreNum = num;
                                [array removeObject:@(num)];
                                
                                self.upArray = self.nong2ChuArray;
                                //                            break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                            }
                        }
                    }
                    
                }
            }
        }
        
        [self nong2BuYao];
        
#pragma mark - 2张
    } else if (self.upArray.count == 2) {
        
        GXFLog(@"%@", self.arrayNong1);
        
        // 遍历农民2
        for (NSInteger i = array.count - 1; i>=0; i--) {
            NSInteger num = [array[i] integerValue];
            NSInteger next;
            NSInteger three = 0;
            if (i != 0) {
                
                next = [array[i-1] integerValue];
            } else {
                next = -555;
            }
            //            next = [self.arrayNong1[i-1] integerValue];
            
            if (i>=2) {
                three = [array[i-2] integerValue];
            } else {
                three = - 333;
            }
            
            GXFLog(@"%zd %zd", num, next);
            if (num > foreNum) {
                
                if (num < 4) {
                    
                    // 3，不可能3压3
                    
                } else if (num >= 4 && num <= 7) {
                    
                    // 4
                    if (next >= 4 && next <= 7) { // 是对，可以出，但是需要注意是不是三个一样的牌，三带一
                        if (three >= 4 && three <= 7) { // 是三带一，不能出
                            continue;
                        } else {
                            
                            // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            if (foreNum < 4) { // 我出的是对3，可以压
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<2; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                }
                                
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
//                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else {
                                
                                continue;
                            }
                            
                        }
                        
                    } else { // 单张，压不起
                        continue;
                    }
                    
                } else if (num >= 8 && num <= 11) {
                    
                    // 5
                    if (next >= 8 && next <= 11) { // 是对，可以出，但是需要判断是否是三带一
                        if (three >= 4 && three <= 7) { // 是三带一，不能出
                            continue;
                        } else { // 只有两张牌，可以出，但是需要判断是否和我出的牌一样大
                            
                            // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            if (foreNum >= 8 && foreNum <= 11) { // 我出的是对3，可以压
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<2; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*18, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                }
                                
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                    
                                }];
                                self.upArray = self.nong2ChuArray;
//                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else {
                                
                                continue;
                            }
                        }
                        
                    } else { // 单张，不可以压
                        
                        continue;
                    }
                    
                } else if (num >= 52) {
                    
                    // 只有两张王可以压
                    if (next >= 52) { // 火箭
                        
                        // 农民2跟牌音效
                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                        [self playYinXiaoWithFileName:name];
                        // 改变pang数字
                        self.nong2Num -= self.nong2ChuArray.count;
                        [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                        
                        for (NSInteger i = 0; i<2; i++) {
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            if (i == 0) {
                                
                                button.tag = next;
                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                            } else {
                                button.tag = num;
                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            }
                            [self.view addSubview:button];
                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                            [self.nong2ChuArray addObject:button];
                        }
                        
                        // 设置2旁的数字
                        if (self.nong2ChuArray.count > 0) {
                            self.nong2Num -= self.nong2ChuArray.count;
                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                        }
                        // 动画到桌面
                        [UIView animateWithDuration:0.8 animations:^{
                            
                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                            for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                
                                GXFButton *button = self.nong2ChuArray[i];
                                CGRect rect = button.frame;
                                button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                            }
                            
                            self.foreNum = num;
                            [array removeObject:@(num)];
                            [array removeObject:@(next)];
                            
                        } completion:^(BOOL finished) {
                            
                            // 移除计时器
                            [self.jishiView removeFromSuperview];
                            
                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                            // 移除自己的出牌
                            for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                
                                GXFButton *button = self.selfChuArray[i];
                                [button removeFromSuperview];
                            }
                            self.selfChuArray = nil;
                            
                            // 显示不出、提示、出牌按钮
                            for (NSInteger i = 0; i<3; i++) {
                                
                                if (i == 2) {
                                    [self.selectView addSubview:self.chuButton];
                                    if (self.chuButton.selected == YES) {
                                        self.chuButton.userInteractionEnabled = NO;
                                    }
                                    
                                } else if (i == 1) {
                                    
                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                    [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                    [self.selectView addSubview:button];
                                    [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    
                                } else if (i == 0) {
                                    
                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                    [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                    [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                    [self.selectView addSubview:button];
                                    [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                }
                            }
                            
                            [self viewDidLayoutSubviews];
                        }];
                        self.upArray = self.nong2ChuArray;
//                        break;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            if (self.nong2Num <= 0) {
                                [self loadFail];
                            } else if (self.nong2Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong2Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                        });
                        return;
                        
                    } else {
                        continue;
                    }
                    
                } else {
                    
                    // i / 4 + 3;
                    if (next / 4 + 3 == num / 4 + 3) { // 是对，可以出，但是需要判断是否是三带一
                        if (three / 4 + 3 == num / 4 + 3) { // 是三带一，不能出
                            continue;
                        } else { // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            if (num/4+3 != foreNum/4+3) { // 可以压
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<2; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
//                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else {
                                continue;
                            }
                        }
                        
                    } else { // 是单，压不起
                        continue;
                        
                    }
                }
            }
        }
        
        [self nong2BuYao];
        
#pragma mark - 3张
    } else if (self.upArray.count == 3) {
        
        GXFLog(@"%@", self.arrayNong1);
        
        // 遍历农民2
        for (NSInteger i = array.count - 1; i>=0; i--) {
            NSInteger num = [array[i] integerValue];
            NSInteger next;
            NSInteger three = 0;
            NSInteger forth = 0;
            if (i != 0) {
                
                next = [array[i-1] integerValue];
            } else {
                next = -555;
            }
            //            next = [self.arrayNong1[i-1] integerValue];
            
            if (i>=2) {
                three = [array[i-2] integerValue];
            } else {
                three = - 333;
            }
            
            if (i>=3) {
                forth = [array[i-3] integerValue];
            } else {
                forth = -111;
            }
            
            GXFLog(@"%zd %zd", num, next);
            if (num > foreNum) {
                
                if (num < 4) {
                    
                    // 3，不可能3压3
                    
                } else if (num >= 4 && num <= 7) {
                    
                    // 4
                    if (next >= 4 && next <= 7) { // 是对
                        if (three >= 4 && three <= 7) { // 是三张，但需要判断是不是炸，是炸不压
                            if (forth >= 4 && forth <= 7) { // 是炸，不压
                                continue;
                            } else {
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                            }
                            
                        } else { // 是对，压不起
                            
                            continue;
                        }
                        
                    } else { // 单张，压不起
                        continue;
                    }
                    
                } else if (num >= 8 && num <= 11) {
                    
                    // 5
                    if (next >= 8 && next <= 11) { // 是对
                        if (three >= 4 && three <= 7) { // 是三张，但是需要判断是不是炸，是炸不压
                            if (forth >= 4 && forth <= 7) { // 是炸，不压
                                continue;
                            } else {
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                }
                                
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                    
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            }
                            
                        } else { // 只有两张牌，压不起
                            continue;
                        }
                        
                    } else { // 单张，压不起
                        
                        continue;
                    }
                    
                } else if (num >= 52) {
                    
                    // 只有两张王可以压
                    if (next >= 52) { // 火箭
                        
                        // 农民2跟牌音效
                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                        [self playYinXiaoWithFileName:name];
                        // 改变pang数字
                        self.nong2Num -= self.nong2ChuArray.count;
                        [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                        
                        for (NSInteger i = 0; i<2; i++) {
                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                            if (i == 0) {
                                
                                button.tag = next;
                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                            } else {
                                button.tag = num;
                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                            }
                            [self.view addSubview:button];
                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*18, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                            [self.nong2ChuArray addObject:button];
                        }
                        // 设置2旁的数字
                        if (self.nong2ChuArray.count > 0) {
                            self.nong2Num -= self.nong2ChuArray.count;
                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                        }
                        
                        // 动画到桌面
                        [UIView animateWithDuration:0.8 animations:^{
                            
                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                            for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                
                                GXFButton *button = self.nong2ChuArray[i];
                                CGRect rect = button.frame;
                                button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                            }
                            
                            self.foreNum = num;
                            [array removeObject:@(num)];
                            [array removeObject:@(next)];
                            
                        } completion:^(BOOL finished) {
                            
                            // 移除计时器
                            [self.jishiView removeFromSuperview];
                            
                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                            // 移除自己的出牌
                            for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                
                                GXFButton *button = self.selfChuArray[i];
                                [button removeFromSuperview];
                            }
                            self.selfChuArray = nil;
                            
                            // 显示不出、提示、出牌按钮
                            for (NSInteger i = 0; i<3; i++) {
                                
                                if (i == 2) {
                                    [self.selectView addSubview:self.chuButton];
                                    if (self.chuButton.selected == YES) {
                                        self.chuButton.userInteractionEnabled = NO;
                                    }
                                    
                                } else if (i == 1) {
                                    
                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                    [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                    [self.selectView addSubview:button];
                                    [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    
                                } else if (i == 0) {
                                    
                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                    [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                    [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                    [self.selectView addSubview:button];
                                    [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                }
                            }
                            
                            [self viewDidLayoutSubviews];
                        }];
                        self.upArray = self.nong2ChuArray;
                        //                        break;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            if (self.nong2Num <= 0) {
                                [self loadFail];
                            } else if (self.nong2Num == 2) {
                                [self ShengYinXiaoWithNum:2];
                            } else if (self.nong2Num == 1) {
                                [self ShengYinXiaoWithNum:1];
                            }
                        });
                        return;
                        
                    } else {
                        continue;
                    }
                    
                } else {
                    
                    // i / 4 + 3;
                    if (next / 4 + 3 == num / 4 + 3) { // 是对
                        if (three / 4 + 3 == num / 4 + 3) { // 是三张，但需要判断是不是炸，是炸不压
                            if (forth / 4 + 3 == num / 4 + 3) { // 是炸，不压
                                continue;
                            } else {
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<3; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                            }
                            
                        } else { // 只有两张牌，可以压，但是需要判断与我出的牌是否一样大
                            
                        }
                        
                    } else { // 是单，压不起
                        continue;
                        
                    }
                }
            }
        }
        
        [self nong2BuYao];
        
#pragma mark - 4张
    } else if (self.upArray.count == 4) {
        // 如果农民1压了，农民2就不压
        if (identifier == YES) { // 农民2不压
            [self nong2BuYao];
        } else { // 农民1没压，农民2压
            
            // 这时就不能取出upArray的第一个GXFButton来比较了，需要判断是炸还是三带一，即判断4张牌是否一样大
            // upArray是GXFButton数组，不能排序
            NSMutableArray *arrayTemp = [NSMutableArray array ];
            for (NSInteger i = 0; i<self.upArray.count; i++) {
                GXFButton *buttonTemp = self.upArray[i];
                [arrayTemp addObject:@(buttonTemp.tag)];
            }
            
            NSArray *descUpArray = [self sortDescWithArray:arrayTemp];
            BOOL zha = [self MyPaiIsZha];
            
            if (zha == YES) { // 炸
                
                GXFLog(@"%@", self.arrayNong1);
                
                // 遍历农民2
                // 如果next = -1， num最大，如果three = -1，next最大
                for (NSInteger i = array.count - 1; i>=0; i--) {
                    NSInteger num = [array[i] integerValue];
                    NSInteger next;
                    NSInteger three = 0;
                    NSInteger forth = 0;
                    if (i != 0) {
                        
                        next = [array[i-1] integerValue];
                    } else {
                        // num已是最大
                        next = -888;
                        
                    }
                    //            next = [self.arrayNong1[i-1] integerValue];
                    
                    if (i>=2) {
                        three = [array[i-2] integerValue];
                    } else {
                        //                if (next == -1) {
                        //                    // num是最大
                        //                    three = 777;
                        //                } else {
                        //                    // next是最大
                        //                    three = 777;
                        //                }
                        
                        three = -777;
                    }
                    
                    if (i>=3) {
                        forth = [array[i-3] integerValue];
                    } else {
                        forth = -222;
                    }
                    
                    GXFLog(@"%zd %zd", num, next);
#warning - 是炸，随便取出其中一张牌做比较即可
                    GXFButton *button = self.upArray[0];
                    
                    if (num > button.tag) {
                        
                        if (num < 4) {
                            
                            // 3，不可能3压3
                            
                        } else if (num >= 4 && num <= 7) {
                            
                            // 4，不用判断是否与我出的牌一样，肯定不一样，只需要判断4张牌是否一样大
                            if (forth >= 4 && forth <= 7) { // 最大的一个都是4，说明是炸，压
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<4; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = forth;
                                        [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==2) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    [array removeObject:@(forth)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else { // 不是炸，压不起
                                
                                continue;
                            }
                            
                        } else if (num >= 8 && num <= 11) {
                            
                            // 5，但需要判断4张牌是否一样大
                            if (forth >= 8 && forth <= 11) { // 炸，压
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<4; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = forth;
                                        [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==2) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    [array removeObject:@(forth)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                                
                            } else { // 不是炸，压不起
                                
                                continue;
                            }
                            
                            
                        } else if (num >= 52) {
                            
                            // 只有两张王可以压
                            if (next >= 52) { // 火箭
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<4; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = forth;
                                        [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==2) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    [array removeObject:@(forth)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else {
                                continue;
                            }
                            
                        } else {
                            
                            // 只需要判断4张牌是否一样
                            if (forth/4+3 == num/4+3) { // 是炸，压
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                // 根据num创建出牌按钮
                                for (NSInteger i = 0; i<4; i++) {
                                    
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i==0) {
                                        button.tag = forth;
                                        [button setImage:self.cardArray[forth] forState:UIControlStateNormal];
                                    } else if (i==1) {
                                        button.tag = three;
                                        [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                    } else if (i==2) {
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    [array removeObject:@(three)];
                                    [array removeObject:@(forth)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else { // 不是炸，压不起
                                
                                continue;
                            }
                        }
                    }
                }
                
                [self nong2BuYao];
                
                
            } else { // 三带一
                
                NSInteger smallestSingle;
                
                GXFLog(@"%@", self.arrayNong1);
                
                // 遍历农民2
                // 如果next = -1， num最大，如果three = -1，next最大
                for (NSInteger i = array.count - 1; i>=0; i--) {
                    NSInteger num = [array[i] integerValue];
                    NSInteger next;
                    NSInteger three = 0;
                    NSInteger forth = 0;
                    if (i != 0) {
                        
                        next = [array[i-1] integerValue];
                    } else {
                        // num已是最大
                        next = -888;
                        
                    }
                    //            next = [self.arrayNong1[i-1] integerValue];
                    
                    if (i>=2) {
                        three = [array[i-2] integerValue];
                    } else {
                        //                if (next == -1) {
                        //                    // num是最大
                        //                    three = 777;
                        //                } else {
                        //                    // next是最大
                        //                    three = 777;
                        //                }
                        
                        three = -777;
                    }
                    
                    if (i>=3) {
                        forth = [array[i-3] integerValue];
                    } else {
                        forth = -222;
                    }
                    
                    GXFLog(@"%zd %zd", num, next);
#warning - 这里就不能根据第一个来判断了，需要找到三张一样大的那个来和我出的三带一中三张一样大的比较
                    // 找到我出的牌中三张一样大的牌
                    NSInteger ThreeButtonTag;
                    if (descUpArray[0] == descUpArray[1]) { // 第一个就是三张一样的牌，button不变
                        ThreeButtonTag = [descUpArray[0] integerValue]; // 这里的ThreeButtonTag即是传入的foreNum
                        
                    } else { // 第二个是三张一样的牌
                        
                        ThreeButtonTag = [descUpArray[1] integerValue]; // 这里的ThreeButtonTag即是传入的foreNum
                    }
                    
                    // 找到跟牌中三张一样大的牌，来做比较
                    
                    if (num > ThreeButtonTag) {
                        
                        if (num < 4) {
                            
                            // 3，三带一不可能走到这里
                            
                        } else if (num >= 4 && num <= 7) {
                            
                            // 4，需要判断next、three是否是4
                            if (next >= 4 && next <= 7) { // next也是4，说明有两张4了，再看three是不是4，如果是4，则就有三带一，可以压，但是还得看是不是一炸，即forth是不是4，forth是4不压，forth不是4才压
                                if (three >= 4 && three <= 7) { // 三张一样的，是三带一，压
                                    if (forth >= 4 && forth <= 7) { // 是炸，不压
                                        continue;
                                    } else {
                                        
                                        // 农民2跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        // 根据num创建出牌按钮
                                        for (NSInteger i = 0; i<4; i++) {
                                            
                                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                            if (i==0) {
                                                button.tag = three;
                                                [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                            } else if (i==1) {
                                                button.tag = next;
                                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                            } else if (i==2) {
                                                button.tag = num;
                                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                            } else {
#warning - 这里的第4个牌不再是forth，而是从单牌中找到最小的
                                                // 需要先把三张一样的牌移除
                                                [array removeObject:@(num)];
                                                [array removeObject:@(next)];
                                                [array removeObject:@(three)];
                                                NSInteger smallestSingle = [self findSmallestSingleInArray:array];
                                                button.tag = smallestSingle;
                                                [button setImage:self.cardArray[smallestSingle] forState:UIControlStateNormal];
                                            }
                                            [self.view addSubview:button];
                                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                            [self.nong2ChuArray addObject:button];
                                            
                                        }
                                        // 设置2旁的数字
                                        if (self.nong2ChuArray.count > 0) {
                                            self.nong2Num -= self.nong2ChuArray.count;
                                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                        }
                                        
                                        // 动画到桌面
                                        [UIView animateWithDuration:0.8 animations:^{
                                            
                                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                            for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                                
                                                GXFButton *button = self.nong2ChuArray[i];
                                                CGRect rect = button.frame;
                                                button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                            }
                                            
                                            self.foreNum = num;
                                            [array removeObject:@(num)];
                                            [array removeObject:@(next)];
                                            [array removeObject:@(three)];
                                            [array removeObject:@(smallestSingle)];
                                            
                                        } completion:^(BOOL finished) {
                                            
                                            // 移除计时器
                                            [self.jishiView removeFromSuperview];
                                            
                                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                            // 移除自己的出牌
                                            for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                                
                                                GXFButton *button = self.selfChuArray[i];
                                                [button removeFromSuperview];
                                            }
                                            self.selfChuArray = nil;
                                            
                                            // 显示不出、提示、出牌按钮
                                            for (NSInteger i = 0; i<3; i++) {
                                                
                                                if (i == 2) {
                                                    [self.selectView addSubview:self.chuButton];
                                                    if (self.chuButton.selected == YES) {
                                                        self.chuButton.userInteractionEnabled = NO;
                                                    }
                                                    
                                                } else if (i == 1) {
                                                    
                                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                    [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                                    [self.selectView addSubview:button];
                                                    [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                                    
                                                } else if (i == 0) {
                                                    
                                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                    [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                                    [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                                    [self.selectView addSubview:button];
                                                    [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                                }
                                            }
                                            
                                            [self viewDidLayoutSubviews];
                                        }];
                                        self.upArray = self.nong2ChuArray;
                                        //                                break;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            if (self.nong2Num <= 0) {
                                                [self loadFail];
                                            } else if (self.nong2Num == 2) {
                                                [self ShengYinXiaoWithNum:2];
                                            } else if (self.nong2Num == 1) {
                                                [self ShengYinXiaoWithNum:1];
                                            }
                                        });
                                        return;
                                        
                                    }
                                    
                                } else { // 没有三带一，继续遍历
                                    continue;
                                }
                                
                                
                            } else { // next不是4，说明没有三带一，继续往下遍历
                                continue;
                            }
                            
                        } else if (num >= 8 && num <= 11) {
                            
                            // 5，需要判断next、three是否是5
                            if (next >= 8 && next <= 11) { // next也是5，说明有两张5了，再看three是不是5，如果是5，则就有三带一，可以压，但是还得看是不是一炸，即forth是不是5，forth是5不压，forth不是5才压
                                if (three >= 4 && three <= 7) { // 三张一样的，是三带一，压
                                    if (forth >= 4 && forth <= 7) { // 是炸，不压
                                        continue;
                                    } else {
                                        
                                        // 农民2跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        // 根据num创建出牌按钮
                                        for (NSInteger i = 0; i<4; i++) {
                                            
                                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                            if (i==0) {
                                                button.tag = three;
                                                [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                            } else if (i==1) {
                                                button.tag = next;
                                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                            } else if (i==2) {
                                                button.tag = num;
                                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                            } else {
#warning - 这里的第4个牌不再是forth，而是从单牌中找到最小的
                                                // 需要先把三张一样的牌移除
                                                [array removeObject:@(num)];
                                                [array removeObject:@(next)];
                                                [array removeObject:@(three)];
                                                NSInteger smallestSingle = [self findSmallestSingleInArray:array];
                                                button.tag = smallestSingle;
                                                [button setImage:self.cardArray[smallestSingle] forState:UIControlStateNormal];
                                            }
                                            [self.view addSubview:button];
                                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                            [self.nong2ChuArray addObject:button];
                                            
                                        }
                                        // 设置2旁的数字
                                        if (self.nong2ChuArray.count > 0) {
                                            self.nong2Num -= self.nong2ChuArray.count;
                                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                        }
                                        
                                        // 动画到桌面
                                        [UIView animateWithDuration:0.8 animations:^{
                                            
                                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                            for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                                
                                                GXFButton *button = self.nong2ChuArray[i];
                                                CGRect rect = button.frame;
                                                button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                            }
                                            
                                            self.foreNum = num;
                                            [array removeObject:@(num)];
                                            [array removeObject:@(next)];
                                            [array removeObject:@(three)];
                                            [array removeObject:@(smallestSingle)];
                                            
                                        } completion:^(BOOL finished) {
                                            
                                            // 移除计时器
                                            [self.jishiView removeFromSuperview];
                                            
                                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                            // 移除自己的出牌
                                            for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                                
                                                GXFButton *button = self.selfChuArray[i];
                                                [button removeFromSuperview];
                                            }
                                            self.selfChuArray = nil;
                                            
                                            // 显示不出、提示、出牌按钮
                                            for (NSInteger i = 0; i<3; i++) {
                                                
                                                if (i == 2) {
                                                    [self.selectView addSubview:self.chuButton];
                                                    if (self.chuButton.selected == YES) {
                                                        self.chuButton.userInteractionEnabled = NO;
                                                    }
                                                    
                                                } else if (i == 1) {
                                                    
                                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                    [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                                    [self.selectView addSubview:button];
                                                    [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                                    
                                                } else if (i == 0) {
                                                    
                                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                    [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                                    [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                                    [self.selectView addSubview:button];
                                                    [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                                }
                                            }
                                            
                                            [self viewDidLayoutSubviews];
                                        }];
                                        self.upArray = self.nong2ChuArray;
                                        //                                break;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            if (self.nong2Num <= 0) {
                                                [self loadFail];
                                            } else if (self.nong2Num == 2) {
                                                [self ShengYinXiaoWithNum:2];
                                            } else if (self.nong2Num == 1) {
                                                [self ShengYinXiaoWithNum:1];
                                            }
                                        });
                                        return;
                                        
                                    }
                                    
                                } else { // 没有三带一，继续遍历
                                    continue;
                                }
                                
                                
                            } else { // next不是4，说明没有三带一，继续往下遍历
                                continue;
                            }
                            
                        } else if (num >= 52) {
                            
                            // 只有两张王可以压
                            if (next >= 52) { // 火箭
                                
                                // 农民2跟牌音效
                                NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                [self playYinXiaoWithFileName:name];
                                // 改变pang数字
                                self.nong2Num -= self.nong2ChuArray.count;
                                [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                
                                for (NSInteger i = 0; i<2; i++) {
                                    GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                    if (i == 0) {
                                        
                                        button.tag = next;
                                        [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                    } else {
                                        button.tag = num;
                                        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                    }
                                    [self.view addSubview:button];
                                    button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                    [self.nong2ChuArray addObject:button];
                                    
                                }
                                // 设置2旁的数字
                                if (self.nong2ChuArray.count > 0) {
                                    self.nong2Num -= self.nong2ChuArray.count;
                                    [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                }
                                
                                // 动画到桌面
                                [UIView animateWithDuration:0.8 animations:^{
                                    
                                    //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                    for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                        
                                        GXFButton *button = self.nong2ChuArray[i];
                                        CGRect rect = button.frame;
                                        button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                    }
                                    
                                    self.foreNum = num;
                                    [array removeObject:@(num)];
                                    [array removeObject:@(next)];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    // 移除计时器
                                    [self.jishiView removeFromSuperview];
                                    
                                    [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                    // 移除自己的出牌
                                    for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                        
                                        GXFButton *button = self.selfChuArray[i];
                                        [button removeFromSuperview];
                                    }
                                    self.selfChuArray = nil;
                                    
                                    // 显示不出、提示、出牌按钮
                                    for (NSInteger i = 0; i<3; i++) {
                                        
                                        if (i == 2) {
                                            [self.selectView addSubview:self.chuButton];
                                            if (self.chuButton.selected == YES) {
                                                self.chuButton.userInteractionEnabled = NO;
                                            } else {
                                                self.chuButton.userInteractionEnabled = YES;
                                            }
                                            
                                        } else if (i == 1) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                        } else if (i == 0) {
                                            
                                            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                            [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                            [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                            [self.selectView addSubview:button];
                                            [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                        }
                                    }
                                    
                                    [self viewDidLayoutSubviews];
                                }];
                                self.upArray = self.nong2ChuArray;
                                //                                break;
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    if (self.nong2Num <= 0) {
                                        [self loadFail];
                                    } else if (self.nong2Num == 2) {
                                        [self ShengYinXiaoWithNum:2];
                                    } else if (self.nong2Num == 1) {
                                        [self ShengYinXiaoWithNum:1];
                                    }
                                });
                                return;
                                
                            } else {
                                continue;
                            }
                            
                        } else {
                            
                            // 5，需要判断next、three是否和num一样大
                            if (num/4+3 == next/4+3) { // next和num一样大，说明有两张一样大的了，再看three是不是和num一样大，如果一样大，则就有三带一，可以压，但是还得看是不是一炸，即forth是不是和num一样大，一样大是炸不压，不一样大才压
                                if (three/4+3 == num/4+3) { // 三张一样的，是三带一，压
                                    if (forth/4+3 == num/4+3) { // 是炸，不压
                                        continue;
                                    } else {
                                        
                                        // 农民2跟牌音效
                                        NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
                                        [self playYinXiaoWithFileName:name];
                                        
                                        // 根据num创建出牌按钮
                                        for (NSInteger i = 0; i<4; i++) {
                                            
                                            GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
                                            if (i==0) {
                                                button.tag = three;
                                                [button setImage:self.cardArray[three] forState:UIControlStateNormal];
                                            } else if (i==1) {
                                                button.tag = next;
                                                [button setImage:self.cardArray[next] forState:UIControlStateNormal];
                                            } else if (i==2) {
                                                button.tag = num;
                                                [button setImage:self.cardArray[num] forState:UIControlStateNormal];
                                            } else {
#warning - 这里的第4个牌不再是forth，而是从单牌中找到最小的
                                                // 需要先把三张一样的牌移除
                                                [array removeObject:@(num)];
                                                [array removeObject:@(next)];
                                                [array removeObject:@(three)];
                                                NSInteger smallestSingle = [self findSmallestSingleInArray:array];
                                                button.tag = smallestSingle;
                                                [button setImage:self.cardArray[smallestSingle] forState:UIControlStateNormal];
                                            }
                                            [self.view addSubview:button];
                                            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
                                            [self.nong2ChuArray addObject:button];
                                            
                                        }
                                        // 设置2旁的数字
                                        if (self.nong2ChuArray.count > 0) {
                                            self.nong2Num -= self.nong2ChuArray.count;
                                            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
                                        }
                                        
                                        // 动画到桌面
                                        [UIView animateWithDuration:0.8 animations:^{
                                            
                                            //                                button.transform = CGAffineTransformMakeTranslation(-20, 20);
                                            for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                                                
                                                GXFButton *button = self.nong2ChuArray[i];
                                                CGRect rect = button.frame;
                                                button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
                                            }
                                            
                                            self.foreNum = num;
                                            [array removeObject:@(num)];
                                            [array removeObject:@(next)];
                                            [array removeObject:@(three)];
                                            [array removeObject:@(smallestSingle)];
                                            
                                        } completion:^(BOOL finished) {
                                            
                                            // 移除计时器
                                            [self.jishiView removeFromSuperview];
                                            
                                            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
                                            // 移除自己的出牌
                                            for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                                                
                                                GXFButton *button = self.selfChuArray[i];
                                                [button removeFromSuperview];
                                            }
                                            self.selfChuArray = nil;
                                            
                                            // 显示不出、提示、出牌按钮
                                            for (NSInteger i = 0; i<3; i++) {
                                                
                                                if (i == 2) {
                                                    [self.selectView addSubview:self.chuButton];
                                                    if (self.chuButton.selected == YES) {
                                                        self.chuButton.userInteractionEnabled = NO;
                                                    }
                                                    
                                                } else if (i == 1) {
                                                    
                                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                    [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                                                    [self.selectView addSubview:button];
                                                    [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                                    
                                                } else if (i == 0) {
                                                    
                                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                    [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                                                    [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                                                    [self.selectView addSubview:button];
                                                    [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                                }
                                            }
                                            
                                            [self viewDidLayoutSubviews];
                                        }];
                                        self.upArray = self.nong2ChuArray;
                                        //                                break;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            if (self.nong2Num <= 0) {
                                                [self loadFail];
                                            } else if (self.nong2Num == 2) {
                                                [self ShengYinXiaoWithNum:2];
                                            } else if (self.nong2Num == 1) {
                                                [self ShengYinXiaoWithNum:1];
                                            }
                                        });
                                        return;
                                        
                                    }
                                    
                                } else { // three和num不一样大，继续遍历
                                    continue;
                                }
                                
                                
                            } else { // next和num不一样大，继续遍历
                                continue;
                            }
                            
                        }
                    }
                }
                
                [self nong2BuYao];
                
            }
            
        }
        
    }
    
}

- (NSMutableArray *)nong1ChuArray {
    
    if (!_nong1ChuArray) {
        _nong1ChuArray = [NSMutableArray array];
    }
    return _nong1ChuArray;
}

- (NSMutableArray *)nong2ChuArray {
    
    if (!_nong2ChuArray) {
        _nong2ChuArray = [NSMutableArray array];
    }
    return _nong2ChuArray;
}

- (NSMutableArray *)selfChuArray {
    
    if (!_selfChuArray) {
        _selfChuArray = [NSMutableArray array];
    }
    return _selfChuArray;
}

- (UIImageView *)jishiView {
    
    if (!_jishiView) {
        _jishiView = [UIImageView new];
        _jishiView.image = [UIImage imageNamed:@"ring"];
    }
    return _jishiView;
}

- (void)pop_animationDidStart:(POPAnimation *)anim {
    
//    [GXFPlayerManager playYinXiaoWithFileName:@"card_send_over.mp3"];
}

- (void)rotateDipaiAndMoveToTop {
    
    // 对diPaiView进行动画
    for (UIImageView *imageView in self.diPai3View.subviews) {
        
//        if (imageView.tag > 99 && imageView.tag < 103) {
        
            // 3D旋转
            [UIView animateWithDuration:1.0 animations:^{
                
                imageView.layer.transform = CATransform3DRotate(imageView.layer.transform, M_PI_2, 0, 1, 0);
            } completion:^(BOOL finished) {
                
                // 设置为3张底牌
                NSInteger num =[self.array2[imageView.tag - 100] integerValue];
                imageView.image = self.cardArray[num];
                
                // 旋转正
                [UIView animateWithDuration:1.0 animations:^{
                    
                    imageView.layer.transform = CATransform3DRotate(imageView.layer.transform, M_PI_2, 0, -1, 0);
                } completion:^(BOOL finished) {
                    
                    // 缩小同时移动到顶部
                    [UIView animateWithDuration:1.0 animations:^{
                        
                        CGFloat distance = self.fenView.frame.origin.y + imageView.bounds.size.height * 0.5 * (1-0.3);
                        if (imageView.tag == 100) {
                            imageView.layer.transform = CATransform3DTranslate(imageView.layer.transform, 40, -distance, 0);
                        } else if (imageView.tag == 101) {
                            imageView.layer.transform = CATransform3DTranslate(imageView.layer.transform, 0, -distance, 0);
                        } else if (imageView.tag == 102) {
                            imageView.layer.transform = CATransform3DTranslate(imageView.layer.transform, -40, -distance, 0);
                        }
                        imageView.layer.transform = CATransform3DScale(imageView.layer.transform, 0.3, 0.3, 0.3);
                        
                    }];
                }];
                
            }];
        }
//    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.settingView.hidden = YES;
    [self.veView removeFromSuperview];
    
    // 所有的up牌下去
    [self.paiView downAll];
//    for (NSInteger i = 0; i<self.paiView.subviews.count; i++) {
//        for (NSInteger j = 0; j<self.paiView.upArray.count; j++) {
//            
//            if (self.paiView.upArray[j] == self.paiView.subviews[i]) {
//                GXFButton *button = self.paiView.subviews[i];
//                [self.paiView cardButtonClick:button];
//            }
//        }
//        
//    }
    
    // 改变出牌按钮状态
    if (self.chuButton.selected == NO) {
        
        self.chuButton.selected = !self.chuButton.selected;
    }
    if (self.chuButton.selected == YES) {
        self.chuButton.userInteractionEnabled = NO;
    }
    
}

- (void)saveCard:(UIImage *)card withKey:(NSUInteger)key {
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:card forKey:[NSString stringWithFormat:@"%zd", key]];
    
    NSData *data = UIImagePNGRepresentation(card);
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%zd", key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%zd", key);
}

- (void)paiViewWantToChangeChuButtonStateWithState:(BOOL)state {
    
    if (state) {
        
        self.chuButton.selected = NO;
        self.chuButton.userInteractionEnabled = YES;
        if (self.chuButton.selected == YES) {
            self.chuButton.userInteractionEnabled = NO;
        } else {
            self.chuButton.userInteractionEnabled = YES;
        }
        
    } else {
        
        self.chuButton.selected = YES;
        // 让灰色按钮不可点击
        self.chuButton.userInteractionEnabled = NO;
        if (self.chuButton.selected == YES) {
            self.chuButton.userInteractionEnabled = NO;
        } else {
            self.chuButton.userInteractionEnabled = YES;
        }
    }
}

//- (UIImageView *)duihuaViewZuo {
//    
//    if (!_duihuaViewZuo) {
//        _duihuaViewZuo = [UIImageView new];
//        _duihuaViewZuo.image = [UIImage imageNamed:@"duihuazuo"];
//        self.duihuaContentView = [UIImageView new];
//    }
//    return _duihuaViewZuo;
//}

//- (UIImageView *)duihuaViewYou {
//    
//    if (!_duihuaViewYou) {
//        _duihuaViewYou = [UIImageView new];
//        _duihuaViewYou.image = [UIImage imageNamed:@"duihuayou"];
//    }
//    return _duihuaViewYou;
//}

//- (UIImageView *)duihuaContentView {
//    
//    if (!_duihuaContentView) {
//        _duihuaContentView = [UIImageView new];
//    }
//    return _duihuaContentView;
//}

- (void)where:(NSString *)where addDuiHuaWithImageName:(NSString *)imageName isBigger:(BOOL)isbigger {
    
    if (isbigger == YES) {
        
        if ([where isEqualToString:@"wo"]) {
            if (imageName) {
                
                self.duihuaViewZuo1 = [UIImageView new];
                self.duihuaViewZuo1.image = [UIImage imageNamed:@"duihuazuo"];
                [self.view addSubview:self.duihuaViewZuo1];
                [self.duihuaViewZuo1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.leftBottomView.mas_right);
                    make.top.equalTo(self.leftBottomView).offset(7);
                    make.width.mas_equalTo(58);
                    make.height.mas_equalTo(48);
                }];
                self.duihuaContentView1 = [UIImageView new];
                self.duihuaContentView1.image = [UIImage imageNamed:imageName];
                [self.view addSubview:self.duihuaContentView1];
                [self.duihuaContentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.duihuaViewZuo1);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(20);
                }];
            }
        } else if ([where isEqualToString:@"nong1"]) {
            if (imageName) {
                
                self.duihuaViewYou = [UIImageView new];
                self.duihuaViewYou.image = [UIImage imageNamed:@"duihuayou"];
                [self.view addSubview:self.duihuaViewYou];
                [self.duihuaViewYou mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.rightView.mas_left);
                    make.top.equalTo(self.rightView).offset(7);
                    make.width.mas_equalTo(58);
                    make.height.mas_equalTo(48);
                }];
                self.duihuaContentView2 = [UIImageView new];
                self.duihuaContentView2.image = [UIImage imageNamed:imageName];
                [self.view addSubview:self.duihuaContentView2];
                [self.duihuaContentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.duihuaViewYou);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(20);
                }];
            }
            
        } else {
            if (imageName) {
                self.duihuaViewZuo2 = [UIImageView new];
                self.duihuaViewZuo2.image = [UIImage imageNamed:@"duihuazuo"];
                [self.view addSubview:self.duihuaViewZuo2];
                [self.duihuaViewZuo2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.leftTopView.mas_right);
                    make.top.equalTo(self.leftTopView).offset(7);
                    make.width.mas_equalTo(58);
                    make.height.mas_equalTo(48);
                }];
                self.duihuaContentView3 = [UIImageView new];
                self.duihuaContentView3.image = [UIImage imageNamed:imageName];
                [self.view addSubview:self.duihuaContentView3];
                [self.duihuaContentView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.duihuaViewZuo2);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(20);
                }];
            }
        }
        
        // 放大头像和对话框
        [UIView animateWithDuration:1.0 animations:^{
            if ([where isEqualToString:@"wo"]) {
                self.leftBottomView.transform = CGAffineTransformScale(self.leftBottomView.transform, 1.5, 1.5);
                self.duihuaViewZuo1.transform = CGAffineTransformScale(self.duihuaViewZuo1.transform, 1.5, 1.5);
                self.duihuaViewZuo1.transform = CGAffineTransformTranslate(self.duihuaViewZuo1.transform, (self.leftBottomView.bounds.size.width + self.duihuaViewZuo1.bounds.size.width) * 0.25, 0);
                self.duihuaContentView1.transform = CGAffineTransformScale(self.duihuaContentView1.transform, 1.5, 1.5);
                self.duihuaContentView1.transform = CGAffineTransformTranslate(self.duihuaContentView1.transform, (self.leftBottomView.bounds.size.width + self.duihuaContentView1.bounds.size.width) * 0.25, 0);
            } else if ([where isEqualToString:@"nong1"]) {
                
                self.rightView.transform = CGAffineTransformScale(self.rightView.transform, 1.5, 1.5);
                self.duihuaViewYou.transform = CGAffineTransformScale(self.duihuaViewYou.transform, 1.5, 1.5);
                self.duihuaViewYou.transform = CGAffineTransformTranslate(self.duihuaViewYou.transform, -(self.rightView.bounds.size.width + self.duihuaViewYou.bounds.size.width) * 0.25, 0);
                self.duihuaContentView2.transform = CGAffineTransformScale(self.duihuaContentView2.transform, 1.5, 1.5);
                self.duihuaContentView2.transform = CGAffineTransformTranslate(self.duihuaContentView2.transform, -(self.rightView.bounds.size.width + self.duihuaContentView2.bounds.size.width) * 0.25, 0);
            } else {
                
                self.leftTopView.transform = CGAffineTransformScale(self.leftTopView.transform, 1.5, 1.5);
                self.duihuaViewZuo2.transform = CGAffineTransformScale(self.duihuaViewZuo2.transform, 1.5, 1.5);
                self.duihuaViewZuo2.transform = CGAffineTransformTranslate(self.duihuaViewZuo2.transform, (self.rightView.bounds.size.width + self.duihuaViewZuo2.bounds.size.width) * 0.25, 0);
                self.duihuaContentView3.transform = CGAffineTransformScale(self.duihuaContentView3.transform, 1.5, 1.5);
                self.duihuaContentView3.transform = CGAffineTransformTranslate(self.duihuaContentView3.transform, (self.leftTopView.bounds.size.width + self.duihuaContentView3.bounds.size.width) * 0.25, 0);
            }
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{
                
                self.leftBottomView.transform = CGAffineTransformIdentity;
                self.leftTopView.transform = CGAffineTransformIdentity;
                self.rightView.transform = CGAffineTransformIdentity;
                self.duihuaViewZuo1.transform = CGAffineTransformIdentity;
                self.duihuaViewZuo2.transform = CGAffineTransformIdentity;
                self.duihuaViewYou.transform = CGAffineTransformIdentity;
                self.duihuaContentView1.transform = CGAffineTransformIdentity;
                self.duihuaContentView2.transform = CGAffineTransformIdentity;
                self.duihuaContentView3.transform = CGAffineTransformIdentity;
            }];
        }];
        
        // 一定时间后消失3分对话框
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.duihuaViewZuo1 removeFromSuperview];
            [self.duihuaViewZuo2 removeFromSuperview];
            [self.duihuaViewYou removeFromSuperview];
            [self.duihuaContentView1 removeFromSuperview];
            [self.duihuaContentView2 removeFromSuperview];
            [self.duihuaContentView3 removeFromSuperview];
        });
        
    } else {
        
        if ([where isEqualToString:@"wo"]) {
            self.duihuaViewZuo1 = [UIImageView new];
            self.duihuaViewZuo1.image = [UIImage imageNamed:@"duihuazuo"];
            [self.view addSubview:self.duihuaViewZuo1];
            [self.duihuaViewZuo1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftBottomView.mas_right);
                make.top.equalTo(self.leftBottomView).offset(7);
                make.width.mas_equalTo(58);
                make.height.mas_equalTo(48);
            }];
            self.duihuaContentView1 = [UIImageView new];
            self.duihuaContentView1.image = [UIImage imageNamed:imageName];
            [self.view addSubview:self.duihuaContentView1];
            [self.duihuaContentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.duihuaViewZuo1);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(20);
            }];
        } else if ([where isEqualToString:@"nong1"]) {
            
            self.duihuaViewYou = [UIImageView new];
            self.duihuaViewYou.image = [UIImage imageNamed:@"duihuayou"];
            [self.view addSubview:self.duihuaViewYou];
            [self.duihuaViewYou mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.rightView.mas_left);
                make.top.equalTo(self.rightView).offset(7);
                make.width.mas_equalTo(58);
                make.height.mas_equalTo(48);
            }];
            self.duihuaContentView2 = [UIImageView new];
            self.duihuaContentView2.image = [UIImage imageNamed:imageName];
            [self.view addSubview:self.duihuaContentView2];
            [self.duihuaContentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.duihuaViewYou);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(20);
            }];
            
        } else {
            
            self.duihuaViewZuo2 = [UIImageView new];
            self.duihuaViewZuo2.image = [UIImage imageNamed:@"duihuazuo"];
            [self.view addSubview:self.duihuaViewZuo2];
            [self.duihuaViewZuo2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTopView.mas_right);
                make.top.equalTo(self.leftTopView).offset(7);
                make.width.mas_equalTo(58);
                make.height.mas_equalTo(48);
            }];
            self.duihuaContentView3 = [UIImageView new];
            self.duihuaContentView3.image = [UIImage imageNamed:imageName];
            [self.view addSubview:self.duihuaContentView3];
            [self.duihuaContentView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.duihuaViewZuo2);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(20);
            }];
        }
        
        // 1s后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.duihuaViewZuo1 removeFromSuperview];
            [self.duihuaViewZuo2 removeFromSuperview];
            [self.duihuaViewYou removeFromSuperview];
            [self.duihuaContentView1 removeFromSuperview];
            [self.duihuaContentView2 removeFromSuperview];
            [self.duihuaContentView3 removeFromSuperview];
        });
    }
    
}

- (void)ShengYinXiaoWithNum:(NSInteger)num{
    if (num == 2) {
        NSInteger temp = 0; //arc4random_uniform(2);
        if (temp == 0) {
            
            [[GXFPlayYinXiao new] playYinXiaoWithFileName:@"card_last_2_M.mp3"];
        } else {
            [[GXFPlayYinXiao new] playYinXiaoWithFileName:@"card_last_2_W.mp3"];
        }
    } else {
        NSInteger temp = 0; //arc4random_uniform(2);
        if (temp == 0) {
            
            [[GXFPlayYinXiao new] playYinXiaoWithFileName:@"card_last_1_M.mp3"];
        } else {
            [[GXFPlayYinXiao new] playYinXiaoWithFileName:@"card_last_1_W.mp3"];
        }
    }
}

- (void)nong1AutoChuWithArray:(NSArray *)array {
    
    if ([array isEqualToArray:self.arrayNong1]) {
        
        [self.nong1ChuArray removeAllObjects];
    } else {
        [self.nong2ChuArray removeAllObjects];
    }
    // 把array降序
    NSArray *arraytemp = [self sortDescWithArray:array];
    
    NSInteger last = [arraytemp.lastObject integerValue];
    NSInteger second = 0;
    NSInteger three = 0;
    if (arraytemp.count>=2) {
        
        NSInteger temp = arraytemp.count - 2;
        second = [arraytemp[temp] integerValue];
    }
    if (arraytemp.count>=3) {
        
        NSInteger temp2 = arraytemp.count - 3;
        three = [arraytemp[temp2] integerValue];
    }
    
    if (last < 4) {
        // 3
        if (second < 4 && second != 0) { // 出对，也可能出三带一，或者三个
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), @(second), nil];
//            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
            if (three >= 4) { // 出对
                
                
            } else { // 出三带一或者三个
                
            }
            
            
        } else { // 出单
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
        }
        
    } else if (last >= 4 && last <= 7) {
        
        // 4
        if (second >= 4 && second <= 7) { // 出对，也可能出三带一，或者三个
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), @(second), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
            if (three > 7) { // 出对
                
            } else { // 出三带一或者三个
                
            }
            
            
        } else { // 出单
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
        }
        
    } else if (last >= 8 && last <= 11) {
        
        // 5
        if (second <= 8 && second <= 11) { // 出对，也可能出三带一，或者三个
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), @(second), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
            if (three > 11) { // 出对
                
            } else { // 出三带一或者三个
                
            }
            
            
        } else { // 出单
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
        }
        
    } else if (last >= 52) {
        
        
        
    } else {
        
        // i / 4 + 3;
        if (second / 4 + 3 == last / 4 + 3) { // 出对，也可能出三带一，或者三个
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), @(second), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
            if (three != last / 4 + 3) { // 出对
                
            } else { // 出三带一或者三个
                
            }
            
            
        } else { // 出单
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:@(last), nil];
            //            [self nong1ChuWithNumArray:array];
            if ([array isEqualToArray:self.arrayNong1]) {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"1"];
            } else {
                [self nong1ChuWithNumArray:arrayTemp identifier:@"2"];
            }
        }
    }
}

- (void)nong1ChuWithNumArray:(NSArray *)numArray identifier:(NSString *)identifier {
    
    self.upArray = nil;
    for (NSInteger i = 0; i<numArray.count; i++) {
        GXFButton *button = [GXFButton new];
        button.tag = [numArray[i] integerValue];
        [self.upArray addObject:button];
    }
    
    NSInteger num = 0;
    if ([identifier isEqualToString:@"1"]) {
        [self.nong1ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nong1ChuArray = nil;
    } else {
        [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nong2ChuArray = nil;
    }
    
    for (NSInteger i = 0; i<numArray.count; i++) {
        
        num = [numArray[i] integerValue];
        
        // 根据num创建出牌按钮
        GXFButton *button = [GXFButton buttonWithType:UIButtonTypeCustom];
        button.tag = num;
        [button setImage:self.cardArray[num] forState:UIControlStateNormal];
        [self.view addSubview:button];
        if ([identifier isEqualToString:@"1"]) {
            
            button.frame = CGRectMake(self.rightPangButton.frame.origin.x + 10 + i*8, self.rightPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
            [self.nong1ChuArray addObject:button];
        } else {
            button.frame = CGRectMake(self.leftPangButton.frame.origin.x - 10 + i*8, self.leftPangButton.frame.origin.y, 60 * 0.3, 80 * 0.3);
            [self.nong2ChuArray addObject:button];
        }
        
    }
    
    // 农民1跟牌音效
//    NSString *name = [NSString stringWithFormat:@"card_dani_M_%zd.mp3", arc4random_uniform(3) + 1];
//    [self playYinXiaoWithFileName:name];
    if ([identifier isEqualToString:@"1"]) {
        
        [self.paiView chuPaiSoundWithArray:self.nong1ChuArray];
        self.upArray = nil;
        self.upArray = self.nong1ChuArray;
        
    } else {
        
        [self.paiView chuPaiSoundWithArray:self.nong2ChuArray];
        self.upArray = nil;
        self.upArray = self.nong2ChuArray;
    }
    
    // 动画到桌面
    [UIView animateWithDuration:0.8 animations:^{
        
        // 改变pang数字
        if ([identifier isEqualToString:@"1"]) {
            self.nong1Num -= self.nong1ChuArray.count;
            [self.rightPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong1Num] forState:UIControlStateNormal];
            
            for (NSInteger i = 0; i<self.nong1ChuArray.count; i++) {
                
                GXFButton *button = self.nong1ChuArray[i];
                CGRect rect = button.frame;
                button.frame = CGRectMake(rect.origin.x - 50 + i*8, rect.origin.y + 30, rect.size.width * 0.7/0.3, rect.size.height*0.7/0.3);
            }
            
#warning 用于农民2压
            self.foreNum = num;
#warning 如果是提示，再次touchesBegin的话，num就没有了，所以需要在touchesBegain中添加num
            [self.arrayNong1 removeObjectsInArray:numArray];
            
        } else {
            
            self.nong2Num -= self.nong2ChuArray.count;
            [self.leftPangButton setTitle:[NSString stringWithFormat:@"%zd", self.nong2Num] forState:UIControlStateNormal];
            
            for (NSInteger i = 0; i<self.nong2ChuArray.count; i++) {
                
                GXFButton *button = self.nong2ChuArray[i];
                CGRect rect = button.frame;
                button.frame = CGRectMake(rect.origin.x + 40 + i * 10, rect.origin.y + 30, rect.size.width*0.7/0.3, rect.size.height*0.7/0.3);
            }
            
#warning 用于农民2压
            self.foreNum = num;
#warning 如果是提示，再次touchesBegin的话，num就没有了，所以需要在touchesBegain中添加num
            [self.arrayNong2 removeObjectsInArray:numArray];
        }
        
        
    } completion:^(BOOL finished) {
        
        if ([identifier isEqualToString:@"1"]) {
            
            if (self.nong1Num <= 0) {
                [self loadFail];
            } else if (self.nong1Num == 2) {
                [self ShengYinXiaoWithNum:2];
            } else if (self.nong1Num == 1) {
                [self ShengYinXiaoWithNum:1];
            }
            // 计时器移到农民2
            [self.jishiView removeFromSuperview];
            [self.view addSubview:self.jishiView];
            [self.jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftPangButton.mas_right).offset(5);
                make.centerY.equalTo(self.rightPangButton);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(21);
            }];
            
            // 隐藏农民2的出牌
            if (self.nong2ChuArray.count > 0) {
                
                [self.nong2ChuArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.nong2ChuArray = nil;
            }
            
            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
            
            // 等1s让农民2跟牌
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self genPai2WithArray:self.arrayNong2 foreNum:self.foreNum identifier:YES];
            });
            
        } else {
            // 移除计时器
            [self.jishiView removeFromSuperview];
            
            [self playYinXiaoWithFileName:@"card_send_over.mp3"];
            // 移除自己的出牌
            for (NSInteger i = 0; i<self.selfChuArray.count; i++) {
                
                GXFButton *button = self.selfChuArray[i];
                [button removeFromSuperview];
            }
            self.selfChuArray = nil;
            
            // 显示不出、提示、出牌按钮
            [self.selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (NSInteger i = 0; i<3; i++) {
                GXFLog(@"dddddd");
                if (i == 2) {
                    [self.selectView addSubview:self.chuButton];
                    if (self.chuButton.selected == YES) {
                        self.chuButton.userInteractionEnabled = NO;
                    } else {
                        self.chuButton.userInteractionEnabled = YES;
                    }
                    
                } else if (i == 1) {
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setImage:[UIImage imageNamed:@"ztishi"] forState:UIControlStateNormal];
                    [self.selectView addSubview:button];
                    [button addTarget:self action:@selector(tishiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                } else if (i == 0) {
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setImage:[UIImage imageNamed:@"zbuchunormal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"zbuchu"] forState:UIControlStateHighlighted];
                    [self.selectView addSubview:button];
                    [button addTarget:self action:@selector(buchuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            
            [self viewDidLayoutSubviews];
            
            self.upArray = self.nong2ChuArray;
            
            if (self.nong2Num <= 0) {
                [self loadFail];
            } else if (self.nong2Num == 2) {
                [self ShengYinXiaoWithNum:2];
            } else if (self.nong2Num == 1) {
                [self ShengYinXiaoWithNum:1];
            }
        }
    }];
    
}

- (void)saveFenShu {
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.fenShu forKey:@"FENSHU"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadVictory {
    
    // 设置分数
    self.fenShu += difen * beishu;
    self.moneyLabel.text = [NSString stringWithFormat:@"%zd", self.fenShu];
    // 保存分数到本地
    [self saveFenShu];
    
    // 音效
    [self playYinXiaoWithFileName:@"game_win.mp3"];
    
    
    UIImageView *successView = [UIImageView new];
    successView.userInteractionEnabled = YES;
    successView.image = [UIImage imageNamed:@"shengli"];
    [self.view addSubview:successView];
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.successView = successView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSuccessView)];
    [successView addGestureRecognizer:tap];
}

- (void)loadFail {
    
    // 设置分数
    self.fenShu -= difen * beishu;
    self.moneyLabel.text = [NSString stringWithFormat:@"%zd", self.fenShu];
    // 保存分数到本地
    [self saveFenShu];
    
    // 音效
    [self playYinXiaoWithFileName:@"game_lose.mp3"];
    
    
    UIImageView *successView = [UIImageView new];
    successView.userInteractionEnabled = YES;
    successView.image = [UIImage imageNamed:@"shibai"];
    [self.view addSubview:successView];
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.successView = successView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFailView)];
    [successView addGestureRecognizer:tap];
}

- (void)removeSuccessView {
    
//    [self.successView removeFromSuperview];
//
//    ViewController *Vc = [ViewController shareVc];
//
//    Vc.sign = 1;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeFailView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)sex {
    NSInteger num = arc4random_uniform(2);
    if (num == 0) {
        _sex = @"W";
    } else {
        _sex = @"M";
    }
    return _sex;
}

@end
