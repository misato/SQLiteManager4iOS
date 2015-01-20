//
//  SQLiteMigrater.m
//  SQLiteManagerExample
//
//  Created by casa on 15/1/20.
//
//

#import "SQLiteMigrater.h"
#import "SQLiteManager.h"

@implementation SQLiteMigrater

- (BOOL)sqliteManagerShouldMigrate:(SQLiteManager *)manager
{
    NSString *currentVersion = manager.currentVersion;
    NSUInteger index = [self.versionList indexOfObject:currentVersion];
    if (index == [self.versionList count] - 1) {
        return NO;
    }
    return YES;
}

- (void)sqliteManagerPerformMigrate:(SQLiteManager *)manager
{
    BOOL shouldPerformMigration = NO;
    NSArray *versionList = [self versionList];
    NSDictionary *migrationObjectContainer = [self migrateList];
    for (NSString *version in versionList) {
        if (shouldPerformMigration) {
            SQLiteManagerMigrateObject *object = migrationObjectContainer[version];
            NSError *error = [manager performSelector:@selector(executeQuery:) withObject:object.upSql];
            if (error) {
                [manager performSelector:@selector(executeQuery:) withObject:object.downSql];
                break;
            } else {
                [manager performSelector:@selector(modifyCurrentVersionWithVersionString:) withObject:version];
            }
        }
        
        if ([version isEqualToString:manager.currentVersion]) {
            shouldPerformMigration = YES;
        }
    }
}

@end

@implementation SQLiteManagerMigrateObject

- (NSString *)upSql
{
    if (_upSql == nil) {
        _upSql = @"";
    }
    return _upSql;
}

- (NSString *)downSql
{
    if (_downSql == nil) {
        _downSql = @"";
    }
    return _downSql;
}

@end
