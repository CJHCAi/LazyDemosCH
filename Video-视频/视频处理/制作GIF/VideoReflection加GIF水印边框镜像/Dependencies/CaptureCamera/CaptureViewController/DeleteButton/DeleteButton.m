
#import "DeleteButton.h"

#define DELETE_BTN_NORMAL_IAMGE @"record_delete_normal.png"
#define DELETE_BTN_DELETE_IAMGE @"record_deletesure_normal.png"
#define DELETE_BTN_DISABLE_IMAGE @"record_delete_disable.png"

@interface DeleteButton ()


@end

@implementation DeleteButton

+ (DeleteButton *)getInstance
{
    DeleteButton *deleteButton = [[DeleteButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    return deleteButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    [self setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:DELETE_BTN_DISABLE_IMAGE] forState:UIControlStateDisabled];
}

- (void)setButtonStyle:(DeleteButtonStyle)style
{
    self.style = style;
    switch (style)
    {
        case DeleteButtonStyleNormal:
        {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
            
            break;
        }
        case DeleteButtonStyleDisable:
        {
            self.enabled = NO;
            break;
        }
        case DeleteButtonStyleDelete:
        {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:DELETE_BTN_DELETE_IAMGE] forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }
}

@end
