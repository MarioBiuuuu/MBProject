//
//  DbObject.m
//  STQuickKit
//
//  Version 1.0
//

#import "MBDBObject.h"
#import "MBDBVersion.h"
#import "MBDBQueue.h"
#import "MBDB.h"

#import <objc/runtime.h>

#import "NSDate+MBDBHandle.h"
#import "NSData+MBDBHandle.h"

@implementation MBDBObject

- (id)init {
    self = [super init];
    if (self) {
        self.expireDate = [NSDate distantFuture];
        ___id__ = -1;
    }
    return self;
}

- (instancetype)initWithPrimaryValue:(NSInteger)_id; {
    self = [self init];
    if (self) {
        ___id__ = _id;
    }
    return self;
}

/**
 *	@brief	插入到数据库中
 */
- (BOOL)insertToDb {
    @synchronized(self){
        return [[MBDB defaultDb] insertDbObject:self];
    }
}
- (BOOL)insertToDb:(MBDB *)db {
    return [db insertDbObject:self];
}

+ (NSInteger)lastRowId; {
    return [[MBDB defaultDb] lastRowIdWithClass:[self class]];
}
+ (NSInteger)lastRowIdInDb:(MBDB *)db; {
    return [db lastRowIdWithClass:[self class]];
}

- (BOOL)updateToDbsWhere:(NSString *)where NS_DEPRECATED(10_0, 10_4, 2_0, 2_0) {
    @synchronized(self){
        return [[MBDB defaultDb] updateDbObject:self condition:where];
    }
}

/**
 *	@brief	保证数据唯一
 */
- (BOOL)replaceToDb {
    @synchronized(self){
        return [[MBDB defaultDb] replaceDbObject:self];
    }
}
- (BOOL)replaceToDb:(MBDB *)db {
    @synchronized(self){
        return [db replaceDbObject:self];
    }
}

- (BOOL)updateToDb {
    @synchronized(self){
        return [self updateToDb:[MBDB defaultDb]];
    }
}

- (BOOL)updateToDb:(MBDB *)db {
    @synchronized(self){
        NSString *condition = [NSString stringWithFormat:@"%@=%@", kDbId, @(self.__id__)];
        return [db updateDbObject:self condition:condition];
    }
}

/**
 *	@brief	从数据库删除对象
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)removeFromDb {
    @synchronized(self){
        return [self removeFromDb:[MBDB defaultDb]];
    }
}

- (BOOL)removeFromDb:(MBDB *)db {
    @synchronized(self){
        NSMutableArray *subDbObjects = [NSMutableArray arrayWithCapacity:0];
        [self subDbObjects:subDbObjects];
        
        for (MBDBObject *dbObj in subDbObjects) {
            NSString *where = [NSString stringWithFormat:@"%@=%@", kDbId, @(dbObj.__id__)];
            [db removeDbObjects:[dbObj class] condition:where];
        }
        return YES;
    }
}

- (void)subDbObjects:(NSMutableArray *)subObj {
    @synchronized(self){
        if (!self || ![self isKindOfClass:[MBDBObject class]]) {
            return;
        }
        
        [subObj addObject:self];
        
        unsigned int count;
        MBDBObject *obj = self;
        Class cls = [obj class];
        objc_property_t *properties = st_class_copyPropertyList(cls, &count);
        
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [obj valueForKey:key];

            if (value && (NSNull *)value != [NSNull null] && [value isKindOfClass:[MBDBObject class]]) {
                [subObj addObject:value];
            }
            
            if ([value isKindOfClass:[NSArray class]]) {
                for (MBDBObject *obj in value) {
                    if (obj && (NSNull *)obj != [NSNull null] && [obj isKindOfClass:[MBDBObject class]]) {
                        [subObj addObject:obj];
                    }
                }
            }
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in value) {
                    MBDBObject *obj = value[key];
                    if (obj && (NSNull *)obj != [NSNull null] && [obj isKindOfClass:[MBDBObject class]]) {
                        [subObj addObject:obj];
                    }
                }
            }
        }
    }
}

/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)exiMBDBObjectsWhere:(NSString *)where {
    @synchronized(self){
        return [self exiMBDBObjectsWhere:where db:[MBDB defaultDb]];
    }
}

+ (BOOL)exiMBDBObjectsWhere:(NSString *)where db:(MBDB *)db {
    @synchronized(self){
        NSArray *objs = [db selectDbObjects:[self class] condition:where orderby:nil];
        if ([objs count] > 0) {
            return YES;
        }
        return NO;
    }
}

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部删除
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)removeDbObjectsWhere:(NSString *)where {
    return [self removeDbObjectsWhere:where db:[MBDB defaultDb]];
}
+ (BOOL)removeDbObjectsWhere:(NSString *)where db:(MBDB *)db {
    @synchronized(self){
        return [db removeDbObjects:[self class] condition:where];
        return NO;
    }
}

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
+ (NSArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby {
    return [self dbObjectsWhere:where orderby:orderby db:[MBDB defaultDb]];
}

+ (NSArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby db:(MBDB *)db {
    @synchronized(self){
        return [db selectDbObjects:[self class] condition:where orderby:orderby];
    }
}

/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)allDbObjects {
    @synchronized(self){
        return [[MBDB defaultDb] selectDbObjects:[self class] condition:@"all" orderby:nil];
    }
}

+ (NSMutableArray *)allDbObjectsInDb:(MBDB *)db {
    @synchronized(self){
        return [db selectDbObjects:[self class] condition:@"all" orderby:nil];
    }
}

/**
 *	@brief	objc to dictionary
 */
- (NSDictionary *)objcDictionary; {
    @synchronized(self){
        unsigned int count;
        MBDBObject *obj = self;

        Class cls = [obj class];
        objc_property_t *properties = st_class_copyPropertyList(cls, &count);

        NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [obj valueForKey:key];
            if (value) {
                [retDict setObject:value forKey:key];
            }
        }
        
        return retDict;
    }
}

/**
 *	@brief	objc from dictionary
 */
+ (MBDBObject *)objcFromDictionary:(NSDictionary *)dict; {
    @synchronized(self){
        MBDBObject *obj = [[[self class] alloc] init];
        
        unsigned int count;
        
        Class cls = [obj class];
        objc_property_t *properties = st_class_copyPropertyList(cls, &count);

        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [dict objectForKey:key];
            if (value) {
                [obj setValue:value forKey:key];
            }
        }
        return obj;
    }
}

+ (NSInteger)dbVersion {
    return 0;
}

@end

