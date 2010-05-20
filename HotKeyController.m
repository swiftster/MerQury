//
//  HotKeyController.m
//  QSync
//
//  Created by Jason Tratta on 5/20/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import "HotKeyController.h"




NSString *kGlobalGoKey = @"Global Go Key";
NSString *kGlobalStopKey = @"Global Stop Key";
NSString *kGlobalUpKey = @"Global Up Key";
NSString *kGlobalDownKey = @"Global Down Key";
NSString *kGlobalBecomePrimaryKey = @"Global Primary Key";

@implementation HotKeyController



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




@end
