//
//  ChatterServing.h
//  QSync
//
///  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import <Foundation/Foundation.h>

//Message the client will receive from the server
@protocol ChatterUsing

-(oneway void)showMessage:(in bycopy NSString *)message
			 fromNickname:(in bycopy NSString *)nickname;

-(bycopy NSString *)nickname;

@end



//Message the server will receive from the client 
@protocol ChatterServing

-(oneway void)sendMessage:(in bycopy NSString *)message
			 fromClient:(in bycopy NSString *)client;

//Returns NO if someone already has newClients nickname 
-(BOOL)subscribeClient:(in byref id <ChatterUsing>)newClient; 

-(void)unsubscribeClient:(in byref id <ChatterUsing>)client;

@end 


