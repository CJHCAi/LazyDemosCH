//
//  CommonFunction.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

enum  {
    RSA_ERROR_NONE,
    RSA_ERROR_NETWORK_CANT_CONNECT_HOST,
    RSA_ERROR_NETWORK_TIME_OUT,
    RSA_ERROR_NETWORK_ERROR,
    RSA_ERROR_NETWORK_UNKOWN,
    RSA_ERROR_JSON_PARSE_ERROR,
    RSA_ERROR_AUTH_ERROR = 1001,
    RSA_ERROR_USERID_EXIST = 1002,
    RSA_ERROR_ACCESS_TOKEN_ERROR = 1003,
    RSA_ERROR_DATABASE_ERROR = 1004,
    RSA_ERROR_CHAT_SERVICE_ERROR = 1005,
    RSA_ERROR_INVALID_JSON_DATA = 1006,
    RSA_ERROR_USER_NOT_FOUND = 1007,
    RSA_ERROR_PASSWORD_WRONG = 1008,
    RSA_ERROR_INVAILD_FILE = 1009,
    RSA_ERROR_HTTP_ERROR = 1010,
    RSA_ERROR_FILE_NOT_FOUND = 1011,
    RSA_ERROR_SEND_MAIL_ERROR = 1012,
    RSA_ERROR_INVALID_CAR_ID = 1013,
    RSA_ERROR_INVALID_ADDRESS_ERROR = 1014,
    RSA_ERROR_INVALID_MESSAGE_ERROR = 1015,
    RSA_ERROR_INVALID_DEVICE_TOKEN_ERR = 1016,
    RSA_ERROR_REVIEW_NOT_FOUND_ERR = 1017,
    RSA_ERROR_INVAILD_INVITE_CODE = 1018,
};

typedef enum {
    login_type_email,
    login_type_phone,
    login_type_weibo,
    login_type_nickname
}account_login_type;

typedef enum {
    article_type_text,
    article_type_image
}article_seg_type;

typedef enum {
    chat_send_text,
    chat_send_voice,
    chat_send_image,
    chat_send_video,
}chat_send_type;

typedef enum {
    event_type_chat,
    event_type_groupchat,
    event_type_subscribe,
    event_type_thumb,
    event_type_at,
    event_type_record,
    event_type_coach_comment,
    event_type_coach_pass_comment,
    event_type_coach_npass_comment,
    event_type_comment,
    event_type_tx,
    event_type_reward,
    event_type_send_heart,
    event_type_receive_heart,
    event_type_run_share,
    event_type_run_shared,
    event_type_post_share,
    event_type_post_shared,
    event_type_pk_share,
    event_type_pk_shared,
    event_type_info,
}event_type;

typedef enum {
    article_type_all,
    article_type_comments,
    article_type_articles,
}article_type;

typedef enum {
    record_type_run,
    record_type_ride,
    record_type_swimming,
}record_type;

typedef enum {
    board_query_type_top,
    board_query_type_friend,
    board_query_type_user,
}board_query_type;

typedef enum {
    e_actor_type_pro,
    e_actor_type_mid,
    e_actor_type_amateur,
}e_actor_type;

typedef enum {
    e_related_friend,
    e_related_attention,
    e_related_fans,
    e_related_defriend,
    e_related_weibo,
}e_related_type;

typedef enum {
    e_task_physique,
    e_task_literature,
    e_task_magic,
}e_task_type;

typedef enum {
    e_task_normal,
    e_task_finish,
    e_task_unfinish,
    e_task_authentication,
}e_task_status;

typedef enum {
    e_article_log,
    e_article_theory,
    e_article_equip,
    e_article_life,
    e_article_proposal,
}e_article_tag_type;

typedef enum {
    e_sex_male,
    e_sex_female,
}e_sex_tag_type;

typedef enum {
    e_trade,
    e_reward,
}e_trade_type;

typedef enum {
    e_game_mishi,
    e_game_qixi,
    e_game_spiderman,
    e_game_xiongchumo,
    e_game_znm,
}e_game_type;

typedef enum {
    e_auth_idcard,
    e_auth_cert,
    e_auth_record
}e_auth_type;

typedef enum {
    e_auth_unverified,
    e_auth_verifying,
    e_auth_verified,
    e_auth_refused
}e_auth_status_type;

typedef enum {
    e_accept_physique,
    e_accept_literature,
    e_accept_pk
}e_accept_type;

@interface CommonFunction : NSObject

+(NSString*)ConvertLoginTypeToString:(account_login_type) eLoginType;
+(account_login_type)ConvertStringToLoginType:(NSString*) strLoginType;
+(article_seg_type)ConvertStringToArticleType:(NSString*) strArticleType;
+(chat_send_type)ConvertStringToChatSendType:(NSString*) strSendType;
+(e_task_type)ConvertStringToTaskType:(NSString*) strTaskType;
+(e_task_status)ConvertStringToTaskStatusType:(NSString*) strTaskStatusType;
+(e_sex_tag_type)ConvertStringToSexType:(NSString*) strSexType;
+(e_auth_type)ConvertStringToAuthType:(NSString*) strAuthType;
+(e_auth_status_type)ConvertStringToAuthStatusType:(NSString*) strAuthStatusType;
+(NSString*)ConvertSendTypeToString:(chat_send_type) eSendType;
+(NSString*)ConvertEventTypeToString:(event_type) eEventType;
+(NSString*)ConvertArticleTypeToString:(article_type) eArticleType;
+(NSString*)ConvertRecordTypeToString:(record_type)eRecordType;
+(NSString*)ConvertBoardQueryTypeToString:(board_query_type)eBoardQueryType;
+(NSString*)ConvertActorTypeToString:(e_actor_type)eActorType;
+(NSString*)ConvertRelatedTypeToString:(e_related_type)eRelatedType;
+(NSString*)ConvertArticleTagTypeToString:(e_article_tag_type)eArticleTagType;
+(NSString*)ConvertTradeTypeToString:(e_trade_type)eTradeType;
+(NSString*)ConvertGameTypeToString:(e_game_type)eGameType;
+(NSString*)ConvertAuthTypeToString:(e_auth_type)eAuthType;
+(NSString*)ConvertAuthStatusTypeToString:(e_auth_status_type)eAuthStatusType;
+(NSString*)ConvertAcceptTypeToString:(e_accept_type)eAcceptType;

@end
