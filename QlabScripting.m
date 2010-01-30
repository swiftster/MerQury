
//  QlabScripting.m
//  QAutoSaver
//
//  Created by Jason Tratta on 6/10/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import "QlabScripting.h"
#import	"Qlab.h"


NSString const * JATFeedBackNotification = @"JATFeedBackPost";

@implementation QlabScripting

@synthesize feedBackText;
@synthesize workspaceName; 
@synthesize workspaces; 
@synthesize qlabCurrentArray;


-(id)init
{
	[super init]; 

	return self;
}	


-(void)loadQlabArray 
{ 
	
	qlabCurrentArray = NULL;
	QlabApplication *qLab = [SBApplication applicationWithBundleIdentifier:@"com.figure53.Qlab.2"]; 
	qlabCurrentArray = [qLab workspaces];
}



-(NSArray *)getWorkspaceArray 
{ 
	QlabApplication *qLab = [SBApplication applicationWithBundleIdentifier:@"com.figure53.Qlab.2"]; 
	NSArray *array = [qLab workspaces];
	
	return array;

}

-(NSArray *)getDocumentArray
{
	QlabApplication *qLab = [SBApplication applicationWithBundleIdentifier:@"com.figure53.Qlab.2"]; 
	NSArray *array = [qLab documents];
	
	return array; 
}

-(int)numberofWorkspaces
{ 
	
	
	NSArray *array = [self getWorkspaceArray]; 
	int arrayCount; 
	arrayCount = [array count]; 
	
	[array release]; 
	return arrayCount; 
	
}

	

#pragma mark -
#pragma mark Qlab Polling
#pragma mark -

// Method to find any running cues 
-(BOOL)isRunning 
{ 
	
	NSArray *array;
	array = [self getWorkspaceArray];
	NSArray *cuesRunning;
	int i;
	int c;
	BOOL running = FALSE;
	NSInteger arrayCount = [array count]; 
	int cueCount;
	
	for (i = 0; i < arrayCount; i++){
		
		cuesRunning = [[array objectAtIndex:i]cues];
		cueCount = [cuesRunning count]; 
		
		for (c = 0; c < cueCount; c++){
			
			if([[cuesRunning objectAtIndex:c]running] == TRUE) { 
				NSLog(@"Cue Running"); 
				running = TRUE; 
				
			} else { 
				running = FALSE;
			NSLog(@"No Cue Running"); }
			
		}
	}
	
	return running;
	[array release]; 
	[cuesRunning release];
	
}

-(int)findNewRunningCue
{ 
	
	NSArray *array;
	array = [self getWorkspaceArray];
	NSArray *cuesRunning;
	int i;
	int c;
	BOOL running = FALSE;
	NSInteger arrayCount = [array count]; 
	int cueCount;
	
	for (i = 0; i < arrayCount; i++){
		
		cuesRunning = [[array objectAtIndex:i]cues];
		cueCount = [cuesRunning count]; 
		
		for (c = 0; c < cueCount; c++){
			
			if([[cuesRunning objectAtIndex:c]running] == TRUE) { 
				NSLog(@"Cue Running"); 
				running = TRUE; 
				
					
				
			} else { 
				running = FALSE;
				NSLog(@"No Cue Running"); }
			
		}
	}
}

//Is the QLab Application Running?
-(BOOL)isQlabActive 
{ 
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	
	QlabApplication *qLab = [SBApplication applicationWithBundleIdentifier:@"com.figure53.Qlab.2"]; 
	
	if ([qLab isRunning] == TRUE){
		active = TRUE;
		NSLog(@"Qlab is active"); 
		
	} else {
		
		NSLog(@"Qlab is not active");
		active = FALSE; 
		[self setFeedBackText:@"Please Launch Qlab 2!"]; 
		NSLog(@"Sending Notification"); 
		[nc postNotificationName:(NSString *) JATFeedBackNotification object:self];
	  }
	
	
	
	return active; 
	[qLab release];
}

#pragma mark -

#pragma mark -
#pragma mark File Handleing / Moving Files Around 
#pragma mark -

	

-(int)getArrayNumber
{ 
	int i; 
	i = arrayNumber; 
	
	return i; 
}








#pragma mark -
#pragma mark Controls 
#pragma mark -

-(void)goCue 
{ 
	
	[[qlabCurrentArray objectAtIndex:0]go]; 
	//NSLog(@"Go script Called"); 
	
}

-(void)moveSelectionUp
{ 
	
	[[qlabCurrentArray objectAtIndex:0]moveSelectionUp];
	
}

-(void)moveSelectionDown 
{ 
	[[qlabCurrentArray objectAtIndex:0]moveSelectionDown];
}
	

-(void)stopCue
{ 
	[[qlabCurrentArray objectAtIndex:0]stop];
	
}


-(void)pause 
{ 
	[[qlabCurrentArray objectAtIndex:0]pause];
	
}


-(void)reset 
{ 

[[qlabCurrentArray objectAtIndex:0]reset];
	

}



-(void) adjustLoadTime:(double) a 
{ 
	int i, c;
	NSArray *cuesArray;
	NSInteger arrayCount = [qlabCurrentArray count]; //Count the workspaces
	
	for (i = 0; i < arrayCount; i++){      //Get CueList Array
		
		cuesArray = [[qlabCurrentArray objectAtIndex:i]cues];
		NSInteger cueCount = [cuesArray count]; 
		
		for (c = 0; c < cueCount; c++){
			
			
			[[cuesArray objectAtIndex:c]loadTime:a];
			NSLog(@"Cue Adjust %i", c); }}
	
	
	
}


	
	
	

		
		

	

@end

