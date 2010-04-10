//
//  ImportOp.m
//  QServer
//
//  Created by Jason Tratta on 9/5/09.
//  Copyright 2009 Sound Character All rights reserved.
//
#import "SharedDataImport.h"
#import "QSyncController.h"


@implementation SharedDataImport


@synthesize appDelegate;
@synthesize mainMOC;
@synthesize sortInt; 
@synthesize sharedData;




- (id)initWithDelegate:(QSyncController*)delegate withArray:(NSArray *)array
{
	
	if (!(self = [super init])) return nil;
	
	
	appDelegate = delegate;
	sortInt = 0;
	sharedData = array;
	
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
	NSLog(@"Starting Remote Server Import");
	NSArray *sharedArray = sharedData;
	NSArray *workspaceArray;
	int i, l, c, g, numberOfCueLists, numberOfCues; 
	int arrayCount = [sharedArray count];
	NSLog(@"Workspace Array: %d", arrayCount);
	NSMutableSet *mutableCueLists;
	NSMutableSet *mutableCues;
	NSMutableSet *mutableGroupCues;
	NSMutableSet *mutableWorkspace; 
	NSArray *cueListArray, *cueArray; 
	
	
	NSManagedObjectContext *moc = mainMOC;
	
	//Add the Remote Server Name 
	NSString *nameTest;
	
	NSManagedObject *serverObject = [sharedArray objectAtIndex:0]; 
	nameTest = [serverObject valueForKey:@"serverName"];
	NSLog(@"ServerName is:%@",nameTest);
	

	
	//Add New Object to Local Context
	NSManagedObject *server = [NSEntityDescription insertNewObjectForEntityForName:@"Server" inManagedObjectContext:moc]; 
	[server setValue:nameTest forKey:@"serverName"];
	[server setValue:NO forKey:@"isLocal"];
		
	
	
	//Prepare Workspace Set 
	
	NSMutableSet *workSpaceSet = [serverObject valueForKey:@"workspace"];  //Gets a set of all the workspace entities. 
	workspaceArray = [workSpaceSet allObjects];								
	arrayCount = [workspaceArray count]; 
	

	
	
	
	
	// Begin sorting the workspaces
	for (i = 0; i < arrayCount; i++) {
		
		
		//Enumerates through the aval. workspaces. 
		NSManagedObject *tempWorkspaceObject = [workspaceArray objectAtIndex:i];
		NSManagedObject *workspace = [NSEntityDescription insertNewObjectForEntityForName:@"Workspace" inManagedObjectContext:moc]; 
		
		mutableWorkspace = [workspace mutableSetValueForKey:@"workspace"];
		
		NSString *nameString = [tempWorkspaceObject valueForKey:@"name"]; 
		
		
		[workspace setValue:nameString forKey:@"name"];
		[workspace setValue:NO forKey:@"isLocal"];

		NSLog(@"Name Added");
		
		//Add Cue Lists to the Workspace
		mutableCueLists = [workspace mutableSetValueForKey:@"cuelists"];
		NSLog(@"MutableCueList created");
		
		NSSet *cueListSet = [tempWorkspaceObject valueForKey:@"cuelists"];
		
		cueListArray = [cueListSet allObjects];
		numberOfCueLists = [cueListArray count];

		
	
		
		
		
		
		for (l = 0; l < numberOfCueLists; l++) { 
			
			NSLog(@"Num of Cues:%d Pass:%d",numberOfCueLists, l);
			NSManagedObject *tempCueListObject = [cueListArray objectAtIndex:l]; 
			NSManagedObject *cueListObject = [NSEntityDescription insertNewObjectForEntityForName:@"CueLists" inManagedObjectContext:moc];
			
			
			NSString *listName = [tempCueListObject valueForKey:@"qName"];
			NSLog(@"ListName:%@",listName);
			NSString *idNumberString = [tempCueListObject valueForKey:@"uniqueID"];
			
			[cueListObject setValue:listName forKey:@"qName"];
			[cueListObject setValue:idNumberString forKey:@"uniqueID"];
			[cueListObject setValue:NO forKey:@"isLocal"];
			
			//Begin Adding Cues to the List
			mutableCues = [cueListObject mutableSetValueForKey:@"cues"]; 
			
			
			NSSet *tempCuesSet = [tempCueListObject valueForKey:@"cues"];
			//NSLog(@"temp CuesSet:%@",[tempCuesSet description]);
			cueArray = [tempCuesSet allObjects];
			numberOfCues = [cueArray count]; 
		
			
			
			for (c = 0; c < numberOfCues; c++){
				
				NSManagedObject *tempCuesObject = [cueArray objectAtIndex:c];
			
				NSString *isGroup = [tempCuesObject valueForKey:@"qType"];
				NSLog(@"isGroup:%@Number of Cues:%d",isGroup, numberOfCues);
				
				
				
				//If the cue type is Group, add the Cue and then the children group cues
				if ([isGroup isEqualToString:@"Group"] == TRUE)  {
					
					NSManagedObject *cueObjectReturn = [self cueObject:c :moc :tempCuesObject];  //Create and use a single Cue Object pre cue
					
					
					NSSet *tempGroupSet = [cueObjectReturn valueForKey:@"cues"];
					NSArray *groupCueArray = [tempGroupSet allObjects];				//Get an Array of Group Cues
					int groupCount = [groupCueArray count];									//Count 
					
					
					
					
					mutableGroupCues = [cueObjectReturn mutableSetValueForKey:@"groupCues"]; //Prepare MutableSet, Adds values via KVO
					
					for (g = 0; g < groupCount; g++) { 
						
						NSManagedObject *tempGroupCueObject = [groupCueArray objectAtIndex:g];
						
						[mutableGroupCues addObject:[self groupObject:g :moc:tempGroupCueObject]]; }
					
					
					[mutableCues addObject:cueObjectReturn]; 
					
					
				} else {																	// If not a Group Cue just Add the cue
					
					NSLog(@"Adding Cues");
					[mutableCues addObject:[self cueObject:c :moc :tempCuesObject]]; 
					NSLog(@"Finished Cues Added");						
				}
				
				
				[mutableCueLists addObject:cueListObject]; 
				NSLog(@"Finished Cue Lists Added");    }
			
			
		}
		
		[mutableWorkspace addObject:workspace];   //Add the workspace
		NSLog(@"Workspace Added"); }
	
	
}

-(NSManagedObject *)cueObject:(int) c:(NSManagedObjectContext *) moc:(NSManagedObject *)object
{
	
	//NSLog(@"Pulling Cue");
	
	NSManagedObject *cueObject = [NSEntityDescription insertNewObjectForEntityForName:@"Cues" inManagedObjectContext:moc];
	NSMutableSet *mutableLevelSet = [cueObject mutableSetValueForKey:@"levels"];
	
	
	
	
	NSNumber *sortIndex = [NSNumber numberWithInt:[self incrementSortInt]];
	[cueObject setValue:sortIndex forKey:@"sortNumber"];
	
	
	NSString *cueName = [object valueForKey:@"qName"];
	[cueObject setValue:cueName forKey:@"qName"];
	
	
	NSString *idName = [object valueForKey:@"uniqueID"];
	[cueObject setValue:idName forKey:@"uniqueID"]; 
	
	NSString *cueNumber = [object valueForKey:@"qNumber"];
	[cueObject setValue:cueNumber forKey:@"qNumber"];
	
	NSString *cueType = [object valueForKey:@"qType"];
	[cueObject setValue:cueType forKey:@"qType"]; 
	
	NSNumber *isArmed = [object valueForKey:@"armed"];
	[cueObject setValue:isArmed forKey:@"armed"];
	
	NSNumber *isBroken = [object valueForKey:@"broken"];
	[cueObject setValue:isBroken forKey:@"broken"];
	
	
	NSString *durationTimeString;
	durationTimeString = [object valueForKey:@"duration"];
	[cueObject setValue:durationTimeString forKey:@"duration"];
	//NSLog(@"Duration:%@",durationTimeString);
	
	
	NSNumber *qExists = [object valueForKey:@"exists"];
	[cueObject setValue:qExists forKey:@"exists"];
	
	
	NSString *qFileTarget = [object valueForKey:@"fileTarget"];
	[cueObject setValue:qFileTarget forKey:@"fileTarget"];
	//NSLog(@"Target:%@",qFileTarget);
	
	NSNumber *qLoaded = [object valueForKey:@"loaded"];
	[cueObject setValue:qLoaded	forKey:@"loaded"]; 
	//NSLog(@"Loaded:%@",qLoaded);
	
	NSString *qNotes = [object valueForKey:@"notes"];
	[cueObject setValue:qNotes forKey:@"notes"];
	//NSLog(@"Notes");
	
	NSNumber *qPaused = [object valueForKey:@"paused"];
	[cueObject setValue:qPaused	forKey:@"paused"];
	
	
	NSString *postWaitTimeString;
	postWaitTimeString = [object valueForKey:@"postWait"];
	[cueObject setValue:postWaitTimeString forKey:@"postWait"];
	//NSLog(@"PostWait:%@",postWaitTimeString);
	
	
	NSString *preWaitTimeString;
	preWaitTimeString = [object valueForKey:@"preWait"];
	[cueObject setValue:preWaitTimeString forKey:@"preWait"]; 
	//NSLog(@"PreWait:%@",preWaitTimeString);
	
	
	NSSet *tempLevelSet = [object valueForKey:@"levels"];
	NSArray *tempLevelArray = [tempLevelSet allObjects]; 
	NSManagedObject *tempLevelsObject = [tempLevelArray objectAtIndex:0]; 
	
	//Add Levels Here 
	[mutableLevelSet addObject:[self levelsObject:c :moc :tempLevelsObject]];
	
	
	
	return cueObject; 
	
	[durationTimeString release]; 
}

-(NSManagedObject *)groupObject:(int) c:(NSManagedObjectContext *) moc: (NSManagedObject *)object 

{    
	
	NSManagedObject *groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"GroupCue" inManagedObjectContext:moc];
	NSMutableSet *mutableLevelSet = [groupObject mutableSetValueForKey:@"levels"];
	
	
	NSNumber *sortIndex = [NSNumber numberWithInt:[self incrementSortInt]];
	[groupObject setValue:sortIndex forKey:@"sortNumber"];
	
	
	NSString *cueName = [object valueForKey:@"qName"];
	[groupObject setValue:cueName forKey:@"qName"];
	
	NSString *idName = [object valueForKey:@"uniqueID"];
	[groupObject setValue:idName forKey:@"uniqueID"]; 
	
	NSString *cueNumber = [object valueForKey:@"qNumber"];
	[groupObject setValue:cueNumber forKey:@"qNumber"];
	
	NSString *cueType = [object valueForKey:@"qType"];
	[groupObject setValue:cueType forKey:@"qType"]; 
	
	NSNumber *isArmed = [object valueForKey:@"armed"];
	[groupObject setValue:isArmed forKey:@"armed"];
	
	NSNumber *isBroken = [object valueForKey:@"broken"];
	[groupObject setValue:isBroken forKey:@"broken"];
	
	
	NSString *durationTimeString;
	durationTimeString = [object valueForKey:@"duration"];
	[groupObject setValue:durationTimeString forKey:@"duration"];
	
	
	NSNumber *qExists = [object valueForKey:@"exists"];
	[groupObject setValue:qExists forKey:@"exists"];
	
	
	NSString *qFileTarget = [object valueForKey:@"fileTarget"];
	[groupObject setValue:qFileTarget forKey:@"fileTarget"];
	
	
	NSNumber *qLoaded = [object valueForKey:@"loaded"];
	[groupObject setValue:qLoaded	forKey:@"loaded"]; 
	
	
	NSString *qNotes = [object valueForKey:@"notes"];
	[groupObject setValue:qNotes forKey:@"notes"];
	
	NSNumber *qPaused = [object valueForKey:@"paused"];
	[groupObject setValue:qPaused	forKey:@"paused"];
	
	
	NSString *postWaitTimeString;
	postWaitTimeString = [object valueForKey:@"postWait"];
	[groupObject setValue:postWaitTimeString forKey:@"postWait"];
	
	
	NSString *preWaitTimeString;
	preWaitTimeString = [object valueForKey:@"prewait"];
	[groupObject setValue:preWaitTimeString forKey:@"preWait"]; 
	
	
	
	NSSet *tempLevelSet = [object valueForKey:@"levels"];
	NSArray *tempLevelArray = [tempLevelSet allObjects]; 
	NSManagedObject *tempLevelsObject = [tempLevelArray objectAtIndex:0]; 
	
	
	[mutableLevelSet addObject:[self levelsObject:c :moc :tempLevelsObject]];

	
	return groupObject; 
}


-(NSManagedObject *)levelsObject:(int) c:(NSManagedObjectContext *) moc:(NSManagedObject *)object
{
	NSLog(@"Levels Called");
	NSManagedObject *cueObject = [NSEntityDescription insertNewObjectForEntityForName:@"Levels" inManagedObjectContext:moc];
	
	//Fader Levels 
	
	NSNumber *qMaster =  [object valueForKey:@"masterLevel"];
	[cueObject setValue:qMaster forKey:@"masterLevel"];
	//NSLog(@"Master Level:%@",qMaster);
	
	NSNumber *qFader1 =  [object valueForKey:@"output1"]; 
	[cueObject setValue:qFader1 forKey:@"output1"];
	
	NSNumber *qFader2 =  [object valueForKey:@"output2"];  
	[cueObject setValue:qFader2 forKey:@"output2"];
	
	NSNumber *qFader3 =  [object valueForKey:@"output3"];  
	[cueObject setValue:qFader3 forKey:@"output3"];
	
	NSNumber *qFader4 =  [object valueForKey:@"output4"]; 
	[cueObject setValue:qFader4 forKey:@"output4"];
	
	NSNumber *qFader5 = [object valueForKey:@"output5"]; 
	[cueObject setValue:qFader5 forKey:@"output5"];
	
	NSNumber *qFader6 =  [object valueForKey:@"output6"]; 
	[cueObject setValue:qFader6 forKey:@"output6"];
	
	NSNumber *qFader7=  [object valueForKey:@"output7"];  
	[cueObject setValue:qFader7 forKey:@"output7"];
	
	NSNumber *qFader8 =  [object valueForKey:@"output8"];  
	[cueObject setValue:qFader8 forKey:@"output8"];
	
	NSNumber *qFader9 = [object valueForKey:@"output9"]; 
	[cueObject setValue:qFader9 forKey:@"output9"];
	
	NSNumber *qFader10 =  [object valueForKey:@"output10"];  
	[cueObject setValue:qFader10 forKey:@"output10"];
	
	NSNumber *qFader11 =  [object valueForKey:@"output11"]; 
	[cueObject setValue:qFader11 forKey:@"output11"];
	
	NSNumber *qFader12 =  [object valueForKey:@"output12"]; 
	[cueObject setValue:qFader12 forKey:@"output12"];
	
	NSNumber *qFader13 =  [object valueForKey:@"output13"]; 
	[cueObject setValue:qFader13 forKey:@"output13"];
	
	NSNumber *qFader14 =  [object valueForKey:@"output14"]; 
	[cueObject setValue:qFader14 forKey:@"output14"];
	
	NSNumber *qFader15 =  [object valueForKey:@"output15"]; 
	[cueObject setValue:qFader15 forKey:@"output15"];
	
	NSNumber *qFader16 =  [object valueForKey:@"output16"]; 
	[cueObject setValue:qFader16 forKey:@"output16"];
	
	NSNumber *qFader17 =  [object valueForKey:@"output17"]; 
	[cueObject setValue:qFader17 forKey:@"output17"];
	
	NSNumber *qFader18 =  [object valueForKey:@"output18"]; 
	[cueObject setValue:qFader18 forKey:@"output18"];
	
	NSNumber *qFader19 =  [object valueForKey:@"output19"]; 
	[cueObject setValue:qFader19 forKey:@"output19"];
	
	NSNumber *qFader20 =  [object valueForKey:@"output20"]; 
	[cueObject setValue:qFader20 forKey:@"output20"];
	
	NSNumber *qFader21 =  [object valueForKey:@"output21"];  
	[cueObject setValue:qFader21 forKey:@"output21"];
	
	NSNumber *qFader22 =  [object valueForKey:@"output22"]; 
	[cueObject setValue:qFader22 forKey:@"output22"];
	
	NSNumber *qFader23 =  [object valueForKey:@"output23"];  
	[cueObject setValue:qFader23 forKey:@"output23"]; 
	
	NSNumber *qFader24 =  [object valueForKey:@"output24"]; 
	[cueObject setValue:qFader24 forKey:@"output24"];
	
	NSNumber *qFader25 =  [object valueForKey:@"output25"];  
	[cueObject setValue:qFader25 forKey:@"output25"];
	
	NSNumber *qFader26 =  [object valueForKey:@"output26"]; 
	[cueObject setValue:qFader26 forKey:@"output26"];
	
	NSNumber *qFader27 =  [object valueForKey:@"output27"]; 
	[cueObject setValue:qFader27 forKey:@"output27"];
	
	NSNumber *qFader28 =  [object valueForKey:@"output28"]; 
	[cueObject setValue:qFader28 forKey:@"output28"];
	
	NSNumber *qFader29 = [object valueForKey:@"output29"]; 
	[cueObject setValue:qFader29 forKey:@"output29"];
	
	NSNumber *qFader30 =  [object valueForKey:@"output30"]; 
	[cueObject setValue:qFader30 forKey:@"output30"];
	
	NSNumber *qFader31 =  [object valueForKey:@"output31"]; 
	[cueObject setValue:qFader31 forKey:@"output31"];
	
	NSNumber *qFader32 =  [object valueForKey:@"output32"];  
	[cueObject setValue:qFader32 forKey:@"output32"];
	
	NSNumber *qFader33 =  [object valueForKey:@"output33"]; 
	[cueObject setValue:qFader33 forKey:@"output33"];
	
	NSNumber *qFader34 =  [object valueForKey:@"output34"]; 
	[cueObject setValue:qFader34 forKey:@"output34"];
	
	NSNumber *qFader35 =  [object valueForKey:@"output35"]; 
	[cueObject setValue:qFader35 forKey:@"output35"];
	
	NSNumber *qFader36 =  [object valueForKey:@"output36"]; 
	[cueObject setValue:qFader36 forKey:@"output36"];
	
	NSNumber *qFader37 =  [object valueForKey:@"output37"];  
	[cueObject setValue:qFader37 forKey:@"output37"];
	
	NSNumber *qFader38 =  [object valueForKey:@"output38"]; 
	[cueObject setValue:qFader38 forKey:@"output38"];
	
	NSNumber *qFader39 =  [object valueForKey:@"output39"]; 
	[cueObject setValue:qFader39 forKey:@"output39"];
	
	NSNumber *qFader40 =  [object valueForKey:@"output40"]; 
	[cueObject setValue:qFader40 forKey:@"output40"];
	
	NSNumber *qFader41 =  [object valueForKey:@"output41"];  
	[cueObject setValue:qFader41 forKey:@"output41"];
	
	NSNumber *qFader42 =  [object valueForKey:@"output42"]; 
	[cueObject setValue:qFader42 forKey:@"output42"];
	
	NSNumber *qFader43 =  [object valueForKey:@"output43"]; 
	[cueObject setValue:qFader43 forKey:@"output43"];
	
	NSNumber *qFader44 =  [object valueForKey:@"output44"]; 
	[cueObject setValue:qFader44 forKey:@"output44"];
	
	NSNumber *qFader45 =  [object valueForKey:@"output45"]; 
	[cueObject setValue:qFader45 forKey:@"output45"];
	
	NSNumber *qFader46 =  [object valueForKey:@"output46"]; 
	[cueObject setValue:qFader46 forKey:@"output46"];
	
	NSNumber *qFader47 =  [object valueForKey:@"output47"];  
	[cueObject setValue:qFader47 forKey:@"output47"];
	
	NSNumber *qFader48 =  [object valueForKey:@"output48"]; 
	[cueObject setValue:qFader48 forKey:@"output48"];
	
	NSLog(@"Finished Levels");
	
	
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
