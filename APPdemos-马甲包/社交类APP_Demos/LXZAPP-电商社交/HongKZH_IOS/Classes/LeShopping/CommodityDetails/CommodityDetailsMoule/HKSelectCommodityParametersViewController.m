//
//  HKSelectCommodityParametersViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelectCommodityParametersViewController.h"
#import "HKPurchaseToolView.h"
#import "CommodityDetailsRespone.h"
#import "HKDetailInfoCollectionViewCell.h"
#import "HKColorHeadCollectionViewCell.h"
#import "HKSpecificationsCollectionViewCell.h"
#import "HKPurchaseQuantityCollectionViewCell.h"
#import "CommodityDetailsViewModel.h"
#import "HKUpdataFromDataModel.h"
@interface HKSelectCommodityParametersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HKPurchaseToolViewDelegate,HKPurchaseQuantityCollectionViewCellDelegate,HKDetailInfoCollectionViewCellDelagete>
@property (nonatomic, strong)HKPurchaseToolView *toolView;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger colorItem;
@property (nonatomic,assign) NSInteger sepecItem;

@property (nonatomic,weak) HKDetailInfoCollectionViewCell *infoCell;

@property (nonatomic,assign) int num;
@end

@implementation HKSelectCommodityParametersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.colorItem = -1;
    self.sepecItem = -1;
    self.num = 1;
}
-(void)setUI{
    [self.view addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.toolView.mas_top);
    }];
}
-(void)updataNum:(int)num{
    self.num = num;
}

-(void)gotoToolClick:(NSInteger)tag{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(gotoToolClick:)]) {
            [self.delegate gotoToolClick:tag];
        }
    }];

}
-(void)gotoSelectParameWithTag:(NSInteger)tag{
    if (tag == 4||tag == 3) {
        if (self.colorItem<0) {
            [SVProgressHUD showErrorWithStatus:@"请选择颜色"];
            return;
        }
        if (self.sepecItem<0) {
            [SVProgressHUD showErrorWithStatus:@"请选择尺寸"];
            return;
        }
        if (self.num<1) {
            [SVProgressHUD showErrorWithStatus:@"请选择数量"];
            return;
        }
        [CommodityDetailsViewModel getAddCart:@{@"loginUid":HKUSERLOGINID,@"shopId":self.respone.data.shopId.length>0?self.respone.data.shopId:@"",@"productId":self.respone.data.productId,@"skuId":self.respone.data.skuId,@"number":@(self.num),@"mediaUserId":self.respone.data.mediaUserId.length>0?self.respone.data.mediaUserId:@""} success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                
                [self clickClose];
                NSDictionary*dict = (NSDictionary*)responde.data;
                if (tag == 3&&[self.delegate respondsToSelector:@selector(gotoCat:)]) {
                    HKUpdataFromDataModel*formData = [[HKUpdataFromDataModel alloc]init];
                    formData.name = @"cartId";
                    formData.vaule = dict[@"cartId"];
                    [self.delegate gotoCat:@[formData]];
                }else{
                    [EasyShowTextView showSuccessText:@"加入购物车成功"];
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:responde.msg];
            }
        }];
    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKDetailInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKDetailInfoCollectionViewCell"];
         [_collectionView registerNib:[UINib nibWithNibName:@"HKColorHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKColorHeadCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSpecificationsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HKSpecificationsCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKPurchaseQuantityCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HKPurchaseQuantityCollectionViewCell"];
       
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self clickClose];
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0||section == 1||section == 3||section == 5) {
        return 1;
    }else if (section == 2){
         return self.respone.data.colors.count;
    }else if (section == 4){
         return self.respone.data.specs.count;
    }

    return 1;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKDetailInfoCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKDetailInfoCollectionViewCell" forIndexPath:indexPath];
        cell.respone = self.respone;
        self.infoCell = cell;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1||indexPath.section == 3){
        HKColorHeadCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKColorHeadCollectionViewCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        return cell;
    }else if (indexPath.section == 2){
        HKSpecificationsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSpecificationsCollectionViewCell" forIndexPath:indexPath];
        if (self.colorItem == indexPath.item) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
        cell.colorsM = self.respone.data.colors[indexPath.item];
      
        return cell;
    }else if (indexPath.section == 4){
        HKSpecificationsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSpecificationsCollectionViewCell" forIndexPath:indexPath];
        if (self.sepecItem == indexPath.item) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
        cell.specs = self.respone.data.specs[indexPath.item];
       
        return cell;
    }else{
        HKPurchaseQuantityCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKPurchaseQuantityCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 115);
    }else if (indexPath.section == 1){
       return CGSizeMake(kScreenWidth, 35);
    }else if (indexPath.section == 2){
        CommodityDetailsesColors*coloM = self.respone.data.colors[indexPath.item];
        
        return CGSizeMake(coloM.w+15, 45);
    }else if (indexPath.section == 3){
        return CGSizeMake(kScreenWidth, 45);
    }else if (indexPath.section == 4){
        CommodityDetailsesSpecs*coloM = self.respone.data.specs[indexPath.item];
        
        return CGSizeMake(coloM.w+15, 45);
    }

    return CGSizeMake(kScreenWidth, 92);
}



// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return -10;
}



// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        self.colorItem = indexPath.item;
       
    }else if (indexPath.section == 4){
        self.sepecItem = indexPath.item;
      
    }
    if (indexPath.section == 2||indexPath.section == 4) {
        NSArray* array = [collectionView visibleCells];
        for (UICollectionViewCell*cell in array) {
            if ([[collectionView indexPathForCell:cell] section]==indexPath.section) {
                if ([[collectionView indexPathForCell:cell] item]==indexPath.item) {
                    HKSpecificationsCollectionViewCell*selectCell = (HKSpecificationsCollectionViewCell*)cell;
                    selectCell.isSelect = YES;
                }else{
                    HKSpecificationsCollectionViewCell*selectCell = (HKSpecificationsCollectionViewCell*)cell;
                    selectCell.isSelect = NO;
                }
            }
        }
    }
    
    if (self.colorItem>=0||self.sepecItem>=0) {
        [self getSepecData];
    }
    
}
-(void)clickClose{
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getSepecData{
        NSString*skuId=@"";
    CommodityDetailsesColors* model;
    if (self.colorItem<0) {
        model = self.respone.data.colors.firstObject;
    }else{
        model =  self.respone.data.colors[self.colorItem];
    }
    CommodityDetailsesSpecs*spec;
    if (self.sepecItem < 0) {
        spec = self.respone.data.specs.firstObject;
    }else{
   spec = self.respone.data.specs[self.sepecItem];
    }
        for (CommodityDetailsesSkus*skus in self.respone.data.skus) {
              if ([model.productColorId isEqualToString:skus.productColorId]&&[spec.productSpecId isEqualToString:skus.productSpecId]) {
                  skuId = skus.skuId;
                  break;
        }
    }
   
          self.respone.data.skuId = skuId;
            [CommodityDetailsViewModel getProductSkuBySku:@{@"loginUid":HKUSERLOGINID,@"skuId":skuId} success:^(CommodityDetailsRespone *responde) {
//              HKDetailInfoCollectionViewCell*cell =  (HKDetailInfoCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                self.respone.data.images = responde.data.images;
                self.respone.data.integral = responde.data.integral;
                self.respone.data.stocks = responde.data.stocks;
                self.infoCell.respone = self.respone;
            }];
    
}
-(HKPurchaseToolView *)toolView{
    if (!_toolView) {
        _toolView = [[HKPurchaseToolView alloc]init];
        _toolView.delegate = self;
    }
    return _toolView;
}
-(void)setRespone:(CommodityDetailsRespone *)respone{
    _respone = respone;
    [self.collectionView reloadData];
}
+(void)showVc:(UIViewController*)subvc respone:(CommodityDetailsRespone *)respone{
    HKSelectCommodityParametersViewController*vc = [[HKSelectCommodityParametersViewController alloc]init];
    vc.respone = respone;
     subvc.navigationController.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    vc.delegate = subvc;
    [subvc.navigationController presentViewController:vc animated:YES completion:nil];
}

@end
