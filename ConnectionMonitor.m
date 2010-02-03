//
//  ConnectionMonitor.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConnectionMonitor.h"


@implementation ConnectionMonitor

-(BOOL)connection:(NSConnection *)ancestor 
					shouldMakeNewConnection:(NSConnection *)conn 
{
	NSLog(@"creating new connection: %d total connections", [[NSConnection allConnections] count]); 
	
	return YES; 
}

-(void)connectionDidDie:(NSNotification *)note
{ 
	NSConnection *connection = [note object]; 
	NSLog(@"Connection did die: %@", connection); 
}



@end
