//
//  ServerMessageBroker.h
//  QSSync
//
//  Created by Jason Tratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsyncSocket;
@class Message;
@class MessageBroker;


@interface NSObject (MessageBrokerDelegateMethods)

-(void)messageBroker:(MessageBroker *)server didSendMessage:(Message *)message;
-(void)messageBroker:(MessageBroker *)server didReceiveMessage:(Message *)message;
-(void)messageBrokerDidDisconnectUnexpectedly:(MessageBroker *)server;

@end


@interface MessageBroker : NSObject {
    AsyncSocket *socket;
    BOOL connectionLostUnexpectedly;
    id delegate;
    NSMutableArray *messageQueue;
    BOOL isPaused;
	
	NSTimer *connectionPinger; 
	NSTimer *waitTimer; 
}

-(id)initWithAsyncSocket:(AsyncSocket *)socket;

-(id)delegate;
-(void)setDelegate:(id)value;

-(AsyncSocket *)socket;

-(void)sendMessage:(Message *)newMessage;

-(void)setIsPaused:(BOOL)yn;
-(BOOL)isPaused;


-(void)pingConnection; 
-(void)maintainConnection; 
-(void)timeOutDisconnect;

@end