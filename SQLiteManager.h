//
//  SQLiteManager.h
//  collections
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "SQLiteMigrater.h"

static NSString * const kSQLiteVersionTableName = @"ThisIsAStrangeVersionTableName";
static NSString * const kSQLiteVersionDefaultVersion = @"InitialVersion";

enum errorCodes {
	kDBNotExists,
	kDBFailAtOpen, 
	kDBFailAtCreate,
	kDBErrorQuery,
	kDBFailAtClose
};

@interface SQLiteManager : NSObject {

	sqlite3 *db; // The SQLite db reference
	NSString *databaseName; // The database name
}

// migrater related
@property (nonatomic, strong) SQLiteMigrater *migrator;
@property (nonatomic, copy, readonly) NSString *currentVersion;

- (id)initWithDatabaseNamed:(NSString *)name;

// SQLite Operations
- (NSError *) openDatabase;
- (NSError *) doQuery:(NSString *)sql;
- (NSError *)doUpdateQuery:(NSString *)sql withParams:(NSArray *)params;
- (NSArray *) getRowsForQuery:(NSString *)sql;
- (NSError *) closeDatabase;
- (NSInteger)getLastInsertRowID;

- (NSString *)getDatabaseDump;

@end
