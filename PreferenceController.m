//
//  PreferenceController.m
//  QSync
//
//  Created by Jason Tratta on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"
#import "HotKeyController.h"
#import "SGKeyCombo.h"
#import	"SGHotKeyCenter.h"



@implementation PreferenceController

@synthesize hotKeyGoControl;
@synthesize hotKeyStopControl; 
@synthesize hotKeyUpSelectionControl; 
@synthesize hotKeyDownSelectionControl; 
@synthesize hotKeyBecomePrimaryControl; 



-(id)init 
{ 
	if (![super initWithWindowNibName:@"PreferenceWindow"])
		return nil;
	
		
	
	return self; 
}

-(void)windowDidLoad 
{ 
	hotKeyCon = [HotKeyController sharedHotKeyController]; 

	[hotKeyGoControl setKeyCombo:SRMakeKeyCombo(hotKeyCon.goKey.keyCombo.keyCode, [hotKeyGoControl carbonToCocoaFlags:hotKeyCon.goKey.keyCombo.modifiers])];
	[hotKeyStopControl setKeyCombo:SRMakeKeyCombo(hotKeyCon.stopKey.keyCombo.keyCode, [hotKeyStopControl carbonToCocoaFlags:hotKeyCon.stopKey.keyCombo.modifiers])];
	[hotKeyUpSelectionControl setKeyCombo:SRMakeKeyCombo(hotKeyCon.upKey.keyCombo.keyCode, [hotKeyUpSelectionControl carbonToCocoaFlags:hotKeyCon.upKey.keyCombo.modifiers])];
	[hotKeyDownSelectionControl setKeyCombo:SRMakeKeyCombo(hotKeyCon.downKey.keyCombo.keyCode, [hotKeyDownSelectionControl carbonToCocoaFlags:hotKeyCon.downKey.keyCombo.modifiers])];
	[hotKeyBecomePrimaryControl setKeyCombo:SRMakeKeyCombo(hotKeyCon.primaryKey.keyCombo.keyCode, [hotKeyBecomePrimaryControl carbonToCocoaFlags:hotKeyCon.primaryKey.keyCombo.modifiers])];
}


#pragma mark ShortcutRecorder Delegate Methods

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {	
	return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	SGKeyCombo *keyCombo = [SGKeyCombo keyComboWithKeyCode:[aRecorder keyCombo].code
												 modifiers:[aRecorder cocoaToCarbonFlags:[aRecorder keyCombo].flags]];
	
	if (aRecorder == hotKeyGoControl) {		
		[[hotKeyCon goKey] setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:[hotKeyCon goKey]];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalGoKey];
	} 
	
	if (aRecorder == hotKeyStopControl) {		
		
		[[hotKeyCon stopKey] setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:[hotKeyCon stopKey]];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalStopKey];
	} 
	
	if (aRecorder == hotKeyUpSelectionControl) {		
		[[hotKeyCon upKey] setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:[hotKeyCon upKey]];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalUpKey];
	} 
	
	if (aRecorder == hotKeyDownSelectionControl) {		
		[[hotKeyCon downKey] setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:[hotKeyCon downKey]];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalDownKey];
	} 
	
	if (aRecorder == hotKeyBecomePrimaryControl) {		
		[[hotKeyCon primaryKey] setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:[hotKeyCon primaryKey]];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	} 
	
	
	
	[defaults synchronize];
}





//This method is now call Toggle HiJacked Keys, should rename
/*
-(void)becomePrimaryPresssed:(id)sender { 
	
	
	int i = [keyCaptureButton state];
	//NSLog(@"Key state: %d", [keyCaptureButton state]);
	
	
	if (i == 0) {
		[self enterMasterMode];
		[keyCaptureButton setState:1]; }
	
	if (i == 1) { 
		[self enterSlaveMode]; 
		[keyCaptureButton setState:0];
	}
	
}
*/








@end
