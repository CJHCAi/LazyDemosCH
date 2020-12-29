//
//  TypeDefine.h
//  WDGSqliteTool
//
//  Created by Wdgfnhui on 16/2/26.
//  Copyright © 2016年 Wdgfnhui. All rights reserved.
//
//宏定义头文件

#ifndef WDGTypeDefine_h
#define WDGTypeDefine_h

#define STMT sqlite3_stmt
#define STEP sqlite3_step


#define OK SQLITE_OK
#define DONE SQLITE_DONE
#define ROW SQLITE_ROW

#define ERRORTYPE -1
#define STRINGTYPE 0
#define VARCHARTYPE 0
#define INT32TYPE 1
#define INT64TYPE 2
#define FLOATTYPE 3
#define DOUBLETYPE 3
#define DATETYPE 4
#define TIMETYPE 5
#endif /* WDGTypeDefine_h */
