//
//  IGEOAppConfigs.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOAppConfigs.h"
#import "IGEOSource.h"

@implementation IGEOAppConfigs

@synthesize proximityRadius = _proximityRadius;
@synthesize appSourcesHashMap = _appSourcesHashMap;
@synthesize appName = _appName;
@synthesize appPackageName = _appPackageName;
@synthesize URLRequests = _URLRequests;
@synthesize URLRequestsSources = _URLRequestsSources;
@synthesize URLRequestsCategories = _URLRequestsCategories;
@synthesize URLRequestAppDefaults = _URLRequestAppDefaults;
@synthesize appColor = _appColor;

-(id)initWithAppName:(NSString *) name PackageName:(NSString *) pkName URLUpdate:(NSString *) URL {
    if ( self = [super init] ) {
        self.appName = name;
        self.appPackageName = pkName;
    }
    return self;
}



/**
 Recebe uma lista de fontes e coloca-as no respetivo dicionário indexadas pelo ID.
 */
-(void) setSourcesList:(NSArray *) list
{
    _appSourcesHashMap = [[NSMutableDictionary alloc] init];
    for(IGEOSource *s in list){
        [_appSourcesHashMap setObject:s forKey:s.sourceID];
    }
}


-(NSString *) description
{
    return [NSString stringWithFormat:@"AppConfigs: (Name: %@, PackageName: %@, URLRequests: %@, URLRequestsSources: %@, URLRequestsCategories: %@, AppColor: %@",
            _appName, _appPackageName, _URLRequests, _URLRequestsSources, _URLRequestsCategories, _appColor];
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:_proximityRadius forKey:@"proximityRadius"];
    [coder encodeObject:_appName forKey:@"appName"];
    [coder encodeObject:_appPackageName forKey:@"appPackageName"];
    [coder encodeObject:_URLRequests forKey:@"URLRequests"];
    [coder encodeObject:_URLRequestsSources forKey:@"URLRequestsSources"];
    [coder encodeObject:_URLRequestsCategories forKey:@"URLRequestsCategories"];
    [coder encodeObject:_URLRequestAppDefaults forKey:@"URLRequestAppDefaults"];
    [coder encodeObject:_appColor forKey:@"appColor"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _proximityRadius = [coder decodeIntForKey:@"proximityRadius"];
    _appName = [coder decodeObjectForKey:@"appName"];
    _appPackageName = [coder decodeObjectForKey:@"appPackageName"];
    _URLRequests = [coder decodeObjectForKey:@"URLRequests"];
    _URLRequestsSources = [coder decodeObjectForKey:@"URLRequestsSources"];
    _URLRequestsCategories = [coder decodeObjectForKey:@"URLRequestsCategories"];
    _URLRequestsCategories = [coder decodeObjectForKey:@"URLRequestsCategories"];
    _URLRequestAppDefaults = [coder decodeObjectForKey:@"URLRequestAppDefaults"];
    _appColor = [coder decodeObjectForKey:@"appColor"];
    return self;
}

@end
