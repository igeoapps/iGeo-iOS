//
//  IGEOHomeScreenConfigs.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOHomeScreenConfigs.h"

@implementation IGEOHomeScreenConfigs

@synthesize backgroundConf = _backgroundConf;
@synthesize urlTopImage = _urlTopImage;
@synthesize btns = _btns;
@synthesize subTitleBg = _subTitleBg;

-(id)init {
    if ( self = [super init] ) {
        _btns = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}


/**
 Obtém o título da imagem de fundo usada na home dado o ID de uma fonte.
 */
-(NSString *) getBackgroundImageForCategoryName:(NSString *) srcID
{
    if(_backgroundConf!=nil){
        if([_backgroundConf objectForKey:srcID] != nil){
            return [_backgroundConf objectForKey:srcID];
        }
    }
    
    return nil;
}


/**
 Obtém o url de cada um dos botões da home no seu modo normal.
 */
-(NSMutableArray *) getBtnsNormal
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:3];
    
    [result insertObject:((IGEOButtonElement *) [_btns objectAtIndex:0]).imageNormalConfigs atIndex:0];
    [result insertObject:((IGEOButtonElement *) [_btns objectAtIndex:1]).imageNormalConfigs atIndex:1];
    [result insertObject:((IGEOButtonElement *) [_btns objectAtIndex:2]).imageNormalConfigs atIndex:2];
    
    return result;
}


/**
 Obtém o url de cada um dos botões da home no seu modo selecionado.
 */
-(NSMutableArray *) getBtnsClicked
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:3];
    
    [result insertObject:((IGEOButtonElement *) [_btns objectAtIndex:0]).imageClickConfigs atIndex:0];
    [result insertObject:((IGEOButtonElement *) [_btns objectAtIndex:1]).imageClickConfigs atIndex:1];
    [result insertObject:((IGEOButtonElement *) [_btns objectAtIndex:2]).imageClickConfigs atIndex:2];
    
    return result;
}





/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilitar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_backgroundConf forKey:@"backgroundConf"];
    [coder encodeObject:_urlTopImage forKey:@"urlTopImage"];
    [coder encodeObject:_btns forKey:@"btns"];
    [coder encodeObject:_subTitleBg forKey:@"subTitleBg"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _backgroundConf = [coder decodeObjectForKey:@"backgroundConf"];
    _urlTopImage = [coder decodeObjectForKey:@"urlTopImage"];
    _btns = [coder decodeObjectForKey:@"btns"];
    _subTitleBg = [coder decodeObjectForKey:@"_ubTitleBg"];
    return self;
}

@end
