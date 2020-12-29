//
//  WalletInfo.m
//  SportForum
//
//  Created by liyuan on 14-9-16.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "WalletInfo.h"

@implementation WalletAddressItem

@end

@implementation WalletInfo

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.keys = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation WalletBalanceItem

@end

@implementation WalletBalanceInfo

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.addresses = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation WalletTradeItem

@end

@implementation WalletTradeInputItem

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.prev_out = [[WalletTradeItem alloc]init];
    }
    
    return self;
}

@end

@implementation WalletTradeDetailItem

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.inputs = [[BaseArray alloc]initWithSubName:@"WalletTradeInputItem"];
        self.outputs = [[BaseArray alloc]initWithSubName:@"WalletTradeItem"];
    }
    
    return self;
}

@end

@implementation WalletTradeDetailInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.txs = [[BaseArray alloc]initWithSubName:@"WalletTradeDetailItem"];
    }
    
    return self;
}

@end
