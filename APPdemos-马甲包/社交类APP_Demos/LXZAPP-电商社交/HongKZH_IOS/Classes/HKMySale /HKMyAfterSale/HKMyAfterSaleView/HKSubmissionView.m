//
//  HKSubmissionView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSubmissionView.h"
#import "UIImage+YY.h"
@interface HKSubmissionView()
@property (weak, nonatomic) IBOutlet UIButton *submission;

@end

@implementation HKSubmissionView

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKSubmissionView" owner:self options:nil].lastObject;
    if (self) {
        UIImage *image = [UIImage createImageWithColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1] size:CGSizeMake(kScreenWidth-30, 50)];
        image = [image zsyy_imageByRoundCornerRadius:5];
        [self.submission setBackgroundImage:image forState:0];
        UIImage *selctImage = [UIImage createImageWithColor:[UIColor blueColor] size:CGSizeMake(kScreenWidth-30, 50)];
        selctImage = [selctImage zsyy_imageByRoundCornerRadius:5];
        self.submission.userInteractionEnabled = NO;
        [self.submission setBackgroundImage:selctImage forState:UIControlStateSelected];
    }
    return self;
}
-(void)setBtnuserInteractionEnabled:(BOOL)btnuserInteractionEnabled{
    _btnuserInteractionEnabled = btnuserInteractionEnabled;
    self.submission.userInteractionEnabled = btnuserInteractionEnabled;
    if (btnuserInteractionEnabled) {
        self.submission.selected = YES;
    }else{
        self.submission.selected = NO;
    }
}
- (IBAction)submission:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submissionViewData)]) {
        [self.delegate submissionViewData];
    }
}
@end
