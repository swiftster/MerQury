//
//  ChatterServer.m
//  QSync
//
////  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import "MessageServer.h"


@implementation MessageServer

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
		
		if ([[currentClient clientName] isEqual:string]) {
			
			return currentClient; 
	}
}

	return nil;
}

//Methods called by clients 

	
-(BOOL)connectClient:(in byref id <ServerMessage>)newClient
{ 
	NSString *newNickname = [newClient clientName]; 
	
	//Is the nickname taken?
	
	if ([self clientWithNickname:newNickname]) {
		return NO; } 
	
	NSLog(@"adding client"); 
	
	[clients addObject:newClient]; 
	
	return YES; 
} 
						
-(void)disconnectClient:(in byref id <ServerMessage>) client
{ 
	
	NSDistantObject *clientProxy = (NSDistantObject *)client; 
	NSConnection *connection = [clientProxy connectionForProxy]; 
	[clients removeObject:client];
	[connection invalidate]; 
	NSLog(@"Client Removed"); 
}
						
						
	
	
@end
