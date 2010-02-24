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
-(oneway void)ServerCommand:(in int)command; 

//Core Data Sharing 
-(byref NSManagedObject *)createObject; 
-(byref NSManagedObject *)createChildForObject:(byref NSManagedObject *)parent; 
-(oneway void)deleteObject:(byref NSManagedObject *)object;
-(byref NSArray *)allObjects; 
-(byref NSArray *)objectsOfName:(bycopy NSString *)name 
				  withPredicate:(bycopy NSPredicate *)predicate;




@end

//Message the server will recieve from the client 

@protocol ClientMessage

-(oneway void)ClientCommand:(in int)command;

//Returns NO if someone already has newClients nickname 
-(BOOL)connectClient:(in byref id <ServerMessage>)newClient; 
-(void)disconnectClient:(in byref id <ServerMessage>)client;





@end
