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

#import	"AboutWindowControl.h"

#import	"DataWindowController.h"
#import	"ClientController.h"
#import "MessageServer.h"

#import "PreferenceController.h"
#import	"HotKeyController.h"


extern NSString * const JATDataRefreshNotification;
extern NSString * const JATModeSelectionNotification;

@class AsyncSocket;
@class MessageBroker;


@interface QSyncController : NSPersistentDocument {
	
	HotKeyController *hotKeyCon;

	IBOutlet NSArrayController *serviceBrowserController; 
	IBOutlet NSTableView *browserTableView;
	
	//iPhone Server 
    NSNetService *netService;
    AsyncSocket *listeningSocket;
    AsyncSocket *connectionSocket;
    MessageBroker *messageBroker;
	NSString *localServerName;
	
	//Client
	ClientController *client;
	NSTimer *wait;
	int retryAttempt; 
	NSNetService *remoteService;
	NSNetServiceBrowser *browser;

	//Qlab
	QlabScripting *qlabScripts;
	
	
	//Server Que 
	NSOperationQueue *doServerOperarionQueue; 
	NSOperation *doServerQueue; 
	NSNetService *macService;

	
	//Qlab  Data Import Operation 
	NSOperationQueue *genericOperationQueue;
	NSOperation *queue;

	//Windows and View Controllers 
	AboutWindowControl *aboutWindow;
	DataWindowController *dataWindow;
	PreferenceController *preferenceWindow; 
	
	
	
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
	BOOL connectMenuItemEnable; 
	BOOL disconnectMenuItemEnable;
	BOOL startServerMenuItemEnable;
	BOOL stopServerMenuItemEnable;
	
	
	//Menus 
	IBOutlet NSMenuItem *toggleKeysMenuItem;
	IBOutlet NSMenuItem *connectMenuItem; 
	IBOutlet NSMenuItem *disconnectMenuItem;
	IBOutlet NSMenuItem *startServerMenuItem; 
	IBOutlet NSMenuItem *stopServerMenuItem;
	  
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
@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readwrite, assign) int retryAttempt;


-(IBAction)search:(id)sender;
-(IBAction)connect:(id)sender;
-(IBAction)disconnectButton:(id)sender;
-(void)disconnect;
-(void)disconnectPause;



//ToolBar 
@property (readwrite, assign) BOOL searchEnabled;
@property (readwrite, assign) BOOL connectEnabled;
@property (readwrite, assign) BOOL disconnectEnabled;
@property (readwrite, assign) BOOL startEnabled;
@property (readwrite, assign) BOOL stopEnabled;

//App Controls
-(IBAction)openAboutWindow: (id) sender;
-(IBAction)openDataViewWindow: (id) sender; 
-(IBAction)openPreferencePanel:(id)sender;
-(IBAction)adjustNow: (id) sender; 
-(IBAction)modeSelection: (id) sender; 
-(void)modeSelectionNote:(NSNotification *)note;

//Qlab Time Cycle 
-(void)activeUpdate;
-(void)qlabMait;
-(void)refreshQlabInfo;
 

-(void)enterMasterMode;
-(void)enterSlaveMode;



//Data Sharing 
-(void)importData;
-(void)startDoServer;
-(void)importSharedData:(NSArray *)array;


-(IBAction)getServerSharedData:(id)sender; 

-(MessageServer *)setupServerClass; 

//Blind Mode 
-(void)remoteDataRefresh;

-(void)sendLevelChangeForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c db:(double)d;
-(void)changeLevelForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c db:(double)d;

-(void)sendCueNameChangeForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)name;
-(void)changeCueNameForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c name:(NSString *)s;

-(void)sendNoteChangesForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)note;
-(void)changeNotesForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)s;

-(void)sendPreWaitForID:(NSString *)unID db:(double)d;
-(void)changePreWaitForID:(NSString *)unID db:(double)d;


-(void)sendPostWaitForID:(NSString *)unID db:(double)d;
-(void)changePostWaitForID:(NSString *)unID db:(double)d;

-(void)sendActionForID:(NSString *)unID db:(double)d;
-(void)changeActionForID:(NSString *)unID db:(double)d;


@end
