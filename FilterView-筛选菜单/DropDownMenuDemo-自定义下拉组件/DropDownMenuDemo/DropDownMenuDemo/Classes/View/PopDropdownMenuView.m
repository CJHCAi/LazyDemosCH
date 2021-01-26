//
//  PopDropdownMenuView.m
//  TextColorRamp
//
//  Created by admin on 2017/6/22.
//  Copyright © 2017年 王晓丹. All rights reserved.
//

#import "PopDropdownMenuView.h"
#define TableViewTag  200
#define imageMargin   15  //有图标时，图标左右间距
#define imageWH       25  //图标宽高
#define heightForRow  45  //cell 高度
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define YB_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

@interface PopDropdownMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView_1;
@property (nonatomic, strong) UITableView *tableView_2;
@property (nonatomic, strong) NSMutableArray *imageArray;  //左侧图片数组，没有可以忽略

@end

@implementation PopDropdownMenuView{
    
    int  _currentSelectedIndex;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self customAccessors];
    }
    return self;
}
#pragma mark - Custom Accessors
- (void)customAccessors {
   
    _imageArray = [[NSMutableArray alloc]init];
    
    [self customContentView];
    [self tapConfiger];
    
}
- (void)customContentView {
    _contentView = [[UIView alloc]initWithFrame:self.frame];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
}

- (void)customTableViews:(NSInteger)isTwoTableView tableOneWith:(CGFloat)tableOneWith {
    self.tableView_1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tableOneWith, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView_1.backgroundColor = [UIColor whiteColor];
    self.tableView_1.delegate = self;
    self.tableView_1.dataSource = self;
    self.tableView_1.tag = TableViewTag;
    self.tableView_1.bounces = NO;
    self.tableView_1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_1.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView_1];
    
    if(isTwoTableView == 1) {
        self.tableView_2 = [[UITableView alloc]initWithFrame:CGRectMake(tableOneWith, 0, self.frame.size.width-tableOneWith, self.frame.size.height) style:UITableViewStylePlain];
        self.tableView_2.backgroundColor = [UIColor clearColor];
        self.tableView_2.delegate = self;
        self.tableView_2.dataSource = self;
        self.tableView_2.tag = TableViewTag + 1;
        self.tableView_2.bounces = NO;
        self.tableView_2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView_2.showsVerticalScrollIndicator = NO;
        [self addSubview:self.tableView_2];
    }

}
- (void)tapConfiger {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSelfView:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

#pragma mark - Click Actions
- (void)cancelSelfView:(UITapGestureRecognizer *)tap {
    CGPoint location = [tap locationInView:self];
    if(self.contentView.hidden != YES) {
        if (!CGRectContainsPoint(self.contentView.frame, location)) {
            [self dissmissChangeBtnSelect];
        }
    }else {
        [self dissmissChangeBtnSelect];
    }
}
#pragma mark - Public
+(instancetype)PopDropdownMenuViewWithFrame:(CGRect)frame  tableOneWith:(CGFloat)tableOneWith imageArray:(NSArray *)imageArray otherSetting:(void (^)(PopDropdownMenuView *popDropMenuView))otherSetting {
    PopDropdownMenuView *popDropView = [[PopDropdownMenuView alloc]initWithFrame:frame];
    
    popDropView.contentView.hidden = YES;
    
    [popDropView.imageArray addObjectsFromArray:imageArray];
    
    YB_SAFE_BLOCK(otherSetting , popDropView);
    
    [popDropView customTableViews:popDropView.isTowTable tableOneWith:tableOneWith];
    
    [popDropView layoutTableViewHeight];
    
    return popDropView;
}
+(instancetype)PopDropdownMenuViewWithFrame:(CGRect)frame contentView:(UIView *)contentMainView otherSetting:(void (^)(PopDropdownMenuView *popDropMenuView))otherSetting{
    PopDropdownMenuView *popDropView = [[PopDropdownMenuView alloc]initWithFrame:frame];
    
    popDropView.tableView_1.hidden = YES;
    popDropView.tableView_2.hidden = YES;
    
    popDropView.contentView.frame = contentMainView.frame;
    
    [popDropView.contentView addSubview:contentMainView];
    
    YB_SAFE_BLOCK(otherSetting,popDropView);
    
    return popDropView;
}

#pragma mark - Private
-(void)show:(BOOL)animated
{
    UIWindow *keyWindow=[UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.backgroundColor=self.backgroundColor=UIColorFromRGBWithAlpha(0x000000,0.35);
}
/* 
 * 仅移除当前页面，不修改当前选中title的状态
 */
-(void)dismiss:(BOOL)animated
{
    [self removeFromSuperview];
}
/* 
 * 点击空白处或者选中对象后自动关闭当前页面，且改变当前选中title的状态
 */
- (void)dissmissChangeBtnSelect{
    
    [self removeFromSuperview];
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissCurrentViewChangeSelectBtnStatues:)]) {
        [self.delegate dismissCurrentViewChangeSelectBtnStatues:nil];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == TableViewTag) {
        return self.firstArray.count;
    }else {
        return self.secondArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SquareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if(tableView.tag == TableViewTag){
            cell.backgroundColor = [self colorFromHexRGB:@"#F5F5F5"];
        }else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
        if (tableView.tag == TableViewTag)
        {
            
            UILabel *lbl = [[UILabel alloc] init];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.tag = 302;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = [self.firstArray objectAtIndex:indexPath.row];
            
            if(self.imageArray.count != 0) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageMargin, (45-imageWH)/2, imageWH, imageWH)];
                if(indexPath.row < self.imageArray.count){
                    imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
                }
                lbl.frame = CGRectMake(imageMargin*2 + imageWH, 20, tableView.frame.size.width, 14);
                
                [cell.contentView addSubview:imageView];
                [cell.contentView addSubview:lbl];
            }else {
                lbl.frame = CGRectMake(30, 20, tableView.frame.size.width, 14);
                [cell.contentView addSubview:lbl];
            }
            
            if (_currentSelectedIndex == indexPath.row)
            {
                lbl.textColor = [self colorFromHexRGB:@""];
                cell.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                [self colorFromHexRGB:@"9e9e9e"];
                cell.backgroundColor = [self colorFromHexRGB:@"#F5F5F5"];
            }
        }
        
        else if (tableView.tag == TableViewTag + 1)
        {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 150, 14)];
            lbl.font = [UIFont systemFontOfSize:13];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = [self.secondArray objectAtIndex:indexPath.row];
            lbl.textColor = [self colorFromHexRGB:@"9e9e9e"];
            [cell.contentView addSubview:lbl];
        }
    return cell;

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return heightForRow;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"kjjdjwijdo");
    _currentSelectedIndex = (int)indexPath.row;
    if(self.isTowTable == 1) {
        if (tableView.tag == TableViewTag) {
            
            [self.secondArray removeAllObjects];
            NSArray *array = self.tmpOuterArray[indexPath.row];
            [self.secondArray addObjectsFromArray:array];
            //刷新tableView高度
            [self layoutTableViewHeight];
            
            [self.tableView_1 reloadData];
            [self.tableView_2 reloadData];
            
        } else if (tableView.tag == TableViewTag + 1) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelect:obj:)]){
                [self.delegate tableViewDidSelect:indexPath.row obj:self.secondArray[indexPath.row]];
            }
            [self dissmissChangeBtnSelect];
        }
    }else {
        [self.tableView_1 reloadData];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelect:obj:)]){
            [self.delegate tableViewDidSelect:indexPath.row obj:self.firstArray[indexPath.row]];
        }
        [self dissmissChangeBtnSelect];
    }
}
#pragma mark - UIGestureRecognizerDelegate
//解决全局手势与tableView表的点击事件冲突。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;
    }
    return YES;
}
#pragma mark - NSObject
/* 刷新tableView高度
 */
- (void)layoutTableViewHeight {
    NSInteger table1Height = self.firstArray.count * heightForRow;
    NSInteger table2Height = self.secondArray.count * heightForRow;
    NSInteger totalHeight = table1Height > table2Height ? table1Height : table2Height;
    totalHeight = totalHeight < self.frame.size.height ? totalHeight : self.frame.size.height ;
    self.tableView_1.frame = CGRectMake(0, 0, self.tableView_1.frame.size.width, totalHeight);
    self.tableView_2.frame = CGRectMake(self.tableView_2.frame.origin.x, 0, self.tableView_2.frame.size.width, totalHeight);
}
/* 通过RGB色值设置颜色
 * inColorString         @“#9e9e9e”
 */
- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
