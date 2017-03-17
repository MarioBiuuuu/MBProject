//
//  LKDB.h
//  LKDBObject
//
//  Version 1.0
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class LKDBObject;

typedef void (^LKDBExecuteCallBackBlock)(NSArray *resultArray);
extern NSString *LKDBDefaultName;
extern objc_property_t * st_class_copyPropertyList(Class cls, unsigned int *count);

@interface LKDB : NSObject

/**
 *	@brief	从外部导入数据库
 *
 *	@param 	dbName 	数据库名称（dbName.db）
 */
+ (void)importDb:(NSString *)dbName  __attribute__ ((deprecated));

/**
 *	@brief	设置数据库路径，方便支持多db应用
 *
 *	@param 	dbPath 	数据库路径
 *
 *  @param descrpition 在应用启动或登录时设置，如果数据库文件不存在，
    自动创建，如果存在，则直接使用该数据库文件
 */
+ (BOOL)setCurrentDbPath:(NSString *)dbPath __attribute__ ((deprecated));

/**
 *	@brief	数据库路径
 */
+ (NSString *)currentDbPath __attribute__ ((deprecated));

/**
 *	@brief	数据库路径，不存在自动创建
 */
+ (instancetype)dbWithPath:(NSString *)path;

/**
 *	@brief	默认数据库
 */
+ (instancetype)defaultDb;

/**
 *	@brief	默认数据库路径
 */
+ (NSString *)defaultDbPath;

/**
 *	@brief	数据库路径
 */
@property (nonatomic, strong, readonly) NSString *dbPath;

/**
 *	@brief	是否加密
 */
@property (nonatomic, assign) BOOL encryptEnable;

/**
 *	@brief	执行select方法
 */
- (BOOL)executeQuery:(NSString *)query resultBlock:(LKDBExecuteCallBackBlock)block;

/**
 *	@brief	执行create, update, delete方法
 */
- (BOOL)executeQuery:(NSString *)query;
- (BOOL)executeUpdate:(NSString*)query;
- (BOOL)executeUpdate:(NSString*)query dictionaryArgs:(NSDictionary *)dictionaryArgs;


#pragma mark - transaction

- (BOOL)beginTransaction;
- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)inTransaction;

#pragma mark - LKDBObject method

/**
 *	@brief	根据条件查询数据
 *
 *	@param 	aClass 	表相关类
 *	@param 	condition 	条件（nil或空或all为无条件），例 id=5 and name='yls'
 *                      带条数限制条件:id=5 and name='yls' limit 5
 *	@param 	orderby 	排序（nil或空或no为不排序）, 例 id,name
 *
 *	@return	数据对象数组
 */
- (NSMutableArray *)selectDbObjects:(Class)aClass condition:(NSString *)condition orderby:(NSString *)orderby;

/**
 *	@brief	插入一条数据
 *
 *	@param 	obj 	数据对象
 */
- (BOOL)insertDbObject:(LKDBObject *)obj;

/**
 *	@brief	仅插入一条数据
 *
 *	@param 	obj 	数据对象
 */
- (BOOL)replaceDbObject:(LKDBObject *)obj;

/**
 *	@brief	更新一条数据
 *
 *	@param 	obj 	数据对象
 */
- (BOOL)updateDbObject:(LKDBObject *)obj condition:(NSString *)condition;

/**
 *	@brief	remove object from aClass
 *
 *	@param 	aClass 	数据对象
 *	@param 	condition 	删除条件
 */
- (BOOL)removeDbObjects:(Class)aClass condition:(NSString *)condition;

/**
 *	@brief	last row in table named aClass
 */
- (NSInteger)lastRowIdWithClass:(Class)aClass;

- (NSInteger)localVersionForClass:(Class)cls;
- (BOOL)setDbVersion:(NSInteger)version toDbObjectClass:(Class)cls;

- (NSArray *)propertyForClass:(Class)cls;
- (BOOL)upgradeTableIfNeed:(Class)cls;

@end
