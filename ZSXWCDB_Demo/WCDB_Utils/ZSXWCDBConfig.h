//
//  ZSXWCDBConfig.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/8.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#ifndef ZSXWCDBConfig_h
#define ZSXWCDBConfig_h

#define zsx_changeBlock void(^_Nullable)(zsx_changeState result)
typedef NS_ENUM(NSInteger,zsx_changeState) {//数据改变状态
    zsx_insert,//插入
    zsx_update,//更新
    zsx_delete,//删除
    zsx_drop//删表
};

#endif /* ZSXWCDBConfig_h */
