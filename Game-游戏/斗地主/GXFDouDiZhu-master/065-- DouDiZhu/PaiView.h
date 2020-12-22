//
//  PaiView.h
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/24.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaiView;
@class GXFButton;
@protocol PaiViewDelegate <NSObject>

- (void)paiViewWantToChangeChuButtonStateWithState:(BOOL)state;

@end

@interface PaiView : UIView

@property (nonatomic, strong) NSMutableArray *numArray; // 当前的牌的降序数组

@property (nonatomic, strong) NSMutableArray *cardArray;

@property (nonatomic, strong) NSMutableArray *currentCardArray; // 当前所有牌的图片

@property (nonatomic, strong) NSMutableArray *tiShiNumArray;

@property (nonatomic, strong) NSMutableArray *upArray;

@property (nonatomic, weak) id<PaiViewDelegate> delegate;

- (void)downAll;

- (void)upTishiPai;

- (void)chuPaiSoundWithArray:(NSArray *)array;

- (void)movePaiToDeskTop;

- (void)resetMasonryWithThreeNumArray:(NSMutableArray *)ThreeNumArray; // 3

- (void)cardButtonClick:(GXFButton *)button;

@end
