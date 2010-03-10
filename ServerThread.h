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
@class QSyncController;


@interface ServerThread : NSOperation {
	
	
	QSyncController *appDelegate;

	
}

@property (assign) QSyncController *appDelegate;





@end
