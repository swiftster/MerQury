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
	qlabScripts = [[QlabScripting alloc] init];
	if ([qlabScripts isQlabActive] == TRUE) { 
		[qlabScripts loadQlabArray];  }

	return self; 
}



//Methods called by clients 
-(oneway void)sendCommand:(in int)command
{
	//NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (command == 110) {
		NSLog(@"Client Go Message Recieved Send Command");
		[qlabScripts goCue]; }
	
	if (command == 120) {
		[qlabScripts stopCue]; }
	
	if (command == 130) {
		[qlabScripts moveSelectionUp]; }
	
	if (command == 140) {
		[qlabScripts moveSelectionDown]; }
	
	
}	

-(oneway void)recieveCommand:(in int)command
{
	
	//NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (command == 110) {
		NSLog(@"Server Go Message Recieved");
		[qlabScripts goCue]; }
	
	if (command == 120) {
		[qlabScripts stopCue]; }
	
	if (command == 130) {
		[qlabScripts moveSelectionUp]; }
	
	if (command == 140) {
		[qlabScripts moveSelectionDown]; }
	
	
}
	
-(BOOL)connectClient:(in byref id <ServerMessage>)newClient
{ 

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
