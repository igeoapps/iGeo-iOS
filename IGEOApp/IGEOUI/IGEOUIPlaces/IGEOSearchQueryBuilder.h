//
//  IGEOSearchQueryBuilder.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum QueryParamType: NSUInteger{
    kNone, kDistrict, KCouncil, kParish, kSearching, kClean
} QueryParamType;


/**
 Esta classe define um parâmetro da pesquisa a efetuar na base de dados dos distritos, concelhos e freguesias.
 */
@interface IGEOSearchQueryBuilder : NSObject


/**
 Permite a utilização de uma instância estática da classe
 */
+(IGEOSearchQueryBuilder *)sharedEntitySearchQueryBuilder;

@property (nonatomic) QueryParamType queryType;

@property (copy, nonatomic) NSString * keywords;

@property (copy, nonatomic) NSString * district;
@property (nonatomic) NSInteger districtID;

@property (copy, nonatomic) NSString * council;
@property (nonatomic) NSInteger councilID;

@property (copy, nonatomic) NSString * parish;
@property (nonatomic) NSInteger parishID;

@property (nonatomic) Boolean GPSSearchEnabled;
@property (nonatomic) NSInteger GPSRange;



@end
