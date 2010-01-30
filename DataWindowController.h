//
//  DataViewController.h
//  QSync
//
//  Created by Jason Tratta on 1/3/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface DataWindowController : NSWindowController {
	

	NSManagedObjectContext *moc; 
	IBOutlet NSTreeController *cuesController; 
	
}



- (void)setManagedObjectContext:(NSManagedObjectContext *)value;
- (NSManagedObjectContext *)managedObjectContext;

- (DataWindowController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc;



- (NSArray*)allCuesSortedBySortID; 
-(IBAction)refreshData:(id)sender;




@end
