//
//  ZSXMessageModel.mm
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ZSXMessageModel+WCTTableCoding.h"
#import "ZSXMessageModel.h"
#import <WCDB/WCDB.h>

@implementation ZSXMessageModel

WCDB_IMPLEMENTATION(ZSXMessageModel)
WCDB_SYNTHESIZE(ZSXMessageModel, property1)
WCDB_SYNTHESIZE(ZSXMessageModel, property2)
WCDB_SYNTHESIZE(ZSXMessageModel, property3)
WCDB_SYNTHESIZE(ZSXMessageModel, property4)
//WCDB_SYNTHESIZE_COLUMN(ZSXMessageModel, <#property5#>, "<#column name#>") // Custom column name
//WCDB_SYNTHESIZE_DEFAULT(ZSXMessageModel, <#property6#>, <#default value#>) // Default to WCTDefaultTypeCurrentTime, WCTDefaultTypeCurrentDate, WCTDefaultTypeCurrentTimestamp or your custom literal value

WCDB_PRIMARY_ASC_AUTO_INCREMENT(ZSXMessageModel, property2)
WCDB_UNIQUE(ZSXMessageModel, property3)
WCDB_NOT_NULL(ZSXMessageModel, property4)

+(BOOL)createTable {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@",docDir,@"wcdb.db"];
    NSLog(@"WCDB Path: %@",path);
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:path];
    BOOL result = [database createTableAndIndexesOfName:NSStringFromClass([self class]) withClass:self];
    return result;
}
  
@end
