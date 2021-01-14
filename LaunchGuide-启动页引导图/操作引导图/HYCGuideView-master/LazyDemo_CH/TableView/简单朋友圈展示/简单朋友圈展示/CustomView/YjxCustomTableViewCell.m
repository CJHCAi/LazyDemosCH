//
//  TableViewCell.m
//  TableviewLayout
//


#import "YjxCustomTableViewCell.h"
#import "Masonry.h"
#import "YjxCustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"
#import "UIColor+YMHex.h"
//列数
#define item_num 3
#define pading 10

@interface YjxCustomTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate,btnClickedDelegate>


@end
@implementation YjxCustomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.timeL];
        [self.contentView addSubview:self.personalLibL];
        [self.contentView addSubview:self.textContentL];
        [self.contentView addSubview:self.collectView];
        [self.contentView addSubview:self.toolbar];
        [self.contentView addSubview:self.line];


        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            make.height.mas_equalTo(@40);
            make.width.mas_equalTo(@40);
        }];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            make.height.mas_equalTo(@15);
            make.width.mas_equalTo(@120);
        }];
        
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImg.mas_right).mas_offset(10);
            make.right.mas_equalTo(self.timeL.mas_left).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(15);
            make.height.mas_equalTo(@15);
        }];
        
        [self.personalLibL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImg.mas_right).mas_offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
            make.top.mas_equalTo(self.nameL.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(@15);
        }];
        
        
        [self.textContentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
            make.top.mas_equalTo(self.iconImg.mas_bottom).mas_offset(15);
        }];
        //设置子视图与父视图的约束，以便b子视图变化是能“撑”起父视图
        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textContentL.mas_bottom).mas_offset(10);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(@1).priorityLow();//设置一个高度，以便赋值后更新
        }];
        
        //设置子视图与父视图的约束，以便b子视图变化是能“撑”起父视图
        [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectView.mas_bottom).mas_offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(@50.0);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(@1.0);
        }];
        
    }
    return self;
}
- (void)setModel:(YjxCustomModel *)model {
    _model = model;
    self.iconImg.image = [UIImage imageNamed:model.iconImg];
    self.nameL.text = model.nickname;
    self.timeL.text = model.timeStr;
    self.textContentL.text = model.textContent;
    self.personalLibL.text = model.personal;
    //行距 字间距
    [_textContentL setColumnSpace:2.0];
    [_textContentL setRowSpace:10.0];
    [self reloadCell:model.imageArr];
}

- (void)reloadCell:(NSArray *)imgarr{
    //更新collectionView
    [self.collectView reloadData];
    [self.collectView layoutIfNeeded];
    [self.collectView setNeedsLayout];
    CGFloat height_pading;
    CGFloat height_collectionview;
    if (imgarr.count > 0) {
        height_pading = 15;
        height_collectionview = self.collectView.collectionViewLayout.collectionViewContentSize.height;
    }else {
        height_pading = 0;
        height_collectionview = 5;
    }
    [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textContentL.mas_bottom).mas_offset(height_pading);

        make.height.equalTo(@(height_collectionview));
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *tagsArr = _model.imageArr;
    
    return tagsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YjxCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    NSArray *tagsArr = _model.imageArr;
    cell.img.image = [UIImage imageNamed:tagsArr[indexPath.row]];
    //    [cell.img sd_setImageWithURL:[NSURL URLWithString:tagsArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zahnweitu"]];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(pading, pading, pading, pading);//分别为上、左、下、右
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat item_height = ([UIScreen mainScreen].bounds.size.width-((item_num+1)*pading))/item_num;
    CGSize size = CGSizeMake(item_height,item_height);
    return size;
}
//这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//两个cell之间的最小间距间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
    broser.currentImageIndex = indexPath.row;
    broser.sourceImagesContainerView = self.collectView;
    NSArray *tagsArr = _model.imageArr;
    broser.imageCount = tagsArr.count;
    broser.delegate = self;
    [broser show];
}

//网址 的iamge
-(NSURL*)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    //网络图片（如果崩溃，可能是此图片地址不存在了）
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str in _model.imageArr) {
        [arr addObject:str];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", arr[index]]];
    
    return url;
}
//占位图
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImage *img = [UIImage imageNamed:@"zhanweitu"];
    return img;
}
-(UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate=self;
        _collectView.dataSource=self;
        [_collectView registerClass:[YjxCustomCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    }
    return _collectView;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.backgroundColor = [UIColor whiteColor];
        _iconImg.clipsToBounds = YES;
        _iconImg.contentMode=UIViewContentModeScaleAspectFill;
        _iconImg.layer.cornerRadius = 20;
        _iconImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapClick)];
        [_iconImg addGestureRecognizer:tap];
    }
    return _iconImg;
}
- (UILabel *)nameL {
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.font = [UIFont systemFontOfSize:15];
        _nameL.backgroundColor = [UIColor whiteColor];
    }
    return _nameL;
}
- (UILabel *)personalLibL {
    if (!_personalLibL) {
        _personalLibL = [[UILabel alloc] init];
        _personalLibL.font = [UIFont systemFontOfSize:13];
        _personalLibL.backgroundColor = [UIColor whiteColor];
        _personalLibL.textColor = [UIColor lightGrayColor];
        
    }
    return _personalLibL;
}
- (UILabel *)timeL {
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:13];
        _timeL.backgroundColor = [UIColor whiteColor];
        _timeL.textColor = [UIColor lightGrayColor];
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.adjustsFontSizeToFitWidth = YES;
    }
    return _timeL;
}
- (UILabel *)textContentL {
    if (!_textContentL) {
        _textContentL = [[UILabel alloc] init];
        _textContentL.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightLight)];
        _textContentL.backgroundColor = [UIColor whiteColor];
        _textContentL.numberOfLines = 0;
    }
    return _textContentL;
}
- (YjxToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[YjxToolBarView alloc] init];
        _toolbar.backgroundColor = [UIColor whiteColor];
        _toolbar.btnDelegate = self;
    }
    return _toolbar;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _line;
}
//头像点击
- (void)headerTapClick {
    NSString *idStr = _model.idStr;
    NSLog(@"-------%@",idStr);
}
//底部按钮点击代理
- (void)BtnLeftClicked {
    NSLog(@"点到我了---%@",_model.idStr);
}

- (void)BtnRightClicked {
    NSLog(@"又点到我了---%@",_model.idStr);

}
@end
