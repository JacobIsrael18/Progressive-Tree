/******************************************
 ProgressiveInternalNode.m

 Regular hashing is O(n). We 'hope' that the hash function will distribute the Objects evenly among the buckets.
 But, the worst case scenario is no better than a regular array. 'Hoping' is NOT computer science.
 Using randomness in an algorithm results in a Non-Deterministic outcome.
 It is an admission by the programmer that he does NOT know what he is doing,
 i.e. He does not know what problem he is trying to solve.
 
 In a ProgressiveTree:
> A Leaf is a Single Child carrying one object with one value.
 Programatically, it is any NSObject that conforms to ProgressiveTreeChild,
 which means it has the  -(uint64_t) value{ }  method.
 
 > An internal node is a ProgressiveInternalNode. This class also conforms to ProgressiveTreeChild.
 But, an internal node always has 2 children:
 childZero
 childOne
 Each child may be a Leaf or a ProgressiveInternalNode
 
 The ProgressiveInternalNode represents the most basic element of a ProgressiveTree.
 It is a 'container' for two 'buckets' (bucket Zero & bucket One)
 It 'hashes' into these buckets based on whether an Object's value has a Zero or One at a given bit position (bitIndex)
 Unlike regular hashing, this mechanism is 100% Deterministic. It is NOT based on some random juggling of the value to create a hash.
 More importantly, it is a Tree of ProgressiveInternalNodes (parent-child-grandchild), that work together to implement Progressive Hashing.
 
 ___Progressive Hashing___  A specialized approach to hashing where items are placed in 'buckets' based on a 'Hash'
 of their value,
*** AND ***
 any 'bucket' that contains more than one item is hashed further (by a different method) into other 'buckets'
 The hashing is GUARANTEED TO STOP when:
 A. No buckets have more than one item    OR
 B. No further hashing is possible, meaning that multiple items in the same bucket must have the same exact value.
 (However, the ProgressiveTree does not allow multiple items in the same bucket,
 because it is coded to behave like a Dictionary. A new item with the same exact value replaces the old item).
 For this to work, the hashing function MUST be Deterministic (you cannot use random hash functions, because there is no Leaf case).
 The simplest 'Hash' function possible is to check a single bit in a value (it will be 1 or 0) and place the Object in the appropriate bucket.
 
 Created by Jacob Israel on 3/12/18.
 Copyright © 2018 - ထ Jacob Israel. All rights reserved.
 ******************************************/
#import <Foundation/Foundation.h>
#import "ProgressiveNode.h"

extern const uint64_t HIGH_BIT;

@interface ProgressiveInternalNode : ProgressiveNode
-(instancetype) initWithChild:(ProgressiveNode*) firstChild andChild:(ProgressiveNode*) secondChild;

//_____Find, Add, Remove__________
-(NSObject*) findObjectWithValue:(uint64_t) value;
-(void) addObject:(NSObject*) object withValue:(uint64_t) value;
-(void) removeObjectWithValue:(uint64_t) objectValue;

-(uint64_t) indexBit;
-(ProgressiveNode*) getChildZero;
-(ProgressiveNode*) getChildOne;
-(BOOL) childZeroIsInternalNode;
-(BOOL) childOneIsInternalNode;
-(BOOL) bothChildrenAreInternalNodes;

-(BOOL) childZeroIsLeafWithValue:(uint64_t) value;
-(BOOL) childOneIsLeafWithValue:(uint64_t) value;
-(uint16_t) getDepth;
 
@end
