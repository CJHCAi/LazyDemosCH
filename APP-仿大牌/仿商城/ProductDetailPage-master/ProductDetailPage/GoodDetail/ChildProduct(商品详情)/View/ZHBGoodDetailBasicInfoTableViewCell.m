//
//  ZHBGoodDetailBasicInfoTableViewCell.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/15.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBGoodDetailBasicInfoTableViewCell.h"
#import "ZHBGoodDetailViewModel.h"
#import "ZHBProdictDetailInfoModel.h"
//#import "UIButton+ImageTitleAlignment.h"


static NSString *const kAPXServiceDescriptionCollectionCell = @"APXServiceDescriptionCollectionCell";

@interface ZHBGoodDetailBasicInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name; // 名称
@property (weak, nonatomic) IBOutlet UILabel *price; // 价格
@property (weak, nonatomic) IBOutlet UILabel *disCountPriceLabel; // 折扣价,划线

@property (weak, nonatomic) IBOutlet UILabel *stockLabel;

@property (weak, nonatomic) IBOutlet UILabel *isChooseLabel; // 已选
@property (weak, nonatomic) IBOutlet UILabel *chooseStandardLabel; // 已选属性
@property (weak, nonatomic) IBOutlet UIImageView *isChooseArrowView;

@property (weak, nonatomic) IBOutlet UIButton *reduceButton; // 降价按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reduceBtnCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reduceBtnRightCons;

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
// 在没有activityLabel活动链接时, 高度调整
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityLabelHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityLabelTopCons;

@end

@implementation ZHBGoodDetailBasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization
    
    self.reduceButton.layer.borderWidth = 1;
    self.reduceButton.layer.borderColor = ColorWithHex(0xe2e1e1).CGColor;
    self.reduceButton.layer.cornerRadius = 2;
    self.reduceButton.layer.masksToBounds = YES;
    
//    self.activityLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActivityLabel)];
//    [self.activityLabel addGestureRecognizer:tap];
}

- (void)setDetailViewModel:(ZHBGoodDetailViewModel *)detailViewModel
{
    
    _detailViewModel = detailViewModel;
    

    
    

    
    NSString *title = [NSString stringWithFormat:@"%@   %@",detailViewModel.subName,detailViewModel.name];

    
    self.name.text = title;


//    if (!IsArrEmpty(detailViewModel.tags)) {
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.name.attributedText];
////        [self appendMark:detailViewModel.tags withAttrStr:attr];
////        self.name.attributedText = attr;
//    }


    self.price.text = [NSString stringWithFormat:@"¥%@",detailViewModel.productInfo.price];
    
    if (!IsStrEmpty(detailViewModel.productInfo.oldPrice)){
        NSString *discountStr = [NSString stringWithFormat:@"¥%@",detailViewModel.productInfo.oldPrice];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:discountStr attributes:attribtDic];
        // 赋值
        self.disCountPriceLabel.attributedText = attribtStr;

        self.disCountPriceLabel.hidden = NO;
    }else{
        self.disCountPriceLabel.hidden = YES;
    }
    
//    // 抢购中和即将开抢不显示价格
//    if ([detailViewModel.productInfo.timeLimit.activityStatus isEqualToString:@"1"] || [detailViewModel.productInfo.timeLimit.activityStatus isEqualToString:@"2"] || ([detailViewModel.productInfo.stockNumber isEqualToString:@"0"] && [detailViewModel.productInfo.timeLimit.activityStatus isEqualToString:@"3"])) {
//
//        self.disCountPriceLabel.hidden = YES;
//    }
    
    
//    // 已选提示语,eg.银色,iPhone7
    self.chooseStandardLabel.text = [detailViewModel.selectedStandardLabelArray componentsJoinedByString:@"，"];
    
//
//    // 只要不等于0 就是别的状态
//    if (![detailViewModel.productInfo.timeLimit.activityStatus isEqualToString:@"0"]) {
//
//        self.price.text = detailViewModel.productInfo.timeLimit.countDesc;
//        self.price.font = [UIFont systemFontOfSize:14];
//    }
    
    /********** 领券优惠券 **********/
    if (detailViewModel.productInfo.coupon) {

        self.getCouponTitle.text = detailViewModel.productInfo.coupon.title;
        self.getCouponLabel.text = detailViewModel.productInfo.coupon.detail;
        [self showViewWithType:BasicInfoTableViewCellClickTypeGetCoupon];
        
    }else{
        
        [self hiddenViewWithType:BasicInfoTableViewCellClickTypeGetCoupon];
    }
    
    /********** 优惠活动 **********/
    
    if (detailViewModel.productInfo.sale) {

        self.discountTitle.text = detailViewModel.productInfo.sale.title;
        self.discountLabel.text = detailViewModel.productInfo.sale.detail;
//        // 有标签字段,打上标签
        if (IsArrEmpty(detailViewModel.productInfo.sale.markList)) {

            self.discountLabel.text = detailViewModel.productInfo.sale.detail;
        }else{

//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.discountLabel.attributedText];
//            self.discountLabel.attributedText = [self appendMark:detailViewModel.productInfo.sale.markList withAttrStr:attr];
        }
        
        [self showViewWithType:BasicInfoTableViewCellClickTypeDiscount];
    }else{
        
        [self hiddenViewWithType:BasicInfoTableViewCellClickTypeDiscount];
    }
    
    /********** 服务说明 **********/
    if (IsArrEmpty(detailViewModel.productInfo.serviceList)) {
        
        [self hiddenViewWithType:BasicInfoTableViewCellClickTypeServiceDescription];
    }else{
        
        self.serviceDataSource = detailViewModel.productInfo.serviceList;
        [self showViewWithType:BasicInfoTableViewCellClickTypeServiceDescription];
        [self addServiceDescriptionView];
    }
    
    /********** 配置 ************/
    if (!detailViewModel.productInfo.config) {
        
        [self hiddenViewWithType:BasicInfoTableViewCellClickTypeConfig];
    }else{
        
        [self showViewWithType:BasicInfoTableViewCellClickTypeConfig];
        self.configTitle.text = detailViewModel.productInfo.config.title;
        self.configLabel.text = detailViewModel.productInfo.config.detail;
    }
    
    /********* 购买须知 ************/
    if (!detailViewModel.productInfo.purchaseNotes) {
        
        [self hiddenViewWithType:BasicInfoTableViewCellClickTypeBuyTip];
    }else{
        
        self.buyTipTitle.text = detailViewModel.productInfo.purchaseNotes.title;
        self.tipLabel.text = detailViewModel.productInfo.purchaseNotes.detail;
        [self showViewWithType:BasicInfoTableViewCellClickTypeBuyTip];
    }
    
    
    if ([detailViewModel.productInfo.stockNumber integerValue] > 0) {
        self.stockLabel.text = @"有货";
    }else{
        self.stockLabel.text = @"无货";
    }
    
    if (!detailViewModel.isExistCanSale) {

        self.isChooseLabel.text = @"此商品暂无货";
        [self hiddenWhenOutSale];
    }
    
    // 下架
    if ([detailViewModel.status isEqualToString:@"6"]) {
        
        
        self.price.text = @"暂无报价";
        self.isChooseLabel.text = @"此商品已下架";
        self.discountLabel.hidden = YES;
        self.stockLabel.hidden = YES;
        [self hiddenWhenOutSale];
    }
}

// 下架,无货隐藏
- (void)hiddenWhenOutSale
{
    self.isChooseArrowView.hidden = YES;
    self.stockLabel.textColor = ColorWithHex(0x353535);
    self.isChooseLabel.textColor = ColorWithHex(0xA3A3A3);
    self.chooseStandardLabel.text = @"";
    self.reduceButton.hidden = YES;
    self.reduceBtnCons.constant = 0;
    self.reduceBtnRightCons.constant = 0;
    [self hiddenViewWithType:BasicInfoTableViewCellClickTypeDiscount];
    [self hiddenViewWithType:BasicInfoTableViewCellClickTypeGetCoupon];
    [self hiddenViewWithType:BasicInfoTableViewCellClickTypeConfig];
    [self hiddenViewWithType:BasicInfoTableViewCellClickTypeBuyTip];
}



#pragma mark - 各个点击回调

// 获取优惠券
- (IBAction)getCouponButtonClick:(id)sender {
    
    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeGetCoupon];
}
// 折扣优惠
- (IBAction)discountButtonClick:(id)sender {
    
    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeDiscount];
}
// 已选
- (IBAction)selectedButtonClick:(id)sender {
    
    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeSelected];
}
// 服务说明
- (IBAction)serviceDescriptionButtonClick:(id)sender {

    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeServiceDescription];
}
// 配置
- (IBAction)configButtonClick:(id)sender {
    
    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeConfig];
}
// 降价通知
- (IBAction)reductionNoticeButtonClick:(id)sender {
    
    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeReduction];
}

- (IBAction)buyTipButtonClick:(id)sender {
    
    [self callDelegateWithBasicInfoTableViewCellClickType:BasicInfoTableViewCellClickTypeBuyTip];
}


- (void)callDelegateWithBasicInfoTableViewCellClickType:(BasicInfoTableViewCellClickType)type
{
    if ([self.delegate respondsToSelector:@selector(goodDetailBasicInfoTableViewCell:
                                                    didClickWithBasicInfoTableViewCellClickType:)]) {
        
        [self.delegate goodDetailBasicInfoTableViewCell:self
            didClickWithBasicInfoTableViewCellClickType:type];
    }
}

- (void)hiddenViewWithType:(BasicInfoTableViewCellClickType)basicInfoType{
    
    switch (basicInfoType) {
            
            // 领取优惠券
        case BasicInfoTableViewCellClickTypeGetCoupon:
            self.getCouponView.hidden = YES;
            self.getCouponViewHeightCons.constant = 1;
            break;
            // 优惠
        case BasicInfoTableViewCellClickTypeDiscount:
            self.disCountView.hidden = YES;
            self.disCountViewHeightCons.constant = 1;
            break;

            // 没有已选 已选不会为空
        case BasicInfoTableViewCellClickTypeServiceDescription:
            self.serviceDescriptionView.hidden = YES;
            self.serviceDescriptionViewHeightCons.constant = 1;
            break;
            
            // 配置
        case BasicInfoTableViewCellClickTypeConfig:
            self.configView.hidden = YES;
            self.configViewHeightCons.constant = 1;
            break;
            
            // 购买须知
        case BasicInfoTableViewCellClickTypeBuyTip:
            self.buyTipView.hidden = YES;
            self.buyTipViewHeightCons.constant = 0;
            self.buyTipLIneViewHeightCons.constant = 0;
            break;
            
        default:
            break;
    }
}

- (void)showViewWithType:(BasicInfoTableViewCellClickType)basicInfoType{
    
    switch (basicInfoType) {
            // 优惠券
        case BasicInfoTableViewCellClickTypeGetCoupon:
            self.getCouponView.hidden = NO;
            self.getCouponViewHeightCons.constant = 50;
            break;
            
            // 优惠
        case BasicInfoTableViewCellClickTypeDiscount:
            self.disCountView.hidden = NO;
            self.disCountViewHeightCons.constant = 50;
            break;
            
            // 服务说明
        case BasicInfoTableViewCellClickTypeServiceDescription:
            self.serviceDescriptionView.hidden = NO;
            break;
            
            // 配置
        case BasicInfoTableViewCellClickTypeConfig:
            self.configView.hidden = NO;
            self.configViewHeightCons.constant = 50;
            break;
            
            // 购买须知
        case BasicInfoTableViewCellClickTypeBuyTip:
            self.buyTipView.hidden = NO;
            self.buyTipViewHeightCons.constant = 50;
            self.buyTipLIneViewHeightCons.constant = 10;
            break;
            
        default:
            break;
    }
}

#pragma mark - event
- (void)tapActivityLabel
{
//    [[APXRouteManager sharedInstance] openNative:self.detailViewModel.activityLink.activityUrl];
//    NSLog(@"tapActivityLabel %@",self.detailViewModel.activityLink.activityUrl);
}

#pragma mark - private
//服务说明
- (void)addServiceDescriptionView
{
//    CGFloat oneLineBtnWidtnLimit = (335);//每行btn占的最长长度，超出则换行
//    CGFloat btnGap = 10;//btn的x间距
//    CGFloat btnGapY = 10;
//    NSInteger BtnlineNum = 0; // 几行
//    CGFloat BtnHeight = 20;
//    CGFloat minBtnLength = 50;//每个btn的最小长度
//    CGFloat maxBtnLength = oneLineBtnWidtnLimit - btnGap*2;//每个btn的最大长度
//    CGFloat Btnx = 0;
//
//    CGFloat BtnDefaultX = 15;//每个btn的起始位置
//    Btnx = BtnDefaultX;
//    CGFloat height = 0;
//
//    for (int i = 0; i < self.serviceDataSource.count; i++) {
//
//        NSString *str;
//        id dict = [self.serviceDataSource objectAtIndex:i];
//        if ([dict isKindOfClass:[NSDictionary class]]) {
//            str = [dict objectForKey:@"title"];
//        }else{
//            str = dict;
//        }
//
//        CGFloat btnWidth = [ZHBBaseMethod WidthWithString:str fontSize:12 height:BtnHeight];
//        btnWidth += 18; // 图片(13) + 间距(5)
//
//        if(btnWidth < minBtnLength)
//            btnWidth = minBtnLength;
//        if(btnWidth > maxBtnLength)
//            btnWidth = maxBtnLength;
//
//        if(Btnx + btnWidth > oneLineBtnWidtnLimit)
//        {
//            BtnlineNum ++;//长度超出换到下一行
//            Btnx = BtnDefaultX;
//        }
//
//        UIButton *btn = [[UIButton alloc] init];
//        btn.userInteractionEnabled = NO;
//
//        height = BtnlineNum * BtnHeight + btnGapY * (BtnlineNum + 1);
//
//        btn.frame = CGRectMake(Btnx, height,btnWidth,BtnHeight );
//        [btn setTitle:str forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor whiteColor];
//        [btn setTitleColor:ColorWithHex(0x717171) forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:12];
//
//        [btn setImage:[UIImage imageNamed:@"productServiceDescriptionIcon"] forState:UIControlStateNormal];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
//
//        Btnx = btn.frame.origin.x + btn.frame.size.width + btnGap;
//        [self.serviceDescriptionView addSubview:btn];
//    }
//
//    self.serviceDescriptionViewHeightCons.constant = height + BtnHeight + btnGapY;
}




// tool 将文字转为富文本,增加标签文字
//- (NSMutableAttributedString *)appendMark:(NSArray *)mark withAttrStr:(NSMutableAttributedString *)AttrStr
//{
//    NSMutableAttributedString *attrMuStr = AttrStr;
//
//    for (int i = 0; i < mark.count; i++) {
//
//        NSString *str = [mark getItemContentAtIndex:i];
//        UILabel *hitLable = [[UILabel alloc]init];
//        hitLable.font = [UIFont systemFontOfSize:11.f];
//        hitLable.layer.borderWidth = 1.f;
//        hitLable.layer.cornerRadius = 1.f;
//        hitLable.layer.borderColor = ColorWithHex(0XD1A783).CGColor;
//        hitLable.clipsToBounds = YES;
//        hitLable.textColor = ColorWithHex(0XFFFFFF);
//        hitLable.backgroundColor = ColorWithHex(0XD1A783);
//        hitLable.text = str;
//        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName : hitLable.font}];
//        hitLable.frame = CGRectMake(0, 0, size.width + 14, size.height+6);
//        hitLable.textAlignment = NSTextAlignmentCenter;
//
//        UIImage *titleImage = [hitLable convertViewToImage];
//
//
//        NSTextAttachment *imgAttachment = [[NSTextAttachment alloc]init];
//        imgAttachment.image = titleImage;
//
//        imgAttachment.bounds = CGRectMake(3, -4, titleImage.size.width, titleImage.size.height);
//
//        NSLog(@"----------------------%@",NSStringFromCGRect(imgAttachment.bounds));
//
//        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:imgAttachment];
//        [attrMuStr insertAttributedString:attrStr atIndex:i * 2];
//        // 间隙
//        [attrMuStr insertAttributedString:[NSAttributedString attributedStringWithString:@"  " font:[UIFont systemFontOfSize:11.f] color:[UIColor clearColor]] atIndex:2*i + 1];
//    }
//
//
//    return attrMuStr;
//}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
