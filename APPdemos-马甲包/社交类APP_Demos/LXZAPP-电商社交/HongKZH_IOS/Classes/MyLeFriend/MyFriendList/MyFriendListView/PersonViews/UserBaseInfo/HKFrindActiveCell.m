//
//  HKFrindActiveCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindActiveCell.h"
#import "HK_PickerCell.h"
@interface HKFrindActiveCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UICollectionView * collectionView;

@end
@implementation HKFrindActiveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,20,200,14)
                      ];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"000000"] text:@""];
    }
    return _titleLabel;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.itemSize = CGSizeMake(70, 70);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+12,kScreenWidth-30,70) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces =NO;
        _collectionView.showsHorizontalScrollIndicator =NO;
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerClass:[Hk_PickerCell class] forCellWithReuseIdentifier:@"pickerCell"];
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.response.data.dynamics.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Hk_PickerCell * photoCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"pickerCell" forIndexPath:indexPath];
    photoCell.iocnV.layer.cornerRadius =5;
    photoCell.iocnV.layer.masksToBounds = YES;
    photoCell.closeBtn.hidden =YES;
    HKmediaDynamics * model =self.response.data.dynamics[indexPath.row];
    [photoCell.iocnV sd_setImageWithURL:[NSURL URLWithString:model.coverImgSrc] placeholderImage:[UIImage imageNamed:@"back2.jpg"]];
    return photoCell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,15,0,0);
}
-(void)setResponse:(HKMediaInfoResponse *)response {
    _response = response;
    NSString *countStr =[NSString stringWithFormat:@"%zd",response.data.dynamics.count];
    NSString *titles =[NSString stringWithFormat:@"动态 %@",countStr];
    NSMutableAttributedString * att =[[NSMutableAttributedString alloc] initWithString:titles];
    [att addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(3,countStr.length)];
    _titleLabel.attributedText = att;
    [self.collectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
