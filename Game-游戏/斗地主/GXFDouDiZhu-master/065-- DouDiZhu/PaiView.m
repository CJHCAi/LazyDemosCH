//
//  PaiView.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/24.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "PaiView.h"
#import "GXFButton.h"

@interface PaiView ()

@property (nonatomic, strong) GXFPlayerManager *playerManager;

@end

static NSInteger upNum = 0;
@implementation PaiView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        if (self = [super initWithFrame:frame]) {
            
//            self.backgroundColor = GXFRandomColor;
            
            for (NSInteger i = 0; i<17; i++) {
                
                GXFButton *cardButton = [GXFButton buttonWithType:UIButtonTypeCustom];
                cardButton.isUp = @"no";
//                cardButton.backgroundColor = GXFRandomColor;
//                [cardButton setImage:image forState:UIControlStateNormal];
                [cardButton addTarget:self action:@selector(cardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:cardButton];
                CGFloat cardButtonW = 60;
                CGFloat cardButtonH = self.bounds.size.height - 18;
                CGFloat cardButtonX = (self.bounds.size.width - 2 * 10 - cardButtonW) / 16 * i + 10;
                CGFloat cardButtonY = 18;
                GXFLog(@"%f", cardButtonX);
//                UIButton *cardButton = self.subviews[i];
                cardButton.frame = CGRectMake(cardButtonX, cardButtonY, cardButtonW, cardButtonH);
            }
            
        }
    }
    return self;
}

- (void)playYinXiaoWithFileName:(NSString *)fileName {
    
    [[GXFPlayerManager sharePlayerManager] playMusicWithfileName:fileName];
}

- (void)cardButtonClick:(GXFButton *)button {
    
    // 改变出牌按钮的状态
    
    
//    if (i<4) {
//        
//        // 3
//    } else if (i >= 4 && i <= 7) {
//        
//        // 4
//    } else if (i >= 8 && i <= 11) {
//        
//        // 5
//    } else {
//        
//        // i / 4 + 3;
//    }
    
    // 播放选牌按钮
    [self playYinXiaoWithFileName:@"card_click.mp3"];
    
    if ([button.isUp isEqualToString:@"no"]) {
        
        CGFloat y = button.frame.origin.y;
        
        y -= 15;
        
        button.frame = CGRectMake(button.frame.origin.x, y, button.bounds.size.width, button.bounds.size.height);
//        button.isUp = NO;
        
//        button.layer.transform = CATransform3DIdentity;
//        button.isUp = NO;
        
//        button.transform = CGAffineTransformMakeTranslation(0, -18);
        
//        button.layer.transform = CATransform3DTranslate(button.layer.transform, 0, -18, 0);
        
        button.isUp = @"yes";
        
        // 保存up牌按钮，因为有可能会出
        [self.upArray addObject:button];
        
        
//        upNum++;
//        if (upNum == 1) {
//            
//            // 说明是从0变到1
//            // 通知MainVc改变出牌按钮状态
//            if ([self.delegate respondsToSelector:@selector(paiViewWantToChangeChuButtonState:)]) {
//                [self.delegate paiViewWantToChangeChuButtonState:];
//            }
//            
//        }
        
    } else {
        
        CGFloat y = button.frame.origin.y;
        y += 15;
        button.frame = CGRectMake(button.frame.origin.x, y, button.bounds.size.width, button.bounds.size.height);
//
////        button.layer.transform = CATransform3DMakeTranslation(0, -18, 0);
//        
//        button.isUp = YES;
        
//        button.layer.transform = CATransform3DIdentity;
        
//        button.isUp = YES;
        
        button.isUp = @"no";
        
        // 移除下来的牌按钮
        [self.upArray removeObject:button];
        
//        upNum--;
//        
//        if (upNum == 0) {
//            
//            // 说明是从1变到0
//            // 通知MainVc改变出牌按钮状态
//            if ([self.delegate respondsToSelector:@selector(paiViewWantToChangeChuButtonState)]) {
//                [self.delegate paiViewWantToChangeChuButtonState];
//            }
//        }
    }
    
    // 每次点击都判断是否合法
    BOOL isHeFa = NO;
    if (self.upArray.count == 1) {
        isHeFa = YES;
        
    } else if (self.upArray.count == 2) {
        
        // 判断是否合法
        GXFButton *button1 = self.upArray[0];
        GXFButton *button2 = self.upArray[1];
        
        if (button1.tag < 4 && button2.tag < 4) {
            
            // 3
            //            [self playYinXiaoWithFileName:@"card_single_3_M.mp3"];
            isHeFa = YES;
            
        } else if ((button1.tag >= 4 && button1.tag <= 7) && (button2.tag >= 4 && button2.tag <= 7) ) {
            
            // 4
            //            [self playYinXiaoWithFileName:@"card_single_4_M.mp3"];
            isHeFa = YES;
            
        } else if ((button1.tag >= 8 && button1.tag <= 11) && (button2.tag >= 8 && button2.tag <= 11) ) {
            
            // 5
            //            [self playYinXiaoWithFileName:@"card_single_5_M.mp3"];
            isHeFa = YES;
            
        } else if (button1.tag > 51 && button2.tag > 51) {
            
            //            [self playYinXiaoWithFileName:@"card_single_17_M.mp3"];
            isHeFa = YES;
            
        } else if (button1.tag >= 12 && button1.tag <= 53 && button2.tag >= 12 && button2.tag <= 53) {
            
            // i / 4 + 3;
            //            NSString *fileName = [NSString stringWithFormat:@"card_single_%zd_M.mp3", button.tag / 4 + 3];
            //            [self playYinXiaoWithFileName:fileName];
            
            if ((button1.tag / 4 + 3) == button2.tag / 4 + 3) {
                isHeFa = YES;
            }
            
        } else {
            
            isHeFa = NO;
        }
        
        
    } else if (self.upArray.count == 3) {
        
        GXFButton *button1 = self.upArray[0];
        GXFButton *button2 = self.upArray[1];
        GXFButton *button3 = self.upArray[2];
        
        if (button1.tag < 4 & button2.tag < 4 & button3.tag < 4) {
            
            isHeFa = YES;
            
        } else if (button1.tag >= 4 && button1.tag <= 7 && button2.tag >= 4 && button2.tag <= 7 && button3.tag >= 4 && button3.tag <= 7) {
            
            isHeFa = YES;
            
        } else if (button1.tag >= 8 && button1.tag <= 11 && button2.tag >= 8 && button2.tag <= 11 && button3.tag >= 8 && button3.tag <= 11) {
            
            isHeFa = YES;
            
        } else if (button1.tag >= 52 || button2.tag >= 52 || button3.tag >= 52) {
            // 只要其中有一个是是大王或小王，就不合法
            [self playYinXiaoWithFileName:@"card_single_17_M.mp3"];
            
        } else if (button1.tag >= 12 && button1.tag <= 53 && button2.tag >= 12 && button2.tag <= 53) {
            
            // i / 4 + 3;
            if ((button1.tag / 4 + 3 == button2.tag / 4 + 3) &&(button1.tag / 4 + 3 == button3.tag / 4 + 3) ) {
                isHeFa = YES;
            }
            
        } else {
            isHeFa = NO;
        }
    } else if (self.upArray.count == 4) {
        // 取出upArray中button的tag最大和最小的一个，差>4即不合法
        // 根据button.tag降序
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:NO];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        
        NSArray *sortedArray = [self.upArray sortedArrayUsingDescriptors:descriptors];
        GXFLog(@"%@", sortedArray);
        // 比较tag差是否大于4
        GXFButton *button1 = sortedArray[0];
        GXFButton *button2 = sortedArray[1];
        GXFButton *button3 = sortedArray[2];
        GXFButton *button4 = sortedArray[3];
        // 如果前3个tag相邻，或者后3个tag相邻，则肯定和合法（4，3，2，1）
        
        if (button1.tag - button4.tag == 4) {
            isHeFa = YES; // 炸
        } else if (((button1.tag - button2.tag >= 1 && button1.tag - button2.tag <= 3) && (button1.tag - button3.tag >= 2) && button1.tag - button3.tag <= 3) || ((button2.tag - button3.tag >= 1 && button2.tag - button3.tag <= 3) && (button2.tag - button4.tag >= 2 && button2.tag - button4.tag <= 3))) { // 三带一
            
            isHeFa = YES;
        } else {
            isHeFa = NO;
        }
//        if (((button1.tag - button2.tag >= 1) && (button1.tag - button3.tag >= 2)) || ((button2.tag - button3.tag >= 1) && (button2.tag - button4.tag >= 2))) {
//            if (button1.tag - button4.tag == 4) { // 炸
//                isHeFa = YES;
//            } else {
//                
//            }
//            
//            
//            isHeFa = YES;
//        } else if (button1.tag - button4.tag == 4) {
//            isHeFa = YES;
//        }else {
//            isHeFa = NO;
//        }
        
    } else if (self.upArray.count == 5) { // 三带二，顺子
        
        // 取出upArray中button的tag最大和最小的一个，差>4即不合法
        // 根据button.tag降序
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:NO];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        
        NSArray *sortedArray = [self.upArray sortedArrayUsingDescriptors:descriptors];
        GXFLog(@"%@", sortedArray);
        // 比较tag差是否大于4
        GXFButton *button1 = sortedArray[0];
        GXFButton *button2 = sortedArray[1];
        GXFButton *button3 = sortedArray[2];
        GXFButton *button4 = sortedArray[3];
        GXFButton *button5 = sortedArray[4];
        // 如果前3个tag相邻，或者后3个tag相邻，则肯定和合法（4，3，2，1）
//        if (((button1.tag - button2.tag >= 1) && (button1.tag - button3.tag >= 2)) || ((button3.tag - button4.tag >= 1) && (button3.tag - button5.tag >= 2))) {
//            
//            // 剩下的两个不好判断，只能原始方法
//            
//            
//            isHeFa = YES;
//        } else {
//            isHeFa = NO;
//        }
        
        if ((button1.tag - button2.tag >= 1 && button1.tag - button2.tag <= 3) && (button1.tag - button3.tag >= 2 && button1.tag - button3.tag <= 3)) { // 前3个一样
            if (button4.tag < 4 && button5.tag < 4) {
                
                // 3
                isHeFa = YES;
                
            } else if (button4.tag >= 4 && button4.tag <= 7 && button5.tag >= 4 && button5.tag <= 7) {
                
                // 4
                isHeFa = YES;
                
            } else if (button4.tag >= 8 && button4.tag <= 11 && button5.tag >= 8 && button5.tag <= 11) {
                
                // 5
                isHeFa = YES;
                
            } else if (button4.tag >= 52 || button5.tag >= 52) {
                
                isHeFa = NO;
                
            } else {
                
                if (button4.tag / 4 + 3 == button5.tag / 4 +3) {
                    
                    isHeFa = YES;
                } else {
                    isHeFa = NO;
                }
            }
            
        } else if ((button3.tag - button4.tag >= 1 && button3.tag - button4.tag <= 3) && (button3.tag - button5.tag >= 2 && button3.tag - button5.tag <= 3)) { // 后3个一样
            
            if (button1.tag < 4 && button2.tag < 4) {
                
                // 3
                isHeFa = YES;
                
            } else if (button1.tag >= 4 && button1.tag <= 7 && button2.tag >= 4 && button2.tag <= 7) {
                
                // 4
                isHeFa = YES;
                
            } else if (button1.tag >= 8 && button1.tag <= 11 && button2.tag >= 8 && button2.tag <= 11) {
                
                // 5
                isHeFa = YES;
                
            }  else if (button1.tag >= 12 && button1.tag <= 51 && button2.tag >= 12 && button2.tag <= 51) {
                
                // i / 4 + 3;
                if (button1.tag / 4 + 3 == button2.tag / 4 + 3) {
                    isHeFa = YES;
                } else {
                    isHeFa = NO;
                }
                
            } else if (button1.tag >= 52 || button2.tag >= 52) {
                isHeFa = NO;
            } else {
                isHeFa = NO;
            }
        } else {
            isHeFa = NO;
#warning 这里有可能是顺子(5张牌的顺子)
            
            
        }
    }
    
    if (self.upArray.count > 5) {
        isHeFa = YES;
    }
    
    
    if (isHeFa) {
        
        // 出牌按钮可用
        GXFLog(@"可用");
        // 通知MainVc让出牌按钮可用
        if ([self.delegate respondsToSelector:@selector(paiViewWantToChangeChuButtonStateWithState:)]) {
            [self.delegate paiViewWantToChangeChuButtonStateWithState:isHeFa];
        }
        
        
    } else {
        
        // 出牌按钮不可用
        GXFLog(@"不可用");
        // 通知MainVc让出牌按钮可用
        if ([self.delegate respondsToSelector:@selector(paiViewWantToChangeChuButtonStateWithState:)]) {
            [self.delegate paiViewWantToChangeChuButtonStateWithState:isHeFa];
        }
    }
    
}

- (void)setNumArray:(NSMutableArray *)numArray {
    
    _numArray = numArray;
    GXFLog(@"%@", _numArray);
}

- (void)setCardArray:(NSMutableArray *)cardArray {
    
    _cardArray = cardArray;
    
    for (NSInteger i = 0; i<self.subviews.count; i++) {
        
        // 随机一张牌
        UIButton *button = self.subviews[i];
        NSInteger num = [self.numArray[i] integerValue];
        UIImage *image = cardArray[num];
        [button setImage:image forState:UIControlStateNormal];
        
        // 没叫之前不能点击
        button.userInteractionEnabled = NO;
        
        // 用于点击音效
        button.tag = num;
        
        // 对牌控制
        button.tag = num;
        NSDictionary *dict = [NSDictionary dictionaryWithObject:button forKey:@(num)];
        self.currentCardArray = [NSMutableArray array];
        [self.currentCardArray addObject:dict];
    }
}

- (void)resetMasonryWithThreeNumArray:(NSArray *)ThreeNumArray {
    
    // 排序新数组
    // self.numArray和numArray
    // 添加3个
    [self.numArray addObject:ThreeNumArray[0]];
    [self.numArray addObject:ThreeNumArray[1]];
    [self.numArray addObject:ThreeNumArray[2]];
    // 排序
    NSArray *num20Array = [self sortDescWithArray:self.numArray];
    NSLog(@"%@", num20Array);
    
#warning dddddddddddddd
    // 布局
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i<20; i++) {
        
        GXFButton *cardButton = [GXFButton buttonWithType:UIButtonTypeCustom];
        cardButton.isUp = @"no";
        //                cardButton.backgroundColor = GXFRandomColor;
        //                [cardButton setImage:image forState:UIControlStateNormal];
        [cardButton addTarget:self action:@selector(cardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger num = [num20Array[i] integerValue];
        UIImage *image = self.cardArray[num];
        [cardButton setImage:image forState:UIControlStateNormal];
        [self addSubview:cardButton];
        
        cardButton.tag = [num20Array[i] integerValue];
        
//        CGFloat cardButtonW = 60;
//        CGFloat cardButtonH = self.bounds.size.height - 18;
//        CGFloat cardButtonX = (self.bounds.size.width - 2 * 10 - cardButtonW) / 19 * i + 10;
//        CGFloat cardButtonY = 18;
//        GXFLog(@"%f", cardButtonX);
//        UIButton *cardButton = self.subviews[i];
//        cardButton.frame = CGRectMake(cardButtonX, cardButtonY, cardButtonW, cardButtonH);
        
//        [self layoutIfNeeded];
    }
    
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
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat margin = scale_W(10);
    
    for (NSInteger i = 0; i<self.subviews.count; i++) {
        
        CGFloat cardButtonW = 60;
        CGFloat cardButtonH = self.bounds.size.height - 18;
        
        // 两边之和
        CGFloat sides = 0;
        if (self.subviews.count > 7) {
            sides = kScreenWidth*0.6/20*(20-self.subviews.count);
        } else if (self.subviews.count > 5) {
            
            sides = kScreenWidth * 0.43;
        } else if (self.subviews.count == 5) {
            
            sides = kScreenWidth * 0.56;
        } else if (self.subviews.count == 4) {
            
            sides = kScreenWidth * 0.65;
        } else if (self.subviews.count == 3) {
            
            sides = kScreenWidth * 0.72;
        } else if (self.subviews.count == 2) {
            
            sides = kScreenWidth * 0.78;
        } else {
            sides = kScreenWidth - cardButtonW;
        }
        
        CGFloat cardButtonX;
        if (self.subviews.count >= 2) {
            cardButtonX = (self.bounds.size.width - 2 * margin - sides - cardButtonW) / (self.subviews.count - 1) * i + margin + sides * 0.5;
            
        } else { // count == 1
            
            cardButtonX = kScreenWidth * 0.5 - cardButtonW * 0.5;
        }
        
//        CGFloat cardButtonX = (self.bounds.size.width - 2 * 10 - sides - cardButtonW) / (self.subviews.count - 1) * i + 10 + sides * 0.5;
        CGFloat cardButtonY = 18;
        GXFLog(@"%f", cardButtonX);
        UIButton *cardButton = self.subviews[i];
        cardButton.frame = CGRectMake(cardButtonX, cardButtonY, cardButtonW, cardButtonH);
        
    }
    
}

- (void)downAll {
    
    for (NSInteger i = 0; i<self.subviews.count; i++) {
        
        GXFButton *button = self.subviews[i];
        if ([button.isUp isEqualToString:@"yes"]) {
            
            CGFloat y = button.frame.origin.y;
            y += 15;
            button.frame = CGRectMake(button.frame.origin.x, y, button.bounds.size.width, button.bounds.size.height);
            
            button.isUp = @"no";
        }
    }
    
    // 清除upArray
    [self.upArray removeAllObjects];
    [self.tiShiNumArray removeAllObjects];
    
    upNum = 0;
}

- (void)upTishiPai {
    
    // 播放选牌按钮
    [self playYinXiaoWithFileName:@"card_click.mp3"];
    
    for (NSInteger i = 0; i<self.subviews.count; i++) {
        
        GXFButton *button1 = self.subviews[i];
        for (NSInteger j = 0; j<self.tiShiNumArray.count; j++) {
            
            if (button1.tag == [self.tiShiNumArray[j] integerValue]) {
                
                CGFloat y = button1.frame.origin.y;
                
                y -= 15;
                
                button1.frame = CGRectMake(button1.frame.origin.x, y, button1.bounds.size.width, button1.bounds.size.height);
                
                button1.isUp = @"yes";
                
                [self.upArray addObject:button1];
            }
        }
    }
    
}

- (void)chuPaiSoundWithArray:(NSArray *)array {
    
    if (array.count == 1) {
        
        GXFButton *button = array[0];
        
        if (button.tag < 4) {
            
            // 3
            [self playYinXiaoWithFileName:@"card_single_3_M.mp3"];
            
        } else if (button.tag >= 4 && button.tag <= 7) {
            
            // 4
            [self playYinXiaoWithFileName:@"card_single_4_M.mp3"];
            
        } else if (button.tag >= 8 && button.tag <= 11) {
            
            // 5
            [self playYinXiaoWithFileName:@"card_single_5_M.mp3"];
            
        } else if (button.tag == 53) {
            
            [self playYinXiaoWithFileName:@"card_single_17_M.mp3"];
            
        } else {
            
            // i / 4 + 3;
            NSString *fileName = [NSString stringWithFormat:@"card_single_%zd_M.mp3", button.tag / 4 + 3];
            [self playYinXiaoWithFileName:fileName];
        }
        
    } else if (array.count == 2) { // 对，也可能是🚀
        
        GXFButton *button = array[0];
        if (button.tag > 51) {
            [self playYinXiaoWithFileName:@"card_rocket_M.mp3"];
        } else {
            GXFButton *button = array[0];
            if (button.tag < 4) {
                
                // 3
                [self playYinXiaoWithFileName:@"card_double_3_M.mp3"];
                
            } else if (button.tag >= 4 && button.tag <= 7) {
                
                // 4
                [self playYinXiaoWithFileName:@"card_double_4_M.mp3"];
                
            } else if (button.tag >= 8 && button.tag <= 11) {
                
                // 5
                [self playYinXiaoWithFileName:@"card_double_5_M.mp3"];
                
            } else if (button.tag == 53) {
                
                [self playYinXiaoWithFileName:@"card_double_17_M.mp3"];
                
            } else {
                
                // i / 4 + 3;
                NSString *fileName = [NSString stringWithFormat:@"card_double_%zd_M.mp3", button.tag / 4 + 3];
                [self playYinXiaoWithFileName:fileName];
            }
            
        }
        
        
    } else if (array.count == 3) { // 三个几
        [self playYinXiaoWithFileName:@"card_three_M.mp3"];
        
    } else if (array.count == 4) { // 炸或者三带一
        
        GXFButton * button1 = array[0];
        GXFButton *button2 = array[1];
        if ((button1.tag < 4 && button2.tag > 4) || (button1.tag > 4 && button2.tag < 4)) {
            
            // 3
            [self playYinXiaoWithFileName:@"card_three_1_M.mp3"];
            
        } else if (((button1.tag >= 4 && button1.tag <= 7) && (button2.tag < 4 || button2.tag > 7)) || ((button2.tag >= 4 && button2.tag <= 7) && (button1.tag < 4 || button1.tag > 7)) ) {
            
            // 4
            [self playYinXiaoWithFileName:@"card_three_1_M.mp3"];
            
        } else if (((button1.tag >= 8 && button1.tag <= 11) && (button2.tag < 8 || button2.tag > 11)) || ((button2.tag >= 8 && button2.tag <= 11) && (button1.tag < 8 || button1.tag > 11)) ) {
            
            // 5
            [self playYinXiaoWithFileName:@"card_three_1_M.mp3"];
            
        } else if (button1.tag == 53) { // 不可能走这里
            
//            [self playYinXiaoWithFileName:@"card_single_17_M.mp3"];
            
        } else {
            
            // i / 4 + 3;
//            NSString *fileName = [NSString stringWithFormat:@"card_single_%zd_M.mp3", button.tag / 4 + 3];
//            [self playYinXiaoWithFileName:fileName];
            // 这里通过i（tag）就能区别是炸还是三带一
            
            GXFButton *button1 = array[0];
            GXFButton *button2 = array[1];
            GXFButton *button3 = array[2];
            GXFButton *button4 = array[3];
            if ((button1.tag / 4 + 3) == (button2.tag / 4 + 3)) {
                // 比较后两个
                if ((button3.tag / 4 + 3) == (button4.tag / 4 + 3)) { // 前后两个都一样，肯定为炸
                    [self playYinXiaoWithFileName:@"card_bomb_M.mp3"]; // 炸
                } else {
                    [self playYinXiaoWithFileName:@"card_three_1_M.mp3"]; // 三带一
                }
                
            } else { // 三带一
                [self playYinXiaoWithFileName:@"card_three_1_M.mp3"]; // 三带一
                
            }
        }
        
//        if (button1.tag - button2.tag > 1) { // 没连着，三带一，一很大
//            [self playYinXiaoWithFileName:@""]; // 三带一
//        } else if (button1.tag - button2.tag == 1) {
//            if (button1.tag < 4 && button2.tag >= 4 && button2.tag <= 7) {
//                // 3
//                [self playYinXiaoWithFileName:@"card_double_3_M.mp3"]; // 三带一
//                
//            } else if (button1.tag >= 4 && button1.tag <= 7 && button2.tag >= 8 && button2.tag <= 11) {
//                
//                // 4
//                [self playYinXiaoWithFileName:@"card_double_4_M.mp3"]; // 三带一
//                
//            } else if (button1.tag >= 8 && button1.tag <= 11 && button2.tag == 53) {
//                
//                // 5
//                [self playYinXiaoWithFileName:@"card_double_5_M.mp3"];
//                
//            } else if (button.tag == 53) {
//                
//                [self playYinXiaoWithFileName:@"card_double_17_M.mp3"];
//                
//            } else {
//                
//                // i / 4 + 3;
//                NSString *fileName = [NSString stringWithFormat:@"card_double_%zd_M.mp3", button.tag / 4 + 3];
//                [self playYinXiaoWithFileName:fileName];
//            }
//        
//        } else if (button1.tag - button2.tag < -1) { // 没连着，三带一，一很小
//            [self playYinXiaoWithFileName:@""]; // 三带一
//        } else if (button1.tag - button2.tag == 1) {
//            
//            
//        }
        
    } else if (array.count == 5) {
        
        [self playYinXiaoWithFileName:@"card_three_2_M.mp3"];
    }
    
    
    
//    for (NSInteger i = 0; i < self.subviews.count; i++) {
//        
//        GXFButton *button = self.subviews[i];
//        if ([button.isUp isEqualToString:@"yes"]) {
//            
//            if (button.tag < 4) {
//                
//                // 3
//                [self playYinXiaoWithFileName:@"card_single_3_M.mp3"];
//                
//            } else if (button.tag >= 4 && button.tag <= 7) {
//                
//                // 4
//                [self playYinXiaoWithFileName:@"card_single_4_M.mp3"];
//                
//            } else if (button.tag >= 8 && button.tag <= 11) {
//                
//                // 5
//                [self playYinXiaoWithFileName:@"card_single_5_M.mp3"];
//                
//            } else if (button.tag == 53) {
//                
//                [self playYinXiaoWithFileName:@"card_single_17_M.mp3"];
//                
//            } else {
//                
//                // i / 4 + 3;
//                NSString *fileName = [NSString stringWithFormat:@"card_single_%zd_M.mp3", button.tag / 4 + 3];
//                [self playYinXiaoWithFileName:fileName];
//            }
//        }
//        
//    }
    
}

- (void)movePaiToDeskTop {
    
    // 移动到桌面，通知MianVc添加SelfDeskView，不用通知
    
    
    // 先移除当前的牌
//    [self.currentCardArray removeObjectsInArray:self.upArray];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i<self.upArray.count; i++) {
        
        GXFLog(@"%@", self.numArray);
        
        GXFButton *button = self.upArray[i];
        
        [self.numArray removeObject:@(button.tag)];
    }
    
    // 对numArray排序，不知道为啥乱了
    NSArray *array = [self sortDescWithArray:self.numArray];
    self.numArray = [NSMutableArray arrayWithArray:array];
    
    // 根据numArray重新创建牌按钮
    for (NSInteger i = 0; i<self.numArray.count; i++) {
        
        GXFButton *cardButton = [GXFButton buttonWithType:UIButtonTypeCustom];
        cardButton.isUp = @"no";
        //                cardButton.backgroundColor = GXFRandomColor;
        //                [cardButton setImage:image forState:UIControlStateNormal];
        [cardButton addTarget:self action:@selector(cardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger num = [self.numArray[i] integerValue];
        UIImage *image = self.cardArray[num];
        [cardButton setImage:image forState:UIControlStateNormal];
        [self addSubview:cardButton];
        
        cardButton.tag = [self.numArray[i] integerValue];
        
        //        CGFloat cardButtonW = 60;
        //        CGFloat cardButtonH = self.bounds.size.height - 18;
        //        CGFloat cardButtonX = (self.bounds.size.width - 2 * 10 - cardButtonW) / 19 * i + 10;
        //        CGFloat cardButtonY = 18;
        //        GXFLog(@"%f", cardButtonX);
        //        UIButton *cardButton = self.subviews[i];
        //        cardButton.frame = CGRectMake(cardButtonX, cardButtonY, cardButtonW, cardButtonH);
        
        //        [self layoutIfNeeded];
    }
    
    [self layoutSubviews];
    
    // 清空upArray
    self.upArray = nil;
    
    
}

- (NSMutableArray *)upArray {
    
    if (!_upArray) {
        _upArray = [NSMutableArray array];
    }
    return _upArray;
}

- (NSMutableArray *)tiShiNumArray {
    
    if (!_tiShiNumArray) {
        _tiShiNumArray = [NSMutableArray array];
    }
    return _tiShiNumArray;
}

- (GXFPlayerManager *)playerManager {
    return [GXFPlayerManager new];
}

@end
