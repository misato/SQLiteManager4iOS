SQLite Manager for iOS
======================

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

Installation & Usage
--------------------

Just drag the two classes into your project. Also you need to import SQLite3 framework. Go to frameworks-> add existing framework->libsql3.dylib

To use an existing database, the full path is required:

```objc
NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"db"];
dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:dbPath];
```

The code is pretty self-explanatory so i hope you'll understand it.
If you have any doubts, don't hesitate to contact me at esanchez [at] misato [dot] es

You have also an usage example in SQLiteManagerExample directory.

