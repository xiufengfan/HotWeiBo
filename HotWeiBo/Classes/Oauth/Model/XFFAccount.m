//
//  XFFAccount.m
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFAccount.h"

@implementation XFFAccount
+(instancetype)accountWithDictionary:(NSDictionary *)dict
{
    XFFAccount *account = [[self alloc]init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    
    return account;
}
// 将对象写入文件的时候调用
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.expires_time forKey:@"expires_time"];
    [encoder encodeObject:self.uid forKey:@"uid"];

}
// 从文件中解析对象的时候调用
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_time"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}
@end
