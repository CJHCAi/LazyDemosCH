//
//  MySingleData.m
//  VoiceRobotQ
//
//  Created by 李宁 on 15/12/28.
//  Copyright © 2015年 Nathan. All rights reserved.
//

#import "MySingleData.h"

static MySingleData * mm=nil;
@implementation MySingleData
+(instancetype)shareMyData{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mm = [[MySingleData alloc]init];
    });
    
    return mm;
}

-(NSMutableArray *)lanArr{
    if (_lanArr==nil) {
        
        _defaultLan=0;//默认是中文
        
        _lanArr = [NSMutableArray arrayWithCapacity:30];
        
        
        _lanArr[0]=@"英语";
        _lanArr[1]=@"中文";
        _lanArr[2]=@"粤语";
        _lanArr[3]=@"文言文";
        _lanArr[4]=@"瑞典语";
        
        
        _lanArr[5]=@"日语";
        _lanArr[6]=@"韩语";
        _lanArr[7]=@"法语";
        _lanArr[8]=@"西班牙语";
        _lanArr[9]=@"泰语";
        
        _lanArr[10]=@"阿拉伯语";
        _lanArr[11]=@"俄语";
        _lanArr[12]=@"葡萄牙语";
        _lanArr[13]=@"德语";
        _lanArr[14]=@"意大利语";
        
        _lanArr[15]=@"希腊语";
        _lanArr[16]=@"荷兰语";
        _lanArr[17]=@"波兰语";
        _lanArr[18]=@"保加利亚语";
        _lanArr[19]=@"爱沙尼亚语";
        
        
        _lanArr[20]=@"丹麦语";
        _lanArr[21]=@"芬兰语";
        _lanArr[22]=@"捷克语";
        _lanArr[23]=@"罗马尼亚语";
        _lanArr[24]=@"斯洛文尼亚语";
        
        
        _lanArr[25]=@"匈牙利语";
        _lanArr[26]=@"繁体中文";
        
    }
    return _lanArr;
}
-(NSMutableArray *)lanCodeArr{
    if (_lanCodeArr==nil) {
        _lanCodeArr = [NSMutableArray arrayWithCapacity:30];
        
        
        _lanCodeArr[0]=@"en";
        _lanCodeArr[1]=@"zh";
        _lanCodeArr[2]=@"yue";
        _lanCodeArr[3]=@"wyw";
        _lanCodeArr[4]=@"swe";
        
        _lanCodeArr[5]=@"jp";
        _lanCodeArr[6]=@"kor";
        _lanCodeArr[7]=@"fra";
        _lanCodeArr[8]=@"spa";
        _lanCodeArr[9]=@"th";
        
        _lanCodeArr[10]=@"ara";
        _lanCodeArr[11]=@"ru";
        _lanCodeArr[12]=@"pt";
        _lanCodeArr[13]=@"de";
        _lanCodeArr[14]=@"it";
        
        _lanCodeArr[15]=@"el";
        _lanCodeArr[16]=@"nl";
        _lanCodeArr[17]=@"pl";
        _lanCodeArr[18]=@"bul";
        _lanCodeArr[19]=@"est";
        
        
        _lanArr[20]=@"dan";
        _lanArr[21]=@"fin";
        _lanArr[22]=@"cs";
        _lanArr[23]=@"rom";
        _lanArr[24]=@"slo";
        
        
        _lanArr[25]=@"hu";
        _lanArr[26]=@"cht";
    }
    return _lanCodeArr;
}
@end
