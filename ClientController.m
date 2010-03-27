//
//  ChatterClientController.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClientController.h"
#import <sys/socket.h>
#import "CommandMessagesProto.h"
#import "QlabScripting.h"


@implementation ClientController

@synthesize proxy;
@synthesize moc; 

//Private Method to clean up connection and proxy 
-(void) cleanUp 
{ 
	NSLog(@"Client Clean Up");
	NSConnection *connection = [proxy connectionForProxy]; 
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[connection invalidate]; 
	[proxy release]; 
	proxy = nil;
	
	
}

-(id)initWithManagedObjectContect:(NSManagedObjectContext *)mainMoc 
{ 
	moc = mainMoc; 
	
	[super init]; 
	return self; 
}


//Show Message coming in from server 
-(oneway void)commandFromServer:(in int)command
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	 
	if (command == 110) {
		NSLog(@"Client Go Message Recieved");
		[nc postNotificationName:JATQlabGoNotification object:self];
		
	}
	
	if (command == 120) {
		[nc postNotificationName:JATQlabStopNotification object:self];
	}
	 
	if (command == 130) {
		[nc postNotificationName:JATQlabSelectionUpNotification object:self];
	}
	
	if (command == 140) {
		[nc postNotificationName:JATQlabSelectionDownNotification object:self];
	}
	
	
}

-(void)updateModalFromServer 
{ 
	NSArray *serverObjects; 
	serverObjects = [proxy allObjects]; 
	
	NSLog(@"Client Object Count:%@",[serverObjects count]);
	
}

-(byref NSArray *)allObjectsClient
{ 
	
	NSManagedObjectContext *context = moc;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Server"
											  inManagedObjectContext:context];
	[request setEntity:entity]; 
	
	NSError *error = nil; 
	
	NSArray *objects = [context executeFetchRequest:request error:&error];
	[request release], request = nil;
	
	if (error) {
		NSLog(@"%@:%s error %@", [self class], _cmd, error); 
		return nil; 
	}
	
	NSLog(@"Main Thread Object Count:%d", [objects count]);
	return objects;
	
}




-(void)proxySendCommand:(int)a 
{ 

}

	

//Connect to the server 
-(BOOL)connect:(NSData *)address
{

BOOL successful; 
NSConnection *connection; 
NSSocketPort *sendPort; 

	NSLog(@"Client: Connecting...");	

//Create the send port INET_TCP is 0x06
sendPort = [[NSSocketPort alloc] initRemoteWithProtocolFamily:AF_INET
												   socketType:SOCK_STREAM
													 protocol:0x06
													  address:address];

//Create a NSConenction 
connection = [NSConnection connectionWithReceivePort:nil sendPort:sendPort]; 
	
		NSLog(@"Client Connection is valid:%d", [connection isValid]);

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
		NSLog(@"Connected to Server");
		
		
	} else {
		//[messageField setStringValue:@"Name not available"];
		[self cleanUp];
	}
	
	
}

@catch (NSException *e) {
	//The server does not respond in 10 seconds, this handler is called 
	//[messageField setStringValue:@"Unable to connect"]; 
	[self cleanUp]; }
	
	return successful;
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
	NSLog(@"Client Disconnect Called");
	
	
		[proxy disconnectClient:self]; 
		[self cleanUp]; 
		NSLog(@"Cleanup:"); 
	
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
