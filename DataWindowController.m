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

@synthesize appDelegate; 



- (DataWindowController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc appDelegate:(QSyncController *)delegate
{
	self = [super initWithWindowNibName:@"DataWindow"];
	
	appDelegate = delegate; 
	
	[self setManagedObjectContext:inMoc];

	return self;
}


- (void)windowDidLoad
{ 
	NSLog(@"Sorting");
	NSSortDescriptor *cueSort = [[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES] autorelease];
	NSArray *cueSortArray = [NSArray arrayWithObject:cueSort];
	[cuesController setSortDescriptors:cueSortArray];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(textDidEndEditing:) name:NSControlTextDidEndEditingNotification object:masterText];
	[nc addObserver:self selector:@selector(textChangedOne:) name:NSControlTextDidChangeNotification object:outputOne];
	[nc addObserver:self selector:@selector(textChangedTwo:) name:NSControlTextDidChangeNotification object:outputTwo];
	[nc addObserver:self selector:@selector(textChangedThree:) name:NSControlTextDidChangeNotification object:outputThree];
	[nc addObserver:self selector:@selector(textChangedFour:) name:NSControlTextDidChangeNotification object:outputFour];
	[nc addObserver:self selector:@selector(textChangedFive:) name:NSControlTextDidChangeNotification object:outputFive];
	[nc addObserver:self selector:@selector(textChangedSix:) name:NSControlTextDidChangeNotification object:outputSix];
	[nc addObserver:self selector:@selector(textChangedSeven:) name:NSControlTextDidChangeNotification object:outputSeven];
	[nc addObserver:self selector:@selector(textChangedEight:) name:NSControlTextDidChangeNotification object:outputEight];
	[nc addObserver:self selector:@selector(textChangedNine:) name:NSControlTextDidChangeNotification object:outputNine];
	[nc addObserver:self selector:@selector(textChangedTen:) name:NSControlTextDidChangeNotification object:outputTen];
	[nc addObserver:self selector:@selector(textChangedEleven:) name:NSControlTextDidChangeNotification object:outputEleven];
	[nc addObserver:self selector:@selector(textChangedTwelve:) name:NSControlTextDidChangeNotification object:outputTweleve];
	[nc addObserver:self selector:@selector(textChangedThirteen:) name:NSControlTextDidChangeNotification object:outputThirteen];
	[nc addObserver:self selector:@selector(textChangedFourteen:) name:NSControlTextDidChangeNotification object:outputFourteen];
	[nc addObserver:self selector:@selector(textChangedFifteen:) name:NSControlTextDidChangeNotification object:outputFifteen];
	[nc addObserver:self selector:@selector(textChangedSixteen:) name:NSControlTextDidChangeNotification object:outputSixteen];
	[nc addObserver:self selector:@selector(textChangedSeventeen:) name:NSControlTextDidChangeNotification object:outputSeventeen];
	[nc addObserver:self selector:@selector(textChangedEightteen:) name:NSControlTextDidChangeNotification object:outputEightteen];
	[nc addObserver:self selector:@selector(textChangedNineteen:) name:NSControlTextDidChangeNotification object:outputNineteen];
	[nc addObserver:self selector:@selector(textChangedTwenty:) name:NSControlTextDidChangeNotification object:outputTwenty];
	[nc addObserver:self selector:@selector(textChangedTwentyOne:) name:NSControlTextDidChangeNotification object:outputTwentyOne];
	[nc addObserver:self selector:@selector(textChangedTwentyTwo:) name:NSControlTextDidChangeNotification object:outputTwentyTwo];
	[nc addObserver:self selector:@selector(textChangedTwentyThree:) name:NSControlTextDidChangeNotification object:outputTwentyThree];
	[nc addObserver:self selector:@selector(textChangedTwentyFour:) name:NSControlTextDidChangeNotification object:outputTwentyFour];
	[nc addObserver:self selector:@selector(textChangedTwentyFive:) name:NSControlTextDidChangeNotification object:outputTwentyFive];
	[nc addObserver:self selector:@selector(textChangedTwentySix:) name:NSControlTextDidChangeNotification object:outputTwentySix];
	[nc addObserver:self selector:@selector(textChangedTwentySeven:) name:NSControlTextDidChangeNotification object:outputTwentySeven];
	[nc addObserver:self selector:@selector(textChangedTwentyEight:) name:NSControlTextDidChangeNotification object:outputTwentyEight];
	[nc addObserver:self selector:@selector(textChangedTwentyNine:) name:NSControlTextDidChangeNotification object:outputTwentyNine];
	[nc addObserver:self selector:@selector(textChangedThirty:) name:NSControlTextDidChangeNotification object:outputThirty];
	[nc addObserver:self selector:@selector(textChangedThirtyOne:) name:NSControlTextDidChangeNotification object:outputThirtyOne];
	[nc addObserver:self selector:@selector(textChangedThirtyTwo:) name:NSControlTextDidChangeNotification object:outputThirtyTwo];
	[nc addObserver:self selector:@selector(textChangedThirtyThree:) name:NSControlTextDidChangeNotification object:outputThirtyThree];
	[nc addObserver:self selector:@selector(textChangedThirtyFour:) name:NSControlTextDidChangeNotification object:outputThirtyFour];
	[nc addObserver:self selector:@selector(textChangedThirtyFive:) name:NSControlTextDidChangeNotification object:outputThirtyFive];
	[nc addObserver:self selector:@selector(textChangedThirtySix:) name:NSControlTextDidChangeNotification object:outputThirtySix];
	[nc addObserver:self selector:@selector(textChangedThirtySeven:) name:NSControlTextDidChangeNotification object:outputThirtySeven];
	[nc addObserver:self selector:@selector(textChangedThirtyEight:) name:NSControlTextDidChangeNotification object:outputThirtyEight];
	[nc addObserver:self selector:@selector(textChangedThirtyNine:) name:NSControlTextDidChangeNotification object:outputThirtyNine];
	[nc addObserver:self selector:@selector(textChangedFourty:) name:NSControlTextDidChangeNotification object:outputFourty];
	[nc addObserver:self selector:@selector(textChangedFourtyOne:) name:NSControlTextDidChangeNotification object:outputFourtyOne];
	[nc addObserver:self selector:@selector(textChangedFourtyTwo:) name:NSControlTextDidChangeNotification object:outputFourtyTwo];
	[nc addObserver:self selector:@selector(textChangedFourtyThree:) name:NSControlTextDidChangeNotification object:outputFourtyThree];
	[nc addObserver:self selector:@selector(textChangedFourtyFour:) name:NSControlTextDidChangeNotification object:outputFourtyFour];
	[nc addObserver:self selector:@selector(textChangedFourtyFive:) name:NSControlTextDidChangeNotification object:outputFourtyFive];
	[nc addObserver:self selector:@selector(textChangedFourtySix:) name:NSControlTextDidChangeNotification object:outputFourtySix];
	[nc addObserver:self selector:@selector(textChangedFourtySeven:) name:NSControlTextDidChangeNotification object:outputFourtySeven];
	[nc addObserver:self selector:@selector(textChangedFourtyEight:) name:NSControlTextDidChangeNotification object:outputFourtyEight];
	

	
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
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc postNotificationName:JATDataRefreshNotification object:self];
	
	
}


- (NSArray*)allCuesSortedBySortID
{
	NSLog(@"Sort Called");
	
	NSSortDescriptor *cueSort = [[NSSortDescriptor alloc] initWithKey:@"sortNumber"
															ascending:YES];
	NSArray *sorters = [NSArray arrayWithObject:cueSort];
	[cueSort release], cueSort = nil;
	
	NSManagedObjectContext *mocl = [self managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setSortDescriptors:sorters];
	[request setEntity:[NSEntityDescription entityForName:@"Workspace"
								   inManagedObjectContext:mocl]];
	NSError *error = nil;
	NSArray *result = [mocl executeFetchRequest:request 
										 error:&error];
	[request release], request = nil;
	if (error) {
		[NSApp presentError:error];
		return nil;
	}
	return [result sortedArrayUsingDescriptors:sorters];
}



-(IBAction)test:(id)sender
{
	
	
	
	
	NSArray *objectArray = [cuesController selectedObjects];
	
	NSLog(@"Array Count:%d", [objectArray count]);
	
	
	NSString *unID;
	
	unID = [[objectArray objectAtIndex:0]uniqueID];
	
	NSLog(@"ID is:%@", unID);
	
	
	
}


-(NSArray *)selectedCue 
{ 
	
	NSArray *objectArray = [cuesController selectedObjects];
	
	return objectArray; 
	
}	



#pragma mark Output TextFeild Change notifications 

- (void)textDidEndEditing:(NSNotification *)notification
{
	NSLog(@"Controller Text Field Edited");
	
}

- (void)textChangedOne:(NSNotification *)notification
{
	NSLog(@"Output 1 Text Field Edited");
	
	
	
	
}

- (void)textChangedTwo:(NSNotification *)notification
{
	NSLog(@"Output 2 Text Field Edited");
	
}
- (void)textChangedThree:(NSNotification *)notification
{
	NSLog(@"Output 3 Text Field Edited");
	
}

- (void)textChangedFour:(NSNotification *)notification
{
	NSLog(@"Output 4 Text Field Edited");
	
}

- (void)textChangedFive:(NSNotification *)notification
{
	NSLog(@"Output 5 Text Field Edited");
	
}
- (void)textChangedSix:(NSNotification *)notification
{
	NSLog(@"Output 6 Text Field Edited");
	
}

- (void)textChangedSeven:(NSNotification *)notification
{
	NSLog(@"Output 7 Text Field Edited");
	
}

- (void)textChangedEight:(NSNotification *)notification
{
	NSLog(@"Output 8 Text Field Edited");
	
}

- (void)textChangedNine:(NSNotification *)notification
{
	NSLog(@"Output 9 Text Field Edited");
	
}

- (void)textChangedTen:(NSNotification *)notification
{
	NSLog(@"Output 10 Text Field Edited");
	
}

- (void)textChangedEleven:(NSNotification *)notification
{
	NSLog(@"Output 11 Text Field Edited");
	
}

- (void)textChangedTwelve:(NSNotification *)notification
{
	NSLog(@"Output 12 Text Field Edited");
	
}
- (void)textChangedThirteen:(NSNotification *)notification
{
	NSLog(@"Output 13 Text Field Edited");
	
}

- (void)textChangedFourteen:(NSNotification *)notification
{
	NSLog(@"Output 14 Text Field Edited");
	
}

- (void)textChangedFifteen:(NSNotification *)notification
{
	NSLog(@"Output 15 Text Field Edited");
	
}

- (void)textChangedSixteen:(NSNotification *)notification
{
	NSLog(@"Output 16 Text Field Edited");
	
}


- (void)textChangedSeventeen:(NSNotification *)notification
{
	NSLog(@"Output 17 Text Field Edited");
	
}


- (void)textChangedEightteen:(NSNotification *)notification
{
	NSLog(@"Output 18 Text Field Edited");
	
}

- (void)textChangedNineteen:(NSNotification *)notification
{
	NSLog(@"Output 19 Text Field Edited");
	
}

- (void)textChangedTwenty:(NSNotification *)notification
{
	NSLog(@"Output 20 Text Field Edited");
	
}

- (void)textChangedTwentyOne:(NSNotification *)notification
{
	NSLog(@"Output 21 Text Field Edited");
	
}

- (void)textChangedTwentyTwo:(NSNotification *)notification
{
	NSLog(@"Output 22 Text Field Edited");
	
}

- (void)textChangedTwentyThree:(NSNotification *)notification
{
	NSLog(@"Output 23 Text Field Edited");
	
}

- (void)textChangedTwentyFour:(NSNotification *)notification
{
	NSLog(@"Output 24 Text Field Edited");
	
}


- (void)textChangedTwentyFive:(NSNotification *)notification
{
	NSLog(@"Output 25 Text Field Edited");
	
}

- (void)textChangedTwentySix:(NSNotification *)notification
{
	NSLog(@"Output 26 Text Field Edited");
	
}


- (void)textChangedTwentySeven:(NSNotification *)notification
{
	NSLog(@"Output 27 Text Field Edited");
	
}

- (void)textChangedTwentyEight:(NSNotification *)notification
{
	NSLog(@"Output 28 Text Field Edited");
	
}


- (void)textChangedTwentyNine:(NSNotification *)notification
{
	NSLog(@"Output 29 Text Field Edited");
	
}

- (void)textChangedThirty:(NSNotification *)notification
{
	NSLog(@"Output 30 Text Field Edited");
	
}

- (void)textChangedThirtyOne:(NSNotification *)notification
{
	NSLog(@"Output 31 Text Field Edited");
	
}

- (void)textChangedThirtyTwo:(NSNotification *)notification
{
	NSLog(@"Output 32 Text Field Edited");
	
}

- (void)textChangedThirtyThree:(NSNotification *)notification
{
	NSLog(@"Output 33 Text Field Edited");
	
}

- (void)textChangedThirtyFour:(NSNotification *)notification
{
	NSLog(@"Output 34 Text Field Edited");
	
}


- (void)textChangedThirtyFive:(NSNotification *)notification
{
	NSLog(@"Output 35 Text Field Edited");
	
}


- (void)textChangedThirtySix:(NSNotification *)notification
{
	NSLog(@"Output 36 Text Field Edited");
	
}

- (void)textChangedThirtySeven:(NSNotification *)notification
{
	NSLog(@"Output 37 Text Field Edited");
	
}



- (void)textChangedThirtyEight:(NSNotification *)notification
{
	NSLog(@"Output 38 Text Field Edited");
	
}

- (void)textChangedThirtyNine:(NSNotification *)notification
{
	NSLog(@"Output 39 Text Field Edited");
	
}

- (void)textChangedFourty:(NSNotification *)notification
{
	NSLog(@"Output 40 Text Field Edited");
	
}



- (void)textChangedFourtyOne:(NSNotification *)notification
{
	NSLog(@"Output 41 Text Field Edited");
	
}


- (void)textChangedFourtyTwo:(NSNotification *)notification
{
	NSLog(@"Output 42 Text Field Edited");
	
}

- (void)textChangedFourtyThree:(NSNotification *)notification
{
	NSLog(@"Output 43 Text Field Edited");
	
}

- (void)textChangedFourtyFour:(NSNotification *)notification
{
	NSLog(@"Output 44 Text Field Edited");
	
}



- (void)textChangedFourtyFive:(NSNotification *)notification
{
	NSLog(@"Output 45 Text Field Edited");
	
}

- (void)textChangedFourtySix:(NSNotification *)notification
{
	NSLog(@"Output 46 Text Field Edited");
	
}

- (void)textChangedFourtySeven:(NSNotification *)notification
{
	NSLog(@"Output 47 Text Field Edited");
	
}


- (void)textChangedFourtyEight:(NSNotification *)notification
{
	NSLog(@"Output 48 Text Field Edited");
	
}

















@end
