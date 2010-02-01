//
//  ServerMessageBroker.m
//  QSSync
//
//  Created by jtratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//


#import "MessageBroker.h"
#import "AsyncSocket.h"
#import "Message.h"


static const unsigned int MessageHeaderSize = sizeof(UInt64);
static const float SocketTimeout = -1.0;


@implementation MessageBroker

-(id)initWithAsyncSocket:(AsyncSocket *)newSocket {
    if ( self = [super init] ) {
        if ( [newSocket canSafelySetDelegate] ) {
            socket = [newSocket retain];
            [newSocket setDelegate:self];
            messageQueue = [NSMutableArray new];
            [socket readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:0];
			[self pingConnection]; 
        }
        else {
            NSLog(@"Could not change delegate of socket");
            [self release];
            self = nil;
        }
    }
    return self;
}

-(void)dealloc {
	
    [socket setDelegate:nil];
    if ( [socket isConnected] ) [socket disconnect];
    [socket release];
    [messageQueue release];
    [super dealloc];
}

-(id)delegate {
    return delegate;
}

-(void)setDelegate:(id)value {
    delegate = value;
}

-(AsyncSocket *)socket {
    return [[socket retain] autorelease];
}

-(void)setIsPaused:(BOOL)yn {
    if ( yn != isPaused ) {
        isPaused = yn;
        if ( !isPaused ) {
            [socket readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:(long)0];
        }
    }
}

-(BOOL)isPaused {
    return isPaused;
}


#pragma mark Sending/Receiving Messages
-(void)sendMessage:(Message *)message {
	//NSLog(@"Broker Sending");
    [messageQueue addObject:message];
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    UInt64 header[1];
    header[0] = [messageData length]; 
    header[0] = CFSwapInt64HostToLittle(header[0]);  // Send header in little endian byte order
    [socket writeData:[NSData dataWithBytes:header length:MessageHeaderSize] withTimeout:SocketTimeout tag:(long)0];
    [socket writeData:messageData withTimeout:SocketTimeout tag:(long)1];
}


#pragma mark Socket Callbacks
-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    if ( connectionLostUnexpectedly ) {
        if ( delegate && [delegate respondsToSelector:@selector(messageBroker:didDisconnectUnexpectedly:)] ) {
            [delegate messageBrokerDidDisconnectUnexpectedly:self];
        }
    }
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    connectionLostUnexpectedly = YES;
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	//NSLog(@"Message Incoming");
    if ( tag == 0 ) {
        // Header
        UInt64 header = *((UInt64*)[data bytes]);
        header = CFSwapInt64LittleToHost(header);  // Convert from little endian to native
        [socket readDataToLength:(CFIndex)header withTimeout:SocketTimeout tag:(long)1];
    }

	else if ( tag == 1 ) { 
        // Message body. Pass to delegate
        if ( delegate && [delegate respondsToSelector:@selector(messageBroker:didReceiveMessage:)] ) {
            Message *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [delegate messageBroker:self didReceiveMessage:message];
        }
        
        // Begin listening for next message
        if ( !isPaused ) [socket readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:(long)0];
    }
 
	else {
	

        NSLog(@"Unknown tag in read of socket data %d", tag);
    }
	

	
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if ( tag == 1 ) {
        // If the message is now complete, remove from queue, and tell the delegate
        Message *message = [[[messageQueue objectAtIndex:0] retain] autorelease];
        [messageQueue removeObjectAtIndex:0];
        if ( delegate && [delegate respondsToSelector:@selector(messageBroker:didSendMessage:)] ) {
            [delegate messageBroker:self didSendMessage:message];
        }
    }
}

// Connection Mait. 

-(void)pingConnection 
{ 
	[waitTimer invalidate];
	////[waitTimer release];
	waitTimer = nil; 
	
	connectionPinger = [[NSTimer scheduledTimerWithTimeInterval:0.5
														 target:self
													   selector:@selector(maintainConnection)
													   userInfo:nil 
														repeats:NO] autorelease]; 
	//Start CountDown
	
	waitTimer = [[NSTimer scheduledTimerWithTimeInterval:2
												  target:self
												selector:@selector(timeOutDisconnect) 
												userInfo:nil 
												 repeats:NO] autorelease];
	
}

-(void)maintainConnection 
{ 
	
	Message *newMessage = [[[Message alloc] init] autorelease]; 
	newMessage.tag = 600;
	
	[self sendMessage:newMessage]; 
	
	//NSLog(@"Ping");
	[connectionPinger invalidate]; 
	[connectionPinger release]; 
	connectionPinger = nil; 
}

-(void)timeOutDisconnect 
{ 
	NSLog(@"TimeOut Called"); 
	[socket setDelegate:nil];
    if ( [socket isConnected] ) [socket disconnect];
    [socket release];
    [messageQueue release];
	
	
	
}



@end
