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

//Use notifcations for server return since Server is running on NSOperation
extern NSString * const JATServerGoNotification;
extern NSString * const JATServerSelectionUpNotification;
extern NSString * const JATServerSelectionDownNotification;
extern NSString * const JATServerStopNotification;


@interface MessageServer : NSObject <ServerMessage> {
	
	NSMutableArray *clients; 
	id proxy; 

}

-(id) initWithConnection:(NSConnection *)connection;
-(void)serverGoNote:(NSNotificationCenter *)note;
-(void)serverStopNote:(NSNotificationCenter *)note;
-(void)serverUpNote:(NSNotificationCenter *)note;
-(void)serverDownNote:(NSNotificationCenter *)note;


@end
