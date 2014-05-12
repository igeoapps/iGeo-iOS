//
//  IGEOLocationManager.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 Esta classe é utilizada para gerir questões relacionadas com localização atual. É através dela que vamos obter a localização
 atual a utilizar na funcionalidade "perto de mim".
 */
@interface IGEOLocationManager : NSObject<CLLocationManagerDelegate>

/**
 Gestor de localização utilizado para gerir a localização atual.
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 Localização atual.
 */
@property (nonatomic, strong) CLLocation *actualLocation;

/**
 Indica há quanto tempo a localização atual foi alterada. Isto é útil para que não estejam
 a fazer alterações de localização constantemente.
 */
@property (nonatomic) long lastChangeLocation;

/**
 Permite ter uma instância estática partilhada por todas as classes da App, o que se torna bastante útil.
 */
+(IGEOLocationManager *) sharedLocationManager;

-(void) initLocationListening;
-(void) startListeningLocation;
-(void) stopListeningLocation;

@end
