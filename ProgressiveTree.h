/******************************************
 ProgressiveTree.h

 Created by Jacob Israel on 3/13/18.
 Copyright  © 2018 - ∞  Jacob Israel . All rights reserved.
 ******************************************/
#import <Foundation/Foundation.h>
#import "ProgressiveNode.h"
#import "ProgressiveLeafNode.h"

@interface ProgressiveTree : NSObject

-(NSObject*) findObjectWithKey:(uint64_t) key;
-(void) addObject:(NSObject*) object withKey:(uint64_t) key;
-(void) removeObjectWithKey:(uint64_t) key;

// Convenience methods
-(BOOL) isEmpty;

/* Key: Value iteration
 This is like asking for all keys and values,
 with the IMPORTANT exception that the Array is always retruned in order of increasing value.
 This is because the Leafs of the Tree are Naturally in order.
 
 __Example___
 ProgressiveTree* progressiveTree;
 NSArray<ProgressiveLeafNode*>* array = [progressiveTree allLeafNodes];
 for(ProgressiveLeafNode* node in array){
    uint64_t key = [node value];
    NSObject* value = [node object];
 //           . . .  do something here
 }                                      */
-(NSArray<ProgressiveLeafNode*>*) allLeafNodes;
-(ProgressiveNode*) topNode;
-(uint16_t) getTreeDepth;
// Serialization
-(NSDictionary*) dictionaryRepresentation;
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary;
@end
