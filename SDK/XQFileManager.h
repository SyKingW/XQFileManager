//
//  XQFileManager.h
//  Pods-XQFileManagerDemo
//
//  Created by WXQ on 2019/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQFileManager : NSObject

/// 获取文件属性
+ (nullable NSDictionary<NSFileAttributeKey, id> *)fileAttrAtPath:(NSString *)filePath;

/// 获取某个文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath;
    
/// 获取文件夹大小
+ (float)folderSizeAtPath:(NSString *)folderPath;

/// 把字符串追加到文件最后, 并且会自动在当前追加内容的头部插入当前时间
/// @param str 要追加的内容
/// @param filePath 文件路径
+ (NSError *)xq_writeDataToLastAndInsertDateWithStr:(NSString *)str filePath:(NSString *)filePath;

/// 把字符串追加到文件最后
/// @param str 要追加的内容
/// @param filePath 文件路径
+ (NSError *)xq_writeDataToLastWithStr:(NSString *)str filePath:(NSString *)filePath;

/// 把字符串追加到文件最后
/// @param data 要追加的内容
/// @param filePath 文件路径
+ (NSError *)xq_writeDataToLastWithData:(NSData *)data filePath:(NSString *)filePath;


/// 查看某个文件夹下面所有的文件(也会迭代下面所有的文件夹)
+ (NSDictionary *)viewDocWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
