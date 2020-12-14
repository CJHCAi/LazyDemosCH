//
//  YIMEditerDrawAttributes.m
//  yimediter
//
//  Created by ybz on 2017/12/1.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerDrawAttributes.h"

@interface YIMEditerDrawAttributes(){
    @protected
    NSDictionary* _textAttributed;
    NSDictionary* _paragraphAttributed;
}
@end

@implementation YIMEditerDrawAttributes
-(instancetype)initWithAttributeString:(NSDictionary*)attribute{
    if (self = [super init]) {
        _textAttributed = attribute;
    }
    return self;
}
-(void)updateAttributed:(YIMEditerDrawAttributes *)attributed{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:_textAttributed];
    [mutableDic addEntriesFromDictionary:attributed.textAttributed];
    _textAttributed = mutableDic;
    
    NSMutableDictionary *paragraphDic = [NSMutableDictionary dictionaryWithDictionary:_paragraphAttributed];
    [paragraphDic addEntriesFromDictionary:attributed.paragraphAttributed];
    _paragraphAttributed = paragraphDic;
}
-(NSDictionary*)textAttributed{
    return _textAttributed;
}
-(NSDictionary*)paragraphAttributed{
    return _paragraphAttributed;
}
@end


@implementation YIMEditerMutableDrawAttributes
@dynamic textAttributed;
@dynamic paragraphAttributed;

-(void)setTextAttributed:(NSDictionary *)textAttributed{
    _textAttributed =  textAttributed;
}
-(void)setParagraphAttributed:(NSDictionary *)paragraphAttributed{
    _paragraphAttributed = paragraphAttributed;
}

@end
