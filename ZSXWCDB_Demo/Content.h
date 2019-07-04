//
//  Content.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/4.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface Content : NSObject<WCTColumnCoding>

@property (nonatomic,copy) NSString *text;

WCDB_PROPERTY(text)

@end

NS_ASSUME_NONNULL_END
