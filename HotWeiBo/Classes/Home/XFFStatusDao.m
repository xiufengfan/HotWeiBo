//
//  XFFStatusDao.m
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

// 微博缓存存储路径
#define XFFStatusesSqlitePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"]

#import "XFFStatusDao.h"
#import "FMDB.h"
#import "XFFAccountDao.h"
#import "XFFAccount.h"
#import "XFFStatusRequest.h"
#import "XFFStatus.h"
#import "MJExtension.h"
@implementation XFFStatusDao
static FMDatabase *_database;
+ (void)initialize
{
    _database = [FMDatabase databaseWithPath:XFFStatusesSqlitePath];
    if ([_database open]) {
        NSLog(@"打开数据库成功！");
        NSLog(@"%@",XFFStatusesSqlitePath);
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_status  (id INTEGER PRIMARY KEY AUTOINCREMENT, idstr TEXT NOT NULL, dict BLOB NOT NULL, access_token TEXT NOT NULL);";;
        if([_database executeUpdate:sql]){
            NSLog(@"创建表成功！");
        }
    }
}

+(BOOL)saveStatuses:(NSDictionary*)dict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:NULL];
    
    NSString *access_token = [XFFAccountDao account].access_token;
    
    NSString *idstr = dict[@"idstr"];
    
    BOOL success = [_database executeUpdate:@"INSERT INTO t_status (idstr, dict, access_token) VALUES (?, ?, ?);",idstr,data,access_token];
    if (success) {
        NSLog(@"保存数据成功！");
    }
    return YES;
}

+(NSArray*)getStatusWithRequest:(XFFStatusRequest*)request
{
    NSMutableArray *statuses = [NSMutableArray array];
    
    FMResultSet *set = nil;
    if (request.since_id) {
        set = [_database executeQuery:@"SELECT * FROM t_status WHERE idstr > ? AND access_token = ? ORDER BY idstr DESC LIMIT ?",request.since_id,request.access_token,request.count];
    }else if (request.max_id){
        set = [_database executeQuery:@"SELECT * FROM t_status WHERE idstr <= ? AND access_token = ? ORDER BY idstr DESC LIMIT ?",request.max_id,request.access_token,request.count];
    }else{
        set = [_database executeQuery:@"SELECT * FROM t_status WHERE access_token = ? ORDER BY idstr DESC LIMIT ?",request.access_token,request.count];
    }
    
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:NULL];
//        NSString *access_token = [set stringForColumn:@"access_token"];
//        NSString *idstr = [set stringForColumn:@"idstr"];
        XFFStatus *status = [XFFStatus mj_objectWithKeyValues:dict];
        
        [statuses addObject:status];
    }
    
    return statuses;
}
@end
