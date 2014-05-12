//
//  IGEOUtils.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOUtils.h"
#include <unistd.h>
#include <netdb.h>

@implementation IGEOUtils

static NSDictionary *dict;

//Nome do ficheiro onde estão colocadas as strings.
static const NSString *STRINGS_FILE_NAME = @"IGEOStrings";

/**
 Dado que em alguns casos é útil colocar como fundo de uma view uma cor, criamos este método para que tal seja possível.
 Assim, criamos com este método uma imagem que contém apenas essa cor.
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 Este método permite de uma forma simples a criação de cores utilizando a rua representação hexadecimal sem o carater "#" no inicio.
 Este método foi obtido após alguma pesquisa, no seguinte post:
 http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background
 Foram feitas alterações para permitir personalizar o alpha da cor obtida.
 */
+ (UIColor*)colorWithHexString:(NSString*)hex alpha:(float) alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}


/**
 Verifica se estamos com acesso à internet. Essa verificação é feita através da tentativa de acesso ao site da apple.
 */
+(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "apple.com";
    @try{
        hostinfo = gethostbyname (hostname);
        if (hostinfo == NULL){
            return NO;
        }
        else{
            return YES;
        }
    }
    @catch(NSException *err){
        return NO;
    }
}


/**
 Este método permite-nos obter uma string dado a sua key. Isto é utilizado do seguinte modo:
    - Temos um ficheiro onde são colocadas strings em pares "chave-valor"
    - Este método lê esse ficheiro e obtém a string pretendida
 Isto permite-nos ter as strings de uma forma mais limpa e organizada.
 */
+(NSString *) getStringForKey:(NSString *)key
{
    if (dict == nil) {
        NSString *path = [[ NSBundle mainBundle ] pathForResource:[NSString stringWithFormat:@"%@", STRINGS_FILE_NAME] ofType:@"strings" ];
        
        dict = [NSDictionary dictionaryWithContentsOfFile:path];
        path = nil;
    }
    
    return [dict objectForKey:key];
}

@end
