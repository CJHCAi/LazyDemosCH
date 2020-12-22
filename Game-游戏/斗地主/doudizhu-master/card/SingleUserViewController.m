//
//  SingleUserViewController.m
//  card
//
//  Created by tmachc on 15/9/10.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "SingleUserViewController.h"
#import "GameTable.h"
#import "PlayingCard.h"
#import "PlayingDeck.h"
#import "CardView.h"
#import "MyCards.h"
#import "MyCardsView.h"
#import "AIforGame.h"

@interface SingleUserViewController () <EndThinkingDelegate>

@property (nonatomic, strong) MyCards *me;
@property (nonatomic, strong) AIforGame *computer1;
@property (nonatomic, strong) AIforGame *computer2;
@property (nonatomic, strong) PlayingDeck *deck;
@property (nonatomic, strong) GameTable *game;
@property (nonatomic, strong) NSArray *otherCards;
@property (nonatomic, strong) UILabel *labC1Num;
@property (nonatomic, strong) UILabel *labC2Num;
@property (nonatomic, strong) UIView *viewLandlordCard;
@property (nonatomic, strong) MyCardsView *myCardsView;
@property (nonatomic, strong) UIButton *btnOutCard;
@property (nonatomic, strong) UIButton *btnNotOut;
@property (nonatomic, strong) UILabel *labNotOut;

@end

@implementation SingleUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建三个 user
    // 创建一个游戏桌 三个user加入游戏桌
    // 游戏桌记录谁是地主，谁有下一轮的出牌权
    
    // 开始游戏，出牌，判断手牌是否为空，下一个出牌
    
    self.me.tag = 0;
    self.computer1.tag = 1;
    self.computer2.tag = 2;
    self.otherCards = @[
                        [self.deck getRandomCard],
                        [self.deck getRandomCard],
                        [self.deck getRandomCard]
                        ];
    [self initView];
    
    [self updateUI];
    
    [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - function

- (void)initView
{
    [self.view addSubview:self.labC1Num];
    [self.view addSubview:self.labC2Num];
    __weak __typeof(&*self)ws = self;
    [self.labC1Num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(48);
    }];
    [self.labC2Num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(ws.labC1Num);
        make.left.mas_equalTo(80);
    }];
    
    self.viewLandlordCard = [UIView new];
    [self.view addSubview:self.viewLandlordCard];
    [self.viewLandlordCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(ws.view);
        make.width.mas_equalTo(106);
        make.height.mas_equalTo(48);
    }];
    
    self.myCardsView = [MyCardsView new];
    [self.view addSubview:self.myCardsView];
    [self.myCardsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.width.centerX.mas_equalTo(ws.view);
        make.height.mas_equalTo(96);
    }];
    NSArray *sortCards = [self.otherCards sortCards];
    for (int i = 0; i < sortCards.count; i ++) {
        CardView *cardView = [[CardView alloc] initWithPlayingCard:sortCards[sortCards.count - i - 1]];
        [self.viewLandlordCard addSubview:cardView];
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(i * 37 - 37);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(48);
            make.bottom.mas_equalTo(-20);
        }];
    }
    
    self.btnNotOut = [UIButton new];
    self.btnNotOut.hidden = YES;
    [self.btnNotOut setTitle:@"不要" forState:UIControlStateNormal];
    [self.btnNotOut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnNotOut.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.btnNotOut.layer.cornerRadius = 10;
    self.btnNotOut.layer.borderWidth = 2;
    self.btnNotOut.layer.borderColor = [UIColor blueColor].CGColor;
    self.btnNotOut.backgroundColor = [UIColor whiteColor];
    [self.btnNotOut addTarget:self action:@selector(notOutCards:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnNotOut];
    [self.btnNotOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.myCardsView.mas_top).with.offset(-20);
        make.right.mas_equalTo(ws.view.mas_centerX).with.offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    self.btnOutCard = [UIButton new];
    self.btnOutCard.hidden = YES;
    [self.btnOutCard setTitle:@"出牌" forState:UIControlStateNormal];
    [self.btnOutCard setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnOutCard.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.btnOutCard.layer.cornerRadius = 10;
    self.btnOutCard.layer.borderWidth = 2;
    self.btnOutCard.layer.borderColor = [UIColor blueColor].CGColor;
    self.btnOutCard.backgroundColor = [UIColor whiteColor];
    [self.btnOutCard addTarget:self action:@selector(outCards:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnOutCard];
    [self.btnOutCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(ws.btnNotOut);
        make.left.mas_equalTo(ws.view.mas_centerX).with.offset(20);
    }];
    
    [self.view addSubview:self.labNotOut];
    self.labNotOut.hidden = YES;
    [self.labNotOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.view);
        make.bottom.mas_equalTo(ws.myCardsView.mas_top).with.offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateUI
{
    self.labC1Num.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.computer1.myCards.count];
    self.labC2Num.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.computer2.myCards.count];
    
    if (self.myCardsView.subviews.count == self.me.myCards.count) {
        return;
    }
    
    for (id item in self.myCardsView.subviews) {
        if ([item isKindOfClass:[CardView class]]) {
            [item removeFromSuperview];
        }
    }
//    __weak __typeof(&*self)ws = self;
    NSArray *sortCards = [self.me.myCards sortCards];
    for (int i = 0; i < sortCards.count; i ++) {
        CardView *cardView = [[CardView alloc] initWithPlayingCard:sortCards[sortCards.count - i - 1]];
        [self.myCardsView addSubview:cardView];
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-((float)sortCards.count / 2) * 30 + i * 30 + 15);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(96);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)start
{
    UIButton *btn = [UIButton new];
    btn.tag = 1;
    // 抢地主
    [self grabLandlord:btn];
}

#pragma mark - delegate

// 抢地主的回调
- (void)grabLandlord:(BOOL)isGrab withTag:(NSInteger)tag
{
    if (isGrab) {
        [[self userWithTag:tag] setLandlordWithOtherCards:self.otherCards];
        self.otherCards = @[];
        [self updateUI];
        // 开始出牌
        [[self userWithTag:tag] setTurn:YES];
        [[self userWithTag:(tag + 1) % 3] setTurn:NO];
        [[self userWithTag:(tag + 2) % 3] setTurn:NO];
        [[self userWithTag:tag] thinkingOutCards:self.otherCards];
        if (!tag) {
            // 我抢的地主
            self.btnNotOut.hidden = NO;
            self.btnOutCard.hidden = NO;
        }
    }
    else {
        [[self userWithTag:(tag + 1) % 3] thinkingGrabLandlord];
    }
}
// 出牌的回调
- (void)outCards:(NSArray *)cards withTag:(NSInteger)tag
{
    if (cards.count) {
        if (![self userWithTag:tag].myCards.count) {
            // 该玩家赢了
            self.labNotOut.text = @"赢了";
            self.labNotOut.hidden = NO;
            __weak __typeof(&*self)ws = self;
            [self.labNotOut mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (tag == 0) {
                    make.centerX.mas_equalTo(ws.view);
                    make.bottom.mas_equalTo(ws.myCardsView.mas_top).with.offset(-20);
                }
                else if (tag == 1) {
                    make.right.mas_equalTo(ws.labC1Num.mas_left).with.offset(-10);
                    make.top.mas_equalTo(ws.labC1Num);
                }
                else {
                    make.left.mas_equalTo(ws.labC2Num.mas_right).with.offset(10);
                    make.top.mas_equalTo(ws.labC2Num);
                }
                
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(30);
            }];
            return;
        }
        // 如果出牌了，修改Turn
        self.labNotOut.hidden = YES;
        [[self userWithTag:tag] setTurn:YES];
        [[self userWithTag:(tag + 1) % 3] setTurn:NO];
        [[self userWithTag:(tag + 2) % 3] setTurn:NO];
        [self updateUI];
        for (id item in self.view.subviews) {
            if ([item isKindOfClass:[CardView class]]) {
                [item removeFromSuperview];
            }
        }
        self.otherCards = cards;
        __weak __typeof(&*self)ws = self;
        for (int i = 0; i < cards.count; i ++) {
            CardView *cardView = [[CardView alloc] initWithPlayingCard:cards[cards.count - i - 1]];
            [self.view addSubview:cardView];
            [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(72);
                if (tag == 0) {
                    // 自己出的
                    make.centerX.mas_equalTo(-((int)cards.count / 2) * 25 + i * 25);
                    make.bottom.mas_equalTo(ws.myCardsView.mas_top).with.offset(-10);
                }
                else if (tag == 1) {
                    // computer1出的 右面
                    make.right.mas_equalTo(ws.labC1Num.mas_left).with.offset(-10 - ((int)cards.count - i - 1) * 25);
                    make.top.mas_equalTo(ws.labC1Num);
                }
                else {
                    // computer2出的 左面
                    make.left.mas_equalTo(ws.labC2Num.mas_right).with.offset(10 + i * 25);
                    make.top.mas_equalTo(ws.labC2Num);
                }
            }];
        }
    }
    else {
        // 没出牌
        self.labNotOut.hidden = NO;
        __weak __typeof(&*self)ws = self;
        [self.labNotOut mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (tag == 0) {
                make.centerX.mas_equalTo(ws.view);
                make.bottom.mas_equalTo(ws.myCardsView.mas_top).with.offset(-20);
            }
            else if (tag == 1) {
                make.right.mas_equalTo(ws.labC1Num.mas_left).with.offset(-10);
                make.top.mas_equalTo(ws.labC1Num);
            }
            else {
                make.left.mas_equalTo(ws.labC2Num.mas_right).with.offset(10);
                make.top.mas_equalTo(ws.labC2Num);
            }
            
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
        if ([self userWithTag:(tag + 1) % 3].isTurn) {
            // 如果下一家的Turn 那么这轮没人要 下一家随意出
            self.otherCards = @[];
            for (id item in self.view.subviews) {
                if ([item isKindOfClass:[CardView class]]) {
                    [item removeFromSuperview];
                }
            }
        }
    }
    
    if (tag == 2) {
        self.btnNotOut.hidden = NO;
        self.btnOutCard.hidden = NO;
    }
    [[self userWithTag:(tag + 1) % 3] thinkingOutCards:self.otherCards];
}

- (User *)userWithTag:(NSInteger)tag
{
    if (tag == 0) {
        return self.me;
    }
    else if (tag == 1) {
        return self.computer1;
    }
    else {
        return self.computer2;
    }
}

#pragma mark - button

- (IBAction)clickBack:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)grabLandlord:(UIButton *)sender
{
    // 玩家不抢 让ai抢地主
    [self.me.delegete grabLandlord:sender.tag withTag:self.me.tag];
}

//- (IBAction)outCard:(UIButton *)sender
//{
//    if (!self.me.isThinking) {
//        return;
//    }
//    PlayingCard *outCard;
//    for (PlayingCard *card in self.me.myCards) {
//        if (sender.tag == card.rank) {
//            if ([self.me outCards:@[card] lastOut:self.otherCards]) {
//                outCard = card;
//                [self.me.myCards removeObject:card];
//            }
//            break;
//        }
//    }
//    self.me.thinking = false;
//    self.btnNotOut.hidden = YES;
//    self.btnOutCard.hidden = YES;
//    [self.me.delegete outCards:outCard ? @[outCard] : @[] withTag:self.me.tag];
//}

- (IBAction)notOutCards:(UIButton *)sender
{
    self.me.thinking = false;
    self.btnNotOut.hidden = YES;
    self.btnOutCard.hidden = YES;
    [self.me.delegete outCards:@[] withTag:self.me.tag];
}

- (IBAction)outCards:(UIButton *)sender
{
    NSMutableArray *ary = [NSMutableArray new];
    for (CardView *cardView in self.myCardsView.subviews) {
        if (cardView.isSelected) {
            [ary addObject:cardView.card];
            [self.me.myCards removeObject:cardView.card];
        }
    }
    if ([self.me outCards:[ary sortCards] lastOut:self.otherCards]) {
        self.me.thinking = false;
        self.btnNotOut.hidden = YES;
        self.btnOutCard.hidden = YES;
        [self.me.delegete outCards:[ary sortCards] withTag:self.me.tag];
    }
    else {
        NSLog(@"这个牌不能出！");
        [self.myCardsView touchesCancelled:nil withEvent:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - 延迟实例化

- (MyCards *)me
{
    if (!_me) {
        _me = [[MyCards alloc] init];
        [_me setCarsCount:17 usingDeck:self.deck];
        _me.delegete = self;
    }
    return _me;
}

- (AIforGame *)computer1
{
    if (!_computer1) {
        _computer1 = [[AIforGame alloc] init];
        [_computer1 setCarsCount:17 usingDeck:self.deck];
        _computer1.delegete = self;
    }
    return _computer1;
}

- (AIforGame *)computer2
{
    if (!_computer2) {
        _computer2 = [[AIforGame alloc] init];
        [_computer2 setCarsCount:17 usingDeck:self.deck];
        _computer2.delegete = self;
    }
    return _computer2;
}

- (PlayingDeck *)deck
{
    if (!_deck) {
        _deck = [[PlayingDeck alloc] init];
    }
    return _deck;
}

- (UILabel *)labC1Num
{
    if (!_labC1Num) {
        _labC1Num = [UILabel new];
        _labC1Num.textAlignment = NSTextAlignmentCenter;
        _labC1Num.textColor = [UIColor blueColor];
        _labC1Num.font = [UIFont boldSystemFontOfSize:18];
        _labC1Num.layer.cornerRadius = 5;
        _labC1Num.layer.borderWidth = 2;
        _labC1Num.layer.borderColor = [UIColor grayColor].CGColor;
        _labC1Num.backgroundColor = [UIColor whiteColor];
    }
    return _labC1Num;
}

- (UILabel *)labC2Num
{
    if (!_labC2Num) {
        _labC2Num = [UILabel new];
        _labC2Num.textAlignment = NSTextAlignmentCenter;
        _labC2Num.textColor = [UIColor blueColor];
        _labC2Num.font = [UIFont boldSystemFontOfSize:18];
        _labC2Num.layer.cornerRadius = 5;
        _labC2Num.layer.borderWidth = 2;
        _labC2Num.layer.borderColor = [UIColor grayColor].CGColor;
        _labC2Num.backgroundColor = [UIColor whiteColor];
    }
    return _labC2Num;
}

- (UILabel *)labNotOut
{
    if (!_labNotOut) {
        _labNotOut = [UILabel new];
        _labNotOut.text = @"不要";
        _labNotOut.textAlignment = NSTextAlignmentCenter;
        _labNotOut.textColor = [UIColor blueColor];
        _labNotOut.font = [UIFont boldSystemFontOfSize:18];
    }
    return _labNotOut;
}

@end
