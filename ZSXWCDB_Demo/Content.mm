//
//  Content.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/4.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "Content.h"

@implementation Content

WCDB_IMPLEMENTATION(Content)
WCDB_SYNTHESIZE(Content, text)

+ (instancetype)unarchiveWithWCTValue:(Content *)value {
    Content *obj = [[Content alloc]init];
    obj.text = @"text";
    return obj;
}
- (id)archivedWCTValue {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    return @"{\"id\":\"19\", \"name\":\"Lida\"}";
}
+ (WCTColumnType)columnTypeForWCDB {
    return WCTColumnTypeString;
}

@end
