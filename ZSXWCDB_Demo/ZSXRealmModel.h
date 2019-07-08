//
//  ZSXRealmModel.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/8.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSXRealmModel : RLMObject

@property(nonatomic, retain) NSString *message;
@property(nonatomic, assign) NSInteger chatId;
@property(nonatomic, strong) NSDate *createDateTime;

@end

NS_ASSUME_NONNULL_END
