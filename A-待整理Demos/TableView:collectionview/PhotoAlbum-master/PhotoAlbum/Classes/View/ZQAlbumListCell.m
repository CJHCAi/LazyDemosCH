//
//  CTAlbumListCell.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQAlbumListCell.h"
#import "ZQAlbumModel.h"
#import "ZQPhotoFetcher.h"

@interface ZQAlbumListCell ()
@property (nonatomic, strong) UIImageView *ivCover;
@property (nonatomic, strong) UILabel *lblTitle;

@end
@implementation ZQAlbumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.ivCover = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, AlbumListCellHeight - 10.0, AlbumListCellHeight - 10.0)];
        self.ivCover.contentMode = UIViewContentModeScaleAspectFill;
        self.ivCover.clipsToBounds = YES;
        [self.contentView addSubview:self.ivCover];
        
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.ivCover.frame.origin.x + self.ivCover.frame.size.width + 20, 0, 200, AlbumListCellHeight)];
        [self.contentView addSubview:self.lblTitle];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setModel:(ZQAlbumModel *)model indexPath:(NSIndexPath *)indexPath {
    _model = model;
    UIFont *font = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)", model.count] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.lblTitle.attributedText = nameString;
    __weak __typeof(&*self) wSelf = self;
    [ZQPhotoFetcher getAlbumCoverFromAlbum:self.model completion:^(UIImage *cover, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wSelf.tag == indexPath.row) {
                if (cover) {
                    wSelf.ivCover.image = cover;
                }
            }
        });
        
    }];
}

@end
