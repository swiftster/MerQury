//
//  ImportOp.m
//  QServer
//
//  Created by Jason Tratta on 9/5/09.
//  Copyright 2009 Sound Character All rights reserved.
//
#import "ImportOp.h"
#import "QSyncController.h"


@implementation ImportOp


@synthesize appDelegate;
@synthesize mainMOC;
@synthesize sortInt; 




- (id)initWithDelegate:(QSyncController*)delegate
{
	
	NSLog(@"Import Op Called"); 
	if (!(self = [super init])) return nil;
	

	appDelegate = delegate;
	sortInt = 0;
	 
	mainMOC = [self newContextToMainStore];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self
			   selector:@selector(contextDidSave:) 
				   name:NSManagedObjectContextDidSaveNotification 
				 object:mainMOC];
;
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	appDelegate = nil;
	
	[super dealloc];
}

#pragma mark Core Data 


- (NSManagedObjectContext*)newContextToMainStore 
{ 
	 
	NSManagedObjectContext *moc = [appDelegate managedObjectContext]; 
	
	return [moc autorelease]; 
} 

- (void)contextDidSave:(NSNotification*)notification
{
	SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
	[[appDelegate managedObjectContext] performSelectorOnMainThread:selector
														 withObject:notification
													  waitUntilDone:YES]; 
}



#pragma mark Main thread import

-(void)main 
{ 
	QlabScripting *myScript = [[QlabScripting alloc] init]; 
	NSArray *workspaceArray = [myScript getWorkspaceArray];
	int i, l, c, g, numberOfCueLists, numberOfCues; 
	int arrayCount = [workspaceArray count];
	NSMutableSet *mutableCueLists;
	NSMutableSet *mutableCues;
	NSMutableSet *mutableGroupCues;
	NSArray *cueListArray, *cueArray; 
	
	
	NSManagedObjectContext *moc = mainMOC;
	
	
	// Find a workspace, determine the number of CueLists, make a MutableNSSet of the Cuelist, add the cues, add it to the workspace
	for (i = 0; i < arrayCount; i++) {
		
		
		
		NSString *nameString = [[workspaceArray objectAtIndex:i]name];
		
		NSManagedObject *workspace = [NSEntityDescription insertNewObjectForEntityForName:@"Workspace" inManagedObjectContext:moc];  
		
		[workspace setValue:nameString forKey:@"name"];
		
		//Prepare CueList Set
		mutableCueLists = [workspace mutableSetValueForKey:@"cuelists"];
		cueListArray = [[workspaceArray objectAtIndex:i]cueLists];
		numberOfCueLists = [cueListArray count];
		
		//Iterate through each cue list and add cues to the Set
		for (l = 0; l < numberOfCueLists; l++) { 
			
			
			
			
			NSManagedObject *cueListObject = [NSEntityDescription insertNewObjectForEntityForName:@"CueLists" inManagedObjectContext:moc];
			
			
			NSString *listName = [[cueListArray objectAtIndex:l]qName];
			NSString *idNumberString = [[cueListArray objectAtIndex:l]uniqueID];
			
			[cueListObject setValue:listName forKey:@"qName"];
			[cueListObject setValue:idNumberString forKey:@"uniqueID"];
			
			
			mutableCues = [cueListObject mutableSetValueForKey:@"cues"]; 
			
			
			
			
			//Prepare Cues, Get Array of Cues and find count
			cueArray = [[cueListArray objectAtIndex:l]cues];
			numberOfCues = [cueArray count]; 
			
			
			for (c = 0; c < numberOfCues; c++){
				
				NSString *isGroup = [[cueArray objectAtIndex:c]qType];						//Is this Cue a Group Cue?
				
				
				
				//If the cue type is Group, add the Cue and then the children group cues
				if (isGroup = @"Group") {
					
					NSManagedObject *cueObjectReturn = [self cueObject:c :moc :cueArray];  //Create and use a single Cue Object pre cue
					
					
					
					NSArray *groupCueArray = [[cueArray objectAtIndex:c]cues];				//Get an Array of Group Cues
					int groupCount = [groupCueArray count];									//Count 
							
					
					
					
					mutableGroupCues = [cueObjectReturn mutableSetValueForKey:@"groupCues"]; //Prepare MutableSet, Adds values via KVO
					
					for (g = 0; g < groupCount; g++) { 
						
						
						[mutableGroupCues addObject:[self groupObject:g :moc:groupCueArray]]; }
					
					
					[mutableCues addObject:cueObjectReturn]; 
					
					
				} else {																	// If not a Group Cue just Add the cue
					
					[mutableCues addObject:[self cueObject:c :moc :cueArray]]; }
				
				
				[mutableCueLists addObject:cueListObject]; }
			
			
		}}
	

	
}

-(NSManagedObject *)cueObject:(int) c:(NSManagedObjectContext *) moc:(NSArray *)cueArray
{
	
	
	NSManagedObject *cueObject = [NSEntityDescription insertNewObjectForEntityForName:@"Cues" inManagedObjectContext:moc];
	
	NSNumber *sortIndex = [NSNumber numberWithInt:[self incrementSortInt]];
	[cueObject setValue:sortIndex forKey:@"sortNumber"];
	
	NSString *cueName = [[cueArray objectAtIndex:c]qName];
	NSLog(@"CueName= %@", cueName);
	[cueObject setValue:cueName forKey:@"qName"];
	
	NSString *cueNumber = [[cueArray objectAtIndex:c]qNumber];
	[cueObject setValue:cueName forKey:@"qName"];

	
	[cueObject setValue:cueNumber forKey:@"qNumber"];
	
	NSString *cueType = [[cueArray objectAtIndex:c]qType];
	[cueObject setValue:cueType forKey:@"qType"]; 
	
	NSNumber *isArmed = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]armed]];
	[cueObject setValue:isArmed forKey:@"armed"];
	
	NSNumber *isBroken = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]broken]];
	[cueObject setValue:isBroken forKey:@"broken"];
	
	NSNumber *qDuration = [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]duration]];
	NSString *durationTimeString;
	durationTimeString = [self doubleToString:qDuration];
	[cueObject setValue:durationTimeString forKey:@"duration"];
	
	
	NSNumber *qExists = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]exists]];
	[cueObject setValue:qExists forKey:@"exists"];
	
	
	NSURL *qFileTarget = [[cueArray objectAtIndex:c]fileTarget];
	[cueObject setValue:[qFileTarget absoluteString] forKey:@"fileTarget"];
	
	
	NSNumber *qLoaded =[NSNumber numberWithBool:[[cueArray objectAtIndex:c]loaded]];
	[cueObject setValue:qLoaded	forKey:@"loaded"]; 
	
	
	NSString *qNotes = [[cueArray objectAtIndex:c]notes];
	[cueObject setValue:qNotes forKey:@"notes"];
	
	NSNumber *qPaused = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]paused]];
	[cueObject setValue:qPaused	forKey:@"paused"];
	
	NSNumber *qPostWait = [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]postWait]];
	NSString *postWaitTimeString;
	postWaitTimeString = [self doubleToString:qPostWait];
	[cueObject setValue:postWaitTimeString forKey:@"postWait"];
	
	NSNumber *qPreWait = [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]preWait]];
	NSString *preWaitTimeString;
	preWaitTimeString = [self doubleToString:qPreWait];
	[cueObject setValue:preWaitTimeString forKey:@"preWait"];  
	
	
	return cueObject; 
	[durationTimeString release]; 
}

-(NSManagedObject *)groupObject:(int) c:(NSManagedObjectContext *) moc: (NSArray *)cueArray

{
	
	
	
	
	NSManagedObject *groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"GroupCue" inManagedObjectContext:moc];
	
	NSNumber *sortIndex = [NSNumber numberWithInt:[self incrementSortInt]];
	[groupObject setValue:sortIndex forKey:@"sortNumber"];

	
	NSString *cueName = [[cueArray objectAtIndex:c]qName];
	[groupObject setValue:cueName forKey:@"qName"];
	
	NSString *cueNumber = [[cueArray objectAtIndex:c]qNumber];
	[groupObject setValue:cueNumber forKey:@"qNumber"];
	
	NSString *cueType = [[cueArray objectAtIndex:c]qType];
	[groupObject setValue:cueType forKey:@"qType"]; 
	
	NSNumber *isArmed = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]armed]];
	[groupObject setValue:isArmed forKey:@"armed"];
	
	NSNumber *isBroken = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]broken]];
	[groupObject setValue:isBroken forKey:@"broken"];
	
	NSNumber *qDuration = [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]duration]];
	NSString *durationTimeString;
	durationTimeString = [self doubleToString:qDuration];
	[groupObject setValue:durationTimeString forKey:@"duration"];

	
	NSNumber *qExists = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]exists]];
	[groupObject setValue:qExists forKey:@"exists"];
	
	
	NSURL *qFileTarget = [[cueArray objectAtIndex:c]fileTarget];
	[groupObject setValue:[qFileTarget absoluteString] forKey:@"fileTarget"];
	
	
	NSNumber *qLoaded =[NSNumber numberWithBool:[[cueArray objectAtIndex:c]loaded]];
	[groupObject setValue:qLoaded	forKey:@"loaded"]; 
	
	
	NSString *qNotes = [[cueArray objectAtIndex:c]notes];
	[groupObject setValue:qNotes forKey:@"notes"];
	
	NSNumber *qPaused = [NSNumber numberWithBool:[[cueArray objectAtIndex:c]paused]];
	[groupObject setValue:qPaused	forKey:@"paused"];
	
	NSNumber *qPostWait = [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]postWait]];
	NSString *postWaitTimeString;
	postWaitTimeString = [self doubleToString:qPostWait];
	[groupObject setValue:postWaitTimeString forKey:@"postWait"];
	
	NSNumber *qPreWait = [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]preWait]];
	NSString *preWaitTimeString;
	preWaitTimeString = [self doubleToString:qPreWait];
	[groupObject setValue:preWaitTimeString forKey:@"preWait"]; 
	
	
	return groupObject; 
}

-(NSString *)doubleToString:(NSNumber *)numberToString
{ 
	int m,s,x,l;
	double y,z;
	NSString *durationTimeString, *minutes, *seconds, *milliSeconds;
	
	m = [numberToString intValue] / 60;
 	s = [numberToString intValue] % 60; 
	x = m * 60 + s; 
	y = [numberToString doubleValue] - x + 0.005;
	
	if (y < 1) {
		z = y + 1; 
		l = z * 100 - 100; 
	} else {
		l = y * 100;
	}
	
	minutes = [NSString stringWithFormat:@"%i", m]; 
	seconds = [NSString stringWithFormat:@"%i", s]; 
	milliSeconds = [NSString stringWithFormat:@"%i", l]; 
	
	if (m < 10) { 
		minutes = [NSString stringWithFormat:@"0%i",m]; } 
	if (s < 10) { 
		seconds = [NSString stringWithFormat:@"0%i",s]; }
	if (l <10) {
		milliSeconds = [NSString stringWithFormat:@"0%i",l];
		
	}

	durationTimeString = [NSString stringWithFormat:@"%@:%@:%@",minutes, seconds, milliSeconds]; 
	
	return durationTimeString; }

-(int)incrementSortInt
{ 
	sortInt++; 
	return sortInt; 
}
	


	
	





@end
