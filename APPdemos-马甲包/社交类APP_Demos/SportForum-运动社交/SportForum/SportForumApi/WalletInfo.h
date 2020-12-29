//
//  WalletInfo.h
//  SportForum
//
//  Created by liyuan on 14-9-16.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface WalletAddressItem : BaseObject

@property(strong, nonatomic) NSString *pubKey;
@property(strong, nonatomic) NSString *privKey;
@property(strong, nonatomic) NSString *label;

@end

@interface WalletInfo : BaseObject

@property(strong, nonatomic) NSString *wallet_id;

//id type WalletAddressItem
@property(strong, nonatomic) BaseArray *keys;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface WalletBalanceItem : BaseObject

@property(strong, nonatomic) NSString *address;

@property(assign, nonatomic) long long confirmed;
@property(assign, nonatomic) long long unconfirmed;

@end

@interface WalletBalanceInfo : BaseObject

//id type WalletBalanceItem
@property(strong, nonatomic) BaseArray *addresses;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface WalletTradeItem : BaseObject

@property(strong, nonatomic) NSString *script;
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *addr;

@property(assign, nonatomic) long long value;
@property(assign, nonatomic) NSUInteger n;

@end

@interface WalletTradeInputItem : BaseObject

@property(strong, nonatomic) NSString *txid;
@property(strong, nonatomic) NSString *script;

//id type WalletTradeItem
@property(strong, nonatomic) WalletTradeItem *prev_out;

@property(assign, nonatomic) long long sequence;

-(id)init;

@end

@interface WalletTradeDetailItem : BaseObject

@property(strong, nonatomic) NSString *tx_hash;
@property(strong, nonatomic) NSString *block;

//id type WalletTradeInputItem
@property(strong, nonatomic) BaseArray *inputs;

//id type WalletTradeItem
@property(strong, nonatomic) BaseArray *outputs;

@property(assign, nonatomic) NSUInteger version;
@property(assign, nonatomic) NSUInteger tx_index;
@property(assign, nonatomic) long long time;
@property(assign, nonatomic) long long amount;

-(id)init;

@end

@interface WalletTradeDetailInfo : BaseObject

//id type WalletTradeDetailItem
@property(strong, nonatomic) BaseArray *txs;

-(id)init;

@end


