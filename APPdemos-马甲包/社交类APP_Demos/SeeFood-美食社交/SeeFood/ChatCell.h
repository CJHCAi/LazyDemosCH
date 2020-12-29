//
//  ChatCell.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inMessageLable;
@property (weak, nonatomic) IBOutlet UILabel *outMessageLable;
@property (weak, nonatomic) IBOutlet UIImageView *inImage;
@property (weak, nonatomic) IBOutlet UIImageView *outImage;

- (void)updateFrameWithMessage:(NSString *)message;
+ (CGFloat)heightForText:(NSString *)text;
@end
