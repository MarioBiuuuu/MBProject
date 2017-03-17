//
//  LKDBQueue.h
//  LKDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@class LKDB;

@interface LKDBQueue : NSObject

/**
 *	@brief	数据库路径，不存在自动创建
 */
+ (instancetype)dbWithPath:(NSString *)path;

/**
 *	@brief	默认数据库路径
 */
+ (instancetype)defaultQueue;

/**
 *	@brief	数据库路径
 */
@property (nonatomic, strong, readonly) NSString *dbPath;

/**
 *	@brief	多线程执行方法
 */
- (void)execute:(void (^)(LKDB *db))block;

@end
