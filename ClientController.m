//
//  ChatterClientController.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClientController.h"
#import <sys/socket.h>

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



	

//Connect to the server 
-(void)connect:(NSData *)address
{

BOOL successful; 
NSConnection *connection; 
NSSocketPort *sendPort; 

//Create the send port INET_TCP is 0x06
sendPort = [[NSSocketPort alloc] initRemoteWithProtocolFamily:AF_INET
												   socketType:SOCK_STREAM
													 protocol:0x06
													  address:address];

//Create a NSConenction 
connection = [NSConnection connectionWithReceivePort:nil sendPort:sendPort]; 

//Set Timeouts to something resonable 
[connection setRequestTimeout:10.0]; 
[connection setReplyTimeout:10.0]; 

//The Send port is retained by the connection 
[sendPort release]; 

@try { 
	//Get the proxy 
	proxy = [[connection rootProxy] retain]; 
	
	//Get informed when connection fails
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(connectionDown:)
												 name:NSConnectionDidDieNotification
											   object:connection]; 
	
	//By telling the proxy about the protocol for the object 
	//it represents, we significantly reduce the network traffic 
	//involved with each invocation 
	
	[proxy setProtocolForProxy:@protocol(ClientMessage)];
	
	//Try to subscribe with chosen nickname 
	successful = [proxy connectClient:self];
	
	if (successful) {
		NSLog(@"Connected");
		
	} else {
		//[messageField setStringValue:@"Name not available"];
		[self cleanUp];
	}
}

@catch (NSException *e) {
	//The server does not respond in 10 seconds, this handler is called 
	//[messageField setStringValue:@"Unable to connect"]; 
	[self cleanUp]; }
}
	
-(void)subscribe
	{
		NSNetService *currentService; 
		
		if (proxy) { 
			NSLog(@"Already Connected"); 
		} else {
			[currentService setDelegate:self]; 
			[currentService resolveWithTimeout:30];
		}
	}
			

-(void)disconnect 
{ 
	@try { 
		[proxy disconnectClient:self]; 
		//[messageField setStringValue:@"Disconnecting"];
		[self cleanUp]; }
	
	@catch (NSException *e) {
		//[messageField setStringValue:@"Error Disconnecting"]; 
	
	}
}

//Delegate Methods 

//If the connection goes down, do cleanup 
-(void)connectionDown:(NSNotification *)note 
{ 
	NSLog(@"Conenction Down:"); 
	//[messageField setStringValue:@"connectons down"];
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
