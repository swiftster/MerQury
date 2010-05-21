//
//  HotKeyController.h
//  QSync
//
//  Created by Jason Tratta on 5/20/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SGHotKey.h"
#import "QlabScripting.h"
#import	"MessageServer.h"



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

@property (nonatomic, retain) SGHotKey *goKey;
@property (nonatomic, retain) SGHotKey *stopKey;
@property (nonatomic, retain) SGHotKey *upKey;
@property (nonatomic, retain) SGHotKey *downKey;
@property (nonatomic, retain) SGHotKey *primaryKey; 

+ (HotKeyController *)sharedHotKeyController;

-(void)registerHotKeys;
-(void)unregisterHotKeys;

- (void)goKeyPressed:(id)sender;
- (void)stopKeyPressed:(id)sender;
- (void)upKeyPressed:(id)sender;
- (void)downKeyPressed:(id)sender;
- (void)becomePrimaryPresssed:(id)sender;


@end
