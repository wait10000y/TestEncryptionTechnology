//
//  Base64codeFunc.m
//  TestEncryptionTechnology
//
//  Created by wsliang on 16/3/22.
//  Copyright © 2016年 wsliang. All rights reserved.
//

#import "Base64CryptorUtil.h"

//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation Base64CryptorUtil

+ (NSString *)base64StringFromText:(NSString *)text
{
  if (text.length>0) {
    //取项目的bundleIdentifier作为KEY
    NSString *key = [[NSBundle mainBundle] bundleIdentifier];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    //IOS 自带DES加密 Begin
    data = [self DESEncrypt:data WithKey:key];
    //IOS 自带DES加密 End
    return [self base64EncodedStringFrom:data];
  }
  else {
    return @"";
  }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
  if (base64.length>0) {
    //取项目的bundleIdentifier作为KEY
    NSString *key = [[NSBundle mainBundle] bundleIdentifier];
    NSData *data = [self dataWithBase64EncodedString:base64];
    //IOS 自带DES解密 Begin
    data = [self DESDecrypt:data WithKey:key];
    //IOS 自带DES加密 End
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  else {
    return @"";
  }
}

/*
 文本数据进行DES加密
 备注信息 : 此函数不可用于过长文本
 */
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
  char keyPtr[kCCKeySizeAES256+1];
  bzero(keyPtr, sizeof(keyPtr));
  
  [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
  
  NSUInteger dataLength = [data length];
  
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  
  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        keyPtr, kCCBlockSizeDES,
                                        NULL,
                                        [data bytes], dataLength,
                                        buffer, bufferSize,
                                        &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
    return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
  }
  
  free(buffer);
  return nil;
}

/*
 文本数据进行DES解密
 备注信息 : 此函数不可用于过长文本
 */
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
  char keyPtr[kCCKeySizeAES256+1];
  bzero(keyPtr, sizeof(keyPtr));
  
  [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
  
  NSUInteger dataLength = [data length];
  
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  
  size_t numBytesDecrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        keyPtr, kCCBlockSizeDES,
                                        NULL,
                                        [data bytes], dataLength,
                                        buffer, bufferSize,
                                        &numBytesDecrypted);
  
  if (cryptStatus == kCCSuccess) {
    return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
  }
  
  free(buffer);
  return nil;
}

/*
 base64格式字符串转换为文本数据
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
  if (string.length==0){
    return [NSData data];
  }
  
  static char *decodingTable = NULL;
  if (decodingTable == NULL)
  {
    decodingTable = malloc(256);
    if (decodingTable == NULL)
      return nil;
    memset(decodingTable, CHAR_MAX, 256);
    NSUInteger i;
    for (i = 0; i < 64; i++)
      decodingTable[(short)encodingTable[i]] = i;
  }
  
  const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
  if (characters == NULL)     //  Not an ASCII string!
    return nil;
  char *bytes = malloc((([string length] + 3) / 4) * 3);
  if (bytes == NULL)
    return nil;
  NSUInteger length = 0;
  
  NSUInteger i = 0;
  while (YES)
  {
    char buffer[4];
    short bufferLength;
    for (bufferLength = 0; bufferLength < 4; i++)
    {
      if (characters[i] == '\0')
        break;
      if (isspace(characters[i]) || characters[i] == '=')
        continue;
      buffer[bufferLength] = decodingTable[(short)characters[i]];
      if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
      {
        free(bytes);
        return nil;
      }
    }
    
    if (bufferLength == 0)
      break;
    if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
    {
      free(bytes);
      return nil;
    }
    
    //  Decode the characters in the buffer to bytes.
    bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
    if (bufferLength > 2)
      bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
    if (bufferLength > 3)
      bytes[length++] = (buffer[2] << 6) | buffer[3];
  }
  
  bytes = realloc(bytes, length);
  return [NSData dataWithBytesNoCopy:bytes length:length];
}

/*
 文本数据转换为base64格式字符串
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
  if ([data length] == 0)
    return @"";
  
  char *characters = malloc((([data length] + 2) / 3) * 4);
  if (characters == NULL)
    return nil;
  NSUInteger length = 0;
  
  NSUInteger i = 0;
  while (i < [data length])
  {
    char buffer[3] = {0,0,0};
    short bufferLength = 0;
    while (bufferLength < 3 && i < [data length])
      buffer[bufferLength++] = ((char *)[data bytes])[i++];
    
    //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
    characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
    characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
    if (bufferLength > 1)
      characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
    else characters[length++] = '=';
    if (bufferLength > 2)
      characters[length++] = encodingTable[buffer[2] & 0x3F];
    else characters[length++] = '=';
  }
  
  return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}




@end
