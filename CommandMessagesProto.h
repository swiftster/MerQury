//
//  CommandMessages.h
//  QSync
//
//  Created by Jason Tratta on 2/5/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Foundation/Foundation.h>

//Message the client will recieve from the server
@protocol ServerMessage 


//Qlab Commands 
//Key Presses
-(oneway void)commandFromServer:(in int)command; 

//Core Data Sharing 
//-(byref NSArray *)allObjectsServer; 

-(void)changeLevelFromClient:(in NSString *)unID inRow:(in NSInteger)r inColumn:(in NSInteger)c db:(in double)d;
-(void)changeCueNameFromClient:(in NSString *)unID inRow:(in NSInteger)r inColumn:(in NSInteger)c name:(in NSString *)s;
-(void)changeNotesFromClient:(in NSString *)unID inRow:(in NSInteger)r inColumn:(in NSInteger)c string:(in NSString *)s;




@end

//Message the server will recieve from the client 

@protocol ClientMessage

-(oneway void)commandFromServer:(in int)command fromClient:(in byref id <ServerMessage>)client;

-(BOOL)connectClient:(in byref id <ServerMessage>)newClient; 
-(void)disconnectClient:(in byref id <ServerMessage>)client;

//Core Data Sharing 
-(byref NSArray *)allObjectsClient; 

-(void)sendLevelChangeForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c db:(double)d;
-(void)sendCueNameChangeForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)name; 
-(void)sendNoteChangesForID:(NSString *)unID inRow:(NSInteger)r inColumn:(NSInteger)c string:(NSString *)note;





@end
