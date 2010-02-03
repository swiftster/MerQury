//
//  ChatterClientController.h
//  QSync
//
//  Created by jtratta on 2/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChatterServing.h"

@interface ChatterClientController : NSObject <ChatterUsing> {
	
	IBOutlet NSTextField *hostField; 
	IBOutlet NSTextField *messageField; 
	IBOutlet NSTextField *nicknameField; 
	IBOutlet NSTextView	 *textView; 
	NSString *nickname; 
	NSString *serverHostName; 
	id proxy;
	
}

 

-(IBAction)sendMessage:(id)sender; 
-(IBAction)subscribe:(id)sender;
-(IBAction)unsubscibe:(id)sender;


@end
