//
//  MD5CryptorUtil.h
//  TestEncryptionTechnology
//
//  Created by wsliang on 16/3/22.
//  Copyright © 2016年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5CryptorUtil : NSObject

+ (NSString *) md5:(NSString *)input;
+ (NSString*) sha1:(NSString*)input;


@end
