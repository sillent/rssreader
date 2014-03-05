//
//  AppDelegate.h
//  RSSreader
//
//  Created by Dmitry Ulyanov on 23.01.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) UINavigationController *uincont;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
