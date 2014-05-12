//
//  OADistritoViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOQueryParamsViewController.h"
#import <sqlite3.h>
#import "IGEOLocation.h"
#import "IGEOSearchQueryBuilder.h"
#import "IGEOPlaceCell.h"
#import "IGEOUtils.h"



@interface IGEOQueryParamsViewController ()



@end

@implementation IGEOQueryParamsViewController

/**
 Base de dados sqlite que contem a lista de distritos concelhos e freguesias.
 Esta base de dados será lida da pasta IGEODataBases.
 */
sqlite3 *regionsDB;

/**
 Path para o ficheiro que contém a base de dados
 */
NSString *databasePath;

NSMutableArray *tableItems;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    
    //obtenção da instância do objecto que constroi a query que será feita à base de dados.
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // diretoria de documentos
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    //Instruções para a instanciação da base de dados
    databasePath = [[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"sqlite"];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &regionsDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESC TEXT, OBS TEXT)";
            
            if (sqlite3_exec(regionsDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(regionsDB);
            
            errMsg = nil;
            sql_stmt = nil;
        } else {
            NSLog(@"Failed to open/create database");
        }
        
        dbpath = nil;
    }
    //-------------------------------------------------------------------------------------------
    
    
    //dependendo do tipo de pesquisa que estamos a fazer à base de dados vamos chamar o método correspondente
    switch (sqb.queryType) {
        case kDistrict:
            self.title = @"Distrito";
            [self getDistricts];
            break;
        case KCouncil:
            self.title = @"Concelho";
            [self getCouncils: (int) sqb.districtID];
            break;
        case kParish:
            self.title = @"Freguesia";
            [self getCouncils: (int) sqb.councilID];
            break;
            
            
        default:
            break;
    }
    
    
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:47.0f/255.0f green:55.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    sqb = nil;
    docsDir = nil;
    dirPaths = nil;
    filemgr = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 Obtém a lista de distritos.
 */
- (void) getDistricts
{
    
    tableItems = [[NSMutableArray alloc] init];
    
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &regionsDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM localizations WHERE length(ID)<=2"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(regionsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //adicionar o <selecionar>
            IGEOLocation *local = [[IGEOLocation alloc] initWithID:-1 name:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
            
            [tableItems addObject: local];
            
            while(sqlite3_step(statement) != SQLITE_DONE)
                //if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *f1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                int field1 = [f1 intValue];
                
                
                NSString *field2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                IGEOLocation *local = [[IGEOLocation alloc] initWithID:field1 name:field2];
                
                [tableItems addObject: local];
                
                f1 = nil;
                field2 = nil;
                local = nil;
                
            }
            
            [self.tableView reloadData];
            
            sqlite3_finalize(statement);
            
            local = nil;
        }
        sqlite3_close(regionsDB);
        
        querySQL = nil;
        query_stmt = nil;
    }
    
    dbpath = nil;
    statement = nil;
}


/**
 Obtém a lista de concelhos para um distrito ou a lista de freguesias para um conselho.
 */
-(void) getCouncils: (int) districtID
{
    tableItems = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &regionsDB) == SQLITE_OK)
    {
        NSString *querySQL = nil;
        if(districtID<100){
            querySQL = [NSString stringWithFormat: @"SELECT * FROM localizations WHERE parent LIKE \"%@\"",
                        (districtID>=10 ? [NSString stringWithFormat:@"%d",districtID] : [NSString stringWithFormat:@"0%d",districtID])];
        }
        else {
            querySQL = [NSString stringWithFormat: @"SELECT * FROM localizations WHERE parent LIKE \"%@\"",
                        (districtID>=1000 ? [NSString stringWithFormat:@"%d",districtID] : [NSString stringWithFormat:@"0%d",districtID])];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(regionsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //adicionar o <selecionar>
            IGEOLocation *local = [[IGEOLocation alloc] initWithID:-1 name:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
            
            [tableItems addObject: local];
            
            while(sqlite3_step(statement) != SQLITE_DONE)
            {
                NSString *f1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                int field1 = [f1 intValue];
                
                
                NSString *field2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                IGEOLocation *local = [[IGEOLocation alloc] initWithID:field1 name:field2];
                
                [tableItems addObject: local];
                
                f1 = nil;
                field2 = nil;
                local = nil;
            }
            
            [self.tableView reloadData];
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(regionsDB);
        
        querySQL = nil;
        query_stmt = nil;
    }
    
    dbpath = nil;
    statement = nil;
}





#pragma mark - métodos do UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IGEOPlaceCell";
    
    IGEOPlaceCell *cell = (IGEOPlaceCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IGEOPlaceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        nib = nil;
    }
    
    IGEOLocation *local = [tableItems objectAtIndex:indexPath.row] ;
    
    cell.textLabel.tag = local.ID;
    cell.tPlaceName.text = local.name;
    
    cell.textLabel.numberOfLines = 3;
    
    CellIdentifier = nil;
    local = nil;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    IGEOLocation *o = [tableItems objectAtIndex:indexPath.item];
    
    switch (sqb.queryType) {
        case kDistrict:
            if(o.ID != sqb.districtID){
                sqb.councilID = -1;
                sqb.council = @"Todos";
                sqb.parishID = -1;
                sqb.parish = @"Todos";
            }
            sqb.districtID = o.ID;
            sqb.district = o.name;
            break;
        case KCouncil:
            if(o.ID != sqb.councilID){
                sqb.parishID = -1;
                sqb.parish = @"Todos";
            }
            sqb.councilID = o.ID;
            sqb.council = o.name;
            break;
        case kParish:
            sqb.parishID = o.ID;
            sqb.parish = o.name;
            break;
            
            
        default:
            break;
    }
    
    [tableItems removeAllObjects];
    
    [[self navigationController] popViewControllerAnimated:YES];
    
    sqb = nil;
    o = nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


@end
