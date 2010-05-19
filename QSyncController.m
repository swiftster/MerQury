//
//  QSyncController.m
//  QSSync
//
//  Created by Jason Tratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//
//


#import "QSyncController.h"
#import "AsyncSocket.h"
#import "MessageBroker.h"
#import "Message.h"

#import	"ImportOp.h"
#import "ServerThread.h"
#import "ServerBrowser.h"
#import "MessageServer.h"
#import "SharedDataImport.h"


NSString * const JATDataRefreshNotification = @"DataRefreshNote";



@implementation QSyncController



//Server
@synthesize listeningSocket;
@synthesize connectionSocket;
@synthesize messageBroker;
@synthesize localServerName;

//Browser
@synthesize browser;

//Client
@synthesize retryAttempt;


//ToolBar
@synthesize searchEnabled;
@synthesize connectEnabled; 
@synthesize disconnectEnabled;
@synthesize startEnabled; 
@synthesize stopEnabled; 

#pragma mark -
#pragma mark Application Life Cycles
#pragma mark -

-(id)init
{
	[super init]; 
	
	 
	queue = [[NSOperationQueue alloc] init];
	remoteService = [[NSNetService alloc] init]; 
	
	qlabScripts = [QlabScripting sharedQlabScripting];
	
	searchEnabled = TRUE; 
	connectEnabled = TRUE;
	disconnectEnabled = TRUE; 
	connectEnabled = YES; 
	disconnectEnabled = NO;
	
	preferenceWindow = [[PreferenceController  alloc] init];
	
	
	
	return self; 
}



-(void)awakeFromNib {    
    
	browser = [[NSNetServiceBrowser new] autorelease];
	[browser setDelegate:self];
    
   
	
	
}


- (void)applicationDidFinishLaunching:(NSNotification *)theNotification {
	
	client = [[ClientController alloc] initWithManagedObjectContect:[self managedObjectContext]];
	[self startService];
	[self startDoServer];
	[self search:self];
	[preferenceWindow registerHotKeys]; 
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(refreshQlabInfo:) name:JATDataRefreshNotification object:nil];
	
	//Preload Qlab Array
	if ([qlabScripts isQlabActive] == YES) { 
		[self importData]; }
	
	[self enterSlaveMode];
	[self activeUpdate];

}

- (void)applicationWillTerminate:(NSNotification *)theNotification {
	[[NSUserDefaults standardUserDefaults] setObject:[preferenceWindow.goKey.keyCombo plistRepresentation] forKey:kGlobalGoKey];
	[[NSUserDefaults standardUserDefaults] setObject:[preferenceWindow.stopKey.keyCombo plistRepresentation] forKey:kGlobalStopKey];
	[[NSUserDefaults standardUserDefaults] setObject:[preferenceWindow.upKey.keyCombo plistRepresentation] forKey:kGlobalUpKey];
	[[NSUserDefaults standardUserDefaults] setObject:[preferenceWindow.downKey.keyCombo plistRepresentation] forKey:kGlobalDownKey];
	[[NSUserDefaults standardUserDefaults] setObject:[preferenceWindow.primaryKey.keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	
	[client disconnect];
} 


-(void)dealloc {
    
	
    browser = nil;
    [messageBroker setDelegate:nil];
    messageBroker = nil;
    [self stopService];
	[qlabScripts release];
	[client release];
	[queue release];
	[remoteService release];
	
	
    [super dealloc];
	
}

#pragma mark Message Center  

/*
//Keys

- (void)goKeyPressed:(id)sender {
	
	//NSLog(@"Go Button Pressed");
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc postNotificationName:JATServerGoNotification object:self];
	[qlabScripts goCue];
}

- (void)stopKeyPressed:(id)sender {

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:JATServerStopNotification object:self];
	[nc postNotificationName:JATQlabStopNotification object:self];
	
}

- (void)upKeyPressed:(id)sender {
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:JATServerSelectionUpNotification object:self];
	[nc postNotificationName:JATQlabSelectionUpNotification object:self];
	
}

- (void)downKeyPressed:(id)sender {

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:JATServerSelectionDownNotification object:self];
	[nc postNotificationName:JATQlabSelectionDownNotification object:self];
	

	
}

//This method is now call Toggle HiJacked Keys, should rename

-(void)becomePrimaryPresssed:(id)sender { 
	
	
	int i = [keyCaptureButton state];
	//NSLog(@"Key state: %d", [keyCaptureButton state]);
	
	
	if (i == 0) {
		[self enterMasterMode];
		[keyCaptureButton setState:1]; }
	
	if (i == 1) { 
		[self enterSlaveMode]; 
		[keyCaptureButton setState:0];
	}
	
}
*/
//Server

-(IBAction)startServer:(id)sender { 
	
	[self startService]; 
}
	
-(void)startService {
	//Start iPhone OS Service 
    // Start listening socket

    NSError *error;
    listeningSocket = [[[AsyncSocket alloc]initWithDelegate:self] autorelease];
    if ( ![listeningSocket acceptOnPort:0 error:&error] ) {
       // NSLog(@"Failed to create listening socket");
        return;
    }
	
    
    // Advertise iphone service with bonjour
    NSString *serviceName = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] hostName]];
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_imerqury._tcp." name:serviceName port:self.listeningSocket.localPort];
	[netService setDelegate:self];
    [netService publish];
	localServerName = [netService name];
	
	NSString *macName = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] hostName]];
    macService = [[NSNetService alloc] initWithDomain:@"" type:@"_merqury._tcp." name:macName port:8081];
    [macService setDelegate:self];
    [macService publish];
	
	startEnabled = FALSE; 
	stopEnabled = TRUE; 
	[self validateToolbarItem:serverStartButton];
	[self validateToolbarItem:serverStopButton];
	[startServerMenuItem setEnabled:NO]; 
	[stopServerMenuItem setEnabled:YES];
	[stopServerMenuItem setState:0];
	[startServerMenuItem setState:1];

	
}


-(IBAction)stopServer:(id)sender {
	
	[self stopService]; 
}



-(void)stopService {
    listeningSocket = nil;
    connectionSocket = nil;
    [messageBroker setDelegate:nil];
    messageBroker = nil;
	
    [netService stop]; 
    [netService release]; 
	[macService stop]; 
	[macService release]; 
	

	
	
	
	[serverStopButton setEnabled:NO];
	[serverStartButton setEnabled:YES];
	//NSLog(@"Service Stopped");
	
	startEnabled = TRUE; 
	stopEnabled = FALSE; 
	[self validateToolbarItem:serverStartButton];
	[self validateToolbarItem:serverStopButton];
	[startServerMenuItem setEnabled:YES]; 
	[stopServerMenuItem setEnabled:NO];
	[stopServerMenuItem setState:1];
	[startServerMenuItem setState:0];
  
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
	
	//NSLog(@"Connected, Host:%@  Port:%d",host,port);
}






#pragma mark MessageBroker Delegate Methods
-(void)messageBroker:(MessageBroker *)server didReceiveMessage:(Message *)message {
	
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//NSLog(@"Reciveing Message"); 
    if ( message.tag == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (message.tag == 110) {
		//[nc postNotificationName:JATQlabGoNotification object:self];
	}
	
	if (message.tag == 120) {
		//[nc postNotificationName:JATQlabStopNotification object:self];
	}
	
	if (message.tag == 130) {
		//[nc postNotificationName:JATQlabSelectionUpNotification object:self];
	}
	
	if (message.tag == 140) {
		//[nc postNotificationName:JATQlabSelectionDownNotification object:self];
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

#pragma mark Server Calls

-(IBAction)getServerSharedData:(id)sender
{ 
	NSArray *array; 
	
	array = [client updateModalFromServer];

	[self importSharedData:array]; 
	
	
	

}



#pragma mark Client Methods 

-(IBAction)search:(id)sender {
	//Stop and remove the controller before starting a new search or bad things will happen.
	
	[browser stop]; 
	[browser searchForServicesOfType:@"_merqury._tcp." inDomain:@""];
}


-(IBAction)connect:(id)sender {
	id theProxy; 
	[remoteService stop];
	
	
	theProxy = [client proxy];
	if (theProxy) {
		NSLog(@"Already Connected"); 
	} else {
		
	NSArray *serviceBrowserObjects = [serviceBrowserController selectedObjects];	
	
	ServerBrowser *servicesBrowser = [serviceBrowserObjects objectAtIndex:0];
	remoteService = [servicesBrowser netService]; 
	[remoteService setDelegate:self]; 
	[remoteService resolveWithTimeout:5];
		
	}
	
    
}

-(IBAction)disconnectButton:(id)sender { 
	NSArray *serviceBrowserObjects = [serviceBrowserController selectedObjects];	
	ServerBrowser *servicesBrowser = [serviceBrowserObjects objectAtIndex:0];
	
	[client disconnect]; 
	
	[servicesBrowser setValue:[NSString stringWithFormat:@"No"]	forKey:@"isConnected"];
	connectEnabled = YES; 
	disconnectEnabled = NO;
	
	
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
	connectionSocket = nil;
	[self search:nil];
	[wait invalidate];
}

#pragma mark Net Service Browser Delegate Methods
//Called by NSNetService when a server is found. 

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more 
{
		
	NSArray *addressCount = [aService addresses];
	NSLog(@"Address Count:%i", [addressCount count]);
	
	
	//Exclude self from the server browser
	BOOL match; 
	match = [localServerName isEqual:[aService name]];
	
	if (match == FALSE) {
		NSManagedObjectContext *moc = [self managedObjectContext]; 
		NSManagedObject *server = [NSEntityDescription insertNewObjectForEntityForName:@"ServerBrowser" inManagedObjectContext:moc];
	    [server setValue:[aService name] forKey:@"name"];
		[server setValue:aService forKey:@"netService"];
		[moc processPendingChanges];
		
		
		
	} else { 
		
		//NSLog(@"Excluding self from server browser"); 
	}
	
	
}

	 
	 
-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more 
{
	
	NSString *nameString = [aService name];
	NSArray *serverObject;
	NSError *error;
	
    NSManagedObjectContext *moc = [self managedObjectContext]; 
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	[request setEntity:[NSEntityDescription entityForName:@"ServerBrowser" inManagedObjectContext:moc]];
	 
	 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",nameString];
	 [request setPredicate:predicate];

	 serverObject = [moc executeFetchRequest:request error:&error];
	 [moc deleteObject:[serverObject objectAtIndex:0]];
	[moc processPendingChanges];
	 
	 
	
	
}

-(void)netServiceDidResolveAddress:(NSNetService *)service {
	NSData *address; 
	BOOL connected; 
	NSArray *serviceBrowserObjects = [serviceBrowserController selectedObjects];	
	ServerBrowser *servicesBrowser = [serviceBrowserObjects objectAtIndex:0];
	
	NSArray *addressArray = [service addresses]; 
	NSLog(@"Array Count %d", [addressArray count]);
	
	address = [addressArray objectAtIndex:0];
	
	connected = [client connect:address]; 
	
	if (connected == YES) { 
		[servicesBrowser setValue:[NSString stringWithFormat:@"Yes"] forKey:@"isConnected"]; 
		connectEnabled = NO; 
		disconnectEnabled = YES;
		[connectMenuItem setEnabled:NO];
		[disconnectMenuItem setEnabled:YES];

		
	} else {
		
		NSLog(@"Not Connected");
		
		
	}

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
	if (!dataWindow) { 
		 
	 
	
	dataWindow = [[DataWindowController alloc] initWithManagedObjectContext:[self managedObjectContext] appDelegate:self];
	[dataWindow setShouldCloseDocument:NO];
	[self addWindowController:dataWindow];
	}
	
	[dataWindow showWindow:self];


	
}



-(IBAction)openPreferencePanel:(id)sender { 
	
	if (!preferenceWindow) { 
		//preferenceWindow = [[PreferenceController  alloc] init]; 
	} 
	 
	[preferenceWindow showWindow:self]; 
	

}

//Old Time adjust method.  Used before the DO server was implemented to adjust for Network lag. 

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


#pragma mark Qlab Update Cycle

-(void)activeUpdate
{ 
	NSTimer *updateTimer;
	updateTimer = [[NSTimer scheduledTimerWithTimeInterval:2
														 target:self
													   selector:@selector(qlabMait)
													   userInfo:nil 
														repeats:NO] autorelease]; 
	
}


-(void)qlabMait
{
	//NSLog(@"Updating Qlab info");
	
	if ([qlabScripts isQlabActive] == YES) { 
		
		[qlabScripts loadQlabArray];
		
	}
	
	[self activeUpdate];
	
}


-(void)refreshQlabInfo
{ 
	NSLog(@"Refreshing Data");
	[qlabScripts loadQlabArray];
	
	//Remove ALl Core Data Objects Before Update
	NSManagedObjectContext *moc = [self managedObjectContext]; 
	
	NSFetchRequest *fetch = [[[NSFetchRequest alloc] init] autorelease];
	[fetch setEntity:[NSEntityDescription entityForName:@"GroupCue" inManagedObjectContext:moc]];
	NSArray *result = [moc executeFetchRequest:fetch error:nil];
	for (id groupcue in result)
		[moc deleteObject:groupcue];
	
	[fetch setEntity:[NSEntityDescription entityForName:@"Cues" inManagedObjectContext:moc]];
	result = [moc executeFetchRequest:fetch error:nil];
	for (id cues in result)
		[moc deleteObject:cues];
	
	
	[fetch setEntity:[NSEntityDescription entityForName:@"CueLists" inManagedObjectContext:moc]];
	result = [moc executeFetchRequest:fetch error:nil];
	for (id cuelists in result)
		[moc deleteObject:cuelists];
	
	
	[fetch setEntity:[NSEntityDescription entityForName:@"Workspace" inManagedObjectContext:moc]];
	result = [moc executeFetchRequest:fetch error:nil];
	for (id workspace in result)
		[moc deleteObject:workspace];
	
	
	[fetch setEntity:[NSEntityDescription entityForName:@"Server" inManagedObjectContext:moc]];
	result = [moc executeFetchRequest:fetch error:nil];
	for (id server in result)
		[moc deleteObject:server];
	
	[self importData]; 
	 

}




#pragma mark Server Browser Table Delegate

-(void)tableViewSelectionDidChange:(NSNotification *)aNotification
{ 

	NSArray *serviceBrowserObjects = [serviceBrowserController selectedObjects];	
	NSInteger x = [serviceBrowserObjects count];

	if (x == 0) {
		NSLog(@"Selected Nothing");
		connectEnabled = NO; 
		disconnectEnabled = NO;
	
	} else {
		
	ServerBrowser *servicesBrowser = [serviceBrowserObjects objectAtIndex:0];
		if ([[servicesBrowser isConnected] isEqualToString:@"Yes"] == YES) {
			connectEnabled = NO; 
			disconnectEnabled = YES;
		}else {
			connectEnabled = YES; 
			disconnectEnabled = NO;
		}

	
	}
	
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

#pragma mark TODO MenuItem Validation
/*
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{ 
	BOOL enable;
	
	
}
	
*/

-(void)enterMasterMode { 
	
	//NSLog(@"Master Mode");
	[preferenceWindow registerHotKeys];
	[qlabScripts loadQlabArray];
	[toggleKeysMenuItem setState:1];
		
	
}

-(void)enterSlaveMode { 
	
	//NSLog(@"Slave Mode");
	[preferenceWindow unregisterHotKeys];
	[qlabScripts loadQlabArray];
	[toggleKeysMenuItem setState:0];
	
	
}


#pragma mark -
#pragma mark Qlab Data Import Methods

-(MessageServer *)setupServerClass
{
	MessageServer *server = [[MessageServer sharedMessageServer] initWithDelegate:self];
	NSLog(@"Server Setup");
	return server; 
	
}




-(void)importData
{ 

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
	
	if (!doServerQueue) {
		doServerQueue = [[NSOperationQueue alloc] init]; }
	
	
	ServerThread *op = nil;
	op = [[ServerThread alloc] initWithDelegate:self withServer:[self setupServerClass]];
	
	if (!doServerOperarionQueue) {
		doServerOperarionQueue = [[NSOperationQueue alloc] init];
	}
	
	[doServerOperarionQueue addOperation:op];
	[op release], op = nil;
}
	


-(void)importSharedData:(NSArray *)array
{ 
	
	if (!queue) {
		queue = [[NSOperationQueue alloc] init]; }
	
	
	SharedDataImport *op = nil;
	op = [[SharedDataImport alloc] initWithDelegate:self withArray:array];
	
	if (!genericOperationQueue) {
		genericOperationQueue = [[NSOperationQueue alloc] init];
	}
	
	[genericOperationQueue addOperation:op];
	[op release], op = nil;
	
}


#pragma mark Blind Mode Methods 

-(void)remoteDataRefresh 
{ 
	[client refreshData]; 
}


-(void)sendLevelChangeForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c db:(double)d
{ 
	
	[client sendLevelChangeForID:unID inRow:r inColumn:c db:d];
	
	
	
}

-(void)sendCueNameChangeForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)name 
{ 
	[client sendCueNameChangeForID:unID inRow:r inColumn:c string:name];
	
	
}


-(void)sendNoteChangesForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)note
{ 
	[client sendNoteChangesForID:unID inRow:r inColumn:c string:note];
	
}


-(void)sendPreWaitForID:(NSString *)unID db:(double)d
{ 
	
	[client sendPreWaitChangeForID:unID db:d];
	
	
	
}


-(void)sendPostWaitForID:(NSString *)unID db:(double)d
{ 
	
	[client sendPostWaitChangeForID:unID db:d];
	
	
	
}

-(void)sendActionForID:(NSString *)unID db:(double)d
{ 
	[client sendActionChangeForID:unID db:d];
	
}


-(void)changeLevelForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c db:(double)d
{
	
	NSArray *array = [qlabScripts qlabCurrentArray]; 
	NSArray *cueArray;
	NSString *cueID = unID; 
	NSInteger xRow = r; 
	NSInteger xColumn = c; 
	double level = d; 
	int i, x, cueCount, j;
	
	x = [array count]; 
	
	for (i = 0; i < x; i++){
		
		cueArray = [[array objectAtIndex:i]cues];
		cueCount = [cueArray count]; 
		
		for (j = 0; j < cueCount; j++){
			
			if([[[cueArray objectAtIndex:j]uniqueID] isEqual:cueID]) { 
				
				[[cueArray objectAtIndex:j]setLevelRow:xRow column:xColumn db:level]; 
			}
				
		}
			
	}

}

-(void)changeCueNameForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c name:(NSString *)s
{
	
	NSArray *array = [qlabScripts qlabCurrentArray]; 
	NSArray *cueArray;
	NSString *cueID = unID; 
	//NSInteger xRow = r; 
	//NSInteger xColumn = c; 
	NSString *nameString = s;
	int i, x, cueCount, j;
	
	x = [array count]; 
	
	for (i = 0; i < x; i++){
		
		cueArray = [[array objectAtIndex:i]cues];
		cueCount = [cueArray count]; 
		
		for (j = 0; j < cueCount; j++){
			
			if([[[cueArray objectAtIndex:j]uniqueID] isEqual:cueID]) { 
				
				[[cueArray objectAtIndex:j]setQName:nameString]; 
			}
			
		}
		
	}
	
	
	
	
	
}

-(void)changeNotesForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)s
{
	
	NSArray *array = [qlabScripts qlabCurrentArray]; 
	NSArray *cueArray;
	NSString *cueID = unID; 
	//NSInteger xRow = r; 
	//NSInteger xColumn = c; 
	NSString *nameString = s;
	int i, x, cueCount, j;
	
	x = [array count]; 
	
	for (i = 0; i < x; i++){
		
		cueArray = [[array objectAtIndex:i]cues];
		cueCount = [cueArray count]; 
		
		for (j = 0; j < cueCount; j++){
			
			if([[[cueArray objectAtIndex:j]uniqueID] isEqual:cueID]) { 
				
				[[cueArray objectAtIndex:j]setNotes:nameString]; 
			}
			
		}
		
	}
	
	
	
	
	
}


-(void)changePreWaitForID:(NSString *)unID db:(double)d
{
	
	NSArray *array = [qlabScripts qlabCurrentArray]; 
	NSArray *cueArray;
	NSString *cueID = unID; 
	double time = d; 
	int i, x, cueCount, j;
	
	x = [array count]; 
	
	for (i = 0; i < x; i++){
		
		cueArray = [[array objectAtIndex:i]cues];
		cueCount = [cueArray count]; 
		
		for (j = 0; j < cueCount; j++){
			
			if([[[cueArray objectAtIndex:j]uniqueID] isEqual:cueID]) { 
				
				[[cueArray objectAtIndex:j]setPreWait:time]; 
			}
			
		}
		
	}
	
}

-(void)changePostWaitForID:(NSString *)unID db:(double)d
{
	
	NSArray *array = [qlabScripts qlabCurrentArray]; 
	NSArray *cueArray;
	NSString *cueID = unID; 
	double time = d; 
	int i, x, cueCount, j;
	
	x = [array count]; 
	
	for (i = 0; i < x; i++){
		
		cueArray = [[array objectAtIndex:i]cues];
		cueCount = [cueArray count]; 
		
		for (j = 0; j < cueCount; j++){
			
			if([[[cueArray objectAtIndex:j]uniqueID] isEqual:cueID]) { 
				
				[[cueArray objectAtIndex:j]setPostWait:time]; 
			}
			
		}
		
	}
	
}

-(void)changeActionForID:(NSString *)unID db:(double)d
{
	
	NSArray *array = [qlabScripts qlabCurrentArray]; 
	NSArray *cueArray;
	NSString *cueID = unID; 
	double time = d; 
	int i, x, cueCount, j;
	
	x = [array count]; 
	
	for (i = 0; i < x; i++){
		
		cueArray = [[array objectAtIndex:i]cues];
		cueCount = [cueArray count]; 
		
		for (j = 0; j < cueCount; j++){
			
			if([[[cueArray objectAtIndex:j]uniqueID] isEqual:cueID]) { 
				
				[[cueArray objectAtIndex:j]setDuration:time]; 
			}
			
		}
		
	}
	
}

@end


