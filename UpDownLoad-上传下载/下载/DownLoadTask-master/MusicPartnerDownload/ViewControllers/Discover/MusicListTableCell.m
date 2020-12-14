//
//  MusicListTableCell.m
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/13.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import "MusicListTableCell.h"

@implementation MusicListTableCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)downLoadAction:(UIButton *)sender {
    [self.delegate addDownLoadTaskAction:self.index];
}


-(void)showData:(NSDictionary *)data{
    self.name.text = [data objectForKey:@"name"];
    self.desc.text = [data objectForKey:@"desc"];
    self.img.image = [UIImage imageNamed:[data objectForKey:@"imgName"]];
}

@end
