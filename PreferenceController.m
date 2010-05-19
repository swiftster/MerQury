//
//  PreferenceController.m
//  QSync
//
//  Created by Jason Tratta on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"
#import "SGKeyCombo.h"
#import "SGHotKeyCenter.h"
#import	"QlabScripting.h"


 
NSString *kGlobalGoKey = @"Global Go Key";
NSString *kGlobalStopKey = @"Global Stop Key";
NSString *kGlobalUpKey = @"Global Up Key";
NSString *kGlobalDownKey = @"Global Down Key";
NSString *kGlobalBecomePrimaryKey = @"Global Primary Key";


@implementation PreferenceController

@synthesize hotKeyGoControl;
@synthesize hotKeyStopControl; 
@synthesize hotKeyUpSelectionControl; 
@synthesize hotKeyDownSelectionControl; 
@synthesize hotKeyBecomePrimaryControl; 

@synthesize goKey;
@synthesize stopKey; 
@synthesize upKey; 
@synthesize downKey; 
@synthesize primaryKey;


-(id)init 
{ 
	if (![super initWithWindowNibName:@"PreferenceWindow"])
		return nil;
	
	qlabScripts = [QlabScripting sharedQlabScripting]; 
	
	return self; 
}

-(void)windowDidLoad 
{ 
	NSLog(@"About Nib is loaded"); 
	
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
		[goKey setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:goKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalGoKey];
	} 
	
	if (aRecorder == hotKeyStopControl) {		
		//self.stopKey.keyCombo = keyCombo;
		[stopKey setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:stopKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalStopKey];
	} 
	
	if (aRecorder == hotKeyUpSelectionControl) {		
		[upKey setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:upKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalUpKey];
	} 
	
	if (aRecorder == hotKeyDownSelectionControl) {		
		[downKey setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.downKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalDownKey];
	} 
	
	if (aRecorder == hotKeyBecomePrimaryControl) {		
		[primaryKey setKeyCombo:keyCombo];
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.primaryKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	} 
	
	
	
	[defaults synchronize];
}


# pragma mark -
#pragma mark Register HotKeys 

-(void)registerHotKeys { 
	//GO Key
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:goKey];	
	id goKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalGoKey];
	SGKeyCombo *goKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:goKeyComboPlist] autorelease];
	goKey = [[SGHotKey alloc] initWithIdentifier:kGlobalGoKey keyCombo:goKeyCombo target:self action:@selector(goKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:goKey];
	[hotKeyGoControl setKeyCombo:SRMakeKeyCombo(goKey.keyCombo.keyCode, [hotKeyGoControl carbonToCocoaFlags:goKey.keyCombo.modifiers])];
	
	
	//Stop Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:stopKey];	
	id stopKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalStopKey];
	SGKeyCombo *stopKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:stopKeyComboPlist] autorelease];
	stopKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:stopKeyCombo target:self action:@selector(stopKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:stopKey];
	[hotKeyStopControl setKeyCombo:SRMakeKeyCombo(stopKey.keyCombo.keyCode, [hotKeyStopControl carbonToCocoaFlags:stopKey.keyCombo.modifiers])];
	
	//Up Selection Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:upKey];	
	id upKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalUpKey];
	SGKeyCombo *upKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:upKeyComboPlist] autorelease];
	upKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:upKeyCombo target:self action:@selector(upKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:upKey];
	[hotKeyUpSelectionControl setKeyCombo:SRMakeKeyCombo(upKey.keyCombo.keyCode, [hotKeyUpSelectionControl carbonToCocoaFlags:upKey.keyCombo.modifiers])];
	
	//Down Selection Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:downKey];	
	id downKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalDownKey];
	SGKeyCombo *downKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:downKeyComboPlist] autorelease];
	downKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:downKeyCombo target:self action:@selector(downKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:downKey];
	[hotKeyDownSelectionControl setKeyCombo:SRMakeKeyCombo(downKey.keyCombo.keyCode, [hotKeyDownSelectionControl carbonToCocoaFlags:downKey.keyCombo.modifiers])];
	
	//Become Primary Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:primaryKey];	
	id primaryKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalBecomePrimaryKey];
	SGKeyCombo *primaryKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:primaryKeyComboPlist] autorelease];
	primaryKey = [[SGHotKey alloc] initWithIdentifier:kGlobalBecomePrimaryKey keyCombo:primaryKeyCombo target:self action:@selector(becomePrimaryPresssed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:primaryKey];
	[hotKeyBecomePrimaryControl setKeyCombo:SRMakeKeyCombo(primaryKey.keyCombo.keyCode, [hotKeyBecomePrimaryControl carbonToCocoaFlags:primaryKey.keyCombo.modifiers])];
	
	NSLog(@"Keys Registered");
}

-(void)unregisterHotKeys { 
	NSLog(@"Unregistering Keys");
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:goKey];	
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:stopKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:upKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:downKey];
	//[[SGHotKeyCenter sharedCenter] unregisterHotKey:primaryKey];
}

-(void)clearKeys { 
	
	[goKey setKeyCombo:nil]; 
	
}

#pragma mark Message Center  


//Keys

- (void)goKeyPressed:(id)sender {
	
	NSLog(@"Go Button Pressed");

	[qlabScripts goCue];
}

- (void)stopKeyPressed:(id)sender {
	

	[qlabScripts stopCue];
	
} 

- (void)upKeyPressed:(id)sender {
	
	
	[qlabScripts moveSelectionUp];
	
}

- (void)downKeyPressed:(id)sender {
	
	
	[qlabScripts moveSelectionDown];
	
	
	
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
