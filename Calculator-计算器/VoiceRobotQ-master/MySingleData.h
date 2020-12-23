//
//  MySingleData.h
//  VoiceRobotQ
//
//  Created by 李宁 on 15/12/28.
//  Copyright © 2015年 Nathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingleData : NSObject

@property(nonatomic,copy) NSString * aString;
@property(nonatomic,assign)NSInteger LanNumber;//语言序号
+(instancetype)shareMyData;

@property(nonatomic,strong)NSMutableArray *lanCodeArr;//语言列表-代码
@property(nonatomic,assign)NSInteger defaultLan;//默认是0 汉语
@property(nonatomic,strong)NSMutableArray *lanArr;//语言列表-汉语名字

@end
