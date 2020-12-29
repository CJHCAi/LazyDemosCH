//
//  CommonFunction.m
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "CommonFunction.h"
#import "ServiceKeys.h"

@implementation CommonFunction

+(NSString*)ConvertLoginTypeToString:(account_login_type) eLoginType
{
    NSString *strLoginType = login_email;
    
    switch (eLoginType) {
        case login_type_email:
            strLoginType = login_email;
            break;
        case login_type_phone:
            strLoginType = login_phone;
            break;
        case login_type_weibo:
            strLoginType = login_weibo;
            break;
        case login_type_nickname:
            strLoginType = login_nickname;
            break;
        default:
            break;
    }
    
    return strLoginType;
}

+(account_login_type)ConvertStringToLoginType:(NSString*) strLoginType
{
    account_login_type eLoginType = login_type_email;
    
    if ([strLoginType isEqualToString:login_email]) {
        eLoginType = login_type_email;
    }
    else if([strLoginType isEqualToString:login_phone])
    {
        eLoginType = login_type_phone;
    }
    else if([strLoginType isEqualToString:login_weibo])
    {
        eLoginType = login_type_weibo;
    }
    else if([strLoginType isEqualToString:login_nickname])
    {
        eLoginType = login_type_nickname;
    }
    
    return eLoginType;
}

+(article_seg_type)ConvertStringToArticleType:(NSString*) strArticleType
{
    article_seg_type eArticleType = article_type_text;
    
    if([strArticleType isEqualToString:article_text])
    {
        eArticleType = article_type_text;
    }
    else if([strArticleType isEqualToString:article_image])
    {
        eArticleType = article_type_image;
    }
    
    return eArticleType;
}

+(chat_send_type)ConvertStringToChatSendType:(NSString*) strSendType
{
    chat_send_type eChatSendType = chat_send_text;
    
    if ([strSendType isEqualToString:send_type_text]) {
        eChatSendType = chat_send_text;
    }
    else if([strSendType isEqualToString:send_type_voice])
    {
        eChatSendType = chat_send_voice;
    }
    else if([strSendType isEqualToString:send_type_image])
    {
        eChatSendType = chat_send_image;
    }
    else if([strSendType isEqualToString:send_type_video])
    {
        eChatSendType = chat_send_video;
    }
    
    return eChatSendType;
}

+(e_task_type)ConvertStringToTaskType:(NSString*) strTaskType
{
    e_task_type eTaskType = e_task_physique;
    
    if ([strTaskType isEqualToString:task_physique]) {
        eTaskType = e_task_physique;
    }
    else if([strTaskType isEqualToString:task_literature])
    {
        eTaskType = e_task_literature;
    }
    else if([strTaskType isEqualToString:task_magic])
    {
        eTaskType = e_task_magic;
    }
    
    return eTaskType;
}

+(e_task_status)ConvertStringToTaskStatusType:(NSString*) strTaskStatusType
{
    e_task_status eTaskStatusType = e_task_normal;
    
    if([strTaskStatusType isEqualToString:task_normal]) {
        eTaskStatusType = e_task_normal;
    }
    else if ([strTaskStatusType isEqualToString:task_finish]) {
        eTaskStatusType = e_task_finish;
    }
    else if([strTaskStatusType isEqualToString:task_unfinish])
    {
        eTaskStatusType = e_task_unfinish;
    }
    else if([strTaskStatusType isEqualToString:task_authentication])
    {
        eTaskStatusType = e_task_authentication;
    }
    
    return eTaskStatusType;
}

+(e_sex_tag_type)ConvertStringToSexType:(NSString*) strSexType
{
    e_sex_tag_type eSexTagType = e_sex_male;
    
    if ([strSexType isEqualToString:sex_male]) {
        eSexTagType = e_sex_male;
    }
    else if([strSexType isEqualToString:sex_female])
    {
        eSexTagType = e_sex_female;
    }
    
    return eSexTagType;
}

+(e_auth_type)ConvertStringToAuthType:(NSString*) strAuthType
{
    e_auth_type eAuthType = e_auth_idcard;
    
    if ([strAuthType isEqualToString:Auth_IdCard]) {
        eAuthType = e_auth_idcard;
    }
    else if([strAuthType isEqualToString:Auth_Cert])
    {
        eAuthType = e_auth_cert;
    }
    else if([strAuthType isEqualToString:Auth_Record])
    {
        eAuthType = e_auth_record;
    }
    
    return eAuthType;
}

+(e_auth_status_type)ConvertStringToAuthStatusType:(NSString*) strAuthStatusType
{
    e_auth_status_type eAuthStatusType = e_auth_unverified;
    
    if ([strAuthStatusType isEqualToString:Auth_Unverified]) {
        eAuthStatusType = e_auth_unverified;
    }
    else if([strAuthStatusType isEqualToString:Auth_Verifying])
    {
        eAuthStatusType = e_auth_verifying;
    }
    else if([strAuthStatusType isEqualToString:Auth_Verified])
    {
        eAuthStatusType = e_auth_verified;
    }
    else if([strAuthStatusType isEqualToString:Auth_Refused])
    {
        eAuthStatusType = e_auth_refused;
    }
    
    return eAuthStatusType;
}

+(NSString*)ConvertSendTypeToString:(chat_send_type) eSendType
{
    NSString *strSendType = send_type_text;
    
    switch (eSendType) {
        case chat_send_text:
            strSendType = send_type_text;
            break;
        case chat_send_voice:
            strSendType = send_type_voice;
            break;
        case chat_send_image:
            strSendType = send_type_image;
            break;
        case chat_send_video:
            strSendType = send_type_video;
            break;
        default:
            break;
    }
    
    return strSendType;
}

+(NSString*)ConvertEventTypeToString:(event_type) eEventType
{
    NSString *strEventType = @"";

    switch (eEventType) {
        case event_type_chat:
            strEventType = event_chat;
            break;
        case event_type_groupchat:
            strEventType = GroupChat;
            break;
        case event_type_subscribe:
            strEventType = SubScribe;
            break;
        case event_type_thumb:
            strEventType = Thumb;
            break;
        case event_type_at:
            strEventType = @"at";
            break;
        case event_type_record:
            strEventType = @"record";
            break;
        case event_type_coach_comment:
            strEventType = Coach;
            break;
        case event_type_coach_pass_comment:
            strEventType = @"coachpass";
            break;
        case event_type_coach_npass_comment:
            strEventType = @"coachnpass";
            break;
        case event_type_comment:
            strEventType = Comment;
            break;
        case event_type_tx:
            strEventType = Trade;
            break;
        case event_type_reward:
            strEventType = Reward;
            break;
        case event_type_send_heart:
            strEventType = SendHeart;
            break;
        case event_type_receive_heart:
            strEventType = ReceiveHeart;
            break;
        case event_type_run_share:
            strEventType = @"runshare";
            break;
        case event_type_run_shared:
            strEventType = @"runshared";
            break;
        case event_type_post_share:
            strEventType = @"postshare";
            break;
        case event_type_post_shared:
            strEventType = @"postshared";
            break;
        case event_type_pk_share:
            strEventType = @"pkshare";
            break;
        case event_type_pk_shared:
            strEventType = @"pkshared";
            break;
        case event_type_info:
            strEventType = @"info";
            break;
        default:
            break;
    }

    return strEventType;
}

+(NSString*)ConvertArticleTypeToString:(article_type) eArticleType
{
    NSString *strArticleType = article_all;
    
    switch (eArticleType) {
        case article_type_all:
            strArticleType = article_all;
            break;
        case article_type_comments:
            strArticleType = article_comments;
            break;
        case article_type_articles:
            strArticleType = article_articles;
            break;
        default:
            break;
    }
    
    return strArticleType;
}

+(NSString*)ConvertRecordTypeToString:(record_type)eRecordType
{
    NSString *strRecordType = sport_type_run;
    
    switch (eRecordType) {
        case record_type_run:
            strRecordType = sport_type_run;
            break;
        case record_type_ride:
            strRecordType = sport_type_ride;
            break;
        case record_type_swimming:
            strRecordType = sport_type_swimming;
            break;
        default:
            break;
    }
    
    return strRecordType;
}

+(NSString*)ConvertBoardQueryTypeToString:(board_query_type)eBoardQueryType
{
    NSString *strBoardQueryType = board_query_top;
    
    switch (eBoardQueryType) {
        case board_query_type_top:
            strBoardQueryType = board_query_top;
            break;
        case board_query_type_friend:
            strBoardQueryType = board_query_friend;
            break;
        case board_query_type_user:
            strBoardQueryType = board_query_user_around;
            break;
        default:
            break;
    }
    
    return strBoardQueryType;
}

+(NSString*)ConvertActorTypeToString:(e_actor_type)eActorType
{
    NSString *strActor = actor_amatrur;
    
    switch (eActorType) {
        case e_actor_type_pro:
            strActor = actor_pro;
            break;
        case e_actor_type_mid:
            strActor = actor_mid;
            break;
        case e_actor_type_amateur:
            strActor = actor_amatrur;
            break;
        default:
            break;
    }
    
    return strActor;
}

+(NSString*)ConvertRelatedTypeToString:(e_related_type)eRelatedType
{
    NSString *strRelated = member_friend;
    
    switch (eRelatedType) {
        case e_related_friend:
            strRelated = member_friend;
            break;
        case e_related_attention:
            strRelated = member_attention;
            break;
        case e_related_fans:
            strRelated = member_fans;
            break;
        case e_related_defriend:
            strRelated = member_defriend;
            break;
        case e_related_weibo:
            strRelated = member_weibo;
            break;
        default:
            break;
    }
    
    return strRelated;
}

+(NSString*)ConvertArticleTagTypeToString:(e_article_tag_type)eArticleTagType
{
    NSString *strArticleType = sport_Log;
    
    switch (eArticleTagType) {
        case e_article_log:
            strArticleType = sport_Log;
            break;
        case e_article_theory:
            strArticleType = sport_theory;
            break;
        case e_article_equip:
            strArticleType = equip_blog;
            break;
        case e_article_life:
            strArticleType = sport_life;
            break;
        case e_article_proposal:
            strArticleType = product_proposal;
            break;
        default:
            break;
    }
    
    return strArticleType;
}

#define trade @"TRADE"
#define reward @"REWARD"

+(NSString*)ConvertTradeTypeToString:(e_trade_type)eTradeType
{
    NSString *strTradeType = trade;
    
    switch (eTradeType) {
        case e_trade:
            strTradeType = trade;
            break;
        case e_reward:
            strTradeType = reward;
            break;
        default:
            break;
    }
    
    return strTradeType;
}

+(NSString*)ConvertGameTypeToString:(e_game_type)eGameType
{
    NSString *strGameType = Game_MISHI;
    
    switch (eGameType) {
        case e_game_mishi:
            strGameType = Game_MISHI;
            break;
        case e_game_qixi:
            strGameType = Game_QIXI;
            break;
        case e_game_spiderman:
            strGameType = Game_SPIDERMAN;
            break;
        case e_game_xiongchumo:
            strGameType = Game_XIONGCHUMO;
            break;
        case e_game_znm:
            strGameType = Game_ZNM;
            break;
        default:
            break;
    }
    
    return strGameType;
}

+(NSString*)ConvertAuthTypeToString:(e_auth_type)eAuthType
{
    NSString *strAuthType = Auth_IdCard;
    
    switch (eAuthType) {
        case e_auth_idcard:
            strAuthType = Auth_IdCard;
            break;
        case e_auth_cert:
            strAuthType = Auth_Cert;
            break;
        case e_auth_record:
            strAuthType = Auth_Record;
            break;
        default:
            break;
    }
    
    return strAuthType;
}

+(NSString*)ConvertAuthStatusTypeToString:(e_auth_status_type)eAuthStatusType
{
    NSString *strAuthStatusType = Auth_Unverified;
    
    switch (eAuthStatusType) {
        case e_auth_unverified:
            strAuthStatusType = Auth_Unverified;
            break;
        case e_auth_verifying:
            strAuthStatusType = Auth_Verifying;
            break;
        case e_auth_verified:
            strAuthStatusType = Auth_Verified;
            break;
        case e_auth_refused:
            strAuthStatusType = Auth_Refused;
            break;
        default:
            break;
    }
    
    return strAuthStatusType;
}

+(NSString*)ConvertAcceptTypeToString:(e_accept_type)eAcceptType
{
    NSString *strAcceptType = Accept_Physique;
    
    switch (eAcceptType) {
        case e_accept_physique:
            strAcceptType = Accept_Physique;
            break;
        case e_accept_literature:
            strAcceptType = Accept_Literature;
            break;
        case e_accept_pk:
            strAcceptType = Accept_Pk;
            break;
        default:
            break;
    }
    
    return strAcceptType;
}

@end
