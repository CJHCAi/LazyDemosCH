//
//  HtmlElement.h
//  yimediter
//
//  Created by ybz on 2017/12/11.
//  Copyright © 2017年 ybz. All rights reserved.
//

#ifndef HtmlElement_h
#define HtmlElement_h

#include <stdio.h>

struct HtmlElement{
    //html标签名称
    char* tag_name;
    //属性的json格式
    char* attr_json;
    //内容
    char* content;
    //子元素数量
    unsigned int sub_elecount;
    //子元素
    struct HtmlElement *sub_elements;
};
void HtmlElementRelease(struct HtmlElement *elements,int len);
struct HtmlElement * analy_html(const char *html,long *index, unsigned int *element_count, char *content);

#endif /* HtmlElement_h */
