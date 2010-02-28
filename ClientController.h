//
//  ChatterClientController.h
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CommandMessagesProto.h"
#import "QlabScripting.h"
#import <sys/socket.h>

@interface ClientController : NSObject <ServerMessage> {
	
	
	NSString *nickname; 
	NSString *serverHostName; 
	id proxy;
	
	
	
	
}

@property (readwrite, assign) id proxy;
-(BOOL)connect:(NSData *)address;
-(void)disconnect;
-(void)proxySendCommand:(int)a;
 


@end
