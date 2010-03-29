//
//  ServerThread.h
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MessageServer.h"
#import "CommandMessagesProto.h"
#import "ConnectionMonitor.h"
#include <sys/socket.h>
#import "MessageServer.h"

@class QSyncController;


@interface ServerThread : NSOperation {
	
	QSyncController *appDelegate;
	MessageServer *myServer; 
	
}

@property (assign) QSyncController *appDelegate;
@property (readwrite, assign) MessageServer *myServer;

- (id)initWithDelegate:(QSyncController*)delegate withServer:(MessageServer *)server;



@end
