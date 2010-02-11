//
//  ChatterServer.m
//  QSync
//
////  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import "MessageServer.h"

NSString * const JATServerGoNotification = @"ServerGoNote";
NSString * const JATServerSelectionUpNotification = @"ServerUpNote";
NSString * const JATServerSelectionDownNotification = @"ServerDownNote";
NSString * const JATServerStopNotification = @"ServerStopNote";

@implementation MessageServer

-(id) initWithConnection:(NSConnection *)connection 
{
	[super init]; 
	clients = [[NSMutableArray alloc] init];
	NSConnection *proxyConnection = connection; 
	
	proxy = [[proxyConnection rootProxy] retain]; 
	[proxy setProtocolForProxy:@protocol(ServerMessage)];
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(serverGoNote:) name:JATServerGoNotification object:nil];
	[nc addObserver:self selector:@selector(serverUpNote:) name:JATServerSelectionUpNotification object:nil];
	[nc addObserver:self selector:@selector(serverDownNote:) name:JATServerSelectionDownNotification object:nil];
	[nc addObserver:self selector:@selector(serverStopNote:) name:JATServerStopNotification object:nil];

	return self; 
}



//Methods called by clients 
-(oneway void)sendCommand:(in int)command
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	
	//NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (command == 110) {
		NSLog(@"Client Go Message Recieved Send Command");
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

-(oneway void)recieveCommand:(in int)command
{
	
	NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (command == 110) {
		NSLog(@"Server Go Message Recieved");
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:JATQlabGoNotification object:self];

	}
	
	if (command == 120) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:JATQlabGoNotification object:self];
	}
	
	if (command == 130) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:JATQlabSelectionUpNotification object:self]; 
	}
	
	if (command == 140) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:JATQlabSelectionDownNotification object:self];
	}
	
	
}
	
-(BOOL)connectClient:(in byref id <ServerMessage>)newClient
{ 

	NSLog(@"adding client"); 
	
	[clients addObject:newClient]; 
	
	return YES; 
} 
						
-(void)disconnectClient:(in byref id <ServerMessage>) client
{ 
	
	NSDistantObject *clientProxy = (NSDistantObject *)client; 
	NSConnection *connection = [clientProxy connectionForProxy]; 
	[clients removeObject:client];
	[connection invalidate]; 
	NSLog(@"Client Removed"); 
}
						
//Notification Handle 

-(void)serverGoNote:(NSNotificationCenter *)note 
{
	[proxy sendCommand:110];
	NSLog(@"Send Server Command");
}

-(void)serverStopNote:(NSNotificationCenter *)note 
{ 
	//[self recieveCommand:120]; 
	
}

-(void)serverUpNote:(NSNotificationCenter *)note 
{ 
	//[self recieveCommand:130]; 
}

-(void)serverDownNote:(NSNotificationCenter *)note
{ 
	//[self recieveCommand:140]; 
}
	
	
@end
