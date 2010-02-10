//
//  CommandMessages.h
//  QSync
//
//  Created by Jason Tratta on 2/5/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Foundation/Foundation.h>

//Message the client will recieve from the server
@protocol ServerMessage 


//Qlab Commands 
-(oneway void)sendCommand:(in int)command; 




@end

//Message the server will recieve from the client 

@protocol ClientMessage


//Returns NO if someone already has newClients nickname 
-(BOOL)connectClient:(in byref id <ServerMessage>)newClient; 

-(void)disconnectClient:(in byref id <ServerMessage>)client;

-(oneway void)recieveCommand:(in int)command;




@end
