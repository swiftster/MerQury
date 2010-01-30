//
//  DataViewController.m
//  QSync
//
//  Created by Jason Tratta on 1/3/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import "DataWindowController.h"
#import "QSyncController.h"



@implementation DataWindowController


- (void)windowDidLoad
{ 
	NSLog(@"Sorting");
	NSSortDescriptor *cueSort = [[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES] autorelease];
	NSArray *cueSortArray = [NSArray arrayWithObject:cueSort];
	[cuesController setSortDescriptors:cueSortArray];
	
}


- (DataWindowController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc
{
	self = [super initWithWindowNibName:@"DataWindow"];
	
	[self setManagedObjectContext:inMoc];

	return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)value
{
	// keep only weak ref
	moc = value;
}

- (NSManagedObjectContext *)managedObjectContext
{
	return moc;
}

-(IBAction)refreshData:(id)sender 
{ 
	[self allCuesSortedBySortID];
	
	
}


- (NSArray*)allCuesSortedBySortID
{
	NSLog(@"Sort Called");
	
	NSSortDescriptor *cueSort = [[NSSortDescriptor alloc] initWithKey:@"sortNumber"
															ascending:YES];
	NSArray *sorters = [NSArray arrayWithObject:cueSort];
	[cueSort release], cueSort = nil;
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setSortDescriptors:sorters];
	[request setEntity:[NSEntityDescription entityForName:@"Workspace"
								   inManagedObjectContext:moc]];
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:request 
										 error:&error];
	[request release], request = nil;
	if (error) {
		[NSApp presentError:error];
		return nil;
	}
	return [result sortedArrayUsingDescriptors:sorters];
}



@end