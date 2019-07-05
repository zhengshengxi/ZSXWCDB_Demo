//
//  ZSXChatModel.mm
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ZSXChatModel+WCTTableCoding.h"
#import "ZSXChatModel.h"
#import <WCDB/WCDB.h>

@implementation ZSXChatModel

WCDB_IMPLEMENTATION(ZSXChatModel)
WCDB_SYNTHESIZE(ZSXChatModel, zsx_Id)
WCDB_SYNTHESIZE(ZSXChatModel, message)
WCDB_SYNTHESIZE(ZSXChatModel, chatId)
WCDB_SYNTHESIZE(ZSXChatModel, createDateTime)

WCDB_PRIMARY_ASC_AUTO_INCREMENT(ZSXChatModel, zsx_Id)
WCDB_INDEX(ZSXChatModel, "_index", createDateTime)

-(instancetype)init {
    if (self == [super init]) {
        self.isAutoIncrement = YES;
    }
    return self;
}
  
@end
