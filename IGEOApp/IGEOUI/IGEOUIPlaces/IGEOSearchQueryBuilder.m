//
//  IGEOSearchQueryBuilder.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOSearchQueryBuilder.h"

@implementation IGEOSearchQueryBuilder

@synthesize keywords = _keywords;


@synthesize queryType = _queryType;

@synthesize district = _district;
@synthesize districtID = _districtID;

@synthesize council = _council;
@synthesize councilID = _councilID;

@synthesize parish = _parish;
@synthesize parishID = _parishID;

@synthesize GPSSearchEnabled = _GPSSearchEnabled;
@synthesize GPSRange = _GPSRange;

static IGEOSearchQueryBuilder* _sharedEntitySearchQueryBuilder = nil;

#pragma mark - Singleton instantiation
+(IGEOSearchQueryBuilder *) sharedEntitySearchQueryBuilder
{
    @synchronized([IGEOSearchQueryBuilder class])
	{
		if (!_sharedEntitySearchQueryBuilder)
			return [[self alloc] init];
		return _sharedEntitySearchQueryBuilder;
	}
    
	return nil;
}


+(id)alloc
{
	@synchronized([IGEOSearchQueryBuilder class])
	{
		NSAssert(_sharedEntitySearchQueryBuilder == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedEntitySearchQueryBuilder = [super alloc];
		return _sharedEntitySearchQueryBuilder;
	}
    
	return nil;
}

-(id)init {
    //na inicialização vamos colocar o ID de todos os distritos, concelhos a freguesias a -1. Este será o valor utrilizado
    //para indicar que um ID não se encontra selecionado.
	self = [super init];
    
    self.queryType =kNone;
    
    self.keywords = @"";
    
    self.district = @"";
    self.districtID = -1;
    
    self.council = @"";
    self.councilID = -1;
    
    self.parish = @"";
    self.parishID = -1;
    
    self.GPSSearchEnabled =  false;
    self.GPSRange = 5;
    
	return self;
}


@end
