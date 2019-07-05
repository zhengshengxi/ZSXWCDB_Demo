//
//  ZSXMessageModel+WCTTableCoding.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ZSXMessageModel.h"
#import <WCDB/WCDB.h>

@interface ZSXMessageModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(property1)
WCDB_PROPERTY(property2)
WCDB_PROPERTY(property3)
WCDB_PROPERTY(property4)
WCDB_PROPERTY(dateTime)

@end
