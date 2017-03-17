//
//  LKDBQueue.m
//  LKDBKit
//
//  Version 1.0
//

#import "LKDBQueue.h"
#import "LKDB.h"

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@interface LKDBQueue() {
    LKDB *_db;
    dispatch_queue_t _queue;
}
@end

@implementation LKDBQueue

- (instancetype)initWithPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create([NSString stringWithFormat:@"LKDB.%@", self].UTF8String, NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
        LKDB *db = [LKDB dbWithPath:filePath];
        self->_db = db;
    }
    return self;
}

- (NSString *)dbPath {
    return _db.dbPath;
}

- (void)execute:(void (^)(LKDB *db))block; {
    LKDBQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "execute: was called reentrantly on the same queue, which would lead to a deadlock");
    
    dispatch_queue_t queue = self->_queue;
    
    dispatch_sync(queue, ^{
        LKDB *db = self->_db;
        if (block) {
            block(db);
        }
    });
}

+ (instancetype)dbWithPath:(NSString *)path; {
    NSString *dbPath = [path stringByStandardizingPath];
    if (![dbPath isAbsolutePath]) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        dbPath = [docPath stringByAppendingFormat:@"/%@", dbPath];
    }
    
    NSString *pathExt = [dbPath pathExtension];
    NSString *filePath = dbPath;
    NSString *dirPath = dbPath;
    if (pathExt.length != 0) {
        dirPath = [dbPath stringByDeletingLastPathComponent];
    } else {
        filePath = [dbPath stringByAppendingPathComponent:LKDBDefaultName];
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        BOOL rc = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!rc) {
            NSLog(@"%@", error);
        }
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL rc = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        if (!rc) {
            NSLog(@"create file %@ error.", filePath);
        }
    }
    LKDBQueue *dbQueue = [[LKDBQueue alloc] initWithPath:filePath];
    return dbQueue;
}

/**
 *	@brief	默认数据库路径
 */
+ (instancetype)defaultQueue {
    return [LKDBQueue dbWithPath:[LKDB defaultDbPath]];
}

@end
