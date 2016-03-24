//
//  MD5CryptorUtil.m
//  TestEncryptionTechnology
//
//  Created by wsliang on 16/3/22.
//  Copyright © 2016年 wsliang. All rights reserved.
//

#import "MD5CryptorUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5CryptorUtil




+ (NSString *) md5:(NSString *)text
{
  const char *cStr = [text UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(cStr, strlen(cStr), result);
  
  NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [hash appendFormat:@"%02X", result[i]];
  return [hash lowercaseString];
}

+ (NSString*) sha1:(NSString*)input
{
  const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:input.length];
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  return output;
  
}


@end
