#import <UIKit/UIKit.h>
#import "IntroView.h"

@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    
    NSTimer *timer;
    
    int currentPhotoNum;
}

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;
-(void)setCurrentPage:(int)nPageNum;
-(UIImage*)getCurrentPageImage;
-(int)getCurrentPhotoNum;

@end
