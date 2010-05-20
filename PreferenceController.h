//
//  PreferenceController.h
//  QSync
//
//  Created by Jason Tratta on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "SGHotKey.h"
#import "QlabScripting.h"
#import "MessageServer.h"


extern NSString *kGlobalGoKey;
extern NSString *kGlobalStopKey;
extern NSString *kGlobalUpKey;
extern NSString *kGlobalDownKey;
extern NSString *kGlobalBecomePrimaryKey; 


@interface PreferenceController : NSWindowController {
	
	
	SRRecorderControl *hotKeyGoControl;
	SRRecorderControl *hotKeyStopControl; 
	SRRecorderControl *hotKeyUpSelectionControl; 
	SRRecorderControl *hotKeyDownSelectionControl; 
	SRRecorderControl *hotKeyBecomePrimaryControl;


}

@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyGoControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyStopControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyUpSelectionControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyDownSelectionControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyBecomePrimaryControl;

@property (nonatomic, retain) SGHotKey *goKey;
@property (nonatomic, retain) SGHotKey *stopKey;
@property (nonatomic, retain) SGHotKey *upKey;
@property (nonatomic, retain) SGHotKey *downKey;
@property (nonatomic, retain) SGHotKey *primaryKey; 

-(void)registerHotKeys;
-(void)unregisterHotKeys;
-(void)clearKeys;


@end
