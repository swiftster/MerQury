//
//  chatterd.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerThread.h"


@implementation ServerThread

@synthesize appDelegate;

- (id)initWithDelegate:(QSyncController*)delegate
{
	
	NSLog(@"Server Thread"); 
	if (!(self = [super init])) return nil;
	
	
	appDelegate = delegate;

	return self;
}



-(void)main 
{ 
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	ConnectionMonitor *monitor = [[ConnectionMonitor alloc] init];
	
	
	
	//Create Recive Port 
	NSSocketPort *receivePort; 
	@try {
		  //The server will wait for requests on port 8081
		  receivePort = [[NSSocketPort alloc] initWithTCPPort:8081]; }
		  
	@catch (NSException *e) {
		NSLog(@"Unable to get port 8081"); 
		exit(-1); 
	}
		  
	//Create the connection object 
	NSLog(@"Starting Server Connection");
	NSConnection *connection; 
	connection = [NSConnection connectionWithReceivePort:receivePort sendPort:nil];
	
	//The port is retained by the connection 
	[receivePort release]; 
		  
	//When clients use this connection, they will talk to the Server
	MessageServer *mServer = [[MessageServer alloc] initWithDelegate:appDelegate];
	[connection setRootObject:mServer]; 
	
	
	//The Server is retained by the connection 
	[mServer release]; 
	
	//Set up the monitor object 
	[connection setDelegate:monitor];
	[[NSNotificationCenter defaultCenter] 
					addObserver:monitor
						selector:@selector(connectionDidDie:)
							name:NSConnectionDidDieNotification
								object:nil];
	
	//Start thr runloop 
	[runLoop run]; 
	
	//If the runloop exits cleanup 
	[connection release]; 
	[monitor release]; 
	[pool release];
	//return 0;
	
}

@end
