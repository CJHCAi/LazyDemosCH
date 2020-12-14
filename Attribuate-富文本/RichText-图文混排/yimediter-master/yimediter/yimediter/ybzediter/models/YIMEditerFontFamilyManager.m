//
//  YIMEditerFontManager.m
//  yimediter
//
//  Created by ybz on 2017/11/26.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerFontFamilyManager.h"

@interface YIMEditerFontFamilyManager()
@property(nonatomic,strong)NSMutableArray<NSString*>* reigisterFonts;
@end

@implementation YIMEditerFontFamilyManager

static YIMEditerFontFamilyManager *_defualtFontManager;
+(instancetype)defualtManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defualtFontManager = [[YIMEditerFontFamilyManager alloc]init];
    });
    return _defualtFontManager;
}
-(instancetype)init{
    if (self = [super init]) {
        self.reigisterFonts = [NSMutableArray array];
    }
    return self;
}

-(UIFont*)fontWithName:(NSString *)name size:(CGFloat)size{
    return [UIFont fontWithName:name size:size];
}
-(NSArray<NSString*>*)allRegistFontName{
    return [NSArray arrayWithArray:self.reigisterFonts];
}

-(BOOL)regiestFont:(NSString *)fontName{
    if([UIFont fontWithName:fontName size:16]){
        if(![self.reigisterFonts containsObject:fontName]){
            [self.reigisterFonts addObject:fontName];
            return true;
        }
    }
    return false;
}
-(void)removeFont:(NSString *)fontName{
    [self.reigisterFonts removeObject:fontName];
}

@end
