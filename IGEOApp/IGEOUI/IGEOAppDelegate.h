//
//  IGEOAppDelegate.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGEODownloadsConfigsThread.h"

/**
 Esta é a classe principal da aplicação e é aqui que se gerem questões mais diretas relativas à instancia da mesma.
 É aqui que corre a thread que recebe pedidos de atualização de items das configurações, bem como outras funcionalidades
 importantes.
 */
@interface IGEOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) IGEODownloadsConfigsThread *downloadConfigsThread;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
