//
//  HtmlElement.c
//  yimediter
//
//  Created by ybz on 2017/12/11.
//  Copyright © 2017年 ybz. All rights reserved.
//

#include "HtmlElement.h"
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

void HtmlElementRelease(struct HtmlElement *elements,int len){
    for (int i = 0; i < len; i++) {
        free(elements[i].attr_json);
        free(elements[i].tag_name);
        free(elements[i].content);
        if (elements[i].sub_elecount) {
            HtmlElementRelease(elements[i].sub_elements, elements[i].sub_elecount);
        }
    }
    free(elements);
}



/**
 解析html 标签内部文字

 @param html html代码字符串
 @param len html长度
 @param index 开始解析的index
 @param isCloseTag 是否闭合标签
 @param tag_name 标签名称
 @param attr_json 标签的属性json格式
 @return 是否成功解析
 */
static bool inTagName(const char* html, long len ,long *index, bool *isCloseTag, char *tag_name,char *attr_json){
    //index处字符不是左尖角，不是标签开头，返回失败
    if (html[*index] != '<') {
        return false;
    }
    //跳过第一个左尖角
    *index = *index + 1;
    //跳过前面的所有空格
    for (; *index < len && html[*index] == ' '; (*index)++)
        ;

    attr_json[0] = '{';
    //属性json指针位置
    long attr_json_index = 1;
    //标签名称json指针位置
    long tag_name_index = 0;
    // 第一个字符为/，表示这是一个 闭合tag
    if (html[*index] == '/') {
        *isCloseTag = true;
        for (int j = 0; *index < len && html[*index] != '>'; (*index)++,j++){
            tag_name[j] = html[*index];
        }
    }else{
        *isCloseTag = false;
        //是否在标签名称中
        bool isInTagName = true;
        //是否在属性名称中
        bool isInAttrName = false;
        //是否在属性值种
        bool isInAttrValue = false;
        
        //表示状态，在标签名称中
        static const int inTagNameStatus = 0;
        //表示状态，在属性名称中
        static const int inAttrNameStatus = 1;
        //表示状态，在属性值中
        static const int inAttrValueStatus = 2;
        
        //上一个状态0 InTagName，1 InAttrName，2 InAttrValue
        char lastStatus = -1;
        
        //解析
        for (; *index < len; (*index)++) {
            if (isInTagName) {
                //遇到第一个空格则表示标签名称结束
                if(html[*index] == ' '){
                    tag_name[tag_name_index] = '\0';                    //添加字符串结束符号
                    lastStatus = inTagNameStatus;                       //标记上一个状态
                    isInTagName = false;                                //结束标签名称
                }else if((html[*index] >= 'a' && html[*index] <= 'z') || (html[*index] >= 'A' && html[*index] <= 'Z')){
                    tag_name[tag_name_index] = html[*index];            //记录标签名称
                    tag_name_index++;
                }else if(html[*index] == '>'){                          //如果碰到左尖角，则直接结束解析
                    tag_name[tag_name_index] = '\0';
                    (*index)++;                                         //因为直接goto，所以这里要加一个index
                    goto gotoreturn;
                }else{
                    return false;                       //全都不是，返回false
                }
            }else if (isInAttrName){                    //在属性名称中
                //属性名称结束
                if (html[*index] == '=') {              //遇到等于符号，表示属性名称结束
                    lastStatus = inAttrNameStatus;      //标记上一个状态
                    isInAttrName = false;               //标记已不在属性名称
                    attr_json[attr_json_index] = '"';   //json添加一个引号，表示结束json键
                    attr_json_index++;                  //json指针+1
                    attr_json[attr_json_index] = ':';   //json添加一个冒号，表示将要开始json值
                    attr_json_index++;                  //json指针+1
                }else{
                    attr_json[attr_json_index] = html[*index];  //记录属性json名称
                    attr_json_index++;
                }
            }else if (isInAttrValue){                           //在属性值中
                if(html[*index] == '"'){                        //遇到引号表示结束属性值
                    attr_json[attr_json_index] = '"';           //json添加一个引号，表示结束json值
                    attr_json_index++;                          //json指针+1
                    lastStatus = inAttrValueStatus;             //标记上一个状态
                    isInAttrValue = false;                      //标记已结束属性值
                }else{
                    attr_json[attr_json_index] = html[*index];  //记录属性值
                    attr_json_index++;
                }
            }else{                                              //当所有状态都不是，则表示在标签中，但不在标签名中也不在属性中
                if (html[*index] == ' ') {                      //跳过空格
                    continue;
                }
                if (html[*index] == '/') {                      //如果遇到斜杠，表示自闭合标签，，，暂时不处理这种情况，我们的html不会出现自闭合标签
                    return false;
                }
                if (html[*index] == '>') {                      //如果遇到右尖角，表示闭合，结束解析
                    (*index)++;
                    goto gotoreturn;
                }
                
                
                if(html[*index] == '"' && lastStatus == inAttrNameStatus){  //如果遇到引号并且上一个状态是属性名称，则表示开始属性值
                    isInAttrValue = true;
                    attr_json[attr_json_index] = '"';
                    attr_json_index++;
                }else if(lastStatus == inTagNameStatus || lastStatus == inAttrValueStatus){ //如果上一个状态是tagName或者是属性值，则开始属性名称
                    isInAttrName = true;
                    if (attr_json_index > 1) {              //如果不是json的第一个属性key，添加一个逗号
                        attr_json[attr_json_index] = ',';
                        attr_json_index++;
                    }
                    attr_json[attr_json_index] = '"';
                    attr_json_index++;
                    attr_json[attr_json_index] = html[*index];
                    attr_json_index++;
                }
                
            }
        }
    }
    
gotoreturn:
    attr_json[attr_json_index] = '}';
    attr_json[attr_json_index+1] = '\0';
    return true;
}


/**
 解析html

 @param html html代码
 @param index 从这个index开始解析
 @param element_count 解析出来的HtmlElement数量
 @param content 解析出来的内容，必须有足够的长度
 @return HtmlElement数组
 */
struct HtmlElement * analy_html(const char *html,long *index, unsigned int *element_count, char *content){
    //初始10个元素
    unsigned int element_len = 10;
    //申请element数组内存
    struct HtmlElement *element_list = malloc(element_len * sizeof(struct HtmlElement));
    //element指针
    struct HtmlElement *element_pointer = element_list;
    //html长度
    unsigned long len = strlen(html);
    //是否在标签中
    bool isInTagName = false;
    //当前所在的标签
    char *current_tag = NULL;
    unsigned long i = 0;
    for (; *index < len; (*index)++) {
        if (isInTagName) {
            //开辟标签名内存
            char *tag_name = malloc(len);
            //开辟属性json内存
            char *attr_json = malloc(len);
            //tag解析完之后的html index
            long tag_index = *index;
            //是否闭合标签
            bool is_close = false;
            //解析标签
            bool tag_result = inTagName(html, len, &tag_index, &is_close, tag_name, attr_json);
            if (tag_result) {
                //如果是闭合标签，但是无法找到当前的标签，不推进index指针位置，直接跳出循环，这里可以在递归的时候交给上一次解析
                if (is_close && current_tag == NULL) {
                    break;
                }
                //index推到tag解析完之后到位置
                *index = tag_index;
                //标记不在标签中
                isInTagName = false;
                //如果是闭合标签，表示解析完一个标签，当前element指针往前推1，继续记录下一个element
                if (is_close) {
                    element_pointer++;
                    long count = element_pointer - element_list;
                    //如果开辟的指针内存不过，重新拓展内存
                    if (count >= element_len) {
                        element_len*=2;
                        element_list = realloc(element_list, element_len * sizeof(struct HtmlElement));
                        element_pointer = element_list + count;
                    }
                    current_tag = NULL;             //标记当前标签为NULL
                    free(tag_name);                 //闭合标签不需要保存标签名称，释放标签名称
                    free(attr_json);                //闭合标签不需要保存属性json，释放
                }else{
                    char *cnt = malloc(len);        //开辟保存内容的空间
                    tag_name = realloc(tag_name, strlen(tag_name)+1);       //释放多余的标签名称内存
                    attr_json = realloc(attr_json, strlen(attr_json)+1);    //释放多余的属性列表内存
                    current_tag = tag_name;                                 //记录当前标签名称
                    
                    unsigned int sub_count = 0;                             //准备递归解析的元素数量
                    long sub_index = *index;                                //准备递归解析的index
                    //递归。。。
                    struct HtmlElement *sub_elements = analy_html(html, &sub_index, &sub_count, cnt);
                    //因为递归的循环最后会将index+1，这里减掉一个index
                    *index = sub_index - 1;
                    
                    cnt = realloc(cnt, strlen(cnt)+1);                      //重新分配内容内存
                    
                    element_pointer->attr_json = attr_json;                 //保存element
                    element_pointer->tag_name = tag_name;
                    element_pointer->content = cnt;
                    element_pointer->sub_elecount = sub_count;
                    element_pointer->sub_elements = sub_elements;
                }
            }else{
                printf("解析失败啦");
            }
        }else{
            //碰到左尖角，表示即将进入子标签
            if (html[*index] == '<') {
                isInTagName = true;
                *index = *index - 1;
            }else{
                content[i] = html[*index];
                i++;
            }
        }
    }
    content[i] = '\0';
    *element_count = (int)(element_pointer - element_list);
    return element_list;
}
