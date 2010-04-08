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
	//QlabScripting *qLab = [[QlabScripting alloc] init]; 
	//Use to create another instance of the QlabScripting Class.  Considering makeing Singelton.  Until then..this works for import.
	QlabApplication *qLab = [SBApplication applicationWithBundleIdentifier:@"com.figure53.Qlab.2"]; 
	NSArray *workspaceArray = [qLab workspaces];
	int i, l, c, g, numberOfCueLists, numberOfCues; 
	int arrayCount = [workspaceArray count];
	//NSLog(@"Workspace Array: %d", arrayCount);
	NSMutableSet *mutableCueLists;
	NSMutableSet *mutableCues;
	NSMutableSet *mutableGroupCues;
	NSMutableSet *mutableWorkspace; 
	NSArray *cueListArray, *cueArray; 
	NSString *serviceName = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] hostName]];
	
	NSManagedObjectContext *moc = mainMOC;
	
	//Add the Local Server Name 
	;
	NSManagedObject *server = [NSEntityDescription insertNewObjectForEntityForName:@"Server" inManagedObjectContext:moc]; 
	[server setValue:serviceName forKey:@"serverName"];

	//Prepare Workspace Set 
	mutableWorkspace = [server mutableSetValueForKey:@"workspace"];
	//Workspace Array Already Created
	//ArrayCount Already Created
	
	
	
	// Find a workspace, determine the number of CueLists, make a MutableNSSet of the Cuelist, add the cues, add it to the workspace
	for (i = 0; i < arrayCount; i++) {
		
		
		
		NSString *nameString = [[workspaceArray objectAtIndex:i]name];
		//NSLog(@"Workspace Name: %@",nameString);
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
				if ([isGroup isEqualToString:@"Group"] == TRUE) {
					
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
			
			
		}
	
		[mutableWorkspace addObject:workspace];  } //Add the workspace
	
	
	
}

-(NSManagedObject *)cueObject:(int) c:(NSManagedObjectContext *) moc:(NSArray *)cueArray
{
	
	
	NSManagedObject *cueObject = [NSEntityDescription insertNewObjectForEntityForName:@"Cues" inManagedObjectContext:moc];
	NSMutableSet *mutableLevelSet = [cueObject mutableSetValueForKey:@"levels"];
	
	
	
	NSNumber *sortIndex = [NSNumber numberWithInt:[self incrementSortInt]];
	[cueObject setValue:sortIndex forKey:@"sortNumber"];
	
	NSString *cueName = [[cueArray objectAtIndex:c]qName];
	[cueObject setValue:cueName forKey:@"qName"];
	
	NSString *idName = [[cueArray objectAtIndex:c]uniqueID]; 
	[cueObject setValue:idName forKey:@"uniqueID"]; 
	
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
	
	//Add Levels Here 
	[mutableLevelSet addObject:[self levelsObject:c :moc :cueArray]];
	
	
	
	return cueObject; 
	[durationTimeString release]; 
}

-(NSManagedObject *)groupObject:(int) c:(NSManagedObjectContext *) moc: (NSArray *)cueArray

{    
	
	NSManagedObject *groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"GroupCue" inManagedObjectContext:moc];
	NSMutableSet *mutableLevelSet = [groupObject mutableSetValueForKey:@"levels"];
	

	
	NSNumber *sortIndex = [NSNumber numberWithInt:[self incrementSortInt]];
	[groupObject setValue:sortIndex forKey:@"sortNumber"];

	
	NSString *cueName = [[cueArray objectAtIndex:c]qName];
	[groupObject setValue:cueName forKey:@"qName"];
	
	NSString *idName = [[cueArray objectAtIndex:c]uniqueID]; ; 
	[groupObject setValue:idName forKey:@"uniqueID"]; 
	
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
	
	
	[mutableLevelSet addObject:[self levelsObject:c :moc :cueArray]];
	
	 
	
	
	return groupObject; 
}


-(NSManagedObject *)levelsObject:(int) c:(NSManagedObjectContext *) moc:(NSArray *)cueArray
{
	//NSLog(@"Levels Called");
	NSManagedObject *cueObject = [NSEntityDescription insertNewObjectForEntityForName:@"Levels" inManagedObjectContext:moc];

	//Fader Levels 
	
	NSNumber *qMaster =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:0]];
	[cueObject setValue:qMaster forKey:@"masterLevel"];
	//NSLog(@"Master level:%@",qMaster);
	
	
	NSNumber *qFader1 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:1]]; 
	[cueObject setValue:qFader1 forKey:@"output1"];
	
	NSNumber *qFader2 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:2]]; 
	[cueObject setValue:qFader2 forKey:@"output2"];
	
	NSNumber *qFader3 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:3]]; 
	[cueObject setValue:qFader3 forKey:@"output3"];
	
	NSNumber *qFader4 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:4]]; 
	[cueObject setValue:qFader4 forKey:@"output4"];
	
	NSNumber *qFader5 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:5]]; 
	[cueObject setValue:qFader5 forKey:@"output5"];
	
	NSNumber *qFader6 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:6]]; 
	[cueObject setValue:qFader6 forKey:@"output6"];
	
	NSNumber *qFader7=  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:7]]; 
	[cueObject setValue:qFader7 forKey:@"output7"];
	
	NSNumber *qFader8 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:8]]; 
	[cueObject setValue:qFader8 forKey:@"output8"];
	
	NSNumber *qFader9 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:9]]; 
	[cueObject setValue:qFader9 forKey:@"output9"];
	
	NSNumber *qFader10 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:10]]; 
	[cueObject setValue:qFader10 forKey:@"output10"];
	
	NSNumber *qFader11 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:11]]; 
	[cueObject setValue:qFader11 forKey:@"output11"];
	
	NSNumber *qFader12 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:12]]; 
	[cueObject setValue:qFader12 forKey:@"output12"];
	
	NSNumber *qFader13 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:13]]; 
	[cueObject setValue:qFader13 forKey:@"output13"];
	
	NSNumber *qFader14 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:14]]; 
	[cueObject setValue:qFader14 forKey:@"output14"];
	
	NSNumber *qFader15 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:15]]; 
	[cueObject setValue:qFader15 forKey:@"output15"];
	
	NSNumber *qFader16 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:16]]; 
	[cueObject setValue:qFader16 forKey:@"output16"];
	
	NSNumber *qFader17 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:17]]; 
	[cueObject setValue:qFader17 forKey:@"output17"];
	
	NSNumber *qFader18 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:18]]; 
	[cueObject setValue:qFader18 forKey:@"output18"];
	
	NSNumber *qFader19 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:19]]; 
	[cueObject setValue:qFader19 forKey:@"output19"];
	
	NSNumber *qFader20 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:20]]; 
	[cueObject setValue:qFader20 forKey:@"output20"];
	
	NSNumber *qFader21 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:21]]; 
	[cueObject setValue:qFader21 forKey:@"output21"];
	
	NSNumber *qFader22 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:22]]; 
	[cueObject setValue:qFader22 forKey:@"output22"];
	
	NSNumber *qFader23 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:23]]; 
	[cueObject setValue:qFader23 forKey:@"output23"]; 
	
	NSNumber *qFader24 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:24]]; 
	[cueObject setValue:qFader24 forKey:@"output24"];
	
	NSNumber *qFader25 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:25]]; 
	[cueObject setValue:qFader25 forKey:@"output25"];
	
	NSNumber *qFader26 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:26]]; 
	[cueObject setValue:qFader26 forKey:@"output26"];
	
	NSNumber *qFader27 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:27]]; 
	[cueObject setValue:qFader27 forKey:@"output27"];
	
	NSNumber *qFader28 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:28]]; 
	[cueObject setValue:qFader28 forKey:@"output28"];
	
	NSNumber *qFader29 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:29]]; 
	[cueObject setValue:qFader29 forKey:@"output29"];
	
	NSNumber *qFader30 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:30]]; 
	[cueObject setValue:qFader30 forKey:@"output30"];
	
	NSNumber *qFader31 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:31]]; 
	[cueObject setValue:qFader31 forKey:@"output31"];
	
	NSNumber *qFader32 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:32]]; 
	[cueObject setValue:qFader32 forKey:@"output32"];
	
	NSNumber *qFader33 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:33]]; 
	[cueObject setValue:qFader33 forKey:@"output33"];
	
	NSNumber *qFader34 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:34]]; 
	[cueObject setValue:qFader34 forKey:@"output34"];
	
	NSNumber *qFader35 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:35]]; 
	[cueObject setValue:qFader35 forKey:@"output35"];
	
	NSNumber *qFader36 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:36]]; 
	[cueObject setValue:qFader36 forKey:@"output36"];
	
	NSNumber *qFader37 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:37]]; 
	[cueObject setValue:qFader37 forKey:@"output37"];
	
	NSNumber *qFader38 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:38]]; 
	[cueObject setValue:qFader38 forKey:@"output38"];
	
	NSNumber *qFader39 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:39]]; 
	[cueObject setValue:qFader39 forKey:@"output39"];
	
	NSNumber *qFader40 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:40]]; 
	[cueObject setValue:qFader40 forKey:@"output40"];
	
	NSNumber *qFader41 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:41]]; 
	[cueObject setValue:qFader41 forKey:@"output41"];
	
	NSNumber *qFader42 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:42]]; 
	[cueObject setValue:qFader42 forKey:@"output42"];
	
	NSNumber *qFader43 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:43]]; 
	[cueObject setValue:qFader43 forKey:@"output43"];
	
	NSNumber *qFader44 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:44]]; 
	[cueObject setValue:qFader44 forKey:@"output44"];
	
	NSNumber *qFader45 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:45]]; 
	[cueObject setValue:qFader45 forKey:@"output45"];
	
	NSNumber *qFader46 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:46]]; 
	[cueObject setValue:qFader46 forKey:@"output46"];
	
	NSNumber *qFader47 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:47]]; 
	[cueObject setValue:qFader47 forKey:@"output47"];
	
	NSNumber *qFader48 =  [NSNumber numberWithDouble:[[cueArray objectAtIndex:c]getLevelRow:0 column:48]]; 
	[cueObject setValue:qFader48 forKey:@"output48"];

	
	
	return cueObject;
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
