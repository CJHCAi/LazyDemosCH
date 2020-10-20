//
//  MMSideslipDrawer.m
//  MMSideslipDrawer
//
//  Created by LEA on 2017/2/17.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMSideslipDrawer.h"

@interface MMSideslipDrawer ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *rankBtn;

@end

@implementation MMSideslipDrawer

- (instancetype)initWithDelegate:(id<MMSideslipDrawerDelegate>)delegate slipItem:(MMSideslipItem *)item;
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
        
        _item = item;
        _delegate = delegate;
        [self addSubview:self.menuView];
        // 更新UI
        self.nameLab.text = item.userName;
        if (item.thumbnailPath) {
            self.portraitImageView.image = [UIImage imageWithContentsOfFile:item.thumbnailPath];
        }
        if (item.levelImageName) {
            [self.rankBtn setImage:[UIImage imageNamed:item.levelImageName] forState:UIControlStateNormal];
        }
        if (item.userLevel) {
            [self.rankBtn setTitle:item.userLevel forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        // 拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
        [pan setDelegate:self];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - setter
- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.nameLab.text = userName;
}

- (void)setUserLevel:(NSString *)userLevel
{
    _userLevel = userLevel;
    [self.rankBtn setTitle:userLevel forState:UIControlStateNormal];
}

- (void)setLevelImageName:(NSString *)levelImageName
{
    [self.rankBtn setImage:[UIImage imageNamed:levelImageName] forState:UIControlStateNormal];
}

#pragma mark - 显示|隐藏
- (void)colseLeftDrawerSide
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
        weakSelf.menuView.left =  -weakSelf.menuView.width;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)openLeftDrawerSide
{
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf];
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        weakSelf.menuView.left = 0;
    }];
}

#pragma mark - 点击隐藏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    if (CGRectContainsPoint(self.menuView.frame, currentPoint) == NO) {
        [self colseLeftDrawerSide];
    }
}

#pragma mark - 手势处理
- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [panGesture setEnabled:YES];
            self.userInteractionEnabled = YES;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            self.userInteractionEnabled = NO;
            CGPoint point = [panGesture translationInView:self];
            CGFloat left = self.menuView.left;
            left+= point.x;
            if (left > 0) {
                left = 0;
            }
            if (left < -kMMSideslipWidth) {
                left = -kMMSideslipWidth;
            }
            self.menuView.left = left;
            [panGesture setTranslation:CGPointZero inView:self.menuView];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.userInteractionEnabled = YES;
            //偏左向左滑，偏右向右滑
            __weak typeof(self) weakSelf = self;
            if (self.menuView.left > -kMMSideslipWidth/4)  {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.menuView.left = 0;
                }];
            } else  {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.menuView.left = -kMMSideslipWidth;
                    weakSelf.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
                } completion:^(BOOL finished) {
                    [weakSelf removeFromSuperview];
                }];
            }
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureCallback:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(didViewUserInformation:)]) {
        [self.delegate didViewUserInformation:self];
    }
}

- (void)btClickedCallBack
{
    if ([self.delegate respondsToSelector:@selector(didViewUserLevelInformation:)]) {
        [self.delegate didViewUserLevelInformation:self];
    }
}

#pragma mark - 视图
- (UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(-kMMSideslipWidth, 0, kMMSideslipWidth, kHeight)];
        _menuView.backgroundColor = [UIColor whiteColor];
        [_menuView addSubview:self.headView];
        [_menuView addSubview:self.tableView];
    }
    return _menuView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.height, kMMSideslipWidth, kHeight-self.headView.height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMMSideslipWidth, kMMSideslipTopHeight)];
        _headView.backgroundColor = [UIColor clearColor];
        [_headView addSubview:self.portraitImageView];
        [_headView addSubview:self.nameLab];
        [_headView addSubview:self.rankBtn];
    }
    return _headView;
}
/**头像*/
- (UIImageView *)portraitImageView
{
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_headView.width-60)/2, (_headView.height-60-50)/2+10, 60, 60)];
        _portraitImageView.layer.cornerRadius = _portraitImageView.height/2;
        _portraitImageView.layer.masksToBounds = YES;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor grayColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback:)];
        [_portraitImageView addGestureRecognizer:tap];
    }
    return _portraitImageView;
}
/**昵称*/
- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.portraitImageView.bottom+5, kMMSideslipWidth, 30)];
        _nameLab.textColor = kMMSideslipMainColor;
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:18.0];
    }
    return _nameLab;
}
/**头衔*/
- (UIButton *)rankBtn
{
    if (!_rankBtn) {
        _rankBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.portraitImageView.left-20, self.nameLab.bottom, self.portraitImageView.width+40, 20)];
        _rankBtn.backgroundColor = [UIColor clearColor];
        _rankBtn.adjustsImageWhenHighlighted = NO;
        _rankBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [_rankBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rankBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [_rankBtn addTarget:self action:@selector(btClickedCallBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rankBtn;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item.textArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    MMSideslipDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMSideslipDrawerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = kMMSideslipMainColor;
    cell.textLabel.text = [self.item.textArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.item.imageNameArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(slipDrawer:didSelectAtIndex:)]) {
        [self.delegate slipDrawer:self didSelectAtIndex:indexPath.row];
    }
}

@end

#pragma mark - MMSideslipItem
@implementation MMSideslipItem

@end


#pragma mark - MMSideslipDrawerCell
@implementation MMSideslipDrawerCell

- (void)layoutSubviews
{
    UIImage *image = self.imageView.image;
    CGFloat h = image.size.height;
    self.imageView.frame = CGRectMake(kMMSideslipWidth/8+15, (kMMSideslipCellHeight-h)/2, h, h);
    self.textLabel.frame = CGRectMake(self.imageView.right+15, 0, kMMSideslipWidth-(self.imageView.right+30), kMMSideslipCellHeight);
}

@end
