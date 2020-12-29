//
//  SportForumAPI.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SportForum.h"

@interface SportForumAPI : NSObject

+(SportForumAPI*)sharedInstance;
-(NSDictionary*)getAllOperation;
-(int)getCurEffectScore;

-(BaseOperation*) accountRegisterInPoolsByUserName:(NSString*)username
                                Password:(NSString*)password
                                NickName:(NSString*)nickname
                           FinishedBlock:(void(^)(int errorCode, NSString* accessToken))finishedBlock;

-(NSOperation*) accountRegisterByUserName:(NSString*)username
                                Password:(NSString*)password
                                NickName:(NSString*)nickname
                           FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken))finishedBlock;

-(NSOperation*) accountRegisterExById:(NSString*)userId
                                 Password:(NSString*)password
                                 AccountType:(NSUInteger)nAccountType
                                 NickName:(NSString*)nickname
                               ImgUrl:(NSString*)strImgUrl
                              SexType:(NSString*)strSexType
                             BirthDay:(long long)lBirthday
                            FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken))finishedBlock;

// verfiycode is password or weibo accesscode
-(NSOperation*) accountLoginByUserName:(NSString*)username
                          Verfiycode:(NSString*)verfiycode
                         AccountType:(NSUInteger)nAccountType
                       FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* accessToken, NSString* userId, BOOL bRegister, long long lLLoginTime, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) accountLoginExById:(NSString*)userId
                            Password:(NSString*)password
                           AccountType:(NSUInteger)nAccountType
                         FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken))finishedBlock;

-(NSOperation*) accountImportFriendsByUserName:(NSString*)username
                            Verfiycode:(NSString*)verfiycode
                            AppKey:(NSString*)strAppKey
                           AccountType:(NSUInteger)nAccountType
                         FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) accountModifyPassword:(NSString*)strPassword
                            NewPassword:(NSString*)strNewPassword
                         FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock;

-(NSOperation*) accountCheckExistById:(NSString*)userId
                          AccountType:(NSUInteger)nAccountType
                        FinishedBlock:(void(^)(int errorCode, NSString* userId))finishedBlock;

-(NSOperation*) userLogout:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userGetDailyLoginReward:(void(^)(int errorCode, int nLoginedDays, NSMutableArray* arrLoginReward))finishedBlock;

-(NSOperation*) userGetPKPropertiesInfo:(NSString*)strUserId FinishedBlock:(void(^)(int errorCode, int nPhysiqueTimes, int nLiteratureTimes, int nMagicTimes))finishedBlock;

-(BaseOperation*) userGetInfoInPoolsByUserId:(NSString*) strUserId FinishedBlock:(void(^)(int errorCode, UserInfo* userInfo))finishedBlock;

-(NSOperation*) userGetInfoByUserId:(NSString*) strUserId NickName:(NSString*) strNickName FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, UserInfo* userInfo))finishedBlock;

-(NSOperation*) userGetPropertiesValue:(NSString*) strUserId FinishedBlock:(void(^)(int errorCode, PropertiesInfo* propertiesInfo))finishedBlock;

-(NSOperation*) userSetInfoByUpdateInfo:(UserUpdateInfo*) userUpdateInfo FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userUpdateEquipment:(EquipmentInfo*) equipmentInfo FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userSetLifePhotos:(NSArray*)arrayPics FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userDelLifePhotoById:(NSString*)strPicId FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userSetProImageByImageId:(NSString*)imageID FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userEnableAttentionByUserId:(NSArray*)arrUserids Attention:(BOOL)bAttention FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userDeFriendByUserId:(NSArray*)arrUserids DeFriend:(BOOL)bDeFriend FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock;

-(NSOperation*) userGetRelaterdMembersCount:(void(^)(int errorCode, int nFriendCount, int nAttectionCount, int nFansCount, int nDeFriend))finishedBlock;

-(NSOperation*) userGetRelaterdByType:(e_related_type)eRelatedType
                               UserId:(NSString*)strUserId
                         FirstPageId:(NSString*)strPageFirstId
                          LastPageId:(NSString*)strPageLastId
                         PageItemNum:(int)nPageItemCount
                       FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) userSearchByPageId:(NSString*)strPageFirstId
                           LastPageId:(NSString*)strPageLastId
                          PageItemNum:(int)nPageItemCount
                          IsNearBy:(BOOL)bIsNeerBy
                        NickName:(NSString*)strNickeName
                        FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) userArticlesByUserId:(NSString*)strUserId
                 ArticleType:(article_type)eArticleType
                 FirstPageId:(NSString*)strPageFirstId
                  LastPageId:(NSString*)strPageLastId
                 PageItemNum:(int)nPageItemCount
               FinishedBlock:(void(^)(int errorCode, ArticlesInfo *articlesInfo))finishedBlock;

-(NSOperation*) userSendDeviceTokenByDeviceId:(NSString*)strDeviceId FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userSetPushEnableStatusByDeviceId:(NSString*)strDeviceId IsEnable:(BOOL)bEnable FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userIsPushEnabledByDeviceId:(NSString*)strDeviceId FinishedBlock:(void(^)(int errorCode, BOOL bEnable))finishedBlock;

-(NSOperation*) userNewGroupByGroupInfo:(NewGroupInfo*)newGroupInfo FinishedBlock:(void(^)(int errorCode, NSString *strGroupId))finishedBlock;

-(NSOperation*) userGetMobileFriendsByPhones:(NSArray*)arrPhones
                               FinishedBlock:(void(^)(int errorCode, ImportContactList *importContactList))finishedBlock;

-(NSOperation*) userGetRecommendsByPageId:(NSString*)strPageFirstId
                               LastPageId:(NSString*)strPageLastId
                            FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *recommendsList))finishedBlock;

-(NSOperation*) userResetPwdByPhone:(NSString*)strPhoneNum Password:(NSString*)strPwd FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock;

-(NSOperation*) userShareToFriends:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userGameResultByType:(e_game_type)eGameType GameScore:(NSUInteger)nGameScore FinishedBlock:(void(^)(int errorCode, GameResultInfo* gameResultInfo))finishedBlock;

-(NSOperation*) userIsNikeNameUsed:(NSString*)strNikeName FinishedBlock:(void(^)(int errorCode, BOOL bUsed))finishedBlock;

-(NSOperation*) userPurchaseSuccessFromCoin:(long long)lCoinValue BuyTime:(long long)lBuyTime BuyValue:(NSUInteger)nValue FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) userGetPayCoinListByFirPagId:(NSString*)strPageFirstId
                                  LastPageId:(NSString*)strPageLastId
                               PageItemCount:(int)nPageItemCount
                               FinishedBlock:(void(^)(int errorCode, PayHistory* payHistory))finishedBlock;

-(NSOperation*) userLeaderBoardByFirPagId:(NSString*)strPageFirstId
                               LastPageId:(NSString*)strPageLastId
                                BoardType:(NSString*)strType
                            PageItemCount:(int)nPageItemCount
                                 FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) userAuthRequestByType:(e_auth_type)eAuthType
                               AuthImgs:(NSArray*)arrImgs
                                AuthDesc:(NSString*)strAuthDesc
                            FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userAuthStatusByUserId:(NSString*)strUserId
                        FinishedBlock:(void(^)(int errorCode, e_auth_status_type eIdcardStatus, e_auth_status_type eCertStatus, e_auth_status_type eRecordStatus))finishedBlock;

-(NSOperation*) userAuthInfoByType:(e_auth_type)eAuthType
                         FinishedBlock:(void(^)(int errorCode, NSString* strAuthDesc, NSString* strAuthReview, NSArray* arrAuthImgs, e_auth_status_type eAuthStatus))finishedBlock;

-(NSOperation*) userSendHeartByRecordId:(NSString*)strRecordId
                          FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userReceiveHeartBySendId:(NSString*)strSendId
                                IsAccept:(BOOL)bAccept
                           FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) userGetRanks:(void(^)(int errorCode, UserRanks *userRanks))finishedBlock;

-(NSOperation*) userIsPreSportForm:(void(^)(int errorCode, BOOL isPreSportForm))finishedBlock;

-(NSOperation*) userActionByPath:(NSString*)strPath FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) tasksGetInfo:(BOOL)bNext FinishedBlock:(void(^)(int errorCode, TasksCurInfo *tasksCurInfo))finishedBlock;

-(NSOperation*) tasksGetResultById:(NSUInteger)nTaskId FinishedBlock:(void(^)(int errorCode, TasksInfo *tasksInfo))finishedBlock;

-(NSOperation*) tasksGetList:(void(^)(int errorCode, TasksInfoList *tasksInfoList))finishedBlock;

-(NSOperation*) tasksGetInfoByTaskId:(NSUInteger)nTaskId FinishedBlock:(void(^)(int errorCode, TasksInfo *tasksInfo))finishedBlock;

-(NSOperation*) tasksExecuteByTaskId:(NSUInteger)nTaskId TaskPics:(NSArray*)arrayPics FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) tasksReferrals:(void(^)(int errorCode, TasksReferList* tasksReferList))finishedBlock;

-(NSOperation*) tasksShareByUserId:(NSString*)strUserId TaskId:(NSUInteger)nTaskId ShareType:(e_accept_type)eSharedType CostCoin:(long long)lCoin Latitude:(float)fLatitude
                         Longitude:(float)fLongitude AddDesc:(NSString*)strAddDesc MapImgUrl:(NSString*)strUrl RunBeginTime:(long long)lRunTime FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) tasksSharedByType:(e_accept_type)eSharedType SenderId:(NSString*)strSenderId ArticleId:(NSString*)strArticleId AddDesc:(NSString*)strAddDesc ImgUrl:(NSString*)strUrl RunBeginTime:(long long)lRunTime IsAccept:(BOOL)bAccept FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) tasksReferralPassByUserId:(NSString*)strUserId FinishedBlock:(void(^)(int errorCode))finishedBlock;

// Array Object type ArticleSegmentObject
-(NSOperation*) articleNewByParArticleId:(NSString*)strParArticleId ArticleSegment:(NSArray*) articleSegment ArticleTag:(NSArray*)arrTags Type:(NSString*)strType AtNameList:(NSArray*)arrAtList FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) articleDeleteByArticleId:(NSString*) strArticleId FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock;

-(NSOperation*) articleThumbByArticleId:(NSString*)articleID ThumbStatus:(BOOL)blThumb
                          FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) articleIsThumbedByArticleId:(NSString*)articleID FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, BOOL isThumbed))finishedBlock;

-(NSOperation*) articleTimeLinesByFirPagId:(NSString*)strPageFirstId
                      LastPageId:(NSString*)strPageLastId
                     PageItemCount:(int)nPageItemCount
                    ArticleTag:(e_article_tag_type) eArticleTagType
                    IsCircle:(BOOL)bAttentionCircle
                   FinishedBlock:(void(^)(int errorCode, ArticlesInfo* articlesInfo))finishedBlock;

-(NSOperation*) articleGetByArticleId:(NSString*)articleID FinishedBlock:(void(^)(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr))finishedBlock;

-(NSOperation*) articleCommentsByArticleId:(NSString*)articleID
                    FirstPageId:(NSString*)strPageFirstId
                     LastPageId:(NSString*)strPageLastId
                    PageItemNum:(int)nPageItemCount
                    Type:(NSString*)strType
                  FinishedBlock:(void(^)(int errorCode, ArticlesInfo *articlesInfo))finishedBlock;

-(NSOperation*) articleThumbsByArticleId:(NSString*) strArticleId
                                     PageIndex:(int)nPageIndex
                                 FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) articleRewardsByArticleId:(NSString*) strArticleId
                               PageIndex:(int)nPageIndex
                           FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) articleNewsByArticleId:(NSString*) strArticleId
                           FinishedBlock:(void(^)(int errorCode, NSInteger nNewsCount, NSArray* arrProfilesImgs))finishedBlock;

-(NSOperation*) articleRepostByArticleId:(NSString*) strReferArticleId
                                Latitude:(float)fLatitude
                               Longitude:(float)fLongitude
                         FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) recordNewByRecordItem:(SportRecordInfo*)sportRecordInfo RecordId:(NSUInteger)nRecordId Public:(BOOL)bPublic FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* strRecordId, ExpEffect* expEffect))finishedBlock;

-(NSOperation*) recordTimeLineByUserId:(NSString*)strUserId
                           FirstPageId:(NSString*)strPageFirstId
                            LastPageId:(NSString*)strPageLastId
                           PageItemNum:(int)nPageItemCount
                            RecordType:(NSString*)strType
                         FinishedBlock:(void(^)(int errorCode, SportRecordInfoList *sportRecordInfoList))finishedBlock;

-(NSOperation*) recordGetById:(NSString*)strRecordId
                         FinishedBlock:(void(^)(int errorCode, SportRecordInfo *sportRecordInfo))finishedBlock;

-(NSOperation*) leaderBoardListByQueryType:(board_query_type)eQueryType
                                 QueryInfo:(NSString*)strQueryInfo
                           FirstPageId:(NSString*)strPageFirstId
                            LastPageId:(NSString*)strPageLastId
                           PageItemNum:(int)nPageItemCount
                         FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) leaderBoardGameListByQueryType:(board_query_type)eQueryType
                                 GameType:(e_game_type)eGameType
                                  GameScore:(NSUInteger)nGameScore
                               PageIndex:(int)nPageIndex
                             FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock;

-(NSOperation*) recordStatisticsByUserId:(NSString*)strUserId
                             FinishedBlock:(void(^)(int errorCode, RecordStatisticsInfo *recordStatisticsInfo))finishedBlock;

-(NSOperation*) eventNews:(void(^)(int errorCode, EventNewsInfo* eventNewsInfo))finishedBlock;

-(NSOperation*) eventNewsDetails:(void(^)(int errorCode, EventNewsDetails* eventNewsDetails))finishedBlock;

//EventTypeStr - article/wallet/system/...
-(NSOperation*) eventChangeStatusReadByEventType:(event_type)eEventType EventTypeStr:(NSString*)strTypeStr EventId:(NSString*)strEventId FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*) eventNotices:(void(^)(int errorCode, EventNotices* eventNotices))finishedBlock;

-(NSOperation*) chatSendMessageBySendId:(NSString*)sendToId SendType:(chat_send_type)eSendType Content:(NSString*)strContent FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString*strMsgId))finishedBlock;

-(NSOperation*) chatRecentChatInfos:(void(^)(int errorCode, ContactInfos* contactInfos))finishedBlock;

-(NSOperation*) chatGetListByUserId:(NSString*)strUserId
                FirstPageId:(NSString*)strPageFirstId
                 LastPageId:(NSString*)strPageLastId
                PageItemCount:(int)nPageItemCount
              FinishedBlock:(void(^)(int errorCode, ChatMessagesList* chatMessagesList))finishedBlock;

-(NSOperation*) chatDeleteMessageByUserId:(NSString*)strUserId FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock;

-(NSOperation*)fileDeleteByIds:(NSArray*)arrFileIds FinishedBlock:(void(^)(int errorCode))finishedBlock;

-(NSOperation*)fileUptoken:(void(^)(int errorCode, NSString* strToken))finishedBlock;

-(NSOperation*)sysConfig:(void(^)(int errorCode, SysConfig* sysConfig))finishedBlock;

-(BaseOperation*) imageUploadByUIImage:(UIImage*)image Width:(NSUInteger)nWidth Height:(NSUInteger)nHeight
                         FinishedBlock:(void(^)(int errorCode, NSString* imageID, NSString* imageURL))finishedBlock;

-(NSOperation*) imageUploadByUIImage:(UIImage*)image Width:(NSUInteger)nWidth Height:(NSUInteger)nHeight IsCompress:(BOOL)bIsCompress
                 UploadProgressBlock:(void(^)(NSInteger bytesWritten, NSInteger totalBytes))uploadProgressBlock
                       FinishedBlock:(void(^)(int errorCode, NSString* imageID, NSString* imageURL))finishedBlock;

-(NSOperation*) walletGetAddressesInfo:(void(^)(int errorCode, WalletInfo* walletInfo))finishedBlock;

-(NSOperation*) walletGetBalanceInfo:(void(^)(int errorCode, WalletBalanceInfo* walletBalanceInfo))finishedBlock;

-(NSOperation*) walletNewAddress:(void(^)(int errorCode, WalletAddressItem* walletAddressItem))finishedBlock;

-(NSOperation*) walletTradeBySelfAddress:(NSString*)strFrom TradeTo:(NSString*)strTo TradeType:(e_trade_type)eTradeType ArticleId:(NSString*)strArticleId TradeValue:(long long)lValue FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* strTxid))finishedBlock;

-(NSOperation*) walletGetTradeListByAddress:(NSString*)strAdd FinishedBlock:(void(^)(int errorCode, WalletTradeDetailInfo* walletTradeDetailInfo))finishedBlock;

-(NSOperation*) videoGetListByPageToken:(long long)lPageToken PageCount:(int)nPageCount FinishedBlock:(void(^)(int errorCode, VideoSearchInfoList* videoSearchInfoList))finishedBlock;

-(NSOperation*) videoGetInfoByVideoID:(NSString*)strVideoID FinishedBlock:(void(^)(int errorCode, VideoInfo* videoInfo))finishedBlock;

@end
