//
//  SingleRowVC.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/2/18.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "SingleRowVC.h"
#import "FXDanmaku.h"
#import "NSTimer+FXWeakTarget.h"
#import "DemoBulletinItem.h"
#import "DemoBulletinItemData.h"
#import "NSObject+FXAlertView.h"

@interface SingleRowVC () <FXDanmakuDelegate>

@property (weak, nonatomic) IBOutlet FXDanmaku *bulletinBoard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bulletinBoardHeightConst;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, strong) NSTimer *addDataTimer;

@end

@implementation SingleRowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.serialQueue = dispatch_queue_create("com.FXDanmakuDemo.serialQueue", NULL);
    [self setupBulletinBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self start:nil];
}

#pragma mark - Views
- (void)setupBulletinBoard {
    self.bulletinBoard.backgroundColor = [UIColor whiteColor];
    self.bulletinBoard.configuration = [FXDanmakuConfiguration singleRowConfigurationWithHeight:[DemoBulletinItem itemHeight]];
    [self.bulletinBoard registerClass:[DemoBulletinItem class] forItemReuseIdentifier:[DemoBulletinItem reuseIdentifier]];
    self.bulletinBoard.delegate = self;
    self.bulletinBoardHeightConst.constant = [DemoBulletinItem itemHeight];
}

#pragma mark - Actions
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    // What you get is a copy of the danmaku configuration
    FXDanmakuConfiguration *config = self.bulletinBoard.configuration;
    config.itemMoveDirection = sender.selectedSegmentIndex; // FXDanmakuItemMoveDirectionRightToLeft、FXDanmakuItemMoveDirectionLeftToRight
    self.bulletinBoard.configuration = config;
}

- (IBAction)start:(id)sender {
    [self createAddDataTimerIfNeeded];
    [self.bulletinBoard start];
}

- (IBAction)pause:(id)sender {
    [self.bulletinBoard pause];
    [self invalidateAddDataTimer];
}

- (IBAction)stop:(id)sender {
    [self invalidateAddDataTimer];
    [self.bulletinBoard stop];
}

- (void)createAddDataTimerIfNeeded {
    if (!self.addDataTimer) {
        __block NSUInteger bIndex = 0;
        __weak typeof(self) weakSelf = self;
        self.addDataTimer =
		[NSTimer fx_scheduledRepeatedTimerWithInterval:0.5
												target:self
												 block:^(NSTimer *timer)
		{
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                DemoBulletinItemData *data = [DemoBulletinItemData dataWithDesc:[NSString stringWithFormat:@"item-%@", @(bIndex++)]
                                                                     avatarName:[NSString stringWithFormat:@"avatar%@", @(arc4random() % 6)]];
                [weakSelf.bulletinBoard addData:data];
            });
		}];
    }
}

- (void)invalidateAddDataTimer {
    [self.addDataTimer invalidate];
    self.addDataTimer = nil;
}

#pragma mark - FXDanmakuDelegate
- (void)danmaku:(FXDanmaku *)danmaku didClickItem:(FXDanmakuItem *)item withData:(DemoBulletinItemData *)data {
    [self fx_presentConfirmViewWithTitle:nil
                                 message:[NSString stringWithFormat:@"You click %@", data.desc]
                      confirmButtonTitle:nil
                       cancelButtonTitle:@"Ok"
                          confirmHandler:nil
                           cancelHandler:nil];
}

- (BOOL)shouldAddDanmakuItemDataWhenQueueIsFull:(FXDanmakuItemData *)data {
    // only discard normal priority data when data queue is beyond limit.
    return FXDataPriorityHigh == data.priority;
}

@end
