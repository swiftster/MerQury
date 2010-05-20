//
//  HotKeyController.h
//  QSync
//
//  Created by Jason Tratta on 5/20/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *kGlobalGoKey;
extern NSString *kGlobalStopKey;
extern NSString *kGlobalUpKey;
extern NSString *kGlobalDownKey;
extern NSString *kGlobalBecomePrimaryKey;


@interface HotKeyController : NSObject {
	
	SGHotKey *goKey;
	SGHotKey *stopKey;
	SGHotKey *upKey;
	SGHotKey *downKey;
	SGHotKey *primaryKey; 
	
	QlabScripting *qlabScripts;
	MessageServer *server;
	
	

}

@end
