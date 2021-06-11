//
//  CustomCellTableViewCell.m
//  上网管理 － 学龄宝
//
//  Created by MAC on 15/2/4.
//  Copyright (c) 2015年 SaiHello. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // 如果找不到就从xib中创建cell
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil] firstObject];
        NSLog(@"创建一个新的cell");
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setBrowseInfo:(BrowseInfo *)browseInfo
{
    _browseInfo = browseInfo;
    _titleLable.text = browseInfo.lable;
}

- (IBAction)OnClick:(id)sender {
    NSMutableString *JSON = [[NSMutableString alloc]initWithString:_titleLable.text];
    [JSON appendString:@"已被加入黑名单！"];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle: @"提示"
                                                          message: JSON
                                                         delegate: nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    [myAlertView show];
}
@end
