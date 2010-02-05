//
//  ChatterClientController.h
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CommandMessagesProto.h"
#import "QlabScripting.h"

@interface ClientController : NSObject <ServerMessage> {
	
	IBOutlet NSTextField *hostField; 
	IBOutlet NSTextField *messageField; 
	IBOutlet NSTextField *nicknameField; 
	IBOutlet NSTextView	 *textView; 
	NSString *nickname; 
	NSString *serverHostName; 
	id proxy;
	
	QlabScripting *qlabScripts;
	
}

 
-(void)connect;
-(void)disconnect;


@end
