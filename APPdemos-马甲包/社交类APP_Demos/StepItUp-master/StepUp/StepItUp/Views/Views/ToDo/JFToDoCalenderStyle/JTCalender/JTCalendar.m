//
//  JTCalendar.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendar.h"
#import "JTCalendarWeekView.h"
#import "JTCalendarMonthView.h"
#import "JTCalendarDayView.h"

#define NUMBER_PAGES_LOADED 3 // Must be the same in JTCalendarView, JTCalendarMenuView, JTCalendarContentView

@interface JTCalendar(){
    BOOL cacheLastWeekMode;
    NSUInteger cacheFirstWeekDay;
}

@end
static NSString *const kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendar

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self->_currentDate = [NSDate date];
    self->_calendarAppearance = [JTCalendarAppearance new];
    self->_dataCache = [JTCalendarDataCache new];
    self.dataCache.calendarManager = self;

    
    return self;
}

// Bug in iOS
- (void)dealloc
{
    [self->_menuMonthsView setDelegate:nil];
    [self->_contentView setDelegate:nil];
}

- (void)setMenuMonthsView:(JTCalendarMenuView *)menuMonthsView
{
    [self->_menuMonthsView setDelegate:nil];
    [self->_menuMonthsView setCalendarManager:nil];
    
    self->_menuMonthsView = menuMonthsView;
    [self->_menuMonthsView setDelegate:self];
    [self->_menuMonthsView setCalendarManager:self];
    
    cacheLastWeekMode = self.calendarAppearance.isWeekMode;
    cacheFirstWeekDay = self.calendarAppearance.calendar.firstWeekday;
    
    [self.menuMonthsView setCurrentDate:self.currentDate];
    [self.menuMonthsView reloadAppearance];
}

- (void)setContentView:(JTCalendarContentView *)contentView
{
    [self->_contentView setDelegate:nil];
    [self->_contentView setCalendarManager:nil];
    
    self->_contentView = contentView;
    [self->_contentView setDelegate:self];
    [self->_contentView setCalendarManager:self];
    
    [self.contentView setCurrentDate:self.currentDate];
    [self.contentView reloadAppearance];
}

- (void)reloadData
{
    // Erase cache
    [self.dataCache reloadData];
    
    [self repositionViews];
    [self.contentView reloadData];
}

- (void)reloadAppearance
{
    [self.menuMonthsView reloadAppearance];
    [self.contentView reloadAppearance];
    
    if(cacheLastWeekMode != self.calendarAppearance.isWeekMode || cacheFirstWeekDay != self.calendarAppearance.calendar.firstWeekday){
        cacheLastWeekMode = self.calendarAppearance.isWeekMode;
        cacheFirstWeekDay = self.calendarAppearance.calendar.firstWeekday;
        
        [self setCurrentDate:self.currentDate];
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    NSAssert(currentDate, @"JTCalendar currentDate cannot be null");

    self->_currentDate = currentDate;
    
    [self.menuMonthsView setCurrentDate:currentDate];
    [self.contentView setCurrentDate:currentDate];
    
    [self repositionViews];
    [self.contentView reloadData];
//    //test
//    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
//    NSInteger unitFlags = NSYearCalendarUnit |
//    NSMonthCalendarUnit |
//    NSDayCalendarUnit |
//    NSWeekdayCalendarUnit |
//    NSHourCalendarUnit |
//    NSMinuteCalendarUnit |
//    NSSecondCalendarUnit;
//    NSCalendar *calendar = self.calendarAppearance.calendar;
//    comps = [calendar components:unitFlags fromDate:currentDate];
//    int week = [comps weekday];
////    //self.calendarAppearance.calendar
////    NSMutableArray* a = [self.contentView getViews ];
//    //self.currentDateSelected = currentDate;
//    NSDate* test = self.currentDateSelected ;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(self.calendarAppearance.isWeekMode){
        return;
    }
    
    CGFloat ratio = CGRectGetWidth(self.contentView.frame) / CGRectGetWidth(self.menuMonthsView.frame);
    if(isnan(ratio)){
        ratio = 1.;
    }
    ratio *= self.calendarAppearance.ratioContentMenu;
    
    if(sender == self.menuMonthsView && self.menuMonthsView.scrollEnabled){
        self.contentView.contentOffset = CGPointMake(sender.contentOffset.x * ratio, self.contentView.contentOffset.y);
    }
    else if(sender == self.contentView && self.contentView.scrollEnabled){
        self.menuMonthsView.contentOffset = CGPointMake(sender.contentOffset.x / ratio, self.menuMonthsView.contentOffset.y);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self.contentView){
        self.menuMonthsView.scrollEnabled = NO;
    }
    else if(scrollView == self.menuMonthsView){
        self.contentView.scrollEnabled = NO;
    }
}

// Use for scroll with scrollRectToVisible or setContentOffset
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)updatePage
{
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat fractionalPage = self.contentView.contentOffset.x / pageWidth;
        
    int currentPage = roundf(fractionalPage);
    if (currentPage == (NUMBER_PAGES_LOADED / 2)){
        self.menuMonthsView.scrollEnabled = YES;
        self.contentView.scrollEnabled = YES;
        return;
    }
    
    NSCalendar *calendar = self.calendarAppearance.calendar;
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    if(!self.calendarAppearance.isWeekMode){
        dayComponent.month = currentPage - (NUMBER_PAGES_LOADED / 2);
    }
    else{
        dayComponent.day = 7 * (currentPage - (NUMBER_PAGES_LOADED / 2));
    }
    
    NSDate *currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    //假如是周模式，移动的时候设置currentDate 为选中
    if (self.calendarAppearance.isWeekMode) {
        NSMutableArray* test = [self.contentView getViews ];
        for (JTCalendarMonthView* i in test) {
            for (JTCalendarWeekView* j in [i getWeeksViews]) {
                for (JTCalendarDayView* day in [j getDaysViews]) {
                    if (day.date == currentDate) {
                        //
                        [day setThisSelected];
                    } ;
                    
                }
            }
        }
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"kJTCalendarDaySelected" object:currentDate];
    [self setCurrentDate:currentDate];
    
    self.menuMonthsView.scrollEnabled = YES;
    self.contentView.scrollEnabled = YES;
}


- (void)repositionViews
{
    // Position to the middle page
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    self.contentView.contentOffset = CGPointMake(pageWidth * ((NUMBER_PAGES_LOADED / 2)), self.contentView.contentOffset.y);
    CGFloat x = self.contentView.contentOffset.x;
    CGFloat menuPageWidth = CGRectGetWidth([self.menuMonthsView.subviews.firstObject frame]);
    self.menuMonthsView.contentOffset = CGPointMake(menuPageWidth * ((NUMBER_PAGES_LOADED / 2)), self.menuMonthsView.contentOffset.y);
    x = self.contentView.contentOffset.x;
}

- (void)loadNextMonth
{
    if(self.calendarAppearance.isWeekMode){
        NSLog(@"JTCalendar loadNextMonth ignored");
        return;
    }
    
    self.menuMonthsView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) + 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

- (void)loadPreviousMonth
{
    if(self.calendarAppearance.isWeekMode){
        NSLog(@"JTCalendar loadPreviousMonth ignored");
        return;
    }
    
    self.menuMonthsView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) - 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

@end
