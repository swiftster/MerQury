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
			   fromClient:(in bycopy NSString *)client
{
	NSString *senderNickname; 
	id currentClient; 
	NSEnumerator *enumerator; 
	
	senderNickname = [client nickname];
	
	enumerator = [clients objectEnumerator];
	
	//Finish this from book pg. 452
	
}
	
	
	
	
	
	
	
	
	

@end
