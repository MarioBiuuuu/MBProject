//
//  DbObject.h
//  STQuickKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>
#import "MBBaseModel.h"

#define kDbId           @"__id__"
#define kDbKeySuffix    @"__key__"

#define key( __p__ ) [NSString stringWithFormat:@"%@%@", __p__, kDbKeySuffix]

@class MBDB;

@protocol MBDBObject

@required

/**
 *	@brief	对象id，唯一标志
 */
@property (assign, nonatomic, readonly) NSInteger __id__;

/**
 *	@brief	父对象id，唯一标志
 */
@property (assign, nonatomic, readonly) NSInteger __pid__;

/**
 *	@brief	子对象id，唯一标志
 */
@property (assign, nonatomic, readonly) NSInteger __cid__;

/**
 *	@brief	失效日期
 */
@property (strong, nonatomic) NSDate *expireDate;

/**
 *	@brief	数据表版本号，要更新数据库表，override
 */
+ (NSInteger)dbVersion;

/**
 *	@brief	插入到数据库中
 */
- (BOOL)insertToDb;
- (BOOL)insertToDb:(MBDB *)db;

/**
 *	@brief	保证数据唯一
 */
- (BOOL)replaceToDb;
- (BOOL)replaceToDb:(MBDB *)db;

/**
 *	@brief	更新某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 */
- (BOOL)updateToDbsWhere:(NSString *)where NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

/**
 *	@brief	更新数据到数据库中
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)updateToDb;
- (BOOL)updateToDb:(MBDB *)db;

/**
 *	@brief	从数据库删除对象
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)removeFromDb;
- (BOOL)removeFromDb:(MBDB *)db;

/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)exiMBDBObjectsWhere:(NSString *)where;
+ (BOOL)exiMBDBObjectsWhere:(NSString *)where db:(MBDB *)db;

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部删除
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)removeDbObjectsWhere:(NSString *)where;
+ (BOOL)removeDbObjectsWhere:(NSString *)where db:(MBDB *)db;

/**
 *	@brief	根据条件取出某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部
 *
 *	@param 	orderby 	排序
 *          例：name and age
 *
 *	@return	数据
 */
+ (NSMutableArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby;
+ (NSMutableArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby db:(MBDB *)db;

/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)allDbObjects;
+ (NSMutableArray *)allDbObjectsInDb:(MBDB *)db;

/*
 * 查看最后插入数据的行号
 */
+ (NSInteger)lastRowId;
+ (NSInteger)lastRowIdInDb:(MBDB *)db;

@end

@interface MBDBObject : MBBaseModel<MBDBObject>

/**
 *	@brief	对象id，唯一标志
 */
@property (assign, nonatomic, readonly) NSInteger __id__;

/**
 *	@brief	父对象id，唯一标志
 */
@property (assign, nonatomic, readonly) NSInteger __pid__;

/**
 *	@brief	子对象id，唯一标志
 */
@property (assign, nonatomic, readonly) NSInteger __cid__;

/**
 *	@brief	失效日期
 */
@property (strong, nonatomic) NSDate *expireDate;

/**
 *	@brief	init with primary key
 */
- (instancetype)initWithPrimaryValue:(NSInteger)_id;

/**
 *	@brief	objc to dictionary
 */
- (NSDictionary *)objcDictionary;

/**
 *	@brief	objc from dictionary
 */
+ (MBDBObject *)objcFromDictionary:(NSDictionary *)dict;

@end

