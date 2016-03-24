//
//  ViewController.m
//  TestEncryptionTechnology
//
//  Created by wsliang on 16/3/22.
//  Copyright © 2016年 wsliang. All rights reserved.
//

#import "ViewController.h"
//#import "Base64CryptorUtil.h"
#import "DESCryptorUtil.h"
#import "MD5CryptorUtil.h"

@interface ViewController ()

@end

@implementation ViewController
{
  int loopNum;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  loopNum = 10;
  
  
  
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1),dispatch_get_main_queue(), ^{
    //
//      [self testStrings];
//      [self testAESStrings];
//      [self testMD5Strings];

    [self testAESFiles];
    
  });
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}



-(NSTimeInterval)nowTimeInterval
{
  return [[NSDate date] timeIntervalSince1970];
}

-(void)testStrings
{
  NSString *normalKey = @"~key!!@@**测试字符串,O(∩_∩)O哈哈~";;
  NSString *normalStr = @"test!!@@**测试字符串,O(∩_∩)O哈哈~";
  NSData * normalData = [normalStr dataUsingEncoding:NSUTF8StringEncoding];
  
  // base64 data
  NSTimeInterval now1 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    NSString *ENBase64 = [DESCryptorUtil base64EncodedStringFrom:normalData];
    NSData *DEData = [DESCryptorUtil dataWithBase64EncodedString:ENBase64];
  }
  NSTimeInterval now2 = [self nowTimeInterval];
  NSLog(@"--- base64 loop:%d , use time:%f ---",loopNum,now2-now1);
  
//  NSString *ENBase64 = [DESCryptorUtil base64EncodedStringFrom:normalData];
//  NSData *DEData = [DESCryptorUtil dataWithBase64EncodedString:ENBase64];
//  NSLog(@"--- base64: normal:%@ , crypt:%@ , dcrypt:%@ ---",[[NSString alloc] initWithData:normalData encoding:NSUTF8StringEncoding],ENBase64,[[NSString alloc] initWithData:DEData encoding:NSUTF8StringEncoding]);
  
  // test base64(DES)
  NSTimeInterval now11 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    NSString *cryptStr = [DESCryptorUtil base64StringFromText:normalStr];
    [DESCryptorUtil textFromBase64String:cryptStr];
  }
  NSTimeInterval now21 = [self nowTimeInterval];
  NSLog(@"--- base64(DES) loop:%d , use time:%f ---",loopNum,now21-now11);
  
//  NSString *cryptStr = [DESCryptorUtil base64StringFromText:normalStr];
//  NSLog(@"--- base64(DES): normal:%@ , crypt:%@ , dcrypt:%@ ---",normalStr,cryptStr,[DESCryptorUtil textFromBase64String:cryptStr]);
  
  // des
  NSTimeInterval now111 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    NSData *cryptData = [DESCryptorUtil DESEncrypt:normalData WithKey:normalKey];
    NSData *dcData = [DESCryptorUtil DESDecrypt:cryptData WithKey:normalKey];
  }
  NSTimeInterval now211 = [self nowTimeInterval];
  NSLog(@"--- DES loop:%d , use time:%f ---",loopNum,now211-now111);
  
//  NSData *cryptData = [DESCryptorUtil DESEncrypt:normalData WithKey:normalKey];
//  NSData *dcData = [DESCryptorUtil DESDecrypt:cryptData WithKey:normalKey];
//  NSLog(@"--- DES: normal:%@ , crypt:%@ , dcrypt:%@ ---",[[NSString alloc] initWithData:normalData encoding:NSUTF8StringEncoding],[[NSString alloc] initWithData:cryptData encoding:NSUTF8StringEncoding],[[NSString alloc] initWithData:dcData encoding:NSUTF8StringEncoding]);
  
}


-(void)testAESStrings
{
  NSString *normalKey = @"~key!!@@**测试字符串,O(∩_∩)O哈哈~";;
  NSString *normalStr = @"test!!@@**测试字符串,O(∩_∩)O哈哈~";
  NSData * normalData = [normalStr dataUsingEncoding:NSUTF8StringEncoding];
  
  // AES128
  NSTimeInterval now111 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    NSString *aes128 = [DESCryptorUtil AES128Encrypt:normalStr WithKey:normalKey withIv:normalKey];
    NSString *aes128D = [DESCryptorUtil AES128Decrypt:aes128 WithKey:normalKey withIv:normalKey];
  }
  NSTimeInterval now211 = [self nowTimeInterval];
  NSLog(@"--- AES128 loop:%d , use time:%f ---",loopNum,now211-now111);
  
//  NSString *aes128 = [DESCryptorUtil AES128Encrypt:normalStr WithKey:normalKey withIv:normalKey];
//  NSString *aes128D = [DESCryptorUtil AES128Decrypt:aes128 WithKey:normalKey withIv:normalKey];
//  NSLog(@"--- AES128: normal:%@ , crypt:%@ , dcrypt:%@ ---",normalStr,aes128,aes128D);
  
  
  // AES256
  NSTimeInterval now11 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    NSData *aes256 = [DESCryptorUtil AES256Encrypt:normalData WithKey:normalKey];
    NSData *aes256D = [DESCryptorUtil AES256Decrypt:aes256 WithKey:normalKey];
  }
  NSTimeInterval now21 = [self nowTimeInterval];
  NSLog(@"--- AES256 loop:%d , use time:%f ---",loopNum,now21-now11);
  
  
//  NSData *aes256 = [DESCryptorUtil AES256Encrypt:normalData WithKey:normalKey];
//  NSData *aes256D = [DESCryptorUtil AES256Decrypt:aes256 WithKey:normalKey];
//  
//  NSLog(@"--- AES256: normal:%@ , crypt:%@ , dcrypt:%@ ---",
//        [[NSString alloc] initWithData:normalData encoding:NSUTF8StringEncoding],
//        [[NSString alloc] initWithData:aes256 encoding:NSUTF8StringEncoding],
//        [[NSString alloc] initWithData:aes256D encoding:NSUTF8StringEncoding]);
  
}

-(void)testMD5Strings
{
 NSString *normalStr = @"test!!@@**测试字符串,O(∩_∩)O哈哈~";
  
  NSTimeInterval now11 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    [MD5CryptorUtil md5:normalStr];
  }
  NSTimeInterval now21 = [self nowTimeInterval];
  NSLog(@"--- MD5 loop:%d , use time:%f ---",loopNum,now21-now11);
  
  NSTimeInterval now1 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    [MD5CryptorUtil md5:normalStr];
  }
  NSTimeInterval now2 = [self nowTimeInterval];
  NSLog(@"--- sha1 loop:%d , use time:%f ---",loopNum,now2-now1);
  
//  NSLog(@"--- MD5: normal:%@ , crypt:%@ ---",normalStr,[MD5CryptorUtil md5:normalStr]);
//  NSLog(@"--- sha1: normal:%@ , crypt:%@ ---",normalStr,[MD5CryptorUtil sha1:normalStr]);
  
}

-(void)testAESFiles
{
  
  NSString *filePath = [[[NSBundle mainBundle] URLForResource:@"apple" withExtension:@"png"] path];
  NSString *normalKey = @"012345678912345";
  NSData *normalData = [NSData dataWithContentsOfFile:filePath];
  NSLog(@"--- filepath:%@ length:%lu ---",filePath,(unsigned long)normalData.length);
  
  NSData *aes256 = [DESCryptorUtil AES256Encrypt:normalData WithKey:normalKey];
  NSLog(@"--- AES256data length:%lu ---",(unsigned long)aes256.length);
  NSData *aes256D = [DESCryptorUtil AES256Decrypt:aes256 WithKey:normalKey];
  NSLog(@"--- file size:%lu , last size:%lu ---",(unsigned long)normalData.length,(unsigned long)aes256D.length);
  
  NSTimeInterval now11 = [self nowTimeInterval];
  for (int it=0; it< loopNum; it++) {
    NSData *encryptData = [DESCryptorUtil AES256Encrypt:normalData WithKey:normalKey];
    [DESCryptorUtil AES256Decrypt:encryptData WithKey:normalKey];
  }
  NSTimeInterval now21 = [self nowTimeInterval];
  NSLog(@"--- AES256 loop:%d , use time:%f ---",loopNum,now21-now11);
  
}

@end
