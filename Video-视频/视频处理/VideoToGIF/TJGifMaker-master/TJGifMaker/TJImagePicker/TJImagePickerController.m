//
//  TJImagePickerController.m
//  TJGifMaker
//
//  Created by TanJian on 17/6/16.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJImagePickerController.h"
#import "UIView+Extension.h"
#import "TJPhotoCollectionCell.h"
#import "TJPhotoManager.h"

static CGFloat KMargin = 3;
static CGFloat KCountPerLine = 4;
static CGFloat KCountLabelH = 35;

@interface TJImagePickerController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *pickPhotoArr;

@property (nonatomic, strong) UILabel *countLabel;


@end

@implementation TJImagePickerController

-(UILabel *)countLabel{
    
    if (!_countLabel) {
        
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.height-KCountLabelH, self.view.width, KCountLabelH)];
        _countLabel.backgroundColor = [UIColor lightGrayColor];
        _countLabel.textColor = [UIColor blueColor];
        _countLabel.text = @"已选择0张";
        
    }
    
    return _countLabel;
    
}

-(NSMutableArray *)pickPhotoArr{
    if (!_pickPhotoArr) {
        _pickPhotoArr = [NSMutableArray arrayWithCapacity:2];
    }
    return _pickPhotoArr;
}

-(UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = KMargin;
        layout.minimumInteritemSpacing = KMargin;
        layout.sectionInset = UIEdgeInsetsMake(KMargin, KMargin, KMargin, KMargin);
        CGFloat itemW = (self.view.width - KMargin*(KCountPerLine + 1))/KCountPerLine;
        layout.itemSize = CGSizeMake(itemW, itemW);
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height-KCountLabelH) collectionViewLayout:layout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        [_photoCollectionView registerClass:[TJPhotoCollectionCell class] forCellWithReuseIdentifier:@"TJPhotoCollectionCell"];
        
    }
    
    return _photoCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}


-(void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configerNavibar];
    [self.view addSubview:self.photoCollectionView];
    [self.view addSubview:self.countLabel];
    
    [self configerPhotos];
}

-(void)configerNavibar{
    
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(canclePick)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickDone)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.title = @"照片选择";

}

-(void)configerPhotos{
    
    PHFetchResult *result = [TJPhotoManager getFetchResultWithMediaType:PHAssetMediaTypeImage ascend:NO];
    
    _dataSource = [TJPhotoManager getPhotosWithPHFetchResult:result original:NO];
    
    [self.photoCollectionView reloadData];
}

-(void)canclePick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)pickDone{
    
    NSMutableArray *pickDoneArr = [NSMutableArray arrayWithCapacity:2];
    
    for (NSNumber *photoIndex in self.pickPhotoArr) {
        
        NSInteger index = photoIndex.integerValue;
        UIImage *image = self.dataSource[index];
        [pickDoneArr addObject:image];
        
    }
    
    if (self.photoPickDoneBlock) {
        self.photoPickDoneBlock(pickDoneArr);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


#pragma collection代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    return 10;
    return self.dataSource.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TJPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TJPhotoCollectionCell" forIndexPath:indexPath];
    
    UIImage *image = self.dataSource[indexPath.item];
    cell.image = image;
    
    __weak typeof(self) weakself = self;
    cell.selectedBlock = ^(NSInteger index){
        
        [weakself.pickPhotoArr addObject:@(index)];
        NSLog(@"添加了第%ld个",(long)index);
    };
    
    cell.unSelectedBlock = ^(NSInteger index){
        
        [weakself.pickPhotoArr removeObject:@(index)];
        NSLog(@"删除了第%ld个",(long)index);
    };
    cell.index = indexPath.item;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选择了cell");
    
}



@end
