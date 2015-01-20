//
//  SQLiteMigrater.h
//  SQLiteManagerExample
//
//  Created by casa on 15/1/20.
//
//

#import <Foundation/Foundation.h>


@class SQLiteManager;

@interface SQLiteMigrater : NSObject

@property (nonatomic, strong) NSDictionary *migrateList;
@property (nonatomic, strong) NSArray *versionList;

- (BOOL)sqliteManagerShouldMigrate:(SQLiteManager *)manager;
- (void)sqliteManagerPerformMigrate:(SQLiteManager *)manager;

@end

@interface SQLiteManagerMigrateObject : NSObject

@property (nonatomic, strong) NSString *upSql;
@property (nonatomic, strong) NSString *downSql;

@end
