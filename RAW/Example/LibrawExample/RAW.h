//
//  Example.h
//  LibrawExample
//
//  Copyright (c) 2012 Alaric Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAW : NSObject

+(UIImage *)getUIImageFromFile:(NSString*)file;
+(UIImage *)getThumbnailFromFile:(NSString*)file;
+(BOOL)writeRawData:(NSString *)file toDisk:(NSString *)destFile;
+(BOOL)writeThumbData:(NSString *)file toDisk:(NSString *)destFile;


+(void)log:(int)res str:(NSString *)str;
@end
