//
//  UntitledViewController.m
//  Untitled
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import "UntitledViewController.h"

@implementation UntitledViewController

@synthesize textView;


- (IBAction) addTable {
	NSError *error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS users (id integer primary key autoincrement, user text, password text);"];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
	}
	
	NSString *dump = [dbManager getDatabaseDump];
	
	textView.text = dump;
	[textView setNeedsDisplay];
	
}

- (IBAction) addUser {
	
	int user = arc4random() % 9999;
	int pass = arc4random() % 9999;
	
	
	NSString *sqlStr = [NSString stringWithFormat:@"insert into users (user, password) values ('%d','%d');",user, pass];
	NSError *error = [dbManager doQuery:sqlStr];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
	}
	
	NSString *dump = [dbManager getDatabaseDump];
	
	textView.text = dump;
	[textView setNeedsDisplay];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"prueba.db"];
	NSString *dump = [dbManager getDatabaseDump];
	textView.text = dump;
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[dbManager release];
	[textView release];
}

@end
