//
//  ChatWindowController.m
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChatWindowController.h"


@implementation ChatWindowController


-(id)init 
{ 
	if (![super initWithWindowNibName:@"ChatWindow"])
		return nil;
	
	 
	
	return self; 
}

-(void)windowDidLoad 
{ 
	NSLog(@"Chat Nib is loaded"); 
	
}


@end
