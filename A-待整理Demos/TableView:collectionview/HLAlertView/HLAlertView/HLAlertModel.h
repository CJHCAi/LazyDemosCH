//
//  HLAlertModel.h
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/4.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HLAlertModel : NSObject


//:label
@property (nonatomic,assign)CGFloat leftBorder;
@property (nonatomic,assign)CGFloat rightBorder;
@property (nonatomic,assign)CGFloat topBorder;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)  UIFont *font;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,copy) UIColor *textColor;
@property (nonatomic,copy) UIColor *backgroundColor;
@property (nonatomic,assign) CGFloat cornerRadius;
@property (nonatomic,assign) BOOL maskToBounds;
@end



@interface HLLabelModel : NSObject
@property (nonatomic,copy)  UIFont              *textFont;
@property (nonatomic,assign) NSTextAlignment    textAlignment;
@property (nonatomic,copy) UIColor              *textColor;
@property (nonatomic,copy) UIColor              *backgroundColor;
@property (nonatomic,assign) CGFloat            cornerRadius;
@property (nonatomic,assign) BOOL               maskToBounds;

@end

@interface HMLabelModel : NSObject
//:label
@property (nonatomic,assign)CGFloat leftBorder;
@property (nonatomic,assign)CGFloat rightBorder;
@property (nonatomic,assign)CGFloat topBorder;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)  UIFont *font;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,copy) UIColor *textColor;
@property (nonatomic,copy) UIColor *backgroundColor;
@property (nonatomic,assign) CGFloat cornerRadius;
@property (nonatomic,assign) BOOL maskToBounds;
@end

@interface HLImageViewModel : NSObject
@property (nonatomic,assign)CGFloat leftBorder;
@property (nonatomic,assign)CGFloat rightBorder;
@property (nonatomic,assign)CGFloat topBorder;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign) CGFloat cornerRadius;
@property (nonatomic,assign) BOOL   maskToBounds;
@end

@interface HLActionModel : NSObject
@property (nonatomic,assign)CGFloat leftBorder;
@property (nonatomic,assign)CGFloat rightBorder;
@property (nonatomic,assign)CGFloat topBorder;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)  UIFont *font;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,copy) UIColor *textColor;
@property (nonatomic,copy) UIColor *backgroundColor;
@property (nonatomic,assign) CGFloat cornerRadius;
@property (nonatomic,assign) BOOL maskToBounds;
@end

@interface HLButtonModel : NSObject

@property (nonatomic,copy)   UIFont             *font;
@property (nonatomic,assign) NSTextAlignment    textAlignment;
@property (nonatomic,copy)   UIColor            *textColor;
@property (nonatomic,copy)   UIColor            *backgroundColor;
@property (nonatomic,copy)   UIColor            *normalColor;
@property (nonatomic,copy)   UIColor            *highlightedColor;
@property (nonatomic,copy)   UIColor            *disabledColor;
@property (nonatomic,assign) CGFloat            cornerRadius;
@property (nonatomic,assign) BOOL               maskToBounds;

@end


@interface Constraint : NSObject
@property (nonatomic,assign)CGFloat left;
@property (nonatomic,assign)CGFloat right;
@property (nonatomic,assign)CGFloat top;
@property (nonatomic,assign)CGFloat bottom;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)BOOL    autoRelation;
@end

@interface HLTextModel : NSObject
@property (nonatomic,copy)      UIFont          *textFont;
@property (nonatomic,assign)    NSTextAlignment textAlignment;
@property (nonatomic,copy)      UIColor         *textColor;
@property (nonatomic,copy)      UIColor         *backgroundColor;
@property (nonatomic,assign)    CGFloat         cornerRadius;
@property (nonatomic,assign)    BOOL            maskToBounds;
@property (nonatomic,assign)    BOOL            scrollEnable;
@end
NS_ASSUME_NONNULL_END
