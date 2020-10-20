//
//  LuckView.h
//  QSyihz
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yihuazhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^luckBlock)(NSInteger result);
typedef void (^luckBtnBlock)(UIButton *btn);

@protocol LuckViewDelegate <NSObject>
- (void)luckViewDidStopWithArrayCount:(NSInteger)count;
- (void)luckSelectBtn:(UIButton *)btn;

@end

@interface LuckView : UIView



/**
 *  图片地址，网络获取
 */
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (assign, nonatomic) int stopCount;
@property (assign, nonatomic) id<LuckViewDelegate> delegate;
@property (copy, nonatomic) luckBlock luckResultBlock;
@property (copy, nonatomic) luckBtnBlock luckBtn;


- (void)getLuckResult:(luckBlock)luckResult;
- (void)getLuckBtnSelect:(luckBtnBlock)btnBlock;

@end
