//
//  DESCryptorUtil.h
//  TestEncryptionTechnology
//
//  Created by wsliang on 16/3/22.
//  Copyright © 2016年 wsliang. All rights reserved.
//


/*
 
 AES加密数据块分组长度必须为128比特，密钥长度可以是128比特、192比特、256比特中的任意一个
 
 */
#import <Foundation/Foundation.h>

@interface DESCryptorUtil : NSObject

/*
 DES
 不可加密过长的字符串
 */
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

/*
 AES256
 AES 是块加密，块的长度是 16 个字节，如果原文不到 16 个字节，则需要填充至 16 个字节后再进行处理。
 AES 密文长度 = (原文长度 / 16) * 16 + 16
 这里的“/”表示整除
 可以处理 小于 100M的文件
 */
+ (NSData *)AES256Encrypt:(NSData *)data WithKey:(NSString *)key;   //加密
+ (NSData *)AES256Decrypt:(NSData *)data WithKey:(NSString *)key;   //解密

/*
 AES128
 
 AES128 CBC No Padding加密方式，也有别的写法，但不是是AES128 CBC No Padding或者不是CBC No Padding。
 No Padding. No Pading的情况下，一定要对加密数据不是kCCKeySizeAES128倍数部分进行0x0000的填充，不然加密长度不正确，
 一般情况下选择使用kCCOptionPKCS7Padding（也就是0x0001）进行填充，但是我们是No Padding所以要用0x0000填充。
 加密后再对加密数据进行了Base64加密.
 
 key,gIv: 16位长度的字符串
 */
+ (NSString*) AES128Encrypt:(NSString *)plainText WithKey:(NSString *)key withIv:(NSString *)gIv;
+ (NSString*) AES128Decrypt:(NSString *)encryptText WithKey:(NSString *)key withIv:(NSString *)gIv;


/*
 将文本转换为base64格式字符串,使用了DES混合
 */
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;

/*
 base64
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

@end
