//
//  IGEOUtils.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Esta classe é utilizada para a implementação de métodos úteis em diversas classes da App.
 */
@interface IGEOUtils : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;
//http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background
+ (UIColor*)colorWithHexString:(NSString*)hex alpha:(float) alpha;
+(BOOL)isNetworkAvailable;
+(NSString *) getStringForKey:(NSString *)key;

@end
