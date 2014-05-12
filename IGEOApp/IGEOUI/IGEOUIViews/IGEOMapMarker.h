//
//  IGEOMapMarker.h
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 Esta classe é utilizada para representar um pin a colocar no mapa.
 A criação de uma classe customizada permite adicionar algumas informações necessárias e que não
 existem por defeito na classe IGEOMapMarker.
 */
@interface IGEOMapMarker : MKPinAnnotationView <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *resume;
@property (nonatomic, retain) NSString *itemID;
@property (nonatomic, retain) NSString *categoryID;

-(id) initWithItemID:(NSString *) ID categoryID:(NSString *) categoryID name:(NSString *) name resume:(NSString *) resume coordenates:(CLLocation *) loc;

@end
