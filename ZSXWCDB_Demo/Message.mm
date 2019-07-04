//
//  Message.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/3.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "Message.h"

@implementation Message

WCDB_IMPLEMENTATION(Message)
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)
WCDB_SYNTHESIZE(Message, unused)
//WCDB_SYNTHESIZE(Message, content)



//WCDB_PRIMARY(Message, localID)
WCDB_PRIMARY_AUTO_INCREMENT(Message, localID)
WCDB_INDEX(Message, "_index", createTime)

@end
