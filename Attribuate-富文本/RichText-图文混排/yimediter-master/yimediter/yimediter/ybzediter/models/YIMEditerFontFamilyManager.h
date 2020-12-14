//
//  YIMEditerFontManager.h
//  yimediter
//
//  Created by ybz on 2017/11/26.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YIMEditerFontFamilyManager : NSObject


/** 获取字体 */
-(UIFont*)fontWithName:(NSString*)name size:(CGFloat)size;
/** 获取所有注册的字体名称 */
-(NSArray<NSString*>*)allRegistFontName;

-(BOOL)regiestFont:(NSString*)fontName;
-(void)removeFont:(NSString*)fontName;

+(instancetype)defualtManager;

@end
