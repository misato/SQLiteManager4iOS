//
//  UntitledViewController.h
//  Untitled
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"


@interface UntitledViewController : UIViewController {

	SQLiteManager *dbManager;
	
	IBOutlet UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction) addTable;
- (IBAction) addUser;

@end

