//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "YMTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"

#define kImageTag 9999


@implementation YMTableViewCell
{
    YMTextData *tempDate;
}

-(void)didHeadPicAndNamePress{
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"didPromulgatorNameOrHeadPicPressedForIndex:name:")]){
		[self.delegate didPromulgatorNameOrHeadPicPressedForIndex:self.stamp name:self.nameLbl.text];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _hideReply = NO;
        
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, TableHeader)];
        //设置头像为圆形
        _headerImage.layer.cornerRadius = _headerImage.frame.size.width / 2;
        _headerImage.clipsToBounds = YES;
        _headerImage.backgroundColor = [UIColor clearColor];
		_headerImage.userInteractionEnabled = YES;
		UIGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeadPicAndNamePress)];
		[_headerImage addGestureRecognizer:tap1];
        [self.contentView addSubview:_headerImage];
        
        //用户名
		_nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImage.frame) + 10, CGRectGetMidY(_headerImage.frame) - TableHeader/4, screenWidth - 120, TableHeader/2)];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font = [UIFont systemFontOfSize:15.0];
        _nameLbl.textColor = [UIColor blackColor];
		_nameLbl.userInteractionEnabled = YES;
		UIGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeadPicAndNamePress)];
		[_nameLbl addGestureRecognizer:tap2];
        [self.contentView addSubview:_nameLbl];
        
        
        
        //数据
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        
        
        //展开动态&收起动态按钮
        _foldBtn = [UIButton buttonWithType:0];
        [_foldBtn setTitle:@"展开动态" forState:0];
        _foldBtn.backgroundColor = [UIColor clearColor];
        _foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_foldBtn setTitleColor:[UIColor colorWithRed:48/255.0 green:126/255.0 blue:78/255.0 alpha:1] forState:0];
        [_foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_foldBtn];
        
        //评论背景初始化
        _replyImageView = [[UIImageView alloc] init];
        
        _replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        //现在把评论背景去掉了
        //[self.contentView addSubview:_replyImageView];
        
        //评论按钮
        _replyBtn = [YMButton buttonWithType:0];
        [_replyBtn setImage:[UIImage imageNamed:@"reply_button.png"] forState:0];
        [self.contentView addSubview:_replyBtn];
        
        //点赞按钮
        _likeBtn = [YMButton buttonWithType:0];
        [_likeBtn setImage:[UIImage imageNamed:@"reply_button.png"] forState:0];
        [self.contentView addSubview:_likeBtn];
        
        //时间戳
        _introLbl = [[UILabel alloc] init];
        _introLbl.numberOfLines = 1;
        _introLbl.font = [UIFont systemFontOfSize:14.0];
        _introLbl.textColor = [UIColor grayColor];
        [self.contentView addSubview:_introLbl];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)foldText{
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [_foldBtn setTitle:@"收起动态" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [_foldBtn setTitle:@"展开动态" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setYMViewWith:(YMTextData *)ymData{
    
    // NSLog(@"width = %f",screenWidth);
    
    tempDate = ymData;
    
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
	
	//说说部分
    [_ymShuoshuoArray removeAllObjects];
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X, 5 + TableHeader, screenWidth - offSet_X - 10, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataWF;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
	textView.type = TextTypeContent;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float shuoshuoHeight = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X, 5 + TableHeader, screenWidth - offSet_X - 10, shuoshuoHeight);
    
    [_ymShuoshuoArray addObject:textView];
    
    //设置折叠按钮位置
    _foldBtn.frame = CGRectMake(offSet_X - 10, 5 + TableHeader + shuoshuoHeight  , 50, 20 );
    
    if (ymData.islessLimit) {
        
        _foldBtn.hidden = YES;
    }else{
        _foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [_foldBtn setTitle:@"展开" forState:0];
    }else{
        
        [_foldBtn setTitle:@"收起" forState:0];
    }

    
    //图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
        
    }
    
    [_imageArray removeAllObjects];
    
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(((screenWidth - 240)/4)*(i%3 + 1) + 80*(i%3), TableHeader + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30), 80, ShowImage_H)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(offSet_X + ShowImage_W*(i%3), TableHeader + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30), ShowImage_W, ShowImage_H)];

        image.userInteractionEnabled = YES;
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        tap.appendArray = ymData.showImageArray;
        image.backgroundColor = [UIColor clearColor];
        image.tag = kImageTag + i;
//		这句话 让图片 支持网络异步加载图片
		[image sd_setImageWithURL:[NSURL URLWithString:[ymData.showImageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"nilPic.png"]];
//        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
        [self.contentView addSubview:image];
        [_imageArray addObject:image];
        
    }

    
   
    if (_hideReply) {
        [_replyBtn removeFromSuperview];
        
    }else{
        
        //最下方回复部分
        for (int i = 0; i < [_ymTextArray count]; i++) {
            
            WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
            if (ymTextView.superview) {
                [ymTextView removeFromSuperview];
                //  NSLog(@"here");
                
            }
            
        }
        
        [_ymTextArray removeAllObjects];
        float origin_Y = 10;
        NSUInteger scale_Y = ymData.showImageArray.count - 1;
        float balanceHeight = 0; //纯粹为了解决没图片高度的问题
        if (ymData.showImageArray.count == 0) {
            scale_Y = 0;
            balanceHeight = - ShowImage_H - kDistance ;
        }
        
        float backView_Y = 0;
        float backView_H = 0;
        
        for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
            
            WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X - replySet_X, 0)];
            
            if (i == 0) {
                backView_Y = TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30);
            }
            
            _ilcoreText.delegate = self;
			
			_ilcoreText.type = TextTypeReply;
			_ilcoreText.replyIndex = i;
            
            _ilcoreText.attributedData = [ymData.attributedData objectAtIndex:i];
            
            
            [_ilcoreText setOldString:[ymData.replyDataSource objectAtIndex:i] andNewString:[ymData.completionReplySource objectAtIndex:i]];
            
            _ilcoreText.frame = CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, screenWidth - offSet_X - replySet_X - 5, [_ilcoreText getTextHeight]);
            [self.contentView addSubview:_ilcoreText];
            origin_Y += [_ilcoreText getTextHeight] + 5 ;
            
            backView_H += _ilcoreText.frame.size.height;
            
            [_ymTextArray addObject:_ilcoreText];
        }
        
        backView_H += (ymData.replyDataSource.count - 1)*5;
        
        
        
        if (ymData.replyDataSource.count == 0) {//没回复的时候
            
            _replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance, 0, 0);
            _replyBtn.frame = CGRectMake(screenWidth - offSet_X - 40 + 6,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + shuoshuoHeight + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance - 24, 40, 18);
            _introLbl.frame = CGRectMake(offSet_X , CGRectGetMinY(_replyImageView.frame) - CGRectGetHeight(_introLbl.frame) - TableHeader/2, screenWidth - 120, TableHeader/2);
            
        }else{
            
            _replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance, screenWidth - replySet_X, backView_H + 20 - 12);//微调
            _introLbl.frame = CGRectMake(offSet_X , CGRectGetMinY(_replyImageView.frame) - TableHeader/2 , screenWidth - 120, TableHeader/2);
            _replyBtn.frame = CGRectMake(screenWidth - replySet_X - 40, CGRectGetMinY(_replyImageView.frame) - 24, 40, 18);
            _likeBtn.frame = CGRectMake(screenWidth - replySet_X - 40*2 - 20, CGRectGetMinY(_replyImageView.frame) - 24, 40, 18);
            
        }

        
    }
    
    
}

#pragma mark - ilcoreTextDelegate
//- (void)clickMyself:(NSString *)clickString{
//    
//    //延迟调用下  可去掉 下同
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        
//    });
//}

- (void)clickWFCoretext:(NSString *)clickString{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
		if ([self.delegate respondsToSelector:NSSelectorFromString(@"didRichTextPress:index:")]) {
			[self.delegate didRichTextPress:clickString index:self.stamp];
		}
    });
}

-(void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		if ([self.delegate respondsToSelector:NSSelectorFromString(@"didRichTextPress:index:replyIndex:")]) {
			[self.delegate didRichTextPress:clickString index:self.stamp replyIndex:index];
		}
	});
}

#pragma mark - 点击照片
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
    
    
}

-(YMTextData*)getYMTextData{
    return tempDate;
}


@end
