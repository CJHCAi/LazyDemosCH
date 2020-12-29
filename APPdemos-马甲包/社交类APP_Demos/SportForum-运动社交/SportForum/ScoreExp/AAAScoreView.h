//
//  AAAScoreView.h
//  Gamify
//
//  Created by Håkon Bogen on 12.02.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAAScoreView : UIView

/**
 *  Sets color of the score label. Default color is black.
 *
 *  @param color to set
 */
- (void)setScoreLabelColor:(UIColor*)color;

- (void)setChangeScoreLabelColor:(UIColor*)color;
/**
 *  Sets the font for the score label. Also sets the change value font to the same font.
 *  Default font is HelveticaNeue-Light 17pt
 *  @param font font to set
 */
- (void)setScoreLabelFont:(UIFont*)font;

- (void)setScoreTextAlignment:(NSTextAlignment)textAlignment;
/**
 * Sets score without any animation. Used for setting initial value
 *
 *  @param score to set
 */
- (void)setScoreWithoutAnimation:(NSInteger) score;
/**
 *  Sets the score shown in the view to the score value. Will show a hovering
 *  number with the change value indicating what value the score changed from, 
 *  example if score is 10 before its called, setcore is called with setScoreTo:15 scoreChange:5
 *  will show a +5 above the score.
 *
 *  @param score to set as new score scoreview is showing
 *  @param change label indicating what the score changed to
 */
- (void)setScoreTo:(NSInteger) score scoreChange:(NSInteger) change;

- (NSString*)labelScoreText;

@end
