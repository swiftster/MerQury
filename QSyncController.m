//
//  QSyncController.m
//  QSSync
//
//  Created by Jason Tratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//
//
// Connection Mait. is handled by the MessageBroker Class

#import "QSyncController.h"
#import "AsyncSocket.h"
#import "MessageBroker.h"
#import "Message.h"
#import "SGHotKeyCenter.h"
#import	"ImportOp.h"
#import "ServerThread.h"






NSString *kGlobalGoKey = @"Global Go Key";
NSString *kGlobalStopKey = @"Global Stop Key";
NSString *kGlobalUpKey = @"Global Up Key";
NSString *kGlobalDownKey = @"Global Down Key";
NSString *kGlobalBecomePrimaryKey = @"Global Primary Key";



@implementation QSyncController

//Server
@synthesize listeningSocket;
@synthesize connectionSocket;
@synthesize messageBroker;
@synthesize localServerName;

//Client 
@synthesize browser;
@synthesize services;
@synthesize isConnected;
@synthesize connectedService;
@synthesize socket;

//hotkeys
@synthesize hotKeyGoControl;
@synthesize hotKeyStopControl; 
@synthesize hotKeyUpSelectionControl; 
@synthesize hotKeyDownSelectionControl; 
@synthesize hotKeyBecomePrimaryControl; 
@synthesize goKey;
@synthesize stopKey; 
@synthesize upKey; 
@synthesize downKey; 
@synthesize primaryKey; 

//ToolBar
@synthesize searchEnabled;
@synthesize connectEnabled; 
@synthesize disconnectEnabled;
@synthesize startEnabled; 
@synthesize stopEnabled; 

//DOServer 
@synthesize macListeningSocket;


-(id)init
{
	[super init]; 
	qlabScripts = [[QlabScripting alloc] init]; 
		
	client = [[ClientController alloc] init]; 
	mServer = [[MessageServer alloc] init]; 
	queue = [[NSOperationQueue alloc] init];
	
	nc = [NSNotificationCenter defaultCenter];
	
	searchEnabled = TRUE; 
	connectEnabled = TRUE;
	disconnectEnabled = TRUE; 
	
	return self; 
}



-(void)awakeFromNib {    
    
	
	//Client 
	services = [NSMutableArray new];
    self.browser = [[NSNetServiceBrowser new] autorelease];
    self.browser.delegate = self;
    self.isConnected = NO;
	
	
	//Preload Qlab Array
	if ([qlabScripts isQlabActive] == YES) { 
		[self importData]; }
	 
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)theNotification {
	
	[self registerHotKeys]; 
	
	//Server 
	[self startService];
	[self startDoServer];
	[self search:self];
	
}

- (void)applicationWillTerminate:(NSNotification *)theNotification {
	[[NSUserDefaults standardUserDefaults] setObject:[self.goKey.keyCombo plistRepresentation] forKey:kGlobalGoKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.stopKey.keyCombo plistRepresentation] forKey:kGlobalStopKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.upKey.keyCombo plistRepresentation] forKey:kGlobalUpKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.downKey.keyCombo plistRepresentation] forKey:kGlobalDownKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.primaryKey.keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	
	
} 

# pragma mark -
#pragma mark Register HotKeys 

-(void)registerHotKeys { 
	//GO Key
	 [[SGHotKeyCenter sharedCenter] unregisterHotKey:goKey];	
	id goKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalGoKey];
	SGKeyCombo *goKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:goKeyComboPlist] autorelease];
	goKey = [[SGHotKey alloc] initWithIdentifier:kGlobalGoKey keyCombo:goKeyCombo target:self action:@selector(goKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:goKey];
	[hotKeyGoControl setKeyCombo:SRMakeKeyCombo(goKey.keyCombo.keyCode, [hotKeyGoControl carbonToCocoaFlags:goKey.keyCombo.modifiers])];
	
	 	
	//Stop Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:stopKey];	
	id stopKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalStopKey];
	SGKeyCombo *stopKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:stopKeyComboPlist] autorelease];
	stopKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:stopKeyCombo target:self action:@selector(stopKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:stopKey];
	[hotKeyStopControl setKeyCombo:SRMakeKeyCombo(stopKey.keyCombo.keyCode, [hotKeyGoControl carbonToCocoaFlags:stopKey.keyCombo.modifiers])];
	
	//Up Selection Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:upKey];	
	id upKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalUpKey];
	SGKeyCombo *upKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:upKeyComboPlist] autorelease];
	upKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:upKeyCombo target:self action:@selector(upKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:upKey];
	[hotKeyUpSelectionControl setKeyCombo:SRMakeKeyCombo(upKey.keyCombo.keyCode, [hotKeyUpSelectionControl carbonToCocoaFlags:upKey.keyCombo.modifiers])];
	
	//Down Selection Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:downKey];	
	id downKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalDownKey];
	SGKeyCombo *downKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:downKeyComboPlist] autorelease];
	downKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:downKeyCombo target:self action:@selector(downKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:downKey];
	[hotKeyDownSelectionControl setKeyCombo:SRMakeKeyCombo(downKey.keyCombo.keyCode, [hotKeyDownSelectionControl carbonToCocoaFlags:downKey.keyCombo.modifiers])];
	
	//Become Primary Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:primaryKey];	
	id primaryKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalBecomePrimaryKey];
	SGKeyCombo *primaryKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:primaryKeyComboPlist] autorelease];
	primaryKey = [[SGHotKey alloc] initWithIdentifier:kGlobalBecomePrimaryKey keyCombo:primaryKeyCombo target:self action:@selector(becomePrimaryPresssed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:primaryKey];
	[hotKeyBecomePrimaryControl setKeyCombo:SRMakeKeyCombo(primaryKey.keyCombo.keyCode, [hotKeyBecomePrimaryControl carbonToCocoaFlags:primaryKey.keyCombo.modifiers])];
	
	
}

-(void)unregisterHotKeys { 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:goKey];	
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:stopKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:upKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:downKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:primaryKey];
}

-(void)clearKeys { 
	
	[goKey setKeyCombo:nil]; 
	
}

#pragma mark Message Center  


//Keys

- (void)goKeyPressed:(id)sender {
	  
	[client proxySendCommand:110]; 
	[nc postNotificationName:JATServerGoNotification object:self];

	
	
}

- (void)stopKeyPressed:(id)sender {

	[client proxySendCommand:120];
	[nc postNotificationName:JATServerStopNotification object:self];
 
}

- (void)upKeyPressed:(id)sender {
	
	[client proxySendCommand:130];
	[nc postNotificationName:JATServerSelectionUpNotification object:self];
	
}

- (void)downKeyPressed:(id)sender {

	[client proxySendCommand:140];
	[nc postNotificationName:JATServerSelectionDownNotification object:self];

	
}

-(void)becomePrimaryPresssed:(id)sender { 
	
	NSLog(@"Primary Pressed");
	[self enterSlaveMode];
	
}


#pragma mark -
#pragma mark ShortcutRecorder Delegate Methods

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {	
	return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	SGKeyCombo *keyCombo = [SGKeyCombo keyComboWithKeyCode:[aRecorder keyCombo].code
												 modifiers:[aRecorder cocoaToCarbonFlags:[aRecorder keyCombo].flags]];
	
	if (aRecorder == hotKeyGoControl) {		
		self.goKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.goKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalGoKey];
	} 
	
	if (aRecorder == hotKeyStopControl) {		
		self.stopKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.stopKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalStopKey];
	} 
	
	if (aRecorder == hotKeyUpSelectionControl) {		
		self.upKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.upKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalUpKey];
	} 
	
	if (aRecorder == hotKeyDownSelectionControl) {		
		self.downKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.downKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalDownKey];
	} 
	
	if (aRecorder == hotKeyBecomePrimaryControl) {		
		self.primaryKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.primaryKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	} 
	
	
	
	[defaults synchronize];
}




//Client
-(void)dealloc {
    self.connectedService = nil;
    self.browser = nil;
    self.socket = nil;
    self.messageBroker.delegate = nil;
    self.messageBroker = nil;
    [services release];
	
	[self stopService];
    [super dealloc];
	
}


//Server

-(IBAction)startServer:(id)sender { 
	
	[self startService]; 
}
	
-(void)startService {
	//Start iPhone OS Service 
    // Start listening socket
	NSLog(@"Listening, Service Started");
    NSError *error;
    self.listeningSocket = [[[AsyncSocket alloc]initWithDelegate:self] autorelease];
    if ( ![self.listeningSocket acceptOnPort:0 error:&error] ) {
        NSLog(@"Failed to create listening socket");
        return;
    }
	
	
	
    
    // Advertise iphone service with bonjour
    NSString *serviceName = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] hostName]];
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_imerqury._tcp." name:serviceName port:self.listeningSocket.localPort];
    netService.delegate = self;
    [netService publish];
	localServerName = [netService name];
	
	NSString *macName = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] hostName]];
    macService = [[NSNetService alloc] initWithDomain:@"" type:@"_merqury._tcp." name:macName port:8081];
    macService.delegate = self;
    [macService publish];
		
	startEnabled = FALSE; 
	stopEnabled = TRUE; 
	[self validateToolbarItem:serverStartButton];
	[self validateToolbarItem:serverStopButton];
	
}


-(IBAction)stopServer:(id)sender {
	
	[self stopService]; 
}



-(void)stopService {
    self.listeningSocket = nil;
    self.connectionSocket = nil;
    self.messageBroker.delegate = nil;
    self.messageBroker = nil;
	
    [netService stop]; 
    [netService release]; 
	[macService stop]; 
	[macService release]; 
	
	
	[serverStopButton setEnabled:NO];
	[serverStartButton setEnabled:YES];
	NSLog(@"Service Stopped");
	
	startEnabled = TRUE; 
	stopEnabled = FALSE; 
	[self validateToolbarItem:serverStartButton];
	[self validateToolbarItem:serverStopButton];
  
}






#pragma mark Socket Callbacks
- (void) onSocket:(AsyncSocket *) sock didAcceptNewSocket:(AsyncSocket *) newSocket 
{
		
	if( ! listeningSocket ) listeningSocket = [newSocket retain];
	else [newSocket disconnect];
	
	id old = connectionSocket;
	connectionSocket = nil;
	[old setDelegate:nil];
	[old disconnect];
	[old release];
	
}


-(BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	
	
    if ( self.connectionSocket == nil ) {
        self.connectionSocket = sock;
        return YES;
    }
    return NO;
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
	
	
    if ( sock == self.connectionSocket ) {
        self.connectionSocket = nil;
        self.messageBroker = nil;
    }
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	
    MessageBroker *newBroker = [[[MessageBroker alloc] initWithAsyncSocket:sock] autorelease];
    newBroker.delegate = self;
    self.messageBroker = newBroker;
	//[self pingConnection];
	NSLog(@"Connected, Host:%@  Port:%d",host,port);
}






#pragma mark MessageBroker Delegate Methods
-(void)messageBroker:(MessageBroker *)server didReceiveMessage:(Message *)message {
	
	//NSLog(@"Reciveing Message"); 
    if ( message.tag == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (message.tag == 110) {
		NSLog(@"Go Message Recieved");
		[nc postNotificationName:JATQlabGoNotification object:self];
	}
	
	if (message.tag == 120) {
		[nc postNotificationName:JATQlabStopNotification object:self];
	}
	
	if (message.tag == 130) {
		[nc postNotificationName:JATQlabSelectionUpNotification object:self];
	}
	
	if (message.tag == 140) {
		[nc postNotificationName:JATQlabSelectionDownNotification object:self];
	}

	
	if (message.tag == 600) { 
		
		
		[server pingConnection];
	}
	
	if (message.tag == 610) {
		//NSLog(@"Negotiate Disconnect");
		[self disconnectPause]; 
	}
	
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

#pragma mark Client Methods 

-(IBAction)search:(id)sender {
	//Stop and remove the controller before starting a new search or bad things will happen.
	
	[browser stop]; 
	
	[servicesController remove:self];
	
    [self.browser searchForServicesOfType:@"_merqury._tcp." inDomain:@""];
}

-(IBAction)connect:(id)sender {
	id theProxy; 
	
	theProxy = [client proxy];
	if (theProxy) {
		NSLog(@"Already Connected"); 
	} else {
    NSNetService *remoteService = servicesController.selectedObjects.lastObject;
	[remoteService setDelegate:self]; 
	[remoteService resolveWithTimeout:30];}
	
    
}


-(IBAction)disconnectButton:(id)sender { 
	//NSNetService *remoteService = servicesController.selectedObjects.lastObject;
	
}

-(void)disconnectPause 
{ 
	
	NSLog(@"Timer Started");
	wait = [[NSTimer scheduledTimerWithTimeInterval:0.5
											 target:self
										   selector:@selector(disconnect)
										   userInfo:nil 
											repeats:NO] autorelease];			
}

-(void)disconnect
{ 
	NSLog(@"Disconnect Called");
	connectedService = nil; 
	[self.socket disconnect];
	connectionSocket = nil;
	[self search:nil];
	[wait invalidate];
}

#pragma mark Net Service Browser Delegate Methods

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more 
{
	//Exclude self from the server browser
	
	BOOL match; 
	match = [localServerName isEqual:[aService name]];
	
	if (match == TRUE) {
		[servicesController addObject:aService];
		
	} else { 
		
		NSLog(@"Excluding self from server browser"); }
	
	
}

	 
	 
-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more {
    [servicesController removeObject:aService];
    if ( aService == self.connectedService ) self.isConnected = NO;
}

-(void)netServiceDidResolveAddress:(NSNetService *)service {
	NSData *address; 
	NSArray *addressArray = [service addresses]; 
	NSLog(@"Array Count %d", [addressArray count]);
	
	address = [addressArray objectAtIndex:0];
	
	
	[client connect:address]; 
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Could not resolve: %@", errorDict);
	NSLog (@"Address: %@", [service addresses]);
}



#pragma mark App Controls	

-(IBAction)openAboutWindow: (id) sender
{ 
	
	
	//Is About window Nil?
	if (!aboutWindow) { 
		aboutWindow = [[AboutWindowControl alloc] init]; 
	} 
	NSLog(@"showing %@", aboutWindow); 
	[aboutWindow showWindow:self]; 
	
	
	
}

-(IBAction)openDataViewWindow: (id) sender
{ 
	
	
DataWindowController *newWindowController = [[DataWindowController alloc] initWithManagedObjectContext:[self managedObjectContext]];
	[newWindowController setShouldCloseDocument:NO];
	[self addWindowController:newWindowController];
	[newWindowController showWindow:sender];
	
}



-(IBAction)openAdjustPanel:(id)sender { 

}


-(IBAction)adjustNow: (id) sender  {
	
	[qlabScripts adjustLoadTime:[timeAdjustmentField doubleValue]];
}


-(IBAction)modeSelection: (id) sender { 
	
	
	
	int i = [keyCaptureButton state];
	
	if (i == 1) {
		[self enterMasterMode];}
	
	if (i == 0) { 
		[self enterSlaveMode]; }
	

}


#pragma mark  Toolbar Validation 

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	BOOL enable; 
	
	if ([[theItem itemIdentifier] isEqual:@"startServerItem"]) { 
		
		enable = startEnabled; 
		
	} else if ([[theItem itemIdentifier] isEqual:@"stopServerItem"]) { 
	
		enable = stopEnabled; 
	
	} else if ([[theItem itemIdentifier] isEqual:@"searchItem"]) { 
		
		enable = searchEnabled; 
	
	} else if ([[theItem itemIdentifier] isEqual:@"connectItem"]) { 
		
		enable = connectEnabled; 
	
	} else if ([[theItem itemIdentifier] isEqual:@"disconnectItem"]) { 
		
		enable = disconnectEnabled; 
	}
	
	
	return enable;
	
}


-(void)enterMasterMode { 
	
	NSLog(@"Master Mode");
	[self registerHotKeys];
	[qlabScripts loadQlabArray];
	[toggleKeysMenuItem setState:1];
		
	
}

-(void)enterSlaveMode { 
	
	NSLog(@"Slave Mode");
	[self unregisterHotKeys];
	[qlabScripts loadQlabArray];
	[toggleKeysMenuItem setState:0];
	
	
}


#pragma mark -
#pragma mark Qlab Data Import Methods


-(void)importData
{ 
	ImportOp *operation = nil;
	operation = [[ImportOp alloc] initWithDelegate:self];
	if (!queue) {
		queue = [[NSOperationQueue alloc] init]; }
	
	
	ImportOp *op = nil;
	op = [[ImportOp alloc] initWithDelegate:self];
	
	if (!genericOperationQueue) {
		genericOperationQueue = [[NSOperationQueue alloc] init];
	}
	
	[genericOperationQueue addOperation:op];
	[op release], op = nil;
	
}

-(void)startDoServer 
{ 
	ServerThread *operation = nil;
	operation = [[ServerThread alloc] init];
	if (!doServerQueue) {
		doServerQueue = [[NSOperationQueue alloc] init]; }
	
	
	ServerThread *op = nil;
	op = [[ServerThread alloc] init];
	
	if (!doServerOperarionQueue) {
		doServerOperarionQueue = [[NSOperationQueue alloc] init];
	}
	
	[doServerOperarionQueue addOperation:op];
	[op release], op = nil;
}
	

@end


