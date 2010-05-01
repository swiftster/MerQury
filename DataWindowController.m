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
	//NSLog(@"Sorting");
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLocal == FALSE"];
	//[serverController setFilterPredicate:predicate];
	//[workSpaceController setFilterPredicate:predicate];
	//[cueListController setFilterPredicate:predicate];
	[self sortByID];
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(textChangedMaster:) name:NSControlTextDidEndEditingNotification object:masterText];
	[nc addObserver:self selector:@selector(textChangedOne:) name:NSControlTextDidEndEditingNotification object:outputOne];
	[nc addObserver:self selector:@selector(textChangedTwo:) name:NSControlTextDidEndEditingNotification object:outputTwo];
	[nc addObserver:self selector:@selector(textChangedThree:) name:NSControlTextDidEndEditingNotification object:outputThree];
	[nc addObserver:self selector:@selector(textChangedFour:) name:NSControlTextDidEndEditingNotification object:outputFour];
	[nc addObserver:self selector:@selector(textChangedFive:) name:NSControlTextDidEndEditingNotification object:outputFive];
	[nc addObserver:self selector:@selector(textChangedSix:) name:NSControlTextDidEndEditingNotification object:outputSix];
	[nc addObserver:self selector:@selector(textChangedSeven:) name:NSControlTextDidEndEditingNotification object:outputSeven];
	[nc addObserver:self selector:@selector(textChangedEight:) name:NSControlTextDidEndEditingNotification object:outputEight];
	[nc addObserver:self selector:@selector(textChangedNine:) name:NSControlTextDidEndEditingNotification object:outputNine];
	[nc addObserver:self selector:@selector(textChangedTen:) name:NSControlTextDidEndEditingNotification object:outputTen];
	[nc addObserver:self selector:@selector(textChangedEleven:) name:NSControlTextDidEndEditingNotification object:outputEleven];
	[nc addObserver:self selector:@selector(textChangedTwelve:) name:NSControlTextDidEndEditingNotification object:outputTweleve];
	[nc addObserver:self selector:@selector(textChangedThirteen:) name:NSControlTextDidEndEditingNotification object:outputThirteen];
	[nc addObserver:self selector:@selector(textChangedFourteen:) name:NSControlTextDidEndEditingNotification object:outputFourteen];
	[nc addObserver:self selector:@selector(textChangedFifteen:) name:NSControlTextDidEndEditingNotification object:outputFifteen];
	[nc addObserver:self selector:@selector(textChangedSixteen:) name:NSControlTextDidEndEditingNotification object:outputSixteen];
	[nc addObserver:self selector:@selector(textChangedSeventeen:) name:NSControlTextDidEndEditingNotification object:outputSeventeen];
	[nc addObserver:self selector:@selector(textChangedEightteen:) name:NSControlTextDidEndEditingNotification object:outputEightteen];
	[nc addObserver:self selector:@selector(textChangedNineteen:) name:NSControlTextDidEndEditingNotification object:outputNineteen];
	[nc addObserver:self selector:@selector(textChangedTwenty:) name:NSControlTextDidEndEditingNotification object:outputTwenty];
	[nc addObserver:self selector:@selector(textChangedTwentyOne:) name:NSControlTextDidEndEditingNotification object:outputTwentyOne];
	[nc addObserver:self selector:@selector(textChangedTwentyTwo:) name:NSControlTextDidEndEditingNotification object:outputTwentyTwo];
	[nc addObserver:self selector:@selector(textChangedTwentyThree:) name:NSControlTextDidEndEditingNotification object:outputTwentyThree];
	[nc addObserver:self selector:@selector(textChangedTwentyFour:) name:NSControlTextDidEndEditingNotification object:outputTwentyFour];
	[nc addObserver:self selector:@selector(textChangedTwentyFive:) name:NSControlTextDidEndEditingNotification object:outputTwentyFive];
	[nc addObserver:self selector:@selector(textChangedTwentySix:) name:NSControlTextDidEndEditingNotification object:outputTwentySix];
	[nc addObserver:self selector:@selector(textChangedTwentySeven:) name:NSControlTextDidEndEditingNotification object:outputTwentySeven];
	[nc addObserver:self selector:@selector(textChangedTwentyEight:) name:NSControlTextDidEndEditingNotification object:outputTwentyEight];
	[nc addObserver:self selector:@selector(textChangedTwentyNine:) name:NSControlTextDidEndEditingNotification object:outputTwentyNine];
	[nc addObserver:self selector:@selector(textChangedThirty:) name:NSControlTextDidEndEditingNotification object:outputThirty];
	[nc addObserver:self selector:@selector(textChangedThirtyOne:) name:NSControlTextDidEndEditingNotification object:outputThirtyOne];
	[nc addObserver:self selector:@selector(textChangedThirtyTwo:) name:NSControlTextDidEndEditingNotification object:outputThirtyTwo];
	[nc addObserver:self selector:@selector(textChangedThirtyThree:) name:NSControlTextDidEndEditingNotification object:outputThirtyThree];
	[nc addObserver:self selector:@selector(textChangedThirtyFour:) name:NSControlTextDidEndEditingNotification object:outputThirtyFour];
	[nc addObserver:self selector:@selector(textChangedThirtyFive:) name:NSControlTextDidEndEditingNotification object:outputThirtyFive];
	[nc addObserver:self selector:@selector(textChangedThirtySix:) name:NSControlTextDidEndEditingNotification object:outputThirtySix];
	[nc addObserver:self selector:@selector(textChangedThirtySeven:) name:NSControlTextDidEndEditingNotification object:outputThirtySeven];
	[nc addObserver:self selector:@selector(textChangedThirtyEight:) name:NSControlTextDidEndEditingNotification object:outputThirtyEight];
	[nc addObserver:self selector:@selector(textChangedThirtyNine:) name:NSControlTextDidEndEditingNotification object:outputThirtyNine];
	[nc addObserver:self selector:@selector(textChangedFourty:) name:NSControlTextDidEndEditingNotification object:outputFourty];
	[nc addObserver:self selector:@selector(textChangedFourtyOne:) name:NSControlTextDidEndEditingNotification object:outputFourtyOne];
	[nc addObserver:self selector:@selector(textChangedFourtyTwo:) name:NSControlTextDidEndEditingNotification object:outputFourtyTwo];
	[nc addObserver:self selector:@selector(textChangedFourtyThree:) name:NSControlTextDidEndEditingNotification object:outputFourtyThree];
	[nc addObserver:self selector:@selector(textChangedFourtyFour:) name:NSControlTextDidEndEditingNotification object:outputFourtyFour];
	[nc addObserver:self selector:@selector(textChangedFourtyFive:) name:NSControlTextDidEndEditingNotification object:outputFourtyFive];
	[nc addObserver:self selector:@selector(textChangedFourtySix:) name:NSControlTextDidEndEditingNotification object:outputFourtySix];
	[nc addObserver:self selector:@selector(textChangedFourtySeven:) name:NSControlTextDidEndEditingNotification object:outputFourtySeven];
	[nc addObserver:self selector:@selector(textChangedFourtyEight:) name:NSControlTextDidEndEditingNotification object:outputFourtyEight];
	
	[nc addObserver:self selector:@selector(textChangedTable:) name:NSControlTextDidEndEditingNotification object:masterTable];
	[nc addObserver:self selector:@selector(textEditingTable:) name:NSControlTextDidBeginEditingNotification object:masterTable];
	[nc addObserver:self selector:@selector(textChangedTable:) name:NSControlTextDidEndEditingNotification object:notesField];
		
	
	
	

	
}

-(void)sortByID 
{ 
	NSSortDescriptor *cueSort = [[[NSSortDescriptor alloc] initWithKey:@"sortNumber" ascending:YES] autorelease];
	NSArray *cueSortArray = [NSArray arrayWithObject:cueSort];
	[cuesController setSortDescriptors:cueSortArray];
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
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLocal == NO"];
	[request setPredicate:predicate];
	
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

-(double)formatLevelText:(NSString *)string 
{ 
	
	NSString *negativeString = [NSString stringWithFormat:@"-"];
	NSString *fieldString = [NSString stringWithFormat:@"%@",string];
	NSLog(@"FString:%@",fieldString); 
	
	NSString *returnString = [negativeString stringByAppendingFormat:fieldString]; 
	NSLog(@"Returning:%f",[returnString doubleValue]);
	
	return [returnString doubleValue];
	

}

-(void)outlineViewSelectionDidChange:(NSNotification *)aNotification
{ 
	
	NSLog(@"Checking for Fade");
	
 
	
	if ([self isFade] == TRUE) { 
		[actionColumn setEditable:TRUE];  
	} else {
		[actionColumn setEditable:FALSE];
	}
	
	
}


-(BOOL)isFade 
{ 
	BOOL fade; 
	
	
	NSArray *array = [cuesController selectedObjects]; 
	
	
	NSArray *isFadeArray;
	isFadeArray = [array valueForKey:@"qType"]; 
	NSString *isFade; 
	isFade = [isFadeArray objectAtIndex:0]; 
	
	if ([isFade isEqualToString:@"Fade"] == TRUE) { 
		fade = TRUE;  
	} else {
		fade = FALSE;
	}

	return fade; 
}

-(void)textEditingTable:(NSNotification *)notification 
{ 
	//set the colomn and row being editied 
	

	
}

- (void)textChangedTable:(NSNotification *)notification
{
	
	
	NSArray *array; 
	NSString *unID; 
	int row = [masterTable editedRow];  
	int column = [masterTable editedColumn]; 
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	NSArray *arrayForName;
	NSString *newString; 
	
	
	arrayForName = [array valueForKey:@"qName"];
	newString = [arrayForName objectAtIndex:0]; 
	

	
	NSString *newNote = [notesField stringValue];
	
	NSArray *arrayPreWait = [array valueForKey:@"preWait"];
	NSArray *arrayPostWait = [array valueForKey:@"postWait"];
	
	NSString *preWaitString = [arrayPreWait objectAtIndex:0]; 
	NSString *postWaitString = [arrayPostWait objectAtIndex:0]; 
	
	NSNumber *pre = [self stringToDouble:preWaitString];
	//NSLog(@"Double is:%f",[q doubleValue]);
	
	NSNumber *post = [self stringToDouble:postWaitString];
	
	double j = [pre doubleValue]; 
	double t = [post doubleValue]; 
		
	[appDelegate sendCueNameChangeForID:unID inRow:row inColumn:column string:newString];
	[appDelegate sendNoteChangesForID:unID inRow:row inColumn:column string:newNote]; 
	[appDelegate sendPreWaitForID:unID db:j]; 
	[appDelegate sendPostWaitForID:unID db:t]; 
	

}


-(NSNumber *)stringToDouble:(NSString *)string
{ 
	
	
	NSString *noCol = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
	
	 
	NSString *mills = [noCol substringFromIndex:4]; 
	NSLog(@"Mills:%@",mills);

	NSRange secondsRange = NSMakeRange(2, 2); 
	NSString *seconds = [noCol substringWithRange:secondsRange]; 
	
	NSRange minutesRange = NSMakeRange(0, 2); 
	NSString *minutes = [noCol substringWithRange:minutesRange]; 
	
	
	
	double a = [mills doubleValue]; 
	double b = [seconds doubleValue]; 
	double c = [minutes doubleValue]; 
	
	//The Double returned is in seconds. 
	//Divide by 100 to get Milliseconds. 
	double d = a / 100; 

	double e = b + d; 
	 
	 
	//Convert minutes to Seconds
	double g = c * 60;  
	
	double h = g + e; 
	
	
	NSNumber *number = [NSNumber numberWithDouble:h]; 
	
	return number; 
	
	
	
}




#pragma mark Output TextFeild Change notifications 

- (void)textChangedMaster:(NSNotification *)notification
{
	
	
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 0;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	

	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[masterText doubleValue]];
	
	
}

- (void)textChangedOne:(NSNotification *)notification
{
	//NSLog(@"Output 1 Text Field Edited");
	
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 1;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputOne doubleValue]];
	
	
}

- (void)textChangedTwo:(NSNotification *)notification
{
	//NSLog(@"Output 2 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 2;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwo doubleValue]];
	
	
}
- (void)textChangedThree:(NSNotification *)notification
{
	//NSLog(@"Output 3 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 3;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThree doubleValue]];
	
	
}

- (void)textChangedFour:(NSNotification *)notification
{
	//NSLog(@"Output 4 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 4;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFour doubleValue]];
	
	
}

- (void)textChangedFive:(NSNotification *)notification
{
	//NSLog(@"Output 5 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 5;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFive doubleValue]];
	
	
}
- (void)textChangedSix:(NSNotification *)notification
{
	//NSLog(@"Output 6 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 6;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputSix doubleValue]];
	
	
}

- (void)textChangedSeven:(NSNotification *)notification
{
	//NSLog(@"Output 7 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 7;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputSeven doubleValue]];
	
	
}

- (void)textChangedEight:(NSNotification *)notification
{
	//NSLog(@"Output 8 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 8;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputEight doubleValue]];
	
	
}

- (void)textChangedNine:(NSNotification *)notification
{
	//NSLog(@"Output 9 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 9;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputNine doubleValue]];
	
	
}

- (void)textChangedTen:(NSNotification *)notification
{
	//NSLog(@"Output 10 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 10;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTen doubleValue]];
	
	
}

- (void)textChangedEleven:(NSNotification *)notification
{
	//NSLog(@"Output 11 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 11;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputEleven doubleValue]];
	
	
}

- (void)textChangedTwelve:(NSNotification *)notification
{
	//NSLog(@"Output 12 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 12;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTweleve doubleValue]];
	
	
}
- (void)textChangedThirteen:(NSNotification *)notification
{
	//NSLog(@"Output 13 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 13;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirteen doubleValue]];
	
	
}

- (void)textChangedFourteen:(NSNotification *)notification
{
	//NSLog(@"Output 14 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 14;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourteen doubleValue]];
	
	
}

- (void)textChangedFifteen:(NSNotification *)notification
{
	//NSLog(@"Output 15 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 15;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFifteen doubleValue]];
	
	
}

- (void)textChangedSixteen:(NSNotification *)notification
{
	//NSLog(@"Output 16 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 16;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputSixteen doubleValue]];
	
	
}


- (void)textChangedSeventeen:(NSNotification *)notification
{
	//NSLog(@"Output 17 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 17;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputSeventeen doubleValue]];
	
	
}


- (void)textChangedEightteen:(NSNotification *)notification
{
	//NSLog(@"Output 18 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 18;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputEightteen doubleValue]];
	
	
}

- (void)textChangedNineteen:(NSNotification *)notification
{
	//NSLog(@"Output 19 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 19;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputOne doubleValue]];
	
	
}

- (void)textChangedTwenty:(NSNotification *)notification
{
	//NSLog(@"Output 20 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 20;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwenty doubleValue]];
	
	
}

- (void)textChangedTwentyOne:(NSNotification *)notification
{
	//NSLog(@"Output 21 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 21;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyOne doubleValue]];
	
	
}

- (void)textChangedTwentyTwo:(NSNotification *)notification
{
	//NSLog(@"Output 22 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 22;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyTwo doubleValue]];
	
	
}

- (void)textChangedTwentyThree:(NSNotification *)notification
{
	//NSLog(@"Output 23 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 23;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyThree doubleValue]];
	
	
}

- (void)textChangedTwentyFour:(NSNotification *)notification
{
	//NSLog(@"Output 24 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 24;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyFour doubleValue]];
	
	
}


- (void)textChangedTwentyFive:(NSNotification *)notification
{
	//NSLog(@"Output 25 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 25;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyFive doubleValue]];
	
	
}

- (void)textChangedTwentySix:(NSNotification *)notification
{
	//NSLog(@"Output 26 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 26;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentySix doubleValue]];
	
}


- (void)textChangedTwentySeven:(NSNotification *)notification
{
	//NSLog(@"Output 27 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 28;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyEight doubleValue]];
	
	
}

- (void)textChangedTwentyEight:(NSNotification *)notification
{
	//NSLog(@"Output 28 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 28;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyEight doubleValue]];
	
}


- (void)textChangedTwentyNine:(NSNotification *)notification
{
	//NSLog(@"Output 29 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 29;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputTwentyNine doubleValue]];
	
	
}

- (void)textChangedThirty:(NSNotification *)notification
{
	//NSLog(@"Output 30 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 30;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirty doubleValue]];
	
	
}

- (void)textChangedThirtyOne:(NSNotification *)notification
{
	//NSLog(@"Output 31 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 31;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyOne doubleValue]];
	
	
}

- (void)textChangedThirtyTwo:(NSNotification *)notification
{
	//NSLog(@"Output 32 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 32;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyTwo doubleValue]];
	
	
}

- (void)textChangedThirtyThree:(NSNotification *)notification
{
	//NSLog(@"Output 33 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 33;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyThree doubleValue]];
	
}

- (void)textChangedThirtyFour:(NSNotification *)notification
{
	//NSLog(@"Output 34 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 34;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyFour doubleValue]];
	
}


- (void)textChangedThirtyFive:(NSNotification *)notification
{
	//NSLog(@"Output 35 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 35;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyFive doubleValue]];
	
	
}


- (void)textChangedThirtySix:(NSNotification *)notification
{
	//NSLog(@"Output 36 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 36;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtySix doubleValue]];
	
	
}

- (void)textChangedThirtySeven:(NSNotification *)notification
{
	//NSLog(@"Output 37 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 37;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtySeven doubleValue]];
	
}



- (void)textChangedThirtyEight:(NSNotification *)notification
{
	//NSLog(@"Output 38 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 38;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyEight doubleValue]];
	
	
}

- (void)textChangedThirtyNine:(NSNotification *)notification
{
	//NSLog(@"Output 39 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 39;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputThirtyNine doubleValue]];
	
}

- (void)textChangedFourty:(NSNotification *)notification
{
	//NSLog(@"Output 40 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 40;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourty doubleValue]];
	
}



- (void)textChangedFourtyOne:(NSNotification *)notification
{
	//NSLog(@"Output 41 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 41;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtyOne doubleValue]];
	
	
}


- (void)textChangedFourtyTwo:(NSNotification *)notification
{
	//NSLog(@"Output 42 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 42;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtyTwo doubleValue]];
	
	
}

- (void)textChangedFourtyThree:(NSNotification *)notification
{
	//NSLog(@"Output 43 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 43;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtyThree doubleValue]];
	
}

- (void)textChangedFourtyFour:(NSNotification *)notification
{
	//NSLog(@"Output 44 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 44;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtyFour doubleValue]];
	
}



- (void)textChangedFourtyFive:(NSNotification *)notification
{
	//NSLog(@"Output 45 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 45;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtyFive doubleValue]];
	
	
}

- (void)textChangedFourtySix:(NSNotification *)notification
{
	//NSLog(@"Output 46 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 46;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtySix doubleValue]];
	
	
}

- (void)textChangedFourtySeven:(NSNotification *)notification
{
	//NSLog(@"Output 47 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 47;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtySeven doubleValue]];
	
}


- (void)textChangedFourtyEight:(NSNotification *)notification
{
	//NSLog(@"Output 48 Text Field Edited");
	NSArray *array; 
	NSString *unID; 
	int row = 0; 
	int column = 48;
	
	array = [self selectedCue]; 
	unID = [[array objectAtIndex:0]uniqueID];
	
	[appDelegate sendLevelChangeForID:unID inRow:row inColumn:column db:[outputFourtyEight doubleValue]];
	
	
}

















@end
