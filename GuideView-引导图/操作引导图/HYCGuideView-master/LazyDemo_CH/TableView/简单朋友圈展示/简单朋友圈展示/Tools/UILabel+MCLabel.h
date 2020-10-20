//
//  UILabel+MCLabel.h
//  MCLabel
//

#import <UIKit/UIKit.h>
/* Values for NSWritingDirection */
typedef NS_ENUM(NSInteger, MCTextDirection) {
    MCTextDirectionNatural       = -1,    // Determines direction using the Unicode Bidi Algorithm rules P2 and P3
    MCTextDirectionLeft   =  0,    // Left to right writing direction
    MCTextDirectionRight   =  1     // Right to left writing direction
};

@interface UILabel (MCLabel)

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;
/**
 *  设置文字对齐方向
 */
- (void)setTextDirection:(MCTextDirection)direction;

@end
