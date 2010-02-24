//
//  ChatterServer.h
//  QSync
//
//  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CommandMessagesProto.h"
#import "ConnectionMonitor.h"
#include <sys/socket.h>
#import "QlabScripting.h"
@class QSyncController; 

//Use notifcations for server return since Server is running on another Thread
extern NSString * const JATServerGoNotification;
extern NSString * const JATServerSelectionUpNotification;
extern NSString * const JATServerSelectionDownNotification;
extern NSString * const JATServerStopNotification;


@interface MessageServer : NSObject <ServerMessage> {
	
	NSMutableArray *clients; 
	id proxy; 
	QSyncController *appDelegate;
	NSManagedObjectContext *mainMOC;


}
@property (assign) QSyncController *appDelegate;
@property (readwrite, assign) NSManagedObjectContext *mainMOC; 



-(id)initWithDelegate:(QSyncController *)delegate andConnection:(NSConnection *)connection;

-(void)proxySendCommand:(int)a;



- (NSManagedObjectContext*)newContextToMainStore;
- (void)contextDidSave:(NSNotification*)notification;

-(void)serverGoNote:(NSNotificationCenter *)note;
-(void)serverStopNote:(NSNotificationCenter *)note;
-(void)serverUpNote:(NSNotificationCenter *)note;
-(void)serverDownNote:(NSNotificationCenter *)note;


@end
