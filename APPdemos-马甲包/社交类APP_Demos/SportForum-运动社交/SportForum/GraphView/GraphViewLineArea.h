
#import <UIKit/UIKit.h>

@interface GraphViewLineArea : UIView

@property (nonatomic, assign) CGFloat fSteps;
@property (nonatomic, assign) CGFloat fMinY;
@property (nonatomic, assign) CGFloat fMaxY;
@property (nonatomic, strong) NSString *xUnit;
@property (nonatomic, strong) UILabel *labelMonth;

- (id)initWithFrame:(CGRect)frame StartDay:(NSDate*) startDate XOffset:(CGFloat) xOffSet YOffset:(CGFloat) yOffSet;
- (void)setLabelMonthText:(NSString*)strText Color:(UIColor*)color;

@end
