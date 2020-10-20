//
//  SKVoiceWaveView.m
//  SKVoiceWave
//
//  Created by ac-hu on 2018/10/24.
//  Copyright © 2018年 SK-HU. All rights reserved.
//

#import "SKVoiceWaveView.h"
#import "SKVoiceFilter.h"
#import "SKVoiceProvider.h"

@interface SKVoiceWaveView()

@property(nonatomic,strong)SKVoiceFilter *filter;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;

@end

@implementation SKVoiceWaveView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setConfig];
    }
    return self;
}

//加载等待视图
-(void)setConfig{
    self.lineWidth = 0;
    self.lineDistance = 4;
    self.lineColor = [UIColor redColor];
    self.filter = [[SKVoiceFilter alloc]init];
    self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingView.center = CGPointMake(self.bounds.size.width / 2., self.bounds.size.height / 2.);
    [self addSubview:self.loadingView];
    [self.loadingView startAnimating];
}

-(void)setAsset:(AVAsset *)asset{
    if (!asset) {
        NSLog(@"路径asset错误");
        [self.loadingView stopAnimating];
        return;
    }
    [SKVoiceProvider loadAudioSamplesFormAsset:asset completionBlock:^(NSData *data) {
        if (data) {
            self.filter.data = data;
        }else{
            NSLog(@"读取音频文件失败");
        }
        [self.loadingView stopAnimating];
        [self setNeedsDisplay];
    }];
}

-(void)setUrl:(NSURL *)url{
    if (!url) {
        NSLog(@"路径url错误");
        [self.loadingView stopAnimating];
        return;
    }
    _url = url;
    self.asset = [AVAsset assetWithURL:_url];
}

-(void)setPath:(NSString *)path{
    if (!path) {
        NSLog(@"路径path错误");
        [self.loadingView stopAnimating];
        return;
    }
    _path = path;
    self.url = [NSURL fileURLWithPath:path];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *filteredSamples = [self.filter filteredSamplesForSize:self.frame.size];
    if (_lineWidth == 0) {
        CGFloat midY = CGRectGetMidY(rect);//得到中心y的坐标
        CGMutablePathRef halfPath = CGPathCreateMutable(); //绘制路径
        CGPathMoveToPoint(halfPath, nil, 0.0f, midY);//在路径上移动当前画笔的位置到一个点，这个点由CGPoint 类型的参数指定。
        for (NSUInteger i = 0; i < filteredSamples.count; i ++) {
            
            float sample = [filteredSamples[i] floatValue];
            CGPathAddLineToPoint(halfPath, NULL, i, midY - sample); //从当前的画笔位置向指定位置（同样由CGPoint类型的值指定）绘制线段
            NSLog(@"%f",sample);
        }
        CGPathAddLineToPoint(halfPath, NULL, filteredSamples.count, midY); //重置起点
        //实现波形图反转
        CGMutablePathRef fullPath = CGPathCreateMutable();//创建新路径
        CGPathAddPath(fullPath, NULL, halfPath); //合并路径
        CGAffineTransform transform = CGAffineTransformIdentity; //反转
        //反转配置
        transform = CGAffineTransformTranslate(transform, 0, CGRectGetHeight(rect));
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGPathAddPath(fullPath, &transform, halfPath);//将路径添加到上下文中
        CGContextAddPath(context, fullPath);
        //绘制颜色
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        //开始绘制
        CGContextDrawPath(context, kCGPathFill);//移除
        CGPathRelease(halfPath);
        CGPathRelease(fullPath);
    }else{
        int count = self.frame.size.width / (self.lineWidth + self.lineDistance);
        NSMutableArray *filterMuArr = @[].mutableCopy;
        if (count >= filteredSamples.count) {
            filterMuArr = filteredSamples.mutableCopy;
        }else{
            int index = (int)filteredSamples.count / count;
            CGContextSetLineWidth(context, self.lineWidth);//线的宽度
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            for (int i = 0; i < count; i ++) {
                [filterMuArr addObject:filteredSamples[i * index]];
                NSInteger lineHeight = [filteredSamples[i * index] floatValue];
                CGContextMoveToPoint(context, i * (self.lineWidth + self.lineDistance), (self.frame.size.height - lineHeight) / 2.f);
                CGContextAddLineToPoint(context, i * (self.lineWidth + self.lineDistance), self.frame.size.height - (self.frame.size.height - lineHeight) / 2.f);
                CGContextDrawPath(context, kCGPathStroke);
            }
            
        }
    }
}

@end
