//
//  IGEOLocationManager.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOLocationManager.h"

@implementation IGEOLocationManager

@synthesize locationManager = _locationManager;
@synthesize actualLocation = _actualLocation;
@synthesize lastChangeLocation = _lastChangeLocation;

static IGEOLocationManager *_sharedLocationManager = nil;


#pragma mark - Singleton instantiation
+(IGEOLocationManager *) sharedLocationManager
{
	@synchronized([IGEOLocationManager class])
	{
		if (!_sharedLocationManager)
			return [[self alloc] init];
		return _sharedLocationManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([IGEOLocationManager class])
	{
		NSAssert(_sharedLocationManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedLocationManager = [super alloc];
		return _sharedLocationManager;
	}
    
	return nil;
}



/**
 Inicia o listener.
 */
-(void) initLocationListening
{
    
    NSLog(@"initLocationListening");
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
    
    _actualLocation = [_locationManager location];
}


/**
    Inicia a receção de alterações de localização.
 */
-(void) startListeningLocation
{
    NSLog(@"startListeningLocation");
    [_locationManager startUpdatingLocation];
}


/**
 Pára a receção de alterações de localização.
 */
-(void) stopListeningLocation
{
    NSLog(@"stopListeningLocation");
    [_locationManager stopUpdatingLocation];
}


/**
 Obtém a localização atual.
 */
-(CLLocation *) getActualLocation
{
    return _actualLocation;
}




#pragma mark - métodos do listener

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *) newLocation fromLocation:(CLLocation *) oldLocation
{
    CLLocation *tmpLoc = newLocation;
    
    _actualLocation = tmpLoc;
    
    _lastChangeLocation = [[NSDate date] timeIntervalSince1970];
    
    tmpLoc = nil;
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _actualLocation = nil;
}

@end
