//
//  YXWWPCollectionViewCell.m
//  StarAlarm
//
//  Created by dllo on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWWPCollectionViewCell.h"
#import "YXWwallPaperView.h"
@implementation YXWWPCollectionViewCell


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        self.wallPaperImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.wallPaperImageView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotification:) name:@"image" object:nil];
        
        [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
        
    }
    
        return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.wallPaperImageView.image = [UIImage imageNamed:self.imageName];
}



-(void)layoutSubviews {
    
    self.wallPaperImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}


//#pragma mark - 通知已使用
-(void)userNotification:(NSNotification *)message {
    if ([self.imageName isEqualToString:message.object ]) {
        YXWwallPaperView *wpView = [YXWwallPaperView shareUseViewWith:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self addSubview:wpView];
    }
    
}





@end
