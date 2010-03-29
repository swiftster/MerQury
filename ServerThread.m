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
@synthesize myServer;

- (id)initWithDelegate:(QSyncController*)delegate withServer:(MessageServer *)server
{
	
	//NSLog(@"Server Thread"); 
	if (!(self = [super init])) return nil;
	
	appDelegate = delegate;
	myServer = server;
	
	return self;
}



-(void)main 
{ 
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	ConnectionMonitor *monitor = [[ConnectionMonitor alloc] init];
	
	//Create and Destroy port 8081 to insure its open?  Will that work?
	NSSocketPort *testPort; 
	testPort = [[NSSocketPort alloc] initWithTCPPort:8081];
	[testPort invalidate]; 
	[testPort release];
	
	
	//Create Recive Port 
	NSSocketPort *receivePort; 
	@try {
		  //The server will wait for requests on port 8081
		  receivePort = [[NSSocketPort alloc] initWithTCPPort:8081];
		//NSLog(@"Server Recieve Port is Valid:%d", [receivePort isValid]);
		}
		  
	@catch (NSException *e) {
		//NSLog(@"Unable to get port 8081"); 
		exit(-1); 
	}
	
		
	
	//Create the connection object 
	//NSLog(@"Starting Server Connection");
	NSConnection *connection; 
	connection = [NSConnection connectionWithReceivePort:receivePort sendPort:nil];
	
	
	
	//The port is retained by the connection 
	[receivePort release]; 
		  
	//When clients use this connection, they will talk to the Server
	//MessageServer *mServer = [appDelegate setupServerClass];
	[connection setRootObject:myServer]; 
	//NSLog(@"Server Connection Valid:%d", [connection isValid]);
	//NSLog(@"Server Root Object:%@",[connection rootObject]);
	//NSDictionary *dict = [connection statistics];
	//NSLog(@"Connection Stats:%@",[dict description]);
	
	//The Server is retained by the connection 
	[myServer release]; 
	 
	
	
	//Set up the monitor object 
	[connection setDelegate:monitor];
	[[NSNotificationCenter defaultCenter] 
					addObserver:monitor
						selector:@selector(connectionDidDie:)
							name:NSConnectionDidDieNotification
								object:nil];
	
	//Start thr runloop 
	[runLoop run]; 
	//NSLog(@"runLoop state:%@", [runLoop currentMode]);
	
	//If the runloop exits cleanup
	//NSLog(@"Server Loop Ending");
	[connection release]; 
	[monitor release]; 
	[pool release];
	//return 0;
	
}


	
	

@end
