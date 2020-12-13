//
//  YIMEditerParagraphView.m
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphView.h"
#import "YIMEditerParagraphAlignmentCell.h"
#import "YIMEditerParagraphLineIndentCell.h"
#import "YIMEditerParagraphSpacingCell.h"
#import "YIMEditerDrawAttributes.h"

@interface YIMEditerParagraphView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)id<YIMEditerStyleChangeDelegate> delegate;
@property(nonatomic,strong)YIMEditerParagraphAlignmentCell *alignmentCell;
@property(nonatomic,strong)YIMEditerParagraphLineIndentCell *lineIndentCell;
@property(nonatomic,strong)YIMEditerParagraphSpacingCell *spacingCell;
@property(nonatomic,strong)NSArray<YIMEditerStyleBaseCell*>* cellList;
@end

@implementation YIMEditerParagraphView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        tableView.frame = self.bounds;
        [tableView registerClass:[YIMEditerParagraphAlignmentCell class] forCellReuseIdentifier:@"alignmentCell"];
        [tableView registerClass:[YIMEditerParagraphLineIndentCell class] forCellReuseIdentifier:@"lineIndentCell"];
        [tableView registerClass:[YIMEditerParagraphSpacingCell class] forCellReuseIdentifier:@"spacingCell"];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:tableView];
        
        self.cellList = @[self.lineIndentCell,self.alignmentCell,self.spacingCell];
        
        self.tableView = tableView;
    }
    return self;
}

#pragma  -mark tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellList[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellList[indexPath.row] needHeight];
}

#pragma -mark get set
-(void)setParagraphStyle:(YIMEditerParagraphStyle *)paragraphStyle{
    _paragraphStyle = paragraphStyle;
    self.alignmentCell.currentTextAlignment = paragraphStyle.alignment;
    self.lineIndentCell.isRightTab = paragraphStyle.firstLineIndent;
    self.spacingCell.spacingHeight = paragraphStyle.lineSpacing;
}
-(YIMEditerParagraphAlignmentCell*)alignmentCell{
    if (!_alignmentCell) {
        _alignmentCell = [[YIMEditerParagraphAlignmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        __weak typeof(self) weakSelf = self;
        [_alignmentCell setAlignmentChangeBlock:^(NSTextAlignment alignment) {
            [weakSelf alignmentChange:alignment];
        }];
    }
    return _alignmentCell;
}
-(YIMEditerParagraphLineIndentCell*)lineIndentCell{
    if (!_lineIndentCell) {
        _lineIndentCell = [[YIMEditerParagraphLineIndentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        __weak typeof(self) weakSelf = self;
        [_lineIndentCell setLineIndentChange:^(BOOL isLineIndent) {
            [weakSelf firstLineIndentChange:isLineIndent];
        }];
    }
    return _lineIndentCell;
}
-(YIMEditerParagraphSpacingCell *)spacingCell{
    if (!_spacingCell) {
        _spacingCell = [[YIMEditerParagraphSpacingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        __weak typeof(self) weakSelf = self;
        [_spacingCell setSpacingChange:^(CGFloat height) {
            [weakSelf lineSpacingChange:height];
        }];
    }
    return _spacingCell;
}
#pragma -mark private methods
-(void)firstLineIndentChange:(BOOL)newValue{
    if (self.paragraphStyle.firstLineIndent != newValue) {
        self.paragraphStyle.firstLineIndent = newValue;
        [self valueChange];
    }
}
-(void)alignmentChange:(NSTextAlignment)newValue{
    if (self.paragraphStyle.alignment != newValue) {
        self.paragraphStyle.alignment = newValue;
        [self valueChange];
    }
}
-(void)lineSpacingChange:(CGFloat)newValue{
    if (self.paragraphStyle.lineSpacing != newValue) {
        self.paragraphStyle.lineSpacing = newValue;
        [self valueChange];
    }
}
-(void)valueChange{
    if ([self.delegate respondsToSelector:@selector(style:didChange:)]) {
        [self.delegate style:self didChange:self.paragraphStyle];
    }
}

#pragma -mark 实现YIMEditerStyleChangeObject接口
/**当前样式*/
-(YIMEditerStyle*)currentStyle{
    return self.paragraphStyle;
}
/**更新UI*/
-(void)updateUIWithTextAttributes:(YIMEditerDrawAttributes *)attributed{
    self.paragraphStyle = [[YIMEditerParagraphStyle alloc]initWithAttributed:attributed];
}
/**样式变更代理*/
-(void)setStyleDelegate:(id<YIMEditerStyleChangeDelegate>)styleDelegate{
    self.delegate = styleDelegate;
}
-(YIMEditerStyle*)styleUseAttributed:(YIMEditerDrawAttributes *)attributed{
    return [[YIMEditerParagraphStyle alloc]initWithAttributed:attributed];
}
-(id<YIMEditerStyleChangeDelegate>)styleDelegate{
    return self.delegate;
}
/**默认样式*/
-(YIMEditerStyle*)defualtStyle{
    return [YIMEditerParagraphStyle createDefualtStyle];
}
-(YIMEditerDrawAttributes*)attributesUseHtmlElement:(struct HtmlElement)element isParagraphElement:(BOOL)isParagraph content:(NSString**)content{
    if (!isParagraph) {
        return [[YIMEditerDrawAttributes alloc]initWithAttributeString:@{}];
    }else{
        return [[YIMEditerParagraphStyle createWithHtmlElement:element content:content]outPutAttributed];
    }
}


@end
