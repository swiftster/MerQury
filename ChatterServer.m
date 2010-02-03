//
//  ChatterServer.m
//  QSync
//
////  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import "ChatterServer.h"


@implementation ChatterServer

-(id) init 
{
	[super init]; 
	clients = [[NSMutableArray alloc] init];
	return self; 
}

//Private Method

-(id)clientWithNickname:(NSString *)string 
{
	id currentClient; 
	NSEnumerator *enumerator; 
	
	enumerator = [clients objectEnumerator];
	
	while (currentClient = [enumerator nextObject]) {
		
		if ([[currentClient nickname] isEqual:string]) {
			
			return currentClient; 
	}
}

	return nil;
}

//Methods called by clients 

-(oneway void)sendMessage:(in bycopy NSString *)message
			   fromClient:(in byref id <ChatterUsing>)client
{
	NSString *senderNickname; 
	id currentClient; 
	NSEnumerator *enumerator; 
	
	senderNickname = [client nickname];
	
	enumerator = [clients objectEnumerator];
	
	NSLog(@"from %@: %@",senderNickname, message); 
	
	while (currentClient = [enumerator nextObject]) {
		[currentClient showMessage:message fromNickname:senderNickname];
	}
	
}
	
-(BOOL)subscribeClient:(in byref id <ChatterUsing>)newClient
{ 
	NSString *newNickname = [newClient nickname]; 
	
	//Is the nickname taken?
	
	if ([self clientWithNickname:newNickname]) {
		return NO; } 
	
	NSLog(@"adding client"); 
	
	[clients addObject:newClient]; 
	
	return YES; 
} 
						
-(void)unsubscribeClient:(in byref id <ChatterUsing>) client
{ 
	
	NSDistantObject *clientProxy = (NSDistantObject *)client; 
	NSConnection *connection = [clientProxy connectionForProxy]; 
	[clients removeObject:client];
	[connection invalidate]; 
	NSLog(@"Client Removed"); 
}
						
						
	
	
@end
