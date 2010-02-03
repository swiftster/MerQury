//
//  ChatterClientController.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChatterClientController.h"


@implementation ChatterClientController



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
-(oneway void)showMessage:(in bycopy NSString *)message
					fromNickname:(in bycopy NSString *)n 
{
	NSString *string = [NSString stringWithFormat:@"%@ says, \"%@\"\n",n,message];
	
	NSTextStorage *currentContents = [textView textStorage];
	NSRange range = NSMakeRange([currentContents length], 0); 
	[currentContents replaceCharactersInRange:range withString:string]; 
	
	range.length = [string length]; 
	[textView scrollRangeToVisible:range];
	
	//Beep to get attention 
	NSBeep(); 
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
	
	BOOL successful; 
	NSConnection *connection; 
	NSSocketPort *sendPort; 
	
	//Create the send port 
	sendPort = [[NSSocketPort alloc] initRemoteWithTCPPort:8081 host:serverHostName];
	
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
		
		[proxy setProtocolForProxy:@protocol(ChatterServing)];
		
		//Try to subscribe with chosen nickname 
		successful = [proxy subscribeClient:self];
		
		if (successful) {
			[messageField setStringValue:@"Connected"];
		
		} else {
			[messageField setStringValue:@"Name not available"];
			[self cleanUp];
		}
	}
	
	@catch (NSException *e) {
		//The server does not respond in 10 seconds, this handler is called 
		[messageField setStringValue:@"Unable to connect"]; 
		[self cleanUp];
	}
}	
	
//Read Hostname and nickname then connect 
-(IBAction)subscribe:(id)sender 
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
		
		
-(IBAction)sendMessage:(id)sender
{
	NSString *inString; 
	
	//IF there is no proxy, try to connect
	if (!proxy) {
		[self connect]; 
		//If there is still no proxy, bail. 
		if (!proxy) {
			return;
		}
	}
		 
//Read the message from the text field 
	inString = [messageField stringValue]; 
	
	@try {
	//Send message to server 
		[proxy sendMessage:inString fromClient:self]; }
	
	@catch (NSException *e) { 
			//If something goes wrong
		[messageField setStringValue:@"The Connection is down"];
		[self cleanUp]; 
	}
}

-(IBAction)unsubscribe:(id)sender 
{ 
	@try { 
		[proxy unsubscribeClient:self]; 
		[messageField setStringValue:@"Unsubscribed"];
		[self cleanUp]; }
	
	@catch (NSException *e) {
		[messageField setStringValue:@"Error Unsubing"]; 
	
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
		[proxy unsubscribeClient:self];
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
