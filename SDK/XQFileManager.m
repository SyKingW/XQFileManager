//
//  XQFileManager.m
//  Pods-XQFileManagerDemo
//
//  Created by WXQ on 2019/12/12.
//

#import "XQFileManager.h"

@implementation XQFileManager

#pragma mark - read

/**
 文件属性
 */
+ (nullable NSDictionary<NSFileAttributeKey, id> *)fileAttrAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [manager attributesOfItemAtPath:filePath error:nil];
    }
    return nil;
}



/**
 单个文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 文件夹大小
 */
+ (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0 * 1024.0);
}

// 查看文件夹
+ (NSDictionary *)viewDocWithPath:(NSString *)path {
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isDirectory) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        [muDic addEntriesFromDictionary:@{}];
        
        NSError *error = nil;
        NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
        
        for (NSString *str in arr) {
            NSString *nPath = [path stringByAppendingPathComponent:str];
            [muDic addEntriesFromDictionary:[self viewDocWithPath:nPath]];
        }
        
        return @{[path componentsSeparatedByString:@"/"].lastObject: muDic};
    }
    
    return @{[path componentsSeparatedByString:@"/"].lastObject: @""};
}

#pragma mark - write

+ (NSError *)xq_writeDataToLastAndInsertDateWithStr:(NSString *)str filePath:(NSString *)filePath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *writeStr = [NSString stringWithFormat:@"\n%@\n%@\n\n",datestr, str];
    return [self xq_writeDataToLastWithStr:writeStr filePath:filePath];
}

+ (NSError *)xq_writeDataToLastWithStr:(NSString *)str filePath:(NSString *)filePath {
    NSData *stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [self xq_writeDataToLastWithData:stringData filePath:filePath];
}

+ (NSError *)xq_writeDataToLastWithData:(NSData *)data filePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    if(![fileManager fileExistsAtPath:filePath]) {
        // 不存在, 创建一个默认的文件
        NSString *str = @"";
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
#if DEBUG
            NSLog(@"创建文件失败: %@", error);
#endif
            return error;
        }
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    // 追加写入数据
    if (@available(iOS 13.0, *)) {
        // 将节点跳到文件的末尾
        unsigned long long offsetInFile = 0;
        [fileHandle seekToEndReturningOffset:&offsetInFile error:&error];
        // 设置自定义偏移值, 不用插入写到最后
//        [fileHandle seekToOffset];
        [fileHandle writeData:data error:&error];
    } else {
        // 将节点跳到文件的末尾
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
    }
    
    [fileHandle closeFile];
    
#if DEBUG
    if (error) {
        NSLog(@"写入文件失败: %@", error);
    }
#endif
    
    return error;
}

@end
