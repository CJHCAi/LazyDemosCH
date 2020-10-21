//
//  publishCollectionViewCell.m
//  LuoChang
//
//  Created by Supwin_mbp002 on 16/1/12.
//  Copyright © 2016年 Rick. All rights reserved.
//

#import "publishCollectionViewCell.h"

@implementation publishCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
}
- (IBAction)deleteCell:(id)sender {
    if ([self.delegate respondsToSelector:@selector(publishCellDelteClick:)]) {
        [self.delegate publishCellDelteClick:self];
    }
}

@end
