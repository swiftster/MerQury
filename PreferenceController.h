//
//  PreferenceController.h
//  QSync
//
//  Created by Jason Tratta on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "HotKeyController.h"





@interface PreferenceController : NSWindowController {
	
	
	SRRecorderControl *hotKeyGoControl;
	SRRecorderControl *hotKeyStopControl; 
	SRRecorderControl *hotKeyUpSelectionControl; 
	SRRecorderControl *hotKeyDownSelectionControl; 
	SRRecorderControl *hotKeyBecomePrimaryControl;
	
	HotKeyController *hotKeyCon; 


}

@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyGoControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyStopControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyUpSelectionControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyDownSelectionControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyBecomePrimaryControl;





@end
