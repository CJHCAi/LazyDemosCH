//
//  IMMessageCellFactory.m
//  StepUp
//
//  Created by chenLong on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "IMMessageCellFactory.h"
#import "IMChatMessageEntityFactory.h"
#import "IMUIMacros.h"
#import "UIViewAdditions.h"
#import "NIAttributedLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "RACEXTScope.h"
#import "UIImage+Utils.h"
#import "MBProgressHUD.h"

#define HEAD_IAMGE_HEIGHT 40
#define CELL_BOTTOM_CLEAN_MARGIN 10

@implementation IMMessageCellFactory

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - IMMessageBaseCell
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface IMMessageBaseCell()

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIImageView *bubbleBgView;

@property (nonatomic, assign) IMChatMessageType type;
@property (nonatomic, assign) BOOL isOutgoing;

@end

@implementation IMMessageBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // head
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, HEAD_IAMGE_HEIGHT, HEAD_IAMGE_HEIGHT)];
        self.headView.image = [UIImage imageNamed:@"head_s.png"];
        [self.contentView addSubview:self.headView];
        
        self.bubbleBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bubbleBgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bubbleBgView];
        
        UILongPressGestureRecognizer *longGesture  = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(showMenuView)];
        [self.bubbleBgView addGestureRecognizer:longGesture];
        
        // background color
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.headView.image = [UIImage imageNamed:@"head_s.png"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0.f, 0.f, SCREEN_SIZE.width, self.height);
    
    UIImage *bubbleBgImage = [self bubbleImageForMessageType:self.type
                                                  isOutgoing:self.isOutgoing];
    
    if (self.isOutgoing) {
        self.headView.right = self.contentView.width - CELL_PADDING_10;
        self.headView.top = CELL_PADDING_10;
        [self.bubbleBgView setImage:[bubbleBgImage stretchableImageWithLeftCapWidth:bubbleBgImage.size.width / 2
                                                                       topCapHeight:bubbleBgImage.size.height / 2]];
    }
    else {
        self.headView.left = CELL_PADDING_10;
        self.headView.top = CELL_PADDING_10;
        [self.bubbleBgView setImage:[bubbleBgImage stretchableImageWithLeftCapWidth:bubbleBgImage.size.width / 2
                                                                       topCapHeight:bubbleBgImage.size.height / 2]];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    if ([object isKindOfClass:[IMChatMessageBaseEntity class]]) {
        IMChatMessageBaseEntity *entity = (IMChatMessageBaseEntity *)object;
        
        if (entity.isOutgoing) {
            [self.headView sd_setImageWithURL:nil
             //[NSURL URLWithString:HEAD_IMAGE(MY_JID.user)]
                             placeholderImage:[UIImage imageNamed:@"head_s.png"]];
        }
        else {
//            if ([IMChatC currentBuddyJid]) {
//                [self.headView  sd_setImageWithURL:nil
//                 //[NSURL URLWithString:HEAD_IMAGE([IMChatC currentBuddyJid].user)]
//                                  placeholderImage:[UIImage imageNamed:@"head_s.png"]];
//            }
        }
    }
    
    return YES;
}

- (void)showMenuView
{
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                      action:@selector(copyContent)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:[NSArray arrayWithObject:menuItem]];
    [menuController setTargetRect:CGRectInset(self.bounds, 0.f, 4.f) inView:self];
    [menuController setMenuVisible:YES animated:YES];
}

- (void)copyContent
{
    
}

- (UIImage *)bubbleImageForMessageType:(IMChatMessageType)type isOutgoing:(BOOL)isOutgoing
{
    UIImage *bubbleBgImage = nil;
    NSString *namePrefix = isOutgoing ? @"Sender" : @"Receiver";
    switch (type) {
        case IMChatMessageType_Text:
        case IMChatMessageType_Voice:
            bubbleBgImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@TextNodeBkg.png", namePrefix]];
            break;
        case IMChatMessageType_Image:
            bubbleBgImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@ImageNodeBorder.png", namePrefix]];
            break;
            // TODO: 其他类型背景
        default:
            break;
    }
    return bubbleBgImage;
}


@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - IMMessageTextCell
///////////////////////////////////////////////////////////////////////////////////////////////////

// 本微博：字体 行高 文本色设置
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:16.f]
#define CONTENT_LINE_HEIGHT 20
#define CONTENT_TEXT_COLOR RGBCOLOR(30, 30, 30)
#define CONTENT_MAX_WIDTH 180

#define BUBBLE_ARROW_MARGIN 20
#define BUBBLE_NOT_ARROW_MARGIN 10
#define BUBBLE_TOP_MARGIN 10
#define BUBBLE_BOTTOM_MARGIN 20

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface IMMessageTextCell()<NIAttributedLabelDelegate>

@property (nonatomic, strong) NIAttributedLabel *contentLabel;
@property (nonatomic, strong) IMChatMessageTextEntity *textMessage;

@end

@implementation IMMessageTextCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)insertAllEmotionsInContentLabel:(NIAttributedLabel *)contentLabel
                        withChatMessage:(IMChatMessageTextEntity *)message
{
//    JLPaserdKeyword* keyworkEntity = nil;
//    if (message.emotionRanges.count) {
//        NSString* emotionImageName = nil;
//        
//        // replace emotion from nail to head, so range's location is right. it's very important, good idea!
//        NSData *imageData = nil;
//        for (int i = message.emotionRanges.count - 1; i >= 0; i--) {
//            keyworkEntity = (JLPaserdKeyword*)message.emotionRanges[i];
//            
//            if (i < message.emotionImageNames.count) {
//                emotionImageName = message.emotionImageNames[i];
//                
//                if (emotionImageName.length) {
//                    imageData = UIImagePNGRepresentation([UIImage imageNamed:emotionImageName]);
//                    [contentLabel insertImage:[UIImage imageWithData:imageData scale:2.4f]
//                                      atIndex:keyworkEntity.range.location
//                                      margins:UIEdgeInsetsZero];
//                }
//            }
//        }
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)attributeHeightForEntity:(IMChatMessageTextEntity *)o withWidth:(CGFloat)width
{
    // only alloc one time,reuse it, optimize best
    static NIAttributedLabel* contentLabel = nil;
    
    if (!contentLabel) {
        contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.font = CONTENT_FONT_SIZE;
        contentLabel.lineHeight = CONTENT_LINE_HEIGHT;
        contentLabel.width = width;
    }
    else {
        // reuse contentLabel and reset frame, it's great idea from my mind
        contentLabel.frame = CGRectZero;
        contentLabel.width = width;
    }
    
    contentLabel.text = o.text;
    [self insertAllEmotionsInContentLabel:contentLabel withChatMessage:o];
    //[contentLabel sizeToFit];
    CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    if (contentSize.height < CONTENT_LINE_HEIGHT) {
        contentSize.height = CONTENT_LINE_HEIGHT;
    }
    return contentSize.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    // content
    if ([object isKindOfClass:[IMChatMessageTextEntity class]]) {
        
        IMChatMessageTextEntity *textEntity = (IMChatMessageTextEntity *)object;
        CGFloat margin = CELL_BOTTOM_CLEAN_MARGIN;
        CGFloat height = margin;
        
        CGFloat kContentLength = CONTENT_MAX_WIDTH;
        
#if 0// sizeWithFont
        CGSize contentSize = [o.text sizeWithFont:CONTENT_FONT_SIZE
                                constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height;
#else// sizeToFit
        CGFloat contentHeight = [self attributeHeightForEntity:textEntity withWidth:kContentLength];
#endif
        if (contentHeight < CONTENT_LINE_HEIGHT) {
            height = height + HEAD_IAMGE_HEIGHT;
        }
        else {
            height = height + contentHeight + BUBBLE_TOP_MARGIN + BUBBLE_BOTTOM_MARGIN;
        }
        
        return height;
    }
    
    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // background color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = CELL_PADDING_8;
    CGFloat margin = CELL_PADDING_10;
    
    // status content
    CGFloat kContentLength = CONTENT_MAX_WIDTH;
    self.contentLabel.frame = CGRectMake(0.f, self.headView.top + margin,
                                         kContentLength, 0.f);
    [self.contentLabel sizeToFit];
    if (self.contentLabel.height < CONTENT_LINE_HEIGHT) {
        self.contentLabel.height = CONTENT_LINE_HEIGHT;
    }
    self.bubbleBgView.frame = CGRectMake(self.bubbleBgView.left, self.headView.top,
                                         self.contentLabel.width + padding + BUBBLE_NOT_ARROW_MARGIN + BUBBLE_ARROW_MARGIN,
                                         self.contentLabel.height + BUBBLE_TOP_MARGIN + BUBBLE_BOTTOM_MARGIN);
    
    if (self.isOutgoing) {
        self.contentLabel.right = self.headView.left - padding - BUBBLE_ARROW_MARGIN;
        self.bubbleBgView.right = self.headView.left - padding;
    }
    else {
        self.contentLabel.left = self.headView.right + padding + BUBBLE_ARROW_MARGIN;
        self.bubbleBgView.left = self.headView.right + padding;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    
    // 从文本中解析出表情等关键字
    if ([object isKindOfClass:[IMChatMessageTextEntity class]]) {
        self.textMessage = (IMChatMessageTextEntity *)object;
        self.type = self.textMessage.type;
        self.isOutgoing = self.textMessage.isOutgoing;
        
        [self.textMessage parseAllKeywords];
        self.contentLabel.text = self.textMessage.text;
        [IMMessageTextCell insertAllEmotionsInContentLabel:self.contentLabel
                                           withChatMessage:self.textMessage];
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIAttributedLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = CONTENT_FONT_SIZE;
        _contentLabel.lineHeight = CONTENT_LINE_HEIGHT;
        _contentLabel.textColor = CONTENT_TEXT_COLOR;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.autoDetectLinks = YES;
        _contentLabel.delegate = self;
        _contentLabel.attributesForLinks = @{(NSString *)kCTForegroundColorAttributeName:(id)RGBCOLOR(6, 89, 155).CGColor};
        _contentLabel.highlightedLinkBackgroundColor = RGBCOLOR(26, 162, 233);
        
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - IMMessageImageCell
///////////////////////////////////////////////////////////////////////////////////////////////////

#define IMAGE_MAX_LENGTH 100

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface IMMessageImageCell()

@property (nonatomic, strong) IMChatMessageImageEntity *imageMessage;
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation IMMessageImageCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return IMAGE_MAX_LENGTH + CELL_PADDING_8 * 2 + CELL_BOTTOM_CLEAN_MARGIN;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bubbleBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.bubbleBgView];
        
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.contentImageView];
        
        // content image gesture
        self.contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapContentImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(showContentOriginImage)];
        [self.contentImageView addGestureRecognizer:tapContentImageGesture];
        
        // background color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = CELL_PADDING_8;
    
    CGSize displaySize = [[self class] displaySizeForImageSourceSize:
                          CGSizeMake(self.imageMessage.width, self.imageMessage.height)];
    self.bubbleBgView.frame = CGRectMake(self.bubbleBgView.left, self.headView.top,
                                         displaySize.width, displaySize.height);
    
    if (self.isOutgoing) {
        self.bubbleBgView.right = self.headView.left - padding;
    }
    else {
        self.bubbleBgView.left = self.headView.right + padding;
    }
    self.contentImageView.frame = self.bubbleBgView.frame;
    
    @weakify(self);
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageMessage.url]]
                          placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  @strongify(self);
                                  // TODO:考虑图片是否旋转过
                                  UIImage *maskImage = [[self class] maskImageWithSize:self.bubbleBgView.size//IM_SIZE_HD(self.bubbleBgView.size)
                                                                            isOutgoing:self.isOutgoing];
                                  self.contentImageView.image = [image maskWithImage:maskImage];
                              });
                              
                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              NSLog(@"image download failure");
                          }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    
    if ([object isKindOfClass:[IMChatMessageImageEntity class]]) {
        self.imageMessage = (IMChatMessageImageEntity *)object;
        self.type = IMChatMessageType_Image;
        self.isOutgoing = self.imageMessage.isOutgoing;
    }
    
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showContentOriginImage
{
//    if (self.viewController) {
//        if ([self.viewController isKindOfClass:[UIViewController class]]) {
//            UITableView* tableView = ((UITableViewController*)self.viewController).tableView;
//            UIWindow* window = [UIApplication sharedApplication].keyWindow;
//            
//            // convert rect to self(cell)
//            CGRect rectInCell = [self.contentView convertRect:self.contentImageView.frame toView:self];
//            
//            // convert rect to tableview
//            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
//            
//            // convert rect to window
//            CGRect rectInWindow = [tableView convertRect:rectInTableView toView:window];
//            
//            // show photo full screen
//            UIImage* image = self.contentImageView.image;
//            if (image) {
//                rectInWindow = CGRectMake(rectInWindow.origin.x + (rectInWindow.size.width - image.size.width) / 2.f,
//                                          rectInWindow.origin.y + (rectInWindow.size.height - image.size.height) / 2.f,
//                                          image.size.width, image.size.height);
//            }
//            JLFullScreenPhotoBrowseView* browseView =
//            [[JLFullScreenPhotoBrowseView alloc] initWithUrlPath:self.imageMessage.url
//                                                       thumbnail:self.contentImageView.image
//                                                        fromRect:rectInWindow];
//            [window addSubview:browseView];
//            
//            
//            
//        }
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static
///////////////////////////////////////////////////////////////////////////////////////////////////

+ (UIImage *)maskImageWithSize:(CGSize)size isOutgoing:(BOOL)isOutgoing
{
    UIImage *maskSourceImage = [[self class] bubbleMaskImageForIsOutgoing:isOutgoing];
    UIImage *stretchImage = [maskSourceImage stretchableImageWithLeftCapWidth:maskSourceImage.size.width / 2
                                                                 topCapHeight:maskSourceImage.size.height / 2];
    UIImage *maskImage = [stretchImage renderAtSize:size];
    return maskImage;
}

+ (CGSize)displaySizeForImageSourceSize:(CGSize)sourceSize
{
    CGFloat realWidth = sourceSize.width;
    CGFloat realHeight = sourceSize.height;
    
    if (sourceSize.width > sourceSize.height) {
        if (sourceSize.width > IMAGE_MAX_LENGTH) {
            realWidth = IMAGE_MAX_LENGTH;
            realHeight =  sourceSize.height * IMAGE_MAX_LENGTH / sourceSize.width;
        }
    }
    else {
        if (sourceSize.height > IMAGE_MAX_LENGTH) {
            realHeight = IMAGE_MAX_LENGTH;
            realWidth = sourceSize.width * IMAGE_MAX_LENGTH / sourceSize.height;
        }
    }
    return CGSizeMake(realWidth, realHeight);
}

+ (UIImage *)bubbleMaskImageForIsOutgoing:(BOOL)isOutgoing
{
    UIImage *bubbleBgImage = nil;
    NSString *namePrefix = isOutgoing ? @"Sender" : @"Receiver";
    
    bubbleBgImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@ImageNodeBorder_back.png", namePrefix]];
    
    return bubbleBgImage;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - IMMessageVoiceCell
///////////////////////////////////////////////////////////////////////////////////////////////////

#define IMAGE_VOICE_HEIGHT 20
#define PROGRESS_VIEW_LENGTH 30

@interface IMMessageAudioCell()

@property (nonatomic, strong) IMChatMessageAudioEntity *audioEntity;
@property (nonatomic, strong) UIImageView *audioImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) MBRoundProgressView *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation IMMessageAudioCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
{
    return CONTENT_LINE_HEIGHT + BUBBLE_TOP_MARGIN + BUBBLE_BOTTOM_MARGIN + CELL_BOTTOM_CLEAN_MARGIN;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, IMAGE_VOICE_HEIGHT, IMAGE_VOICE_HEIGHT)];
        [self.contentView addSubview:self.audioImageView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:self.timeLabel];
        
        self.progressView = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, PROGRESS_VIEW_LENGTH, PROGRESS_VIEW_LENGTH)];
        self.progressView.userInteractionEnabled = YES;
        self.progressView.progressTintColor = [UIColor whiteColor];
        self.progressView.backgroundTintColor = LINE_COLOR;
        [self.contentView addSubview:self.progressView];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:self.indicatorView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(playVoiceAction)];
        [self.bubbleBgView addGestureRecognizer:tapGesture];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // TODO: 考虑cell复用时，如何处理音频的下载进度
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = CELL_PADDING_8;
    CGFloat margin = CELL_PADDING_10;
    
    CGFloat kViewMaxLength = CONTENT_MAX_WIDTH;
    CGFloat kViewMinLength = 40.f;
    CGFloat viewLengthForTime = self.audioEntity.time * 10.f + kViewMinLength;
    CGFloat viewLength = fminf(kViewMaxLength, viewLengthForTime);
    self.bubbleBgView.frame = CGRectMake(self.bubbleBgView.left, self.headView.top,
                                         viewLength + padding + BUBBLE_NOT_ARROW_MARGIN + BUBBLE_ARROW_MARGIN,
                                         CONTENT_LINE_HEIGHT + BUBBLE_TOP_MARGIN + BUBBLE_BOTTOM_MARGIN);
    [self.timeLabel sizeToFit];
    self.audioImageView.top = self.headView.top + margin;
    self.timeLabel.bottom = self.audioImageView.bottom;
    self.progressView.centerY = self.timeLabel.centerY;
    
    if (self.isOutgoing) {
        self.audioImageView.right = self.headView.left - padding - BUBBLE_ARROW_MARGIN;
        self.bubbleBgView.right = self.headView.left - padding;
        self.timeLabel.right = self.bubbleBgView.left - CELL_PADDING_2;
        self.progressView.right = self.timeLabel.left - CELL_PADDING_4;
    }
    else {
        self.audioImageView.left = self.headView.right + padding + BUBBLE_ARROW_MARGIN;
        self.bubbleBgView.left = self.headView.right + padding;
        self.timeLabel.left = self.bubbleBgView.right + CELL_PADDING_2;
        self.progressView.left = self.timeLabel.right + CELL_PADDING_4;
    }
    
    self.indicatorView.frame = self.progressView.frame;
    self.progressView.hidden = YES;
    self.audioImageView.image = [IMMessageAudioCell voiceImageForIsOutgoing:self.isOutgoing];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    
    if ([object isKindOfClass:[IMChatMessageAudioEntity class]]) {
        self.audioEntity = (IMChatMessageAudioEntity *)object;
        self.timeLabel.text = [NSString stringWithFormat:@"%d''", self.audioEntity.time];
        self.isOutgoing = self.audioEntity.isOutgoing;
        
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage *)voiceImageForIsOutgoing:(BOOL)isOutgoing
{
    UIImage *image = nil;
    NSString *namePrefix = isOutgoing ? @"Sender" : @"Receiver";
    
    image = [UIImage imageNamed:[NSString stringWithFormat:@"%@VoiceNodePlaying.png", namePrefix]];
    
    return image;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)playVoiceAction
{
    [self.indicatorView startAnimating];
    @weakify(self);
    [self.audioEntity playAudioWithProgressBlock:^(CGFloat progress) {
        @strongify(self);
        self.progressView.progress = progress;
        self.progressView.hidden = (progress < 1.0) ? NO : YES;
        NSLog(@"progress = %f",progress);
        if (progress > 0.f && !self.indicatorView.hidden) {
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
        }
    }];
}

@end