|version|description| modify by|
|-------|-----------|
|0.1|create|zhengying|
|0.2|1. 删除重复的API <br> 2.chatMessage 对象新增属性is_read <br> 3.新增清除未读API ``` 1/chat/change_status_read``` |zhengying|
|0.3|1. API contact_list 改名为 recent_chat_infos <br>  2.``` 1/chat/recent_chat_infos``` 中新增new_message_count 字段 <br> 3. 修改了一些 accesstoken 的必要性|zhengying|
|0.4|1. ``` 1/user/articles ```  中 response 参数 articles 改名 articles_without_content <br> 2.  所有包含 user_id 改名为 userid <br> 3.  ``` 1/chat/send_message``` message_id 由 int 改为 string |zhengying|
|0.5| page 请求方式变更，所有的page_number 方式变为 page_frist_id/page_last_id |zhengying|
|0.6| 1. 删除 event unread/  chat unread API, 由服务器来处理 <br> 2. ``` 1/user/articles ``` 新增 userid, article_type <br> 3. API中出现is_unread 字段全部删除，由服务器处理|zhengying|
|0.7|1. 新增 API``` 1/event/news_details``` <br> 2. 新增 API ``` 1/event/change_status_read``` <br> 3. [Article object](#articleobj) 新增两个字段 new_thumb_count new_sub_articles |zhengying|
|0.8|所有需要翻页的回复都加上 page_frist_id page_last_id |zhengying|
|0.9| 1. ``` 1/chat/recent_chat_infos ``` 增加 nikename字段 <br>2.增加推送相关API ``` 1/user/send_device_token ``` ``` 1/user/is_push_enabled ``` ``` 1/user/set_push_enable ```|zhengying|
|0.10| 1. 新增 ``` 1/record/new ``` <BR> 2. 新增 ``` 1/record/timeline ``` <BR> 3. 新增 ``` 1/leaderboard/top ``` <BR> 4. 新增 ``` 1/user/setInfo ``` <BR> 5. ``` 1/user/getInfo ``` 添加字段  rankscore rankLevel rankName |zhengying|
|0.11|新增 ```1/record/statistics```|zhengying
|0.12|新增 ```1/record/statistics``` 增加两个字段 top_index leaderboard_max_items |zhengying
|0.13|所有动作字段返回值中都加上exp_effect |zhengying

# 运动社区 API


## 规则：
> API 主要形式是有一个URL做为命令，分为POST，和GET， response 参数都用JSON对象返回
> 
> 注意事项：  
> 1. 返回结果必须是object对象。
> 2. 在参数中大部分都需要一个access_token字符串，这个字符串是由服务器登陆后返回给客户端的，后续API的调用都是靠这个token去认证的。  
> 3. 所有的结果中都必须有一个error对象,格式是 {"error": {"error_id": 1001, "error_msg": "authentication_err"}}    
> 4. 所有API response中都包含访问URL字段req_path   
> 5. API URL中以版本号开始 eg: "1/account/register" 中 1就是API的版本表示版本1

### 基本信息注册  
---
**URL**:  

``` 1/account/register ```

**HTTP请求方式:**   
```POST```


**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- |---
 | email| Y | string|
 | password| Y | string|
 | nikename| Y | string

 **response**:
 
 | key | type | Comments
 | ------------ | ------------- | ---
 | error | dict|
 | access_token | string|
 
 **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | error.username.exist |
 
### *登陆*
---

**MessageID**:  

``` 1/account/login ```

**HTTP请求方式:**   
```POST```

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | userid| Y | string|
 | verfiycode| Y | string| password or weibo accesscode
 | account_type| Y | string| weibo/usrpass/weixin
 
  **Response:**
 
 | key | type | Comments
 | ------------ | ------------- | ---
 | error | dict|
 | access_token | string|
 | exp_effect   | int | 经验值变化
 | register   | BOOL | 注册
 
 
### *注销登陆*
---
**MessageID**:  

``` 1/user/logout ```  

**HTTP请求方式:**   
```POST``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 
   **Response:**
   
 | key | type | Comments
 | ------------ | ------------- | ---
 | error | dict|
 
 **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | error.logout.faied |
 
 
### 查询个人信息  
---
**MessageID**:  

``` 1/user/getInfo ```  

**HTTP请求方式:**   
```GET``` 

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| userid| Y | string|

 **response**:
 
| key |  type | Comments
| ------------ | ------------- | ---
| nikename| string|
| phone_number| string|
| account_type| string|weibo/usr_pass
| about | string|
| profile_image| string|
| register_time  | DateTime string |注册时间
| hobby | string|
| height | int|
| weight | int|
| birthday | int |
| actor | PRO/MID/AMATEUR
| rankscore | int
| rankLevel | 1~40
| rankName | 初级/中级/高级/至尊

### 查询个人信息  
---
**MessageID**:  

``` 1/user/setInfo ```  

**HTTP请求方式:**   
```POST``` 

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| Y | string|
| nikename| N| string|
| phone_number| N| string|
| about | N| string|
| hobby | N| string|
| height | N| string|
| weight | N| string|
| birthday | N| DateTime string |
| actor | N| PRO/MID/AMATEUR

 **response**:
 
| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| exp_effect   | int | 经验值变化



### 修改个人图片
---

``` 1/user/set_profile_image```

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | image_id| Y | string|
 
 
 **HTTP请求方式:**   
```POST``` 

 **Response:**
   
| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| exp_effect   | int | 经验值变化
 
 **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |

 
### *获取的帖子*
 **MessageID**:  

``` 1/user/articles ```   

 **HTTP请求方式:**   
```GET``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string| 
 | userid | Y| string |
 | article_type | Y| string | ALL/COMMENTS/ARTICLES
 | page_frist_id| N | string |
 | page_last_id| N | string |
 | page_item_count| N | int |


 **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | articles_without_content   | array | [Article object](#articleobj)
 | page_frist_id| N | string |
 | page_last_id| N | string |


  **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |


 
### 设置推送ID  
---
**MessageID**:  

``` 1/user/send_device_token ```


 **HTTP请求方式:**   
```POST``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- |---
 |  access_token| Y  |  string|
 |  device_token| Y  |  string|
 
### 设置推送开关
---
**MessageID**:  

``` 1/user/set_push_enable ```

 **HTTP请求方式:**   
```POST``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- |---
 |  access_token| Y  |  string|
 |  device_token| Y  |  string|
 |  is_enabled| Y  |  bool|
 
 
### 查询推送开关  
---
**MessageID**:  

``` 1/user/is_push_enabled ```

 **HTTP请求方式:**   
```GET``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- |---
 |  access_token| Y  |  string|
 |  device_token| Y  |  string|
 
  **Response:**
  
 | key  | type | Comments 
 | ------------ | ------------- | ---
 | is_enabled | bool |
 
### *写帖子*
**MessageID**:  

``` 1/article/new ```  

 **HTTP请求方式:**   
```POST```  

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| Y | string|
| parent_article_id| Y | string|
| article_segments |  [Array(ArticleSegmentObject)](#article_contents_obj)|ArtcleSegment Array

 **Response:**
 
  <a name="articleobj">** Article object: **</a>

 | key  | Mandatory |type | Comments 
 | ------------ | -|------------- | ---
 | parent_article_id| N| string | 当 parent_article_id不为空时这个帖子就评论
 | article_id| Y| string | |
 | author  | Y|  string| 作者ID
 | time | Y|  dateTime|  
 | thumb_count | Y|  int|  赞的次数
 | sub_article_count | Y|  int|  评论的次数
 | new_thumb_count | Y|  int|  新的赞的次数
 | new_sub_article_count | Y|  int|  新的评论的次数
 | cover_image | N | string | 展示在外面的图片，默认取第一张图片
 | cover_text | N | string | 展示在外面的文字，默认取第一张段文字
 | article_segments | Y|  [Array(ArticleSegmentObject)](#article_contents_obj)|ArtcleSegment Array
 
 
 文章的内容对象
<a name ="article_contents_obj">ArticleSegmentObject</a>

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
|seg_type| N| string (IMAGE, TEXT)| 段类型 
|seg_content| N| string(contentText, thumbnail imageURL)| 段内容



### *删帖子，或评论*
**MessageID**:  

``` 1/article/delete ```   

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| Y | string|
| article_id| Y | string|

 **Response:**
 
 **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |    
 
 

### *对文章进行赞／取消赞*
**MessageID**:  

``` 1/aritcle/thumb ```   

 **HTTP请求方式:**   
```POST``` 

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| Y | string|
| article_id| Y | string|
| thumb_status| Y | bool|


 **Response:**
   
 common response
  **Response:**
   
| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| exp_effect   | int | 经验值变化

  **error**:
  
 | error_code| Comments
 | --------| ----------------------
 | TODO: |    
 
 
### *检查是否对某文章进行了赞*
**MessageID**:  

``` 1/aritcle/is_thumbed ```   

 **HTTP请求方式:**   
```GET``` 

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| Y | string|
| article_id| Y | string|

 **Response:**
   
| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| is_thumbed| Y | bool|

  **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |  
 
### *获取文章列表*
**MessageID**:  

``` 1/article/timelines ```  

 **HTTP请求方式:**   
```GET``` 

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| N | string|
| page_frist_id| N | string |
| page_last_id| N | string |
| page_item_count| N | int |

 **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | articles_without_content| array | [Array(ArticleObject)](#articleobj)
 | page_frist_id| N | string |
 | page_last_id| N | string |
 
### *获取某篇文章*
**MessageID**:  

``` 1/article/get ```  

 **HTTP请求方式:**   
```GET``` 

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| access_token| N | string|
| article_id | M | string | 


 **Response:**
 
[ArticleObject](#articleobj)
 
 
### 读取article下的评论
---

``` 1/article/comments```

**HTTP请求方式:**   
```POST``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | article_id| Y | string|
 | page_frist_id| N | string |
 | page_last_id| N | string |
 | page_item_count| N | int |
 
  **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | articles_without_content   | array | [Article object](#articleobj)
 | exp_effect   | int | 经验值变化
 | page_frist_id| N | string |
 | page_last_id| N | string |
 


  **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |
 

### *写运动记录*
**MessageID**:  

``` 1/record/new ```  

 **HTTP请求方式:**   
```POST```  

**Parameter**:

| key | Mandatory | type | Comments
| ------------ | ------------- | ---
| record_item  | [sportRecord](#sportRecord) |


  **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | leaderboard_effect   | int | 排行榜的变化，负数表示下降
 | self_record_effect   | int | 在自己记录中的变化，负数表示下降 
 | exp_effect   | int | 经验值变化


### *成绩列表*
**MessageID**:  

``` 1/record/timeline ```  
 
 **HTTP请求方式:**   
```GET```  

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | usrid| Y | string|
 | page_frist_id| N | string |
 | page_last_id| N | string |
 | page_item_count| N | int |
 
**Response:**

| key  | type | Comments 
| ------------ | ------------- | ---
| record_list  | array [sportRecord](#sportRecord) |
| page_frist_id| N | string |
| page_last_id| N | string |


 <a name="sportRecord">** sportRecord: **</a>

 | key  | Mandatory |type | Comments 
 | ------------ | -|------------- | ---
 | type| Y | string|run/ride/swimming
 | action_time| Y | datetime string|
 | duration| Y | int| 精确到秒
 | distance| Y | int| 单位 米




### *成绩列表*
**MessageID**:  

``` 1/record/statistics ```  
 
 **HTTP请求方式:**   
 ```GET```  

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | usrid| Y | string|
 
 **Response:**

| key  | type | Comments 
| ------------ | ------------- | ---
| total_records_count  | int | 
| total_distance  | int | 单位 米
| total_duration  | int |单位 秒
| max_distance_record  | [sportRecord](#sportRecord) |
| max_speed_record  | [sportRecord](#sportRecord) |
| actor | string |PRO/MID/AMATEUR
| rankscore | int |
| rankLevel | int |1~40
| rankName | string|初级/中级/高级/至尊
| top_index | int
| leaderboard_max_items | int

 
### *排行榜排名*
**MessageID**:  

``` 1/leaderboard/list ```  
 
 **HTTP请求方式:**   
```GET```  


**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | query_type| Y | string| TOP/USER_AROUND
 | query_info| Y | string| TOP 为空，  USER_AROUND 对应 userid
 | page_frist_id| N | string |
 | page_last_id| N | string |
 | page_item_count| N | int |

**Response:**

| key  | type | Comments 
| ------------ | ------------- | ---
|  Leaderboard_list  | array [leaderboardItem](#leaderboardItem) |
|  page_frist_id| N | string |
|  page_last_id| N | string |


 <a name="contactInfoObj">** leaderboardItem: **</a>

 | key  | Mandatory |type | Comments 
 | ------------ | -|------------- | ---
 | userid | Y| string | 
 | nikename | Y| string |
 | user_profile_image | Y| string |
 | index | Y| int |
 | score| Y | string

 
###查询新时间条数
---

``` 1/event/news```

**HTTP请求方式:**   
```GET``` 

**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
   
 **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | new_chat_count |int |
 | new_comment_count |int |
 | new_thumb_count |int | 

  **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |   
 
 
 
###查询新时间条数
---

``` 1/event/news_details```

**HTTP请求方式:**   
```GET``` 
 
**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 
  **Response:**

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | chat_news | N |  [contactInfo](#contactInfoObj)| array |
 | article_news | N |[Article object](#articleobj)    array |

  **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |  
 
 
###查询新时间条数
 
 ``` 1/event/change_status_read```
 
**HTTP请求方式:**   
```POST``` 
 
**Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | type| Y | string|  chat/article/thumb
 | id| Y | string|   userid/articleid/articleid
 
  **Response:**
  common response

  **error**:
 
 | error_code| Comments
 | --------| ----------------------
 | TODO: |  
 
### 聊天 发送消息
---

 ``` 1/chat/send_message```

**HTTP请求方式:**   
```POST``` 

 **Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | to_id| Y | string|
 | type| Y | string| "text"/ "voice" / "image" / "video"
 | content| Y | string| text / URLs
    
 **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | message_id |string |
 
 
### 聊天聊天记录
 ---
 ``` 1/chat/recent_chat_infos```

**HTTP请求方式:**   
```Get``` 

 **Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
    
 **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | contact_infos | [array(contactInfo)](#contactInfoObj) |
 
 
 <a name="contactInfoObj">** contactInfo object: **</a>

 | key  | Mandatory |type | Comments z
 | ------------ | -|------------- | ---
 | userid | Y| string |
 | nikename | Y| string |
 | user_profile_image | Y| string |
 | new_message_count | Y| int |
 | last_message| Y | [chatMessage](#chatMessageObj)

 
### 获取某个人聊天详细列表
 ---
 ``` 1/chat/get_list```

**HTTP请求方式:**   
```Get``` 

 **Parameter**:

 | key | Mandatory | type | Comments
 | ------------ | ------------- | ---
 | access_token| Y | string|
 | userid | N| string | from 
 | page_frist_id| N | string |
 | page_last_id| N | string |
 | page_item_count| N | int |
 
 
 <a name="chatMessageObj">** chatMessage object: **</a>
 
 
  **Response:**

 | key  | type | Comments 
 | ------------ | ------------- | ---
 | messages | [array(chatMessageObj)](#chatMessageObj) |
 | page_frist_id| N | string |
 | page_last_id| N | string |
 
 
 <a name="chatMessageObj">** chatMessage object: **</a>
 
 | key  | Mandatory |type | Comments 
 | ------------ | -|------------- | ---
 | message_id| Y | string|
 | from_id| Y | string|
 | to_id| Y | string|
 | type| Y | string| "text"/ "voice" / "image" / "video"
 | content| Y | string| text / URLs
 | time| Y | dataTime| 
 
  
### 文件上传
---
**MessageID:** 

``` 1/file/upload```    

**注意** ：(下面的key是各个formdata 字段的key)  

**Parameter:**

 | key | Mandatory | type | Comments 
 | ------------ | ------------- | ---
 |  access_token| Y  |  string|
 |  filedata| Y  |  BYTE|
 
**Response:**
 
 | key  | type | Comments 
 | ------------ | ------------- | ---
 | fileid  |  string|
 | fileurl |  string|

