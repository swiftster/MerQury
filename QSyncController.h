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
#import "ChatWindowController.h"
#import	"ClientController.h"
#import "MessageServer.h"


extern NSString *kGlobalGoKey;
extern NSString *kGlobalStopKey;
extern NSString *kGlobalUpKey;
extern NSString *kGlobalDownKey;
extern NSString *kGlobalBecomePrimaryKey; 

@class AsyncSocket;
@class MessageBroker;


@interface QSyncController : NSPersistentDocument {
	
	
	//Notification 
	NSNotificationCenter *nc;
	
	//iPhone Server 
    NSNetService *netService;
    AsyncSocket *listeningSocket;
    AsyncSocket *connectionSocket;
    MessageBroker *messageBroker;
	NSString *localServerName;
	
	//Client
	ClientController *client;
	BOOL isConnected;
    NSNetServiceBrowser *browser;
    NSNetService *connectedService;
    NSMutableArray *services;
    AsyncSocket *socket;
    IBOutlet NSArrayController *servicesController;
	NSTimer *wait;
	

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
	
	//DO Server Que 
	NSOperationQueue *doServerOperarionQueue; 
	NSOperation *doServerQueue; 
	NSNetService *macService;
	MessageServer *mServer;
	
	//Qlab  Data Import Operation 
	NSOperationQueue *genericOperationQueue;
	NSOperation *queue;

	//Windows and View Controllers 
	AboutWindowControl *aboutWindow;
	ChatWindowController *chatWindow;
	
	
	IBOutlet NSButton *keyCaptureButton;
	IBOutlet NSTextField *timeAdjustmentField;
	IBOutlet NSMatrix *modeSelectionMatrix; 
	
	//Toolbar 
	IBOutlet NSToolbarItem *searchButton;
	IBOutlet NSToolbarItem *connectButton;
	IBOutlet NSToolbarItem *disconnectButton;
	IBOutlet NSToolbarItem *serverStartButton;
	IBOutlet NSToolbarItem *serverStopButton;
	
	BOOL searchEnabled;
	BOOL connectEnabled; 
	BOOL disconnectEnabled; 
	BOOL startEnabled; 
	BOOL stopEnabled; 
	
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
-(IBAction)disconnectButton:(id)sender;
-(void)disconnect;
-(void)disconnectPause;


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

//ToolBar 
@property (readwrite, assign) BOOL searchEnabled;
@property (readwrite, assign) BOOL connectEnabled;
@property (readwrite, assign) BOOL disconnectEnabled;
@property (readwrite, assign) BOOL startEnabled;
@property (readwrite, assign) BOOL stopEnabled;

//App Controls
-(IBAction)openAboutWindow: (id) sender;
-(IBAction)openDataViewWindow: (id) sender; 
-(IBAction)openAdjustPanel:(id)sender;
-(IBAction)adjustNow: (id) sender; 
-(IBAction)modeSelection: (id) sender; 
-(IBAction)openChat:(id)sender; 

-(void)enterMasterMode;
-(void)enterSlaveMode;

//DOServer 
@property (readwrite, retain) AsyncSocket *macListeningSocket;

//Data Sharing 
-(void)importData;

-(void)startDoServer;



@end
