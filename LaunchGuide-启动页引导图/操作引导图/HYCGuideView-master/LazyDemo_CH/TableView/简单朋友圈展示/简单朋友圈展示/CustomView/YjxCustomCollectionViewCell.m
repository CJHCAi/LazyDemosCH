//
//  CollectionViewCell.m
//  TableviewLayout
//


#import "YjxCustomCollectionViewCell.h"
#import "Masonry.h"
@interface YjxCustomCollectionViewCell ()


@end

@implementation YjxCustomCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _img = [[UIImageView alloc]init];
        [self.contentView addSubview:_img];
        _img.contentMode=UIViewContentModeScaleAspectFill;
        _img.clipsToBounds=YES;
        _img.layer.cornerRadius = 5.0;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _img.frame = self.contentView.frame;
}

@end
