//
//  SQLiteManager.m
//  collections
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import "SQLiteManager.h"

// Private methods
@interface SQLiteManager (Private)

- (NSString *)getDatabasePath;
- (NSError *)createDBErrorWithDescription:(NSString*)description andCode:(int)code;

@end



@implementation SQLiteManager

#pragma mark Init & Dealloc

- (id)initWithDatabaseNamed:(NSString *)name; {
	self = [super init];
	if (self != nil) {
		databaseName = [[NSString alloc] initWithString:name];
		db = nil;
	}
	return self;	
}

- (void)dealloc {
	[super dealloc];
	if (db != nil) {
		[self closeDatabase];
	}
	[databaseName release];
}

#pragma mark SQLite Operations


/**
 * Open or create a SQLite3 database.
 *
 * If the db exists, then is opened and ready to use. If not exists then is created and opened.
 *
 * @return nil if everything was ok, an NSError in other case.
 *
 */

- (NSError *) openDatabase {
	
	NSError *error = nil;
	
	NSString *databasePath = [self getDatabasePath];
		
	const char *dbpath = [databasePath UTF8String];
	int result = sqlite3_open(dbpath, &db);
	if (result != SQLITE_OK) {
			const char *errorMsg = sqlite3_errmsg(db);
			NSString *errorStr = [NSString stringWithFormat:@"The database could not be opened: %@",[NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]];
			error = [self createDBErrorWithDescription:errorStr	andCode:kDBFailAtOpen];
	}
	
	return error;
}


/**
 * Does an SQL query. 
 *
 * You should use this method for everything but SELECT statements.
 *
 * @param sql the sql statement.
 *
 * @return nil if everything was ok, NSError in other case.
 */

- (NSError *)doQuery:(NSString *)sql {
	
	NSError *openError = nil;
	NSError *errorQuery = nil;
	
	//Check if database is open and ready.
	if (db == nil) {
		openError = [self openDatabase];
	}
	
	if (openError == nil) {		
		sqlite3_stmt *statement;	
		const char *query = [sql UTF8String];
		sqlite3_prepare_v2(db, query, -1, &statement, NULL);
		
		if (sqlite3_step(statement) == SQLITE_ERROR) {
			const char *errorMsg = sqlite3_errmsg(db);
			errorQuery = [self createDBErrorWithDescription:[NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]
													andCode:kDBErrorQuery];
		}
		sqlite3_finalize(statement);
		errorQuery = [self closeDatabase];
	}
	else {
		errorQuery = openError;
	}

	return errorQuery;
}

/**
 * Does a SELECT query and gets the info from the db.
 *
 * The return array contains an NSDictionary for row, made as: key=columName value= columnValue.
 *
 * For example, if we have a table named "users" containing:
 * name | pass
 * -------------
 * admin| 1234
 * pepe | 5678
 * 
 * it will return an array with 2 objects:
 * resultingArray[0] = name=admin, pass=1234;
 * resultingArray[1] = name=pepe, pass=5678;
 * 
 * So to get the admin password:
 * [[resultingArray objectAtIndex:0] objectForKey:@"pass"];
 *
 * @param sql the sql query (remember to use only a SELECT statement!).
 * 
 * @return an array containing the rows fetched.
 */

- (NSArray *)getRowsForQuery:(NSString *)sql {
	
	NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	if (db == nil) {
		[self openDatabase];
	}
	
	sqlite3_stmt *statement;	
	const char *query = [sql UTF8String];
	sqlite3_prepare_v2(db, query, -1, &statement, NULL);
	
	while (sqlite3_step(statement) == SQLITE_ROW) {
		int columns = sqlite3_column_count(statement);
		NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:1];

		for (int i = 0; i<columns; i++) {
			const char *name = sqlite3_column_name(statement, i);	

			NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			
			int type = sqlite3_column_type(statement, i);
			
			switch (type) {
				case SQLITE_INTEGER:
				{
					int value = sqlite3_column_int(statement, i);
					[result setObject:[NSNumber numberWithInt:value] forKey:columnName];
					break;
				}
				case SQLITE_FLOAT:
				{
					float value = sqlite3_column_int(statement, i);
					[result setObject:[NSNumber numberWithFloat:value] forKey:columnName];
					break;
				}
				case SQLITE_TEXT:
				{
					const char *value = (const char*)sqlite3_column_text(statement, i);
					[result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
					break;
				}
				
				case SQLITE_BLOB:
					break;
				case SQLITE_NULL:
					[result setObject:nil forKey:columnName];
					break;

				default:
				{
					const char *value = (const char *)sqlite3_column_text(statement, i);
					[result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
					break;
				}

			} //end switch
			
			
		} //end for
		
		[resultsArray addObject:result];
		[result release];

		
	} //end while
	sqlite3_finalize(statement);
	
	return resultsArray;
	
}


/**
 * Closes the database.
 *
 * @return nil if everything was ok, NSError in other case.
 */

- (NSError *) closeDatabase {
	
	NSError *error = nil;
	
	if (sqlite3_close(db) != SQLITE_OK){
		const char *errorMsg = sqlite3_errmsg(db);
		NSString *errorStr = [NSString stringWithFormat:@"The database could not be closed: %@",[NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]];
		error = [self createDBErrorWithDescription:errorStr andCode:kDBFailAtClose];
	}
	
	db = nil;
	
	return error;
}

@end


#pragma mark -
@implementation SQLiteManager (Private)

/**
 * Gets the database file path (in NSDocumentDirectory).
 *
 * @return the path to the db file.
 */

- (NSString *)getDatabasePath {
	
	// Get the documents directory
	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDir = [dirPaths objectAtIndex:0];
	
	return [docsDir stringByAppendingPathComponent:databaseName];
}

/**
 * Creates an NSError.
 *
 * @param description the description wich can be queried with [error localizedDescription];
 * @param code the error code (code erors are defined as enum in the header file).
 *
 * @return the NSError just created.
 *
 */

- (NSError *)createDBErrorWithDescription:(NSString*)description andCode:(int)code {
	
	NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil];
	NSError *error = [NSError errorWithDomain:@"SQLite Error" code:code userInfo:userInfo];
	[userInfo release];
	
	return error;
}

@end

