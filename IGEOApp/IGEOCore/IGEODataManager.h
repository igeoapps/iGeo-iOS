//
//  IGEODataManager.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOSource.h"
#import "IGEOJSONServerReader.h"
#import <CoreLocation/CLLocation.h>
#import "IGEOCategory.h"
#import "IGEOGenericDataItem.h"

/**
 * Esta classe é responsavel pela interação entre os dados e a UI. Nela estão definidos os métodos
 * necessários para a obtenção de dados das fontes, categorias e dos itens. É através desta classe que são
 * chamados os métodos de outras classes que por sua vez fazem consultas ao servidor quando necessário.
 * São ainda, quando aplicáveis, apresentados resultados contidos em atributos da classe. Isto é, existe um atributo para
 * a fonte atual, para as categorias pelas quais estamos a filtrar os dados, existe uma cache de itens que estao atualmente
 * a ser apresentados, entre outros.
 * Todos os métodos necessários para interagir com os dados a apresentar na aplicação encontram-se aqui.
 */
@interface IGEODataManager : NSObject

//Permite o acesso às variáveis estáticas
+(IGEOSource *) actualSource;
+(NSMutableDictionary *) localHashMapCategories;
+(NSMutableDictionary *) localHashMapDataItems;
+(NSMutableArray *) temporaryDataItemsList;
+(NSString *) codDist;
+(NSString *) codConc;
+(NSString *) codPar;
+(NSString *) keywords;
+(NSMutableArray *) nonDrawPolygonSources;

+(NSString *) getSourceName:(NSString *) srcID;
+(void) getSourcesList;
+(IGEOSource *) getActualSource;
+(void) setACtualSource:(IGEOSource *) s;
+(void) clearActualSource;

//Métodos relativos às categorias
+(void) getCategoriesListActualSourceInLocation:(CLLocation *) l;
+(void) getCategoriesListActualSourceInSearchLocation;
+(NSMutableArray *) getActualCategoriesListActualFilterIDS;
+(BOOL) isFilteringByCategory:(IGEOCategory *) c;
+(NSArray *) getCategoriesForSourceID:(NSString *) sourceID;
+(NSArray *) getFilterCategories;
+(void) addActualCategory:(IGEOCategory *) cat;
+(void) removeActualCategory:(NSString *) catID;
+(void) setLocalCurrentFilterCategories:(NSArray *) categories;
+(NSMutableArray *) getCurrentFilterCategories;
+(NSMutableArray *) getCategoriesListIDActualSource;
+(void) clearCurrentFilterCategories;

//Métodos relativos às fontes
+(void) getListForSource:(NSString *) srcID AndCategories:(NSArray *) catIDList Near:(CLLocation *) loc;
+(void) getListForSource:(NSString *) srcID AndCategories:(NSArray *) catIDList Near:(CLLocation *) loc Filtered:(NSString *) filters;
+(void) getListForSource:(NSString *) srcID AndCategoriesInSearchLocation:(NSArray *) catIDList;
+(void) getListForSource:(NSString *) srcID AndCategories:(NSArray *) catIDList InSearchLocationFiltered:(NSString *) filters;
+(void) getDataItemForID:(NSString *) ID;
+(void) addTemporaryDataItems:(NSArray *) listDataItems;
+(void) clearTemporaryDataItems;
+(NSMutableDictionary *) getLocalHashMapDataItems;
+(NSMutableArray *) getLocalListDataItems;
+(NSString *) getIne;


//Métodos relativos à escolha de localização para o explore
+(void) setLocationSearchDistrict:(NSString *) codDistrict council:(NSString *) codCouncil parish:(NSString *) codParish;
+(NSString *) getLocationSearch;
+(void) clearLocationSearch;
+(void) clearDist;
+(void) clearConc;
+(void) clearPar;
+(void) clearKeywords;
+(NSString *) getKeywords;
+(void) setKeywords:(NSString *) s;
+(int) getActualNumResults;
+(double) getRadius;




@end
