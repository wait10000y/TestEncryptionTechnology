//
//  Base64codeFunc.h
//  TestEncryptionTechnology
//
//  Created by wsliang on 16/3/22.
//  Copyright © 2016年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64CryptorUtil : NSObject

/*
 将文本转换为base64格式字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

@end
