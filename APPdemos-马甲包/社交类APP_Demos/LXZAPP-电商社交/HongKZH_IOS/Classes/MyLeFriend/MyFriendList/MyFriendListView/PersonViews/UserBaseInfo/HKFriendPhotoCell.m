//
//  HKFriendPhotoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendPhotoCell.h"
#import "HK_PickerCell.h"
@interface HKFriendPhotoCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView * collectionView;

@end
@implementation HKFriendPhotoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5.0;
    layout.itemSize = CGSizeMake(80, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,15,kScreenWidth,80) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces =NO;
    self.collectionView.showsHorizontalScrollIndicator =NO;
    self.collectionView.backgroundColor =[UIColor whiteColor];
    [self.collectionView registerClass:[Hk_PickerCell class] forCellWithReuseIdentifier:@"pickerCell"];
    [self.contentView addSubview:self.collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.response.data.albums.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Hk_PickerCell * photoCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"pickerCell" forIndexPath:indexPath];
    photoCell.iocnV.layer.cornerRadius =5;
    photoCell.iocnV.layer.masksToBounds = YES;
    photoCell.closeBtn.hidden =YES;
    HKMediainfoAlbums * model =self.response.data.albums[indexPath.row];
    [photoCell.iocnV sd_setImageWithURL:[NSURL URLWithString:model.imgSrc] placeholderImage:[UIImage imageNamed:@"back1.jpg"]];
    return photoCell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
       return UIEdgeInsetsMake(0,15,0,0);
}
-(void)setResponse:(HKMediaInfoResponse *)response {
    _response = response;
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
