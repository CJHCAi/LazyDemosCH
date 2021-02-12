/*
 * ALiHintProtocol.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#ifndef ALiHintProtocal_h
#define ALiHintProtocal_h

@protocol ALiHintProtocol <NSObject>

//根据bizid返回组件的全量权限点
- (NSArray<NSString*>*)getHintList:(NSString*)bizID;

//上报组件返回的权限点有缺失
- (void)reportHintLost:(NSString*)bizID hintId:(NSString*)hintId;
@end

#endif /* ALiMtopHintProtocol_h */
