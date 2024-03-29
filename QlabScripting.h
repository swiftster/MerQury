
//  QlabScripting.h
//  QAutoSaver
//
//  Created by Jason Tratta on 6/10/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface QlabScripting : NSObject {


	
int arrayNumber;
BOOL active; 

NSString *feedBackText; 
NSMutableArray *workspaces;
NSArray *qlabCurrentArray;
 
	
//Key Values 
NSString *workspaceName;



}

@property (readwrite, assign) NSString *feedBackText;
@property (readwrite, copy) NSString *workspaceName;
@property (assign) NSMutableArray *workspaces;
@property (readwrite, assign) NSArray *qlabCurrentArray;

+ (QlabScripting *)sharedQlabScripting;


// Grab SBElements from Qlab for other Methods. If Qlab Scriping Changes, these should be the only methods to change.
-(NSArray *)getWorkspaceArray;
-(NSArray *)getDocumentArray; 
-(void)loadQlabArray;

-(int)numberofWorkspaces;


//Qlab Polling
-(BOOL)isRunning; 
-(BOOL)isQlabActive; 
-(BOOL)isFrontMost; 
-(NSArray *)selectedCues:(int)inWorkspace; 
-(NSString *)firstSelectedCue; 
-(BOOL)isModified; 

//Saveing and Backups
-(int)getArrayNumber;



//Controls
-(void)goCue;
-(void)moveSelectionUp; 
-(void)moveSelectionDown;
-(void)stopCue;
//-(void)pauseCue;
-(void)reset; 

-(void) adjustLoadTime:(double) i;









@end
