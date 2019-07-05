//
//  ZSXChatModel.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSXBaseWCDBModel.h"
#import "NSObject+ZSXWCDBBaseHandle.h"

@interface ZSXChatModel : ZSXBaseWCDBModel

@property(nonatomic, retain) NSString *message;
@property(nonatomic, assign) NSInteger chatId;
@property(nonatomic, strong) NSDate *createDateTime;

@end
