//
//  MyMigrater.m
//  SQLiteManagerExample
//
//  Created by casa on 15/1/20.
//
//

#import "MyMigrater.h"
#import "SQLiteManager.h"

@implementation MyMigrater

@synthesize migrateList = _migrateList;
@synthesize versionList = _versionList;

#pragma mark - getters and setters
- (NSDictionary *)migrateList
{
    if (_migrateList == nil) {
        SQLiteManagerMigrateObject *migrate0_1 = [[SQLiteManagerMigrateObject alloc] init];
        migrate0_1.upSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);", kIGLocalStorageTableNameSystemMessage];
        migrate0_1.downSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;", kIGLocalStorageTableNameSystemMessage];
        
        SQLiteManagerMigrateObject *migrate0_2 = [[SQLiteManagerMigrateObject alloc] init];
        migrate0_2.upSql = [NSString stringWithFormat:@"INSERT INTO %@ (name) VALUES ('casa');", kIGLocalStorageTableNameSystemMessage];
        
        _migrateList = @{@"0.1":migrate0_1, @"0.2":migrate0_2};
    }
    return _migrateList;
}

- (NSArray *)versionList
{
    if (_versionList == nil) {
        _versionList = @[kSQLiteVersionDefaultVersion, @"0.1", @"0.2"];
    }
    return _versionList;
}

@end
