//
//  QSyncController.h
//  QSSync
//
//  Created by Jason Tratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "QlabScripting.h"
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "SGHotKey.h"
#import	"AboutWindowControl.h"

#import	"DataWindowController.h"


extern NSString *kGlobalGoKey;
extern NSString *kGlobalStopKey;
extern NSString *kGlobalUpKey;
extern NSString *kGlobalDownKey;
extern NSString *kGlobalBecomePrimaryKey; 

@class AsyncSocket;
@class MessageBroker;


@interface QSyncController : NSPersistentDocument {
	
	
	
	//Server 
    NSNetService *netService;
    AsyncSocket *listeningSocket;
    AsyncSocket *connectionSocket;
    MessageBroker *messageBroker;
	NSString *localServerName;
	
	//Client
	BOOL isConnected;
    NSNetServiceBrowser *browser;
    NSNetService *connectedService;
    NSMutableArray *services;
    AsyncSocket *socket;
    IBOutlet NSArrayController *servicesController;
	

	//Qlab
	QlabScripting *qlabScripts;
	
	//HotKeys 
	SRRecorderControl *hotKeyGoControl;
	SRRecorderControl *hotKeyStopControl; 
	SRRecorderControl *hotKeyUpSelectionControl; 
	SRRecorderControl *hotKeyDownSelectionControl; 
	SRRecorderControl *hotKeyBecomePrimaryControl;
	SGHotKey *goKey;
	SGHotKey *stopKey;
	SGHotKey *upKey;
	SGHotKey *downKey;
	SGHotKey *primaryKey; 
	
	//Qlab  Data Import Operation 
	NSOperationQueue *genericOperationQueue;
	NSOperation *queue;

	//Windows and View Controllers 
	AboutWindowControl *aboutWindow;
	
	
	IBOutlet NSButton *keyCaptureButton;
	IBOutlet NSTextField *timeAdjustmentField;
	IBOutlet NSMatrix *modeSelectionMatrix; 
	
	//Toolbar 
	IBOutlet NSToolbarItem *serverStartButton;
	IBOutlet NSToolbarItem *serverStopButton;
	
	//Menus 
	IBOutlet NSMenuItem *toggleKeysMenuItem;
	
	  
}

//Server
@property (readwrite, retain) AsyncSocket *listeningSocket;
@property (readwrite, retain) AsyncSocket *connectionSocket;
@property (readwrite, retain) NSString *localServerName;
@property (readwrite, retain) MessageBroker *messageBroker;
-(IBAction)startServer:(id)sender; 
-(IBAction)stopServer:(id)sender; 

-(void)startService;
-(void)stopService;


//Client
@property (readonly, retain) NSMutableArray *services;
@property (readwrite, assign) BOOL isConnected;
@property (readwrite, retain) AsyncSocket *socket;
@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readwrite, retain) NSNetService *connectedService;

-(IBAction)search:(id)sender;
-(IBAction)connect:(id)sender;
-(IBAction)disconnect:(id)sender;


//HotKeys
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyGoControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyStopControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyUpSelectionControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyDownSelectionControl;
@property (nonatomic, retain) IBOutlet SRRecorderControl *hotKeyBecomePrimaryControl;
@property (nonatomic, retain) SGHotKey *goKey;
@property (nonatomic, retain) SGHotKey *stopKey;
@property (nonatomic, retain) SGHotKey *upKey;
@property (nonatomic, retain) SGHotKey *downKey;
@property (nonatomic, retain) SGHotKey *primaryKey; 

-(void)registerHotKeys;
-(void)unregisterHotKeys;
-(void)clearKeys;

//App Controls
-(IBAction)openAboutWindow: (id) sender;
-(IBAction)openDataViewWindow: (id) sender; 
-(IBAction)openAdjustPanel:(id)sender;
-(IBAction)adjustNow: (id) sender; 
-(IBAction)modeSelection: (id) sender; 

-(void)enterMasterMode;
-(void)enterSlaveMode;







@end
