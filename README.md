*************************

 SQLITE MANAGER FOR IOS

*************************

SQLiteManager is a simple Class "wrapper" to use SQLite3 within iOS SDK.
It provides methods to:
- connect/create a database in your documents app folder
- do a simple query
- get rows in NSDictionary format
- close the connection
- dump your data in sql dump format

For the moment that's all ;) 

SQLiteManager is made by Ester Sanchez (aka misato) and it's free to use, modify and distribute. 
If you use it, don't forget to mention me as the original creator. 

Thanks and enjoy!

**********************

 INSTALLATION & USAGE

**********************

Just drag the two classes into your project. Also you need to import SQLite3 framework. Go to frameworks-> add existing framework->libsql3.dylib

To use an existing database, the full path is required:

```objc
NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"db"];
dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:dbPath];
```

The code is pretty self-explanatory so i hope you'll understand it.
If you have any doubts, don't hesitate to contact me at esanchez [at] misato [dot] es

You have also an usage example in SQLiteManagerExample directory.

**********************

 MIGRATION

**********************

If your app is version 0.1, and then you released version 0.2, and in version 0.2 you did modified the structure of database, so you have to migrate the old version database to a new version, SQLiteMigrater will help you to solve this issue :D

here is an example:

```objc

////////////////////////////////////////////////// MyMigrater.h

#import "SQLiteMigrater.h"

static NSString * const kIGLocalStorageTableNameSystemMessage = @"SystemMessage"; // this is your table name

@interface MyMigrater : SQLiteMigrater
@end


////////////////////////////////////////////////// MyMigrater.m

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

```

and you should set your instance of migrator after you created SQLiteManager:

```objc

dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"prueba.db"];
dbManager.migrator = [[MyMigrater alloc] init];

```

**********************

 HOW TO CREATE MIGRATER

**********************

1. inherit SQLiteMigrater

2. synthesize migrateList and versionList

3. write getter for `migrateList`

    3.1 the key is version string, and the value is instance of `SQLiteManagerMigrateObject`

    3.2 set upSql of `SQLiteManagerMigrateObject`, upSql is the SQL to do your change of new version.

    3.3 set downSql of `SQLiteManagerMigrateObject`, if upSql failed, migrater will run downSql to rollback. You don't have to set it

4. write getter for `versionList`

    4.1 the first one must be `kSQLiteVersionDefaultVersion`

    4.2 migrator will execute `SQLiteManagerMigrateObject` in the order of this versionList

5. make sure your `migrateList` is correct with `versionList`

6. instanciate your migrater and set it to your SQLiteManager:
```objc
dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"prueba.db"];
dbManager.migrator = [[MyMigrater alloc] init];
```

7. done!

