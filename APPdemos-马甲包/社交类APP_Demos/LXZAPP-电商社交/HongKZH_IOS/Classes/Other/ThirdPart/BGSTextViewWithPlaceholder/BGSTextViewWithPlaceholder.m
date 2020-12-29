//
//  BGSTextViewWithPlaceholder.m
//  BGSTextViewWithPlaceholder
//
//  Created by Peter Todd Air on 30/08/2014.
//

#import "BGSTextViewWithPlaceholder.h"

#define APP_FRAME [UIScreen mainScreen ].applicationFrame
#define SCREEN_FRAME [UIScreen mainScreen ].bounds
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]
#define kColorLoginInput UICOLOR_RGB_Alpha(0x576c7c,1.0)
#define kColorLoginPrompt UICOLOR_RGB_Alpha(0x576c7c,1.0)
#define kColorHomeBTN UICOLOR_RGB_Alpha(0xEFF3F8,1.0)
#define UICOLOR_BIG [UIColor colorWithRed:106.0f/255 green:115.0f/255 blue: 125.0f/255 alpha:1.0f]
#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

@interface BGSTextViewWithPlaceholder ()
@property (strong, nonatomic) UILabel *lblPlaceholder;
@end

@implementation BGSTextViewWithPlaceholder
@synthesize strPlaceholder = _strPlaceholder;


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configTextView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configTextView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void)configTextView
{
    // Test
    /*
     if (!self.strPlaceholder)
     {
     NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"TEST LABEL but very long but very long but very long but very long but very long but very long ."];
     [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(2,2)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(7,1)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(6, 2)];
     [self setStrPlaceholder:str];
     }
     */
    
    
    
    
    if (self.strPlaceholder)
    {
        [self configNotifications];
        [self configLabel];
        
        
    }
}

-(void)configNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(textDidChange:)
                               name:UITextViewTextDidChangeNotification object:self];
    
    [notificationCenter addObserver:self selector:@selector(editDidBegin:)
                               name:UITextViewTextDidBeginEditingNotification object:self];
    
    
    [notificationCenter addObserver:self selector:@selector(editDidEnd:)
                               name:UITextViewTextDidEndEditingNotification object:self];
    
    
}



- (void)textDidChange:(NSNotification *)notification
{
    if (self.lblPlaceholder)
    {
        [self.lblPlaceholder removeFromSuperview];
        [self setLblPlaceholder:Nil];
        
    }
}

- (void)editDidBegin:(NSNotification *)notification
{
    if (self.lblPlaceholder)
    {
        [self.lblPlaceholder removeFromSuperview];
        [self setLblPlaceholder:Nil];
        
    }}

- (void)editDidEnd:(NSNotification *)notification
{
    if (self.text.length > 0)
    {
        if (self.lblPlaceholder)
        {
            [self.lblPlaceholder removeFromSuperview];
            [self setLblPlaceholder:Nil];
            
        }        return;
    }else
    {
        [self configLabel];
    }
    
}

-(void)configLabel
{
    if (self.text.length > 0)
    {
        [self.lblPlaceholder removeFromSuperview];
        [self setLblPlaceholder:Nil];
        
        return;
    }
    CGRect frameLbl = self.bounds;
    int heightLbl = frameLbl.size.height;
    int widthlbl = frameLbl.size.width;
    if (self.intHeight > 0)
    {
        heightLbl = self.intHeight;
    }
    if (self.intWidth > 0)
    {
        widthlbl = self.intWidth;
    }
    // Set the placeholder poistion.
//    CGRect frameLblUpd = CGRectMake(frameLbl.origin.x+3+5, frameLbl.origin.y-30+2-30, widthlbl, heightLbl);
    CGRect frameLblUpd = CGRectMake(frameLbl.origin.x+3, frameLbl.origin.y+2, widthlbl, heightLbl);
    if (!self.lblPlaceholder)
    {
        self.lblPlaceholder = [[UILabel alloc]initWithFrame:frameLblUpd];
    }
    
    
    // Default the text color but will be updated by Attributed string properties
//    [self.lblPlaceholder setTextColor:[UIColor lightGrayColor]];
     [self.lblPlaceholder setTextColor:UICOLOR_RGB_Alpha(0xcccccc, 1)];
    
    // Number of Line
    if (self.intLines > 1)
    {
        [self.lblPlaceholder setNumberOfLines:self.intLines];
    }
    
    [self.lblPlaceholder setAttributedText:[self strPlaceholder]];
    if ([self sizeLblToFit])
    {
        self.lblPlaceholder.adjustsFontSizeToFitWidth=YES;
        self.lblPlaceholder.minimumScaleFactor=0.1;
    }

    self.lblPlaceholder.textColor =UICOLOR_RGB_Alpha(0xcccccc, 1);
    self.lblPlaceholder.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblPlaceholder];
    
}

-(void)changePlaceholderSize
{
    CGRect frameLbl = self.bounds;
    int heightLbl = frameLbl.size.height;
    int widthlbl = frameLbl.size.width;
    if (self.intHeight > 0)
    {
        heightLbl = self.intHeight;
    }
    if (self.intWidth > 0)
    {
        widthlbl = self.intWidth;
    }
    self.lblPlaceholder.frame = CGRectMake(frameLbl.origin.x+3+5, frameLbl.origin.y-30+2-30, widthlbl, heightLbl);
}

// Custom setter to show label if neccessary
-(void)setStrPlaceholder:(NSAttributedString *)strPlaceholder
{
    [self.lblPlaceholder setText:@""];
    
    _strPlaceholder = strPlaceholder;
    
    [self configTextView];
}

- (UIFont *)customFont:(NSString *)fontName size:(CGFloat)fontSize
{
    return [UIFont fontWithName:fontName size:fontSize];
}

-(UIFont*)customFontsize:(CGFloat)fontSize
{
//    UIFont*font =  [self customFont:@"Hiragino Sans GB" size:fontSize];
    UIFont*font =  [UIFont systemFontOfSize:fontSize];
    return font;
}

// Method to clear placehodler

- (void)clearPlaceholder
{
    [self textDidChange:Nil];
}

@end
