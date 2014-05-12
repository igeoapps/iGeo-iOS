//
//  IGEONativeMapScreenConfig.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEONativeMapScreenConfig.h"

@implementation IGEONativeMapScreenConfig

@synthesize colorPinsCategory = _colorPinsCategory;
@synthesize colorHTMLCategory = _colorHTMLCategory;
@synthesize pinLegendCategory = _pinLegendCategory;
@synthesize polygonColorCategory = _polygonColorCategory;
@synthesize polygonBackgroundColorCategory = _polygonBackgroundColorCategory;

-(id)init {
    if ( self = [super init] ) {
        _colorPinsCategory = [[NSMutableDictionary alloc] init];
        _colorHTMLCategory = [[NSMutableDictionary alloc] init];
        _pinLegendCategory = [[NSMutableDictionary alloc] init];
        _polygonColorCategory = [[NSMutableDictionary alloc] init];
        _polygonBackgroundColorCategory = [[NSMutableDictionary alloc] init];
    }
    return self;
}


/**
 Obtém o pin do mapa a ser usado para uma determinada fonte e categoria.
 */
-(CGFloat) getPinColorForCategory:(NSString *) srcID cat:(NSString *) catID
{
    @try {
        NSString *key = [NSString stringWithFormat:@"%@_%@", srcID, catID];
        if([_colorPinsCategory objectForKey:key] != nil){
            return [[_colorPinsCategory objectForKey:key] floatValue];
        }
        
        else {
            if([catID length]>1){
                key = [NSString stringWithFormat:@"%@_%@", srcID, [catID substringToIndex:0]];
                if([_colorPinsCategory objectForKey:key] != nil){
                    return [[_colorPinsCategory objectForKey:key] floatValue];
                }
                else {
                    return [[_colorPinsCategory objectForKey:@"-1"] floatValue];
                }
            }
            else {
                return [[_colorPinsCategory objectForKey:@"-1"] floatValue];
            }
        }
        
    }
    @catch (NSException *exception) {
        return [[_colorPinsCategory objectForKey:@"-1"] floatValue];
    }
    
}


/**
 Obtém a cor html a ser usada no título da lista para uma determinada fonte e categoria.
 */
-(NSString *) getHTMLColorForCategory:(NSString *) srcID cat:(NSString *) catID
{
    @try {
        NSString *key = [NSString stringWithFormat:@"%@_%@", srcID, catID];
        if([_colorHTMLCategory objectForKey:key] != nil){
            return [_colorHTMLCategory objectForKey:key];
        }
        
        else {
            if([catID length]>1){
                key = [NSString stringWithFormat:@"%@_%@", srcID, [catID substringToIndex:0]];
                if([_colorHTMLCategory objectForKey:key] != nil){
                    return [_colorHTMLCategory objectForKey:key];
                }
                else {
                    return [_colorHTMLCategory objectForKey:@"-1"];
                }
            }
            else {
                return [_colorHTMLCategory objectForKey:@"-1"];
            }
        }
        
    }
    @catch (NSException *exception) {
        return [_colorHTMLCategory objectForKey:@"-1"];
    }
    
}


/**
 Obtém o pin da legenda a ser usado para uma determinada fonte e categoria.
 */
-(NSString *) getPinLegendForCategory:(NSString *) srcID cat:(NSString *) catID
{
    @try {
        NSString *key = [NSString stringWithFormat:@"%@_%@", srcID, catID];
        if([_pinLegendCategory objectForKey:key] != nil){
            return [_pinLegendCategory objectForKey:key];
        }
        
        else {
            if([catID length]>1){
                key = [NSString stringWithFormat:@"%@_%@", srcID, [catID substringToIndex:0]];
                if([_pinLegendCategory objectForKey:key] != nil){
                    return [_pinLegendCategory objectForKey:key];
                }
                else {
                    return [_pinLegendCategory objectForKey:@"-1"];
                }
            }
            else {
                return [_pinLegendCategory objectForKey:@"-1"];
            }
        }
        
    }
    @catch (NSException *exception) {
        return [_pinLegendCategory objectForKey:@"-1"];
    }
    
}


/**
 Obtém a cor da linha a ser usada no desenho de poligonos para uma determinada fonte e categoria.
 */
-(NSNumber *) getPolygonColorForCategory:(NSString *) srcID cat:(NSString *) catID
{
    @try {
        NSString *key = [NSString stringWithFormat:@"%@_%@", srcID, catID];
        if([_polygonColorCategory objectForKey:key] != nil){
            return [_polygonColorCategory objectForKey:key];
        }
        
        else {
            if([catID length]>1){
                key = [NSString stringWithFormat:@"%@_%@", srcID, [catID substringToIndex:0]];
                if([_polygonColorCategory objectForKey:key] != nil){
                    return [_polygonColorCategory objectForKey:key];
                }
                else {
                    return [_polygonColorCategory objectForKey:@"-1"];
                }
            }
            else {
                return [_polygonColorCategory objectForKey:@"-1"];
            }
        }
        
    }
    @catch (NSException *exception) {
        return [_polygonColorCategory objectForKey:@"-1"];
    }
    
}


/**
 Obtém a cor de fundo a ser usada no desenho de polígonos para uma determinada fonte e categoria.
 */
-(NSNumber *) getPolygonBackgroundColorForCategory:(NSString *) srcID cat:(NSString *) catID
{
    @try {
        NSString *key = [NSString stringWithFormat:@"%@_%@", srcID, catID];
        if([_polygonBackgroundColorCategory objectForKey:key] != nil){
            return [_polygonBackgroundColorCategory objectForKey:key];
        }
        
        else {
            if([catID length]>1){
                key = [NSString stringWithFormat:@"%@_%@", srcID, [catID substringToIndex:0]];
                if([_polygonBackgroundColorCategory objectForKey:key] != nil){
                    return [_polygonBackgroundColorCategory objectForKey:key];
                }
                else {
                    return [_polygonBackgroundColorCategory objectForKey:@"-1"];
                }
            }
            else {
                return [_polygonBackgroundColorCategory objectForKey:@"-1"];
            }
        }
        
    }
    @catch (NSException *exception) {
        return [_polygonBackgroundColorCategory objectForKey:@"-1"];
    }
    
}





/**
 O encode e decode é utilizado todas as classes que são referenciadas nas configurações e guardadas na app..
 Estamos aqui a utilizar o protocolo NSCoding para que possibilidar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_colorPinsCategory forKey:@"colorPinsCategory"];
    [coder encodeObject:_colorHTMLCategory forKey:@"colorHTMLCategory"];
     [coder encodeObject:_pinLegendCategory forKey:@"pinLegendCategory"];
     [coder encodeObject:_polygonColorCategory forKey:@"polygonColorCategory"];
     [coder encodeObject:_polygonBackgroundColorCategory forKey:@"polygonBackgroundColorCategory"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _colorPinsCategory = [coder decodeObjectForKey:@"colorPinsCategory"];
    _colorHTMLCategory = [coder decodeObjectForKey:@"colorHTMLCategory"];
    _pinLegendCategory = [coder decodeObjectForKey:@"pinLegendCategory"];
    _polygonColorCategory = [coder decodeObjectForKey:@"polygonColorCategory"];
    _polygonBackgroundColorCategory = [coder decodeObjectForKey:@"polygonBackgroundColorCategory"];
    return self;
}

@end
