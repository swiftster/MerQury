//
//  ChatterServer.h
//  QSync
//
//  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CommandMessagesProto.h"
#import "QlabScripting.h"


@interface MessageServer : NSObject <ServerMessage> {
	
	NSMutableArray *clients; 


}


@end
