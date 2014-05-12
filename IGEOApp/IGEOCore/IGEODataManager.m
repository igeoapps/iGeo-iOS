//
//  IGEODataManager.m
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODataManager.h"
#import "IGEOSource.h"
#import "IGEOCategory.h"
#import "IGEOConfigsManager.h"
#import "IGEOJSONServerReader.h"
#import "IGEODataItemsCache.h"
#import "IGEOUtils.h"

@implementation IGEODataManager

#pragma mark - Variáveis estáticas

//Indica qual a fonte que está a ser atualmente utilizada
static IGEOSource *actualSource;

//dicionário que faz corresponder a cada categoria o seu ID
static NSMutableDictionary *localHashMapCategories;

//dicionário que faz corresponder a cada item que está atualmente carregado o seu ID
static NSMutableDictionary *localHashMapDataItems;

//esta lista é utilizada para que exista um rápido acesso aos itens sem ter de
//transformar o dicionário a cada vez que queremos obter um iten desta mesma lista
static NSMutableArray *temporaryDataItemsList;

//código do distrito, concelho e freguesia que estamos a utilizar na pesquisa no caso de estarmos no explore
static NSString *codDist;
static NSString *codConc;
static NSString *codPar;
static NSString *keywords;

//este array é utilizado para guardar o ID das fontes nas quais é possivel desenhar polígonos. Isto é-nos util no momento
// de fazer o parsing da lista de itens, de forma a que não ocorram erros na leitura das coordenadas gps dos pontos
static NSMutableArray *nonDrawPolygonSources;

//Token utilizado para acesso ao servidor
//Este token deve ser alterado para o token de desenvolvimento obtido no registo.
static const NSString *TOKEN = @"A45E9DBA-0AD4-4A1B-AEBD-ED9E58FDF2F0";

static const NSString *PREFERENCE_VAR_KEY = @"IGEO_data_items_search_radius";




#pragma mark - acesso às variáveis estáticas
+(IGEOSource *) actualSource
{
    return actualSource;
}

+(NSMutableDictionary *) localHashMapCategories
{
    if(localHashMapCategories == nil){
        localHashMapCategories = [[NSMutableDictionary alloc] init];
    }
    
    return localHashMapCategories;
}

+(NSMutableDictionary *) localHashMapDataItems
{
    if(localHashMapDataItems == nil){
        localHashMapDataItems = [[NSMutableDictionary alloc] init];
    }
    
    return localHashMapDataItems;
}

+(NSMutableArray *) temporaryDataItemsList
{
    if(temporaryDataItemsList == nil){
        temporaryDataItemsList = [[NSMutableArray alloc] init];
    }
    
    return temporaryDataItemsList;
}

+(NSString *) codDist
{
    if(codDist == nil){
        
    }
    
    return codDist;
}

+(NSString *) codConc
{
    if(codConc == nil){
        
    }
    
    return codConc;
}

+(NSString *) codPar
{
    if(codPar == nil){
        
    }
    
    return codPar;
}

+(NSString *) keywords
{
    if(keywords == nil){
        
    }
    
    return keywords;
}

+(NSMutableArray *) nonDrawPolygonSources
{
    if(nonDrawPolygonSources == nil){
        nonDrawPolygonSources = [[NSMutableArray alloc] init];
    }
    
    return nonDrawPolygonSources;
}







#pragma mark - Sources
//sources --------------------------------------------------------
/**
 Obtém o nome de uma fonte dado o seu ID
 */
+(NSString *) getSourceName:(NSString *) srcID
{
    if([[IGEOConfigsManager getAppConfigs] appSourcesHashMap] != nil){
        return [((IGEOSource *) [[[IGEOConfigsManager getAppConfigs] appSourcesHashMap] objectForKey:srcID]) sourcename];
    }
    
    return nil;
}


/**
 Obtém a lista de fontes
 */
+(void) getSourcesList
{
    //tem de ir às configs da app
    if([[IGEOConfigsManager getAppConfigs] appSourcesHashMap] != nil){
        [IGEOJSONServerReader setTemporarySources:[[[[IGEOConfigsManager getAppConfigs] appSourcesHashMap] allValues] mutableCopy]];
    }
    else {
        [IGEOJSONServerReader readJSONSourcesFromServer:[[[IGEOConfigsManager getAppConfigs] URLRequestsSources] stringByAppendingString:[NSString stringWithFormat:@"&token=%@", TOKEN]] clear:YES];
    }
}


+(IGEOSource *) getActualSource;
{
    return actualSource;
}


+(void) setACtualSource:(IGEOSource *) s
{
    actualSource = s;
}


+(void) clearActualSource
{
    actualSource = nil;
    if(localHashMapCategories!=nil)
        [localHashMapCategories removeAllObjects];
}

//sources --------------------------------------------------------








#pragma mark - categories
//categories ---------------------------------------------------------------------
/**
 Obtém a lista de categorias que está neste momento a ser utilizada
 */
+(NSMutableArray *) getCategoriesListIDActualSource;
{
    if(actualSource!=nil){
        return [[[actualSource categoryDictionary] allValues] mutableCopy];
    }
    
    return nil;
}


/**
 Obtém uma string em que temos o ID de cada categoria que está a ser utilizada, separadas por virgula.
 Isto é útil na criação do url utilizado para consulta de dados ao servidor em que queremos passar como argumento
 as categorias para a filtragem.
 */
+(NSString *) getCategoriesIDListActualSource;
{
    NSString *result = @"";
    if(actualSource!=nil){
        for(IGEOCategory *c in [[[actualSource categoryDictionary] allValues] mutableCopy]){
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@;",c.categoryID]];
        }
        
        return result;
    }
    
    return nil;
}


/**
 Obtém a lista de categorias num raio pré-definido, e tendo como centro a localização passada como argumento.
 A obtenção dos dados é feita através da leitura de um JSON.
 */
+(void) getCategoriesListActualSourceInLocation:(CLLocation *) l
{
    NSString *url = [IGEOConfigsManager getAppConfigs].URLRequestsCategories;
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&sid=%@&lat=%f&lon=%f&r=%d&token=%@",
                                        [IGEODataManager getActualSource].sourceID,
                                        l.coordinate.latitude,
                                        l.coordinate.longitude,
                                        (int) [IGEODataManager getRadius],
                                        TOKEN
                                        ]];
    
    [IGEOJSONServerReader readJSONCategoriesFromServer:url];
}


/**
 Obtém a lista de categorias na área de pesquisa atual, isto é, no distrito, concelho e freguesia escolhidos na filtragem do explore.
 A obtenção dos dados é feita através da leitura de um JSON.
 */
+(void) getCategoriesListActualSourceInSearchLocation
{
    
    NSString *url = [IGEOConfigsManager getAppConfigs].URLRequestsCategories;
    
    NSString *ine = nil;
    if(codPar!=nil){
        if(![codPar isEqualToString:@""])
            ine = codPar;
        else
            ine = codConc;
    }
    else {
        ine = codConc;
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&sid=%@&ine=%@&token=%@",
                                        [IGEODataManager getActualSource].sourceID,
                                        ine,
                                        TOKEN]];
    
    [IGEOJSONServerReader readJSONCategoriesFromServer:url];
}


/**
 Obtém a lista de categorias pelas quais estamos neste momento a fazer a filtragem.
 */
+(NSMutableArray *) getActualCategoriesListActualFilter
{
    if(localHashMapCategories!=nil){
        return [[localHashMapCategories allValues] mutableCopy];
    }
    
    return nil;
}

/**
 Retorna a lista de ID's das categorias que estão atualmente a ser utilizadas na filtragem.
 */
+(NSMutableArray *) getActualCategoriesListActualFilterIDS
{
    if(localHashMapCategories!=nil){
        return [[localHashMapCategories allKeys] mutableCopy];
    }
    
    return nil;
}


/**
 Verifica se estamos a filtrar pela categoria passada como argumento.
 */
+(BOOL) isFilteringByCategory:(IGEOCategory *) c
{
    if(localHashMapCategories==nil){
        return false;
    }
    
    return ([localHashMapCategories objectForKey:c] != nil);
}


/**
 Devolve a lista de categoria para uma fonte.
 */
+(NSArray *) getCategoriesForSourceID:(NSString *) sourceID
{
    IGEOSource *selectedSource = [[[IGEOConfigsManager getAppConfigs] appSourcesHashMap]objectForKey:sourceID];
    if(selectedSource!=nil){
        return [IGEODataManager sortCategoriesByID:[[selectedSource.categoryDictionary allValues] mutableCopy]];
    }
    
    return nil;
}

/**
 Este método permite a ordenação das categorias pelo seu ID. Isto é importante dado que pretendemos que as categorias sejam apresentadas
 pela ordem com que vêm do servidor.
 */
+(NSMutableArray *) sortCategoriesByID:(NSMutableArray *) categories
{
    for(int i=1; i <= [categories count]; i++){
        int x = i - 1;
        int y = i;
        
        
        while(y!=0 && y!=[categories count] && [((IGEOCategory *) [categories objectAtIndex:x]) compareID:((IGEOCategory *) [categories objectAtIndex:y]).categoryID]==1){
            
            IGEOCategory *tmp = ((IGEOCategory *) [categories objectAtIndex:x]);
            [categories removeObjectAtIndex:x];
            [categories insertObject:tmp atIndex:y];
            x--;
            y--;
            
            tmp = nil;
        }
        
    }
    
    return categories;
}


/**
 Obtém a lista de categorias pelas quais estamos a filtrar, ordenadas pelo seu ID.
 */
+(NSArray *) getFilterCategories
{
    if(localHashMapCategories!=nil){
        return [IGEODataManager sortCategoriesByID:[[localHashMapCategories allValues] mutableCopy]];
    }
    
    return nil;
}


/**
 Adiciona uma categoria à filtragem atual.
 */
+(void) addActualCategory:(IGEOCategory *) cat
{
    if(localHashMapCategories==nil)
        localHashMapCategories = [[NSMutableDictionary alloc] init];
    
    [localHashMapCategories setObject:cat forKey:cat.categoryID];
}


/**
 Remove uma categoria da filtragem atual.
 */
+(void) removeActualCategory:(NSString *) catID
{
    [localHashMapCategories removeObjectForKey:catID];
}


/**
 Define a lista de categorias da filtragem atual passando como argumento um array com as mesmas.
 */
+(void) setLocalCurrentFilterCategories:(NSArray *) categories
{
    if(localHashMapCategories==nil)
        localHashMapCategories = [[NSMutableDictionary alloc] init];
    
    
    for(IGEOCategory *c in categories){
        [localHashMapCategories setObject:c forKey:c.categoryID];
    }
}


/**
 Obtém a lista de categorias pelas quais estamos a fazer a filtragem.
 */
+(NSMutableArray *) getCurrentFilterCategories
{
    if(localHashMapCategories!=nil)
    {
        return [[localHashMapCategories allValues] mutableCopy];
    }
    
    return nil;
}


/**
 Limpa a lista de categorias pelas quais está a ser feita a filtragem.
 */
+(void) clearCurrentFilterCategories
{
    if(localHashMapCategories!=nil)
    {
        [localHashMapCategories removeAllObjects];
    }
}


/**
 Obtém o código correspondente ao ine do distrito, concelho e freguesia que estamos a utilizar para a filtragem do explore.
 */
+(NSString *) getIne
{
    NSString *ine = nil;
    if(codPar!=nil){
        if(![codPar isEqualToString:@""])
            ine = codPar;
        else
            ine = codConc;
    }
    else {
        ine = codConc;
    }
    
    return ine;
}

//categories ---------------------------------------------------------------------













#pragma mark - dados
//dados ----------------------------------------------------------------------------------------------------------------------------------------------------------
/**
 Obtém a lista de itens para uma dada fonte, categoria numa determinada localização.
 */
+(void) getListForSource:(NSString *) srcID AndCategories:(NSArray *) catIDList Near:(CLLocation *) loc
{
    NSString *url = [IGEOConfigsManager getAppConfigs].URLRequests;
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&sid=%@&cats=", srcID]];
    
    for(NSString *catID in catIDList){
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@;", catID]];
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&lat=%f&lon=%f&r=%d&nr=0&token=%@&txt=", loc.coordinate.latitude, loc.coordinate.longitude, (int) [IGEODataManager getRadius], TOKEN]];
    
    if([IGEODataManager keywords]!=nil){
        url = [[url stringByAppendingString:[[IGEODataManager keywords] stringByReplacingOccurrencesOfString:@" " withString:@"+"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [IGEOJSONServerReader readJSONDataItemsFromServer:url];
}


/**
 Obtém a lista de itens para uma dada fonte, categoria numa determinada localização, utilizando a filtragem por palavras chave.
 */
+(void) getListForSource:(NSString *) srcID AndCategories:(NSArray *) catIDList Near:(CLLocation *) loc Filtered:(NSString *) filters
{
    NSString *url = [IGEOConfigsManager getAppConfigs].URLRequests;
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&sid=%@&cats=", srcID]];
    
    for(NSString *catID in catIDList){
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@;", catID]];
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&lat=%f&lon=%f&r=%d&nr=0&token=%@&txt=", loc.coordinate.latitude, loc.coordinate.longitude, (int) [IGEODataManager getRadius], TOKEN]];
    
    if(filters!=nil){
        keywords = filters;
        url = [[url stringByAppendingString:[[IGEODataManager keywords] stringByReplacingOccurrencesOfString:@" " withString:@"+"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [IGEOJSONServerReader readJSONDataItemsFromServer:url];
}


/**
 Obtém a lista de itens para uma dada fonte, categoria na localização selecionada na filtragem do explore.
 */
+(void) getListForSource:(NSString *) srcID AndCategoriesInSearchLocation:(NSArray *) catIDList
{
    NSString *url = [IGEOConfigsManager getAppConfigs].URLRequests;
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&sid=%@&cats=", srcID]];
    
    for(NSString *catID in catIDList){
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@;", catID]];
    }
    
    NSString *ine = nil;
    if(codPar!=nil){
        if(![codPar isEqualToString:@""])
            ine = codPar;
        else
            ine = codConc;
    }
    else {
        ine = codConc;
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&nr=0&ine=%@&token=%@&txt=", ine, TOKEN]];
    
    [IGEOJSONServerReader readJSONDataItemsFromServer:url];
}


/**
 Obtém a lista de itens para uma dada fonte, categoria na localização selecionada na filtragem do explore, utilizando a filtragem
 por palavras chave.
 */
+(void) getListForSource:(NSString *) srcID AndCategories:(NSArray *) catIDList InSearchLocationFiltered:(NSString *) filters
{
    NSString *url = [IGEOConfigsManager getAppConfigs].URLRequests;
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&sid=%@&cats=", srcID]];
    
    for(NSString *catID in catIDList){
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@;", catID]];
    }
    
    NSString *ine = nil;
    if(codPar!=nil){
        if(![codPar isEqualToString:@""])
            ine = codPar;
        else
            ine = codConc;
    }
    else {
        ine = codConc;
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&nr=0&ine=%@&token=%@&txt=", ine, TOKEN]];
    
    
    if(filters!=nil){
        keywords = filters;
        url = [[url stringByAppendingString:[[IGEODataManager keywords] stringByReplacingOccurrencesOfString:@" " withString:@"+"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [IGEOJSONServerReader readJSONDataItemsFromServer:url];
}


/**
 Obtém os detalhes de um item.
 */
+(void) getDataItemForID:(NSString *) ID
{
    if([IGEODataItemsCache getItem:ID]!=nil){
        [IGEOJSONServerReader setTemporaryDataItem:[IGEODataItemsCache getItem:ID]];
    }
    else {
        
        NSString *url = [IGEOConfigsManager getAppConfigs].URLRequests;
        
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&sdid=%@&token=%@", ID, TOKEN]];
        
        [IGEOJSONServerReader readJSONDataItemDetailsFromServer:url];
    }
    
    //adicionar à cache no método que recebe a notificação
}


/**
 Adiciona á lista dos itens temporários uma lista de itens passada como argumento.
 */
+(void) addTemporaryDataItems:(NSArray *) listDataItems
{
    if(localHashMapDataItems==nil)
        localHashMapDataItems = [[NSMutableDictionary alloc] init];
    
    for(IGEOGenericDataItem *di in listDataItems){
        [localHashMapDataItems setObject:di forKey:di.itemID];
    }
    
    temporaryDataItemsList = [listDataItems mutableCopy]; //[listDataItems mutableCopy];
}


/**
 Limpa a lista de itens temporários
 */
+(void) clearTemporaryDataItems
{
    if(localHashMapDataItems==nil)
        [localHashMapDataItems removeAllObjects];
    localHashMapDataItems = nil;
    
    if(temporaryDataItemsList!=nil)
        [temporaryDataItemsList removeAllObjects];
    temporaryDataItemsList = nil;
}


/**
 Obtém o hashmap com os data itens que estão a ser atualmente apresentados.
 */
+(NSMutableDictionary *) getLocalHashMapDataItems
{
    return localHashMapDataItems;
}


/**
 Obtém a mesma informação que o método anterior mas em lista.
 */
+(NSMutableArray *) getLocalListDataItems
{
    return temporaryDataItemsList;
}


/**
 Altera a localização usada na filtragem do explore.
 */
+(void) setLocationSearchDistrict:(NSString *) codDistrict council:(NSString *) codCouncil parish:(NSString *) codParish
{
    codDist = codDistrict;
    codConc = codCouncil;
    codPar = codParish;
    
    if([codDist length]<2){
        codDist = [NSString stringWithFormat:@"0%@",codDist];
        codConc = [NSString stringWithFormat:@"0%@",codConc];
        
        if(codPar!=nil)
            codPar = [NSString stringWithFormat:@"0%@",codPar];
    }
}


/**
 Obtém a localização utilizada no explore
 */
+(NSString *) getLocationSearch
{
    if(codDist!=nil)
        return [NSString stringWithFormat:@"%@%@%@", codDist, codConc, (codPar!=nil?codPar:@"")];
    else
        return nil;
}


/**
 Limpa a localização utilizada no explore.
 */
+(void) clearLocationSearch
{
    codDist = nil;
    codConc = nil;
    codPar = nil;
}


//Limpesa da informação dos distritos, concelhos e freguesias
+(void) clearDist
{
    codDist = nil;
}


+(void) clearConc
{
    codConc = nil;
}


+(void) clearPar
{
    codPar = nil;
}
//--


//Métodos relativos às palavras chave utilizadas na pesquisa
+(void) clearKeywords
{
    keywords = nil;
}


+(NSString *) getKeywords
{
    return keywords;
}


+(void) setKeywords:(NSString *) s
{
    keywords = s;
}
//--


/**
 Devolce o número de registos atualmente obtidos na pesquisa efetuada.
 */
+(int) getActualNumResults
{
    if(temporaryDataItemsList!=nil){
        return (int) [temporaryDataItemsList count];
    }
    else {
        return 0;
    }
}

//daods ----------------------------------------------------------------------------------------------------------------------------------------------------------




#pragma mark - obtenção de preferencias

/**
 Obtém o raio de pesquisa através das definições.
 */
+(double) getRadius
{
    NSUserDefaults *pref1=[NSUserDefaults standardUserDefaults];
    
    int keyInt = [[pref1 objectForKey:[NSString stringWithFormat:@"%@", PREFERENCE_VAR_KEY]] intValue];
    pref1 = nil;
    
    switch (keyInt) {
        case 0:
            return 1000.0;
            
        case 1:
            return 2000.0;
            
        case 2:
            return 5000.0;
            
        case 3:
            return 10000.0;
            
        default:
            return 10000.0;
            break;
    }
}



@end
