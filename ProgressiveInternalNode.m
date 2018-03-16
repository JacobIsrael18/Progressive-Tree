/******************************************
 ProgressiveInternalNode.m
 
 Created by Jacob Israel on 3/12/18.
 Copyright © 2018 - ထ Jacob Israel. All rights reserved.
 ******************************************/
#import "ProgressiveInternalNode.h" 
#import "ProgressiveLeafNode.h"

#define INDEX_BIT_KEY @"indexBit"
#define CHILD_ZERO_KEY @"childZero"
#define CHILD_ONE_KEY @"childOne"

const uint64_t HIGH_BIT = 1ULL << 63;

@interface ProgressiveInternalNode(ProtectedMethods)
-(void) setMyValue:(uint64_t) newValue;
@end

@implementation ProgressiveInternalNode{
@protected
    uint64_t indexBit;
    ProgressiveNode* childZero;
    ProgressiveNode* childOne;
}

/*================================
 @function    initWithChild:  andChild:
 @discussion
 ===================================*/
-(instancetype) initWithChild:(ProgressiveNode*) firstChild andChild:(ProgressiveNode *)secondChild{
    self = [super initWithValue: [firstChild value]];
    
    // It is Illegal to have two children with the same value
    // Also, this would break the tree.
    if(self == nil || [firstChild value] == [secondChild value]){
        return nil;
    } 
    
    indexBit = HIGH_BIT;
    // We can't update the indexBit until we have children
    // But, the order of the children may be wrong
    childZero = secondChild;
    childOne = firstChild;

    [self updateIndexBit];
    
    if( ([firstChild value] & indexBit) == 0 ){ // firstChild goes to Zero position
        // The indexBit is good. But, we need to swap the children.
        childZero = firstChild;
        childOne = secondChild;
    }
    return self;
}

/*================================
 @function  indexBit
 ===================================*/
-(uint64_t)  indexBit{
    return indexBit;
}

/*================================
 @function updateIndexBit
 We keep shifting the indexBit to the right
 until we find a bit that is different for the value of
 childZero and childOne
 
 Given:
 value0 = 10010101
 value1 = 10011101
 Then:
 indexBit = 00001000
 ===================================*/
-(void) updateIndexBit{
    uint64_t value0 = [childZero value];
    uint64_t value1 = [childOne value];
    
    
    indexBit = HIGH_BIT;
    
    while ((value0 & indexBit) == (value1 & indexBit) && indexBit > 1) {
        indexBit >>= 1;
    }
    [self setMyValue: value0];
}

/*================================
 @function childZeroIschildZeroIsNode
 ===================================*/
-(BOOL) childZeroIsInternalNode{
    return [childZero isKindOfClass: [ProgressiveInternalNode class]];
}

/*================================
 @function childOneIsNode
 ===================================*/
-(BOOL) childOneIsInternalNode{
    return [childOne isKindOfClass: [ProgressiveInternalNode class]];
}

/*================================
 @function bothChildrenAreNodes
 ===================================*/
-(BOOL) bothChildrenAreInternalNodes{
    return [self childZeroIsInternalNode] && [self childOneIsInternalNode];
}

/*================================
 @function    findObjectWithValue:
 @discussion
 We take advantage of the Tree structure to use recursion to find the value.
 Notice that this is essentially a squashed binary tree.
 So, finding the value is O(log n)
 Additionally, because the Tree is squashed,
 the running time is O(log n), where n is the number of values in the Tree,
 NOT the total possible values.
 
 @return The object that has the given value.
 Return nil if the value is not found.
 ===================================*/
-(NSObject*) findObjectWithValue:(uint64_t) value{
    
   // 1. See if we should look at child Zero or Child One
    if((indexBit & value) == 0){ // childZero
        // 2. Is the child a Leaf or an internal Node ?
        if([self childZeroIsInternalNode]){
            // childZeroIschildZeroIsNode == YES
            // The child is a Node. Have the Node process the request.
            return [(ProgressiveInternalNode*)childZero findObjectWithValue: value];
        }
        else{
            // The child is a leaf. It either contains the value
            // or the value is not in the Tree
            if([childZero value] == value){ //    childZero is a Leaf
                return [(ProgressiveLeafNode*)childZero object];
            }   // else
            return nil;
        }
    }
    else{ // childOneIsNode == YES
        if([self childOneIsInternalNode]){
            return [(ProgressiveInternalNode*)childOne findObjectWithValue: value];
        }
        else{   // (indexBit & value) != 0      childOne is a Leaf
            if([childOne value] == value){
                return [(ProgressiveLeafNode*)childOne object];
            }    // else
            return nil;
        }
    }
}

/*================================
 @function     addObject:    withValue:
 @discussion
 If the object's value already exists, the old object will be
 overwritten with the new object.
 ===================================*/
-(void) addObject:(NSObject*) object withValue:(uint64_t) value{
    ProgressiveLeafNode* nodeToAdd = [[ProgressiveLeafNode alloc]initWithObject:object andValue: value];
    [self addLeafNode: nodeToAdd];
}

/*================================
 @function     addLeafNode:
 ===================================*/
-(void) addLeafNode:(ProgressiveLeafNode*) nodeToAdd{
    uint64_t value = [nodeToAdd value];
    
    if((indexBit & value) == 0){ // Add to the Zero side
        
        if( [childZero value] == value && [self childZeroIsInternalNode] == NO){
            // This is a Leaf child with the same value as the object
            // So, this is a Replacement
            childZero = nodeToAdd;
            return;
        }
        // else
        [self addLeafNode: nodeToAdd toChild: childZero];
    }
    else{  // (indexBit & value) != 0     // Add to the One side
        if([childOne value] == value && [self childOneIsInternalNode] == NO){
            //  This is a Replacement
            childOne = nodeToAdd;
            return;
        }
        // else
        [self addLeafNode: nodeToAdd toChild: childOne];
    }
}

/*================================
 @function     addLeafNode:  toChild:
 @discussion
 *** Internal function ***
 This should NEVER be called where  objectValue == childValue
 
 We want to add a new object. We know which child should 'add' it.
 However,
 1. The child may be a Leaf (which cannot add nodes),  or a Node.
 2. If the child is a Leaf, we must put a node in its place,
 then add the new Leaf and the old Leaf to the node we just created.
 We also have to shift pointers around to restructure the tree.
 3. If the child is a Node, we would like to just have the node process the request.
 HOWEVER,
 the tree is squashed. The tree does NOT contain unnecessary internal nodes.
 This means that you can have a node with
 indexBit == 00010000
 and one of its children has
 indexBit == 00000010
 Here, the tree has clearly skipped two unnecessary children,
 But, with the new value, we may need to insert one of these 'missing' children
 Like so
 indexBit == 00010000
 missing' child indexBit == 00000100
 child indexBit == 00000010
 So, if we don't need to add a missing' child, then we just have the child node process the request.
 Otherwise, we must insert the missing' child node.
 ===================================*/
-(void) addLeafNode:(ProgressiveLeafNode*) nodeToAdd toChild:(ProgressiveNode*) child{
 
    // Is the child a Leaf or an internal Node   ?
    if([child isKindOfClass: [ProgressiveInternalNode class]]){ // _____The child is a Node_____
        /*____Add a value to a ProgressiveInternalNode___    */
        // 001010100 <=== new value
        // 000001000 my index
        // 000000010 child index
        uint64_t objectValue = [nodeToAdd value];
        uint64_t childValue = [child value];
        uint64_t childIndexBit = [(ProgressiveInternalNode*)child indexBit];
        uint64_t checkBit = indexBit;//  HIGH_BIT;
 
        //  See if we need an intermediate node
        while ((objectValue & checkBit) == (childValue & checkBit) && checkBit > childIndexBit) {
            checkBit >>= 1;
        }
        
        if(checkBit <= childIndexBit){
            /* We do NOT need an intermediate node
             so just have the child Node do the work. */
            [(ProgressiveInternalNode*)child addLeafNode: nodeToAdd];
            return;
        }
        else{ //  checkBit > childIndexBit
            // We DO need an intermediate node
            ProgressiveInternalNode* intermediateNode = [[ProgressiveInternalNode alloc]initWithChild: nodeToAdd andChild: child];
            
            // Now make the intermediateNode one of our children.
            if(child == childZero){
                childZero = intermediateNode;
            }
            else{
                childOne = intermediateNode;
            }
            // With a new structure, our index bit is wrong.
            [self updateIndexBit];
        }
    }
    else{ // _____The child is a Leaf_____
        /*
         1. Create a node in place of the original (Leaf) value
         2. Add the two values to the node   (Update the node's pointerIndex)    */
        ProgressiveInternalNode* newNode = [[ProgressiveInternalNode alloc]initWithChild: nodeToAdd andChild: child];
         // Move our child pointer
        if(child == childZero){
            childZero = newNode;
        }
        else{
            childOne = newNode;
        }
        // With a new structure, our index bit may be wrong.
        [self updateIndexBit];
    }
}

/*================================
 @function
 ===================================*/
-(BOOL) childZeroIsLeafWithValue:(uint64_t) value{
    return [self childZeroIsInternalNode] == NO && [childZero value] == value;
}

/*================================
 @function
 ===================================*/
-(BOOL) childOneIsLeafWithValue:(uint64_t) value{
    return [self childOneIsInternalNode] == NO && [childOne value] == value;
}

/*================================
 @function
 ===================================*/
-(uint16_t) getDepth{
    uint16_t depth0 = 0;
    uint16_t depth1 = 0;
    
    if([self childZeroIsInternalNode] ){
        depth0 = [(ProgressiveInternalNode*)childZero getDepth];
    }
    if([self childOneIsInternalNode] ){
        depth1 = [(ProgressiveInternalNode*)childOne getDepth];
    }
    return MAX(depth0, depth1) + 1;
}

/*================================
 @function
 ===================================*/
-(ProgressiveNode*) getChildZero{
    return childZero;
}

/*================================
 @function
 ===================================*/
-(ProgressiveNode*) getChildOne{
    return childOne;
}

/*================================
 @function    removeObject:
 @discussion
 IMPORTANT
 A node cannot remove one of its own Leaf children,
 because it would then need to replace itself with the other Leaf child.
 The parent must do this.
 This is an issue for the Top-most Node.
 ===================================*/
-(void) removeObjectWithValue:(uint64_t) objectValue{
   
    uint64_t objectValueAndIndexBit = (objectValue & indexBit);
    
    if(objectValueAndIndexBit == 0 && [self childZeroIsInternalNode]){ // __ZERO__
        ProgressiveInternalNode* nodeZero = (ProgressiveInternalNode*)childZero;
        
        if([nodeZero childZeroIsLeafWithValue: objectValue] ){
            /* Our childZero's childZero is to be removed.
             That means that our new childZero is our childZero's childOne      */
            childZero = [nodeZero getChildOne];
        }
        else if([nodeZero childOneIsLeafWithValue: objectValue] ){
            childZero = [nodeZero getChildZero];
        }
        else{
            // Neither child is a match. So, pass on the request.
            [nodeZero removeObjectWithValue: objectValue];
        }
    }
    else if(objectValueAndIndexBit != 0 && [self childOneIsInternalNode]){ // __ONE__
        ProgressiveInternalNode* nodeOne = (ProgressiveInternalNode*)childOne;
        
        if([nodeOne childZeroIsLeafWithValue: objectValue] ){
            childOne = [nodeOne getChildOne];
        }
        else if([nodeOne childOneIsLeafWithValue: objectValue] ){
            childOne = [nodeOne getChildZero];
        }
        else{
            // Neither child is a match. So, pass on the request.
            [nodeOne removeObjectWithValue: objectValue];
        }
    }
}

-(NSDictionary*) dictionaryRepresentation{
    NSMutableDictionary* output = [NSMutableDictionary new];
    
    output[INDEX_BIT_KEY] = [NSNumber numberWithUnsignedInteger: indexBit];
    
    output[CHILD_ZERO_KEY] = [childZero dictionaryRepresentation];
    
    output[CHILD_ONE_KEY] = [childOne dictionaryRepresentation];
    
    return output;
}

-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    self = [super init];
    
    indexBit = [(NSNumber*)dictionary[INDEX_BIT_KEY]  unsignedIntegerValue];
    
    NSDictionary* childZeroDictionary = dictionary[CHILD_ZERO_KEY];
    NSDictionary* childOneDictionary = dictionary[CHILD_ONE_KEY];
    if( childZeroDictionary[@"myObject"] != nil){
        childZero = [[ProgressiveLeafNode alloc]initFromDictionaryRepresentation: dictionary[CHILD_ZERO_KEY]];
    }
    else{
        childZero = [[ProgressiveInternalNode alloc]initFromDictionaryRepresentation: dictionary[CHILD_ZERO_KEY]];
    }

    if(childOneDictionary[@"myObject"] != nil){
        childOne = [[ProgressiveLeafNode alloc]initFromDictionaryRepresentation: dictionary[CHILD_ONE_KEY]];
    }
    else{
        childOne = [[ProgressiveInternalNode alloc]initFromDictionaryRepresentation: dictionary[CHILD_ONE_KEY]];
    }
    return self;
}

@end
