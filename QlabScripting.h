
//  QlabScripting.h
//  QAutoSaver
//
//  Created by Jason Tratta on 6/10/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferenceController.h"

extern NSString * const JATQlabGoNotification;
extern NSString * const JATQlabSelectionUpNotification;
extern NSString * const JATQlabSelectionDownNotification;
extern NSString * const JATQlabStopNotification;

@interface QlabScripting : NSObject {


	
int arrayNumber;
BOOL active; 

NSString *feedBackText; 
PreferenceController *myPrefs;
NSMutableArray *workspaces;
NSArray *qlabCurrentArray;
 
	
//Key Values 
NSString *workspaceName;



}

@property (readwrite, assign) NSString *feedBackText;
@property (readwrite, copy) NSString *workspaceName;
@property (assign) NSMutableArray *workspaces;
@property (readwrite, assign) NSArray *qlabCurrentArray;

// Grab SBElements from Qlab for other Methods. If Qlab Scriping Changes, these should be the only methods to change.
-(NSArray *)getWorkspaceArray;
-(NSArray *)getDocumentArray; 
-(void)loadQlabArray;

-(int)numberofWorkspaces;


//Qlab Polling
-(BOOL)isRunning; 
-(int)findNewRunningCue;
-(BOOL)isQlabActive; 
-(BOOL)isFrontMost; 
-(NSArray *)selectedCues:(int)inWorkspace; 
-(NSString *)firstSelectedCue; 

//Saveing and Backups
-(int)getArrayNumber;

//Notes
-(void)goCueNote:(NSNotification *)note;
-(void)upSelectionNote:(NSNotification *)note;
-(void)downSelectionNote:(NSNotification *)note;
-(void)stopNote:(NSNotification *)note;

//Controls
-(void)goCue;
-(void)moveSelectionUp; 
-(void)moveSelectionDown;
-(void)stopCue;
-(void)pause;
-(void)reset; 

-(void) adjustLoadTime:(double) i;









@end
