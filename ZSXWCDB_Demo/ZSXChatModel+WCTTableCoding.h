//
//  ZSXChatModel+WCTTableCoding.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ZSXChatModel.h"
#import <WCDB/WCDB.h>

@interface ZSXChatModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(zsx_Id)
WCDB_PROPERTY(message)
WCDB_PROPERTY(chatId)
WCDB_PROPERTY(createDateTime)

@end
