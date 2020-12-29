//
//  PayCoinTableViewCell.h
//  SportForum
//
//  Created by liyuan on 15/3/6.
//  Copyright (c) 2015年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PayClickBlock)(void);

@interface PayCoinItem : NSObject

@property(nonatomic, copy) NSString* payId;
@property(nonatomic, copy) NSString* payImage;
@property(nonatomic, copy) NSString* payDesc;
@property(nonatomic, assign) NSUInteger payValue;
@property(nonatomic, assign) long long coin_value;

@end

@interface PayCoinTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UILabel *lbPayDesc;
@property(nonatomic, strong) UILabel *lbSep;
@property(nonatomic, strong) CSButton *btnPay;
@property(nonatomic, strong) PayCoinItem *payCoinItem;
@property(nonatomic, copy) PayClickBlock payClickBlock;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end