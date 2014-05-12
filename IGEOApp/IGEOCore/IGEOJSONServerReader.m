//
//  IGEOJSONServerReader.m
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOJSONServerReader.h"
#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import <CoreLocation/CoreLocation.h>

#import "IGEOSource.h"
#import "IGEOCategory.h"
#import "IGEODataItem.h"
#import "IGEOGenericDataItem.h"
#import "IGEODataManager.h"
#import "IGEOConfigsManager.h"
#import "IGEOAppDelegate.h"
#import "IGEOFileUtils.h"

@implementation IGEOJSONServerReader

@synthesize errorJSON = _errorJSON;
@synthesize times = _times;

/**Variáveis estaticas nas quais vamos guardar os dados obtidos para as fontes, categorias que estamos atualmente a
   utilizar e itens.
   É de notar que esta informação é referente apenas à ultima pesquisa. 
 */
static NSArray *temporarySources;
static NSArray *temporaryCategories;
static NSMutableArray *temporaryDataItems;
static IGEODataItem *temporaryDataItem;


#pragma mark - Acesso a variáveis estáticas
//Métodos para acesso às variáveis estáticas acima indicadas
+(NSArray *) temporarySources
{
    return temporarySources;
}


+(NSArray *) temporaryCategories
{
    return temporaryCategories;
}


+(NSArray *) temporaryDataItems
{
    return temporaryDataItems;
}


+(IGEODataItem *) temporaryDataItem
{
    return temporaryDataItem;
}


+(void) setTemporarySources:(NSArray *) list
{
    temporarySources = list;
}


+(void) setTemporaryCategories:(NSArray *) list
{
    temporaryCategories = list;
}


+(void) setTemporaryDataItems:(NSArray *) list
{
    temporaryDataItems = nil;
}


+(void) setTemporaryDataItem:(IGEOGenericDataItem *) list
{
    temporaryDataItem = nil;
}


+(void) clearTemporarydataItems
{
    [temporaryDataItems removeAllObjects];
}
//--







#pragma mark - Leitura dos dados do servidor
/**
 Lê de um URL as configs por defeito, isto é, a imagem de fundo da lista e da home quando não temos outra
 imagem de fundo para apresentar.
 */
+(void) readJSONAppDefaultsFromServer:(NSString *) URL
{
    if(temporaryDataItems!=nil)
        [temporaryDataItems removeAllObjects];
    
    //NSLog(@"URL defaults = %@", URL);
    
    //cria o request
    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:SLRequestMethodPOST
                                                        URL:[NSURL URLWithString:URL]
                                                 parameters:nil];
    
    
    
    //Aqui vamos criar um request, que lança uma thread para a obtenção dos dados.
    //Definimos também o que acontece após essa operação terminar.
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSLog(@"SC=%li", (long)[urlResponse statusCode]);
        //se tivemos sucesso na resposta
		if ([urlResponse statusCode] == 200) {
			
            //Obtenção do JSONObject obtido como resposta da consulta ao servidor
			NSError *jsonParsingError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonParsingError];
            
            
            //iterar sobre o array de configurações
            for(NSDictionary *item in [jsonObject objectForKey:@"Theme"])
            {
                NSString *version = [item objectForKey:@"Version"];
                NSString *urlBgHome = [item objectForKey:@"homeimg"];
                NSString *urlBgList = [item objectForKey:@"listimg"];
                
                
                
                
                
                //Neste momento vamos verificar se a versão das configs para este item (configs por default) é maior que a
                //que temos atualmente guardada. E se sim, vamos atualizar o item e substituir a versão
                //Essas alterações, dado que requerem o download de imagens, são feitas em background através da thread
                //que é chamada no ConfigsManager.
                if(urlBgHome!=nil){
                    if(![urlBgHome isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForAppDefaults] < [version intValue]){
                            [IGEOConfigsManager changeBackgroundImageHomeDefaultUrl:urlBgHome];
                        }
                    }
                }
                
                if(urlBgList!=nil){
                    if(![urlBgList isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForAppDefaults] < [version intValue]){
                            [IGEOConfigsManager changeBackgroundImageListDefaultUrl:urlBgList];
                        }
                    }
                }
                
                [IGEOConfigsManager setVersionNumberForAppDefaults:[version intValue]];
                //--
                
                
                version = nil;
                urlBgHome = nil;
                urlBgList = nil;
            }
		}
		else {
            //temporarySources = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONError" object:self];
            return;
		}
        
        @try {
            //temporarySources = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishLoadAppDefaults" object:self];
        }
        @catch (NSException *err) {
            //temporarySources = nil;
            
            NSArray *backtrace = [err callStackSymbols];
            NSString *message = [NSString stringWithFormat:@"Backtrace:\n%@",
                                 backtrace];
            
            NSLog(@"error calling notification\n%@",message);
        }
        
	}];
	
    
    //NSLog(@"Search URL= %@, in object %@", URL, self);
    
}







/**
    Lê de um URL uma lista de fontes
 */
+(void) readJSONSourcesFromServer:(NSString *) URL clear:(BOOL) clear
{
    //o campo imgtype é importante pois é através do mesmo que o servidor sabe que tipo de imagens
    //deverá enviar, ou seja, o url das imagens que obtermos para alteração das configs dependerá sempre deste parâmetro.
    //Nas App's iOS deverá ser passado o valor "ios".
    URL = [URL stringByAppendingString:@"&imgtype=ios"];
    //NSLog(@"URL sources = %@", URL);
    
    if(clear){
    if(temporaryDataItems!=nil)
        [temporaryDataItems removeAllObjects];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    //cria o request
    //semelhante ao já explicado acima
    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodPOST
                                                           URL:[NSURL URLWithString:URL]
                                                    parameters:nil];
    
    
    
    //lança o request 
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        //NSLog(@"SC=%li", (long)[urlResponse statusCode]);
        //se tivemos sucesso na resposta
		if ([urlResponse statusCode] == 200) {
			// Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
			NSError *jsonParsingError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonParsingError];
            
            //iterar sobre o array de fontes
            for(NSDictionary *item in [jsonObject objectForKey:@"Sources"])
            {
                IGEOSource *s = [[IGEOSource alloc] init];
                s.sourceID = [item objectForKey:@"ID"];
                s.sourcename = [item objectForKey:@"Titulo"];
                s.imageURL = [item objectForKey:@"homeimg"];
                s.imageListURL = [item objectForKey:@"listimg"];
                s.srcSubtitle = [item objectForKey:@"Legenda"];
                
                NSString *version = [item objectForKey:@"Version"];
                
                
                
                
                
                //Atualiza as configurações caso a versão das mesmas seja inferior à que que foi recebida. Esta operação
                //encontra-se explicada em mais detalhe no método readJSONAppDefaultsFromServer.
                if(s.imageURL!=nil){
                    if(![s.imageURL isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForSource:s.sourceID] < [version intValue]){
                            [IGEOConfigsManager changeBackgroundImageHomeForSource:s.sourceID url:s.imageURL];
                        }
                    }
                }
                
                if(s.imageListURL!=nil){
                    if(![s.imageListURL isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForSource:s.sourceID] < [version intValue]){
                            [IGEOConfigsManager changeBackgroundImageListForSource:s.sourceID url:s.imageListURL];
                        }
                    }
                }
                
                [IGEOConfigsManager setVersionNumber:[version intValue] ForSource:s.sourceID];
                //--
                
                
                
                
                
                
                
                s.categoryDictionary = [[NSMutableDictionary alloc] init];
                
                //adicionar a lista de fontes em que não desenhamos poligonos
                //esta informação será útil posteriormente quando formos desenhar os pontos no mapa.
                if([[item objectForKey:@"DrawPolygon"] isEqualToString:@"True"]){
                    
                }
                
                //NSLog(@"adding source: %@",[s description]);
                
                //adicionar a source ao array
                [result addObject:s];
                
                version = nil;
            }
		}
        
        //De seguida estamos a usar o sistema de notificações internas da App para comunicar a ocorrência de erro ou de sucesso na
        //leitura dos dados. Para tal, no ViewController que chama este método, foi registado um "observer" que receberá esta notificação
        //e que fará o que for adequado a cada uma das situações.
		else {
            temporarySources = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONError" object:self];
            return;
		}
        
        @try {
            temporarySources = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishLoadSources" object:self];
        }
        @catch (NSException *err) {
            temporarySources = nil;
            
            NSArray *backtrace = [err callStackSymbols];
            NSString *message = [NSString stringWithFormat:@"Backtrace:\n%@",
                                 backtrace];
            
            NSLog(@"error calling notification:\n%@",message);
        }
        
	}];
	
    
    //NSLog(@"Search URL= %@, in object %@", URL, self);
    
}




/**
    Lê de um URL uma lista de categorias
 */
+(void) readJSONCategoriesFromServer:(NSString *) URL
{
    URL = [URL stringByAppendingString:@"&imgtype=ios"];
    //NSLog(@"URL categories = %@", URL);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    //cria o request
    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodPOST
                                                           URL:[NSURL URLWithString:URL]
                                                    parameters:nil];
    
    
    //lança o request 
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        //NSLog(@"SC=%li", (long)[urlResponse statusCode]);
        //se tivemos sucesso na resposta
		if ([urlResponse statusCode] == 200) {
            
			NSError *jsonParsingError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonParsingError];
            
            //iterar sobre o array de categorias
            for(NSDictionary *item in [jsonObject objectForKey:@"Categories"])
            {
                IGEOCategory *c = [[IGEOCategory alloc] init];
                c.categoryID = [item objectForKey:@"ID"];
                c.categoryName = [item objectForKey:@"Titulo"];
                c.icon = [item objectForKey:@"Icon"];
                c.iconSelected = [item objectForKey:@"IconSelected"];
                
                
                
                
                
                
                
                
                
                //Altera as configs de forma já explicada nos métodos anteriores
                NSString *colorHex = [item objectForKey:@"colorhex"];
                [IGEOConfigsManager changeTitleListColorForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID color:colorHex];
                [IGEOConfigsManager changePolygonLineColorForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID color:colorHex];
                [IGEOConfigsManager changePolygonBackgroundColorForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID color:colorHex];
                
                NSString *pinUrl = [item objectForKey:@"pinimg"];
                NSString *version = [item objectForKey:@"Version"];
                
                if(c.icon!=nil){
                    if(![c.icon isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID] < [version intValue]){
                            [IGEOConfigsManager changeCategoryIconNormalForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID url:c.icon];
                        }
                    }
                }
                
                if(c.iconSelected!=nil){
                    if(![c.iconSelected isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID] < [version intValue]){
                            [IGEOConfigsManager changeCategoryIconSelectedForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID url:c.iconSelected];
                        }
                    }
                }
                
                if(pinUrl!=nil){
                    if(![pinUrl isEqualToString:@""]){
                        if([IGEOConfigsManager getVersionNumberForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID] < [version intValue]){
                            [IGEOConfigsManager changePinMapImageForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID url:pinUrl];
                        }
                    }
                }
                
                [IGEOConfigsManager setVersionNumber:[version intValue] ForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID];
                
                pinUrl = nil;
                colorHex = nil;
                version = nil;
                //--
                
                
                
                
                
                
                
                //adicionar a categoria ao array
                [result addObject:c];
                
            }
		}
        
        //De seguida estamos a usar o sistema de notificações internas da App para comunicar a ocorrência de erro ou de sucesso na
        //leitura dos dados. Para tal, no ViewController que chama este método, foi registado um "observer" que receberá esta notificação
        //e que fará o que for adequado a cada uma das situações.
		else {
            temporaryCategories = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONError" object:self];
            return;
		}
        
        @try {
            temporaryCategories = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishLoadCategories" object:self];
        }
        @catch (NSException *err) {
            temporaryCategories = nil;
            
            NSArray *backtrace = [err callStackSymbols];
            NSString *message = [NSString stringWithFormat:@"Backtrace:\n%@",
                                 backtrace];
            
            NSLog(@"error calling notification:\n%@",message);
        }
        
	}];
	
    
    //NSLog(@"Search URL= %@, in object %@", URL, self);
    
}





/**
 Lê de um URL uma lista de dataitens.
 */
+(void) readJSONDataItemsFromServer:(NSString *) URL
{
    URL = [URL stringByAppendingString:@"&imgtype=ios"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    //lança o request
    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodPOST
                                                           URL:[NSURL URLWithString:URL]
                                                    parameters:nil];
    
    
    //cria o request de forma já explicada nos métodos anteriores.
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        //NSLog(@"SC=%li", (long)[urlResponse statusCode]);
        //se tivemos sucesso na resposta
		if ([urlResponse statusCode] == 200) {
            
			NSError *jsonParsingError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonParsingError];
            
            
            
            
            //iterar sobre o array de itens
            for(NSDictionary *item in [jsonObject objectForKey:@"Objects"])
            {
                IGEOGenericDataItem *di = [[IGEOGenericDataItem alloc] init];
                di.itemID = [item objectForKey:@"ID"];
                di.categoryID = [item objectForKey:@"CategoryID"];
                di.textOrHTML = [item objectForKey:@"Resumo"];
                di.title = [item objectForKey:@"Titulo"];
                di.imageURL = [item objectForKey:@"URL_Imagem"];
                
                //NSLog(@"init parse DataItem: %@",[di description]);
                
                
                
                
                
                
                
                
                
                
                
                
                //se é multipoligono
                NSString *isMultiPolygon = [item objectForKey:@"MultiPolygon"];
                int numPointsAdd = 0;
                
                if([isMultiPolygon isEqualToString:@"True"]){
                    
                    //ler centerpoint --> este ponto é usado para ser colocado no centro do poligono que iremos desenhar.
                    NSString *strCenterPoint = [item objectForKey:@"CenterPoint"];
                    NSRange rangeOfSpace = [strCenterPoint rangeOfString:@" "];
                    NSString *strLat = [strCenterPoint substringToIndex:rangeOfSpace.location-1];
                    NSString *strLng = [strCenterPoint substringFromIndex:rangeOfSpace.location+1];
                    strLat = [strLat stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    strLng = [strLng stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    
                    double cLat = [strLat floatValue];
                    double cLng = [strLng floatValue];
                    
                    //dado que por vezes recebemos do servidor as coordenadas trocadas, e dado que no nosso caso a latitude é sempre
                    //maior que zero, vamos utilizar essa verificação para conferir se devemos ou não trocar os valores da latitude e
                    //da longitude.
                    if(cLat<0){
						double tmp = cLat;
						cLat = cLng;
						cLng = tmp;
					}
                    
                    di.centerPoint = [[CLLocation alloc] initWithLatitude:cLat longitude:cLng];
                    
                    //NSLog(@"center point = (%f, %f)", cLat, cLng);
                    
                    
                    
                    
                    
                    //para previnir erros, só iremos obter mais coordenadas caso esta seja uma das fontes na qual é possível a existência
                    //de poligonos. Se sim, iremos então ler uma lista de pontos que formam esse mesmo poligono.
                    if(![[IGEODataManager nonDrawPolygonSources] containsObject:[IGEODataManager actualSource].sourceID]){
                        
                        //NSLog(@"!nonDrawPolygonSources");
                        
                        di.multiPolygon = YES;
                        di.lastPolygonCoordenates = [[NSMutableArray alloc] init];
                        
                        //O campo Gps é o campo que no JSON contém a lista de coordenadas do iten.
                        NSString *gpsDataInfo = [item objectForKey:@"Gps"];
                        
                        @try {
                            if(gpsDataInfo!=nil){
                                if(![gpsDataInfo isEqualToString:@""]){
                                    
                                    di.locationCoordenates = [[NSMutableArray alloc] init];
                                    
                                    //Vamos fazer o split da string através do caracter "|" dado que no caso dos multipolígonos os vários
                                    //polígonos são separados por esse caracter.
                                    NSArray *stMultiP = [gpsDataInfo componentsSeparatedByString:@"|"];
                                    
                                    //aqui vamos ler cada um dos polígonos
                                    for(NSString *stMultiPItem in stMultiP){
                                        
                                        //as coordenadas são recebidas separadas por um espaço, e dado isto vamos fazer o split da string
                                        //do polgono através desse cara´cter.
                                        NSArray *st = [stMultiPItem componentsSeparatedByString:@" "];
                                        int pos = 0;
                                        while(pos<[st count]){
                                            NSString *lat;
                                            NSString *lng;
                                            
                                            lat = [st objectAtIndex:pos++];
                                            
                                            if([lat isEqualToString:@""]){
                                                lat = [st objectAtIndex:pos++];
                                            }
                                            
                                            lng = [st objectAtIndex:pos++];
                                            
                                            //aqui vamos substituir a vírgula pelo ponto nos casos em que recebemos do servidor os valores
                                            //com um ponto em vez de vírgula
                                            NSRange latComaRange = [lat rangeOfString:@","];
                                            NSRange lngComaRange = [lat rangeOfString:@","];
                                            if(latComaRange.location!=NSNotFound && latComaRange.location==[lat length]-1){
                                                lat = [lat substringToIndex:latComaRange.location];
                                            }
                                            if(lngComaRange.location!=NSNotFound && lngComaRange.location==[lng length]-1){
                                                lng = [lng substringToIndex:lngComaRange.location];
                                            }
                                            
                                            lat = [lat stringByReplacingOccurrencesOfString:@"," withString:@"."];
                                            lng = [lng stringByReplacingOccurrencesOfString:@"," withString:@"."];
                                            
                                            double latitude = [lat floatValue];
                                            double longitude = [lng floatValue];
                                            
                                            [di.locationCoordenates addObject:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
                                            
                                            numPointsAdd++;
                                            
                                            lat = nil;
                                            lng = nil;
                                            
                                            
                                        }  //pontos
                                        
                                        //Este é um ponto muito importante, pois é através da adição no indice da coordenada a este array
                                        //que sabemos que a partir daquela coordenada vamos construir um outro poligono quando lermos as
                                        //próximas.
                                        [di.lastPolygonCoordenates addObject:[NSNumber numberWithInt:numPointsAdd]];
                                        
                                    }  //poligonos
                                    
                                    
                                    stMultiP = nil;
                                    
                                }
                                
                            }
                            
                        }
                        @catch (NSException *exception) {
                            //
                        }
                        
                        
                        gpsDataInfo = nil;
                        
                    }  //if
                    
                    
                    
                    //se não estamos numa fonte em que é possível desenhar polígonos, vamos apenas adicionar o ponto central que foi lido
                    //de inicio.
                    else {
                        //NSLog(@"nonDrawPolygonSources");
                        
                        di.locationCoordenates = [[NSMutableArray alloc] init];
                        [di.locationCoordenates addObject:di.centerPoint];
                    }
                    
                }
                
                
                
                
                //se não estamos num multipoligono
                else {
                    
                    NSString *isPolygon = [item objectForKey:@"Polygon"];
                    if([isPolygon isEqualToString:@"True"]){
                        
                        //ler centerpoint
                        NSString *strCenterPoint = [item objectForKey:@"CenterPoint"];
                        NSRange rangeOfSpace = [strCenterPoint rangeOfString:@" "];
                        NSString *strLat = [strCenterPoint substringToIndex:rangeOfSpace.location-1];
                        NSString *strLng = [strCenterPoint substringFromIndex:rangeOfSpace.location+1];
                        strLat = [strLat stringByReplacingOccurrencesOfString:@"," withString:@"."];
                        strLng = [strLng stringByReplacingOccurrencesOfString:@"," withString:@"."];
                        
                        double cLat = [strLat floatValue];
                        double cLng = [strLng floatValue];
                        
                        if(cLat<0){
                            double tmp = cLat;
                            cLat = cLng;
                            cLng = tmp;
                        }
                        
                        di.centerPoint = [[CLLocation alloc] initWithLatitude:cLat longitude:cLng];
                        
                        strCenterPoint = nil;
                        strLat = nil;
                        strLng = nil;
                    }
                    
                    
                    //Variável que contém a lista de coordenadas gps
                    NSString *gpsDataInfo = [item objectForKey:@"Gps"];
                    
                    gpsDataInfo = [gpsDataInfo stringByReplacingOccurrencesOfString:@"  " withString:@" "];
                    
                    @try {
                        if(gpsDataInfo!=nil){
                            if(![gpsDataInfo isEqualToString:@""]){
                                
                                di.locationCoordenates = [[NSMutableArray alloc] init];
                                
                                NSArray *st = [gpsDataInfo componentsSeparatedByString:@" "];
                                int pos = 0;
                                while(pos<[st count]){
                                    NSString *lat;
                                    NSString *lng;
                                    
                                    lat = [st objectAtIndex:pos++];
                                    
                                    lng = [st objectAtIndex:pos++];
                                    
                                    //substituição da virgula pot ponto como já foi anteriormente explicado
                                    NSRange latComaRange = [lat rangeOfString:@","];
                                    NSRange lngComaRange = [lng rangeOfString:@","];
                                    if(latComaRange.location!=NSNotFound && latComaRange.location==[lat length]-1){
                                        lat = [lat substringToIndex:latComaRange.location];
                                    }
                                    if(lngComaRange.location!=NSNotFound && lngComaRange.location==[lng length]-1){
                                        lng = [lng substringToIndex:lngComaRange.location];
                                    }
                                    
                                    lat = [lat stringByReplacingOccurrencesOfString:@"," withString:@"."];
                                    lng = [lng stringByReplacingOccurrencesOfString:@"," withString:@"."];
                                    
                                    double latitude = [lat floatValue];
                                    double longitude = [lng floatValue];
                                    
                                    if(latitude<0){
                                        double tmp = latitude;
                                        latitude = longitude;
                                        longitude = tmp;
                                    }
                                    
                                    [di.locationCoordenates addObject:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
                                    
                                    numPointsAdd++;
                                    
                                    lat = nil;
                                    lng = nil;
                                    
                                }  //pontos
                                
                            }
                        }
                    }
                    @catch (NSException *err) {
                        NSArray *backtrace = [err callStackSymbols];
                        NSString *message = [NSString stringWithFormat:@"Backtrace:\n%@",
                                             backtrace];
                        
                        NSLog(@"error parsing GPS coordenates:\n%@",message);
                        
                        backtrace = nil;
                        message = nil;
                    }
                    
                    
                    gpsDataInfo = nil;
                    
                }
                
                
                
                isMultiPolygon = nil;
                
                
                
                //adicionar o dataitem ao array
                [result addObject:di];
                
                di = nil;
            }
            
            
            jsonParsingError = nil;
            jsonObject = nil;
            
		}
        
        //dependendo de se ocorreu um erro ou não iremos fazer um post da notificação correspondente, para que o ViewController
        //que chamou este método saiba que ação tomar.
		else {
            temporaryDataItems = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONErrorDataItems" object:self];
            return;
		}
        
        @try {
            temporaryDataItems = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishLoadDataItems" object:self];
        }
        @catch (NSException *err) {
            temporaryDataItems = nil;
            
            NSArray *backtrace = [err callStackSymbols];
            NSString *message = [NSString stringWithFormat:@"Backtrace:\n%@",
                                 backtrace];
            
            NSLog(@"error calling notification:\n%@",message);
            
            backtrace = nil;
            message = nil;
        }
        
	}];
    
    
    postRequest = nil;
    
}





/**
    Lê os detalhes de um item
 */
+(void) readJSONDataItemDetailsFromServer:(NSString *) URL
{
    URL = [URL stringByAppendingString:@"&imgtype=ios"];
    
    IGEOGenericDataItem *result = [[IGEOGenericDataItem alloc] init];
    
    //cria o request
    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodPOST
                                                           URL:[NSURL URLWithString:URL]
                                                    parameters:nil];
    
    //Instancia o request como já explicado anteriormente
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        //NSLog(@"SC=%li", (long)[urlResponse statusCode]);
        //se tivemos sucesso na resposta
		if ([urlResponse statusCode] == 200) {
            
			NSError *jsonParsingError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonParsingError];
            
            result.itemID = [jsonObject objectForKey:@"ID"];
            result.categoryID = [jsonObject objectForKey:@"CategoryID"];
            result.textOrHTML = [jsonObject objectForKey:@"Detalhes"];
            result.title = [jsonObject objectForKey:@"Titulo"];
            result.imageURL = [jsonObject objectForKey:@"URL_Imagem"];
		}
		else {
            temporaryDataItem = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JSONErrorDataItemDatails" object:self];
            return;
		}
        
        @try {
            temporaryDataItem = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishLoadDataItemDatails" object:self];
        }
        @catch (NSException *err) {
            temporaryDataItem = nil;
            
            NSArray *backtrace = [err callStackSymbols];
            NSString *message = [NSString stringWithFormat:@"Backtrace:\n%@",
                                 backtrace];
            
            NSLog(@"error calling notification:\n%@",message);
        }
        
	}];
    
}

@end
