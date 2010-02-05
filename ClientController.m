//
//  ChatterClientController.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClientController.h"


@implementation ClientController



//Private Method to clean up connection and proxy 
-(void) cleanUp 
{ 

	NSConnection *connection = [proxy connectionForProxy]; 
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[connection invalidate]; 
	[proxy release]; 
	proxy = nil;
}


//Show Message coming in from server 
-(oneway void)sendCommand:(in int)command
{
	
	//NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (command == 110) {
		NSLog(@"Go Message Recieved");
		[qlabScripts goCue]; }
	
	if (command == 120) {
		[qlabScripts stopCue]; }
	
	if (command == 130) {
		[qlabScripts moveSelectionUp]; }
	
	if (command == 140) {
		[qlabScripts moveSelectionDown]; }
	
	
}

	

//Accessors 
-(bycopy NSString *)nickname 
{ 
	return nickname;
}

-(void)setNickname:(NSString *)s 
{ 
	[s retain]; 
	[nickname release]; 
	nickname = s; 
}

-(void)setServerHostname:(NSString	*)s 
{ 
	
	[s retain]; 
	[serverHostName release]; 
	serverHostName = s; 
}

//Connect to the server 
-(void)connect
{
	
}
	
//Read Hostname and nickname then connect 
-(void)subscribe
{ 
	
	//Is the sender user already subscribed?
	if (proxy) { 
		[messageField setStringValue:@"unsubscribe first!"]; 
	} else { 
		//Read the hostname from UI 
		[self setServerHostname:[hostField stringValue]]; 
		[self setNickname:[nicknameField stringValue]]; 
		
		 //connect 
		 
		 [self connect]; }
		 
}
		
		


-(void)disconnect 
{ 
	@try { 
		[proxy disconnectClient:self]; 
		[messageField setStringValue:@"Disconnecting"];
		[self cleanUp]; }
	
	@catch (NSException *e) {
		[messageField setStringValue:@"Error Disconnecting"]; 
	
	}
}

//Delegate Methods 

//If the connection goes down, do cleanup 
-(void)connectionDown:(NSNotification *)note 
{ 
	NSLog(@"Conenction Down:"); 
	[messageField setStringValue:@"connectons down"];
	[self cleanUp]; 
}

//If the app terminates, unsub 
-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)app 
{ 
	
	NSLog(@"invalidating connection"); 
	if (proxy) { 
		[proxy disconnectClient:self];
		[[proxy connectionForProxy] invalidate];
	}
	return NSTerminateNow; 
}

-(void)dealloc 
{
	[self cleanUp]; 
	[super dealloc]; 
}
	




@end
