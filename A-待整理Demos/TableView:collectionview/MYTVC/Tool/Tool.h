//
//  Tool.h
//  cellLLLLL
//
//  Created by Janice on 2017/10/11.
//  Copyright © 2017年 Janice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface Tool : NSObject
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;

+(NSAttributedString *)theRichText:(NSString *)string theRange:(NSUInteger)theRange changeRange:(NSInteger)changeRange color:(UIColor *)color;
@end
