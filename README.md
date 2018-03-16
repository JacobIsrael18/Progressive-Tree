# Progressive-Tree
The Progressive Tree is a Dictionary that uses Progressive Hashing. 
The Dictionary keys are integers and the values can be any object type. Unlike regular hashing, 
it is completely deterministic. The worst case for Find, Add and Remove operations is O(log n). 
The best case is O(1). So, the worst case to Find / Add / Remove N objects is O(n log n), guaranteed. 
The Progressive Tree consists of internal nodes and leaf nodes. The leaf nodes hold the Dictionary values. 
The Progressive Tree has no empty(nil) nodes. The only exception is the top node (when the Progressive Tree is empty). 
Internal nodes always have two children. Each internal node holds an 'index bit' which is an integer that represents 
the bit where its two children differ in their values.

Regular hashing is O(n), NOT O(1) or even O(log n) as many programmers believe. 
So, the worst case to Find / Add / Remove N objects is O(n ^ 2) 
We 'hope' that the hash function will distribute the Objects evenly among the buckets. 
But, the worst case scenario (Time-Complexity) is no better than a regular array. 
                 'Hoping' is NOT computer science.
Using randomness in an algorithm results in a Non-Deterministic outcome.
It is an admission by the programmer that he does NOT know what he is doing,
i.e. He does not know what problem he is trying to solve.
 
Progressive Hashing - Let us say that you have N items and M buckets. 
Now use a hash function to distribute those items. Some bucket may be empty.
Others have one item. But, for any bucket with multiple items, take another hash function 
and distribute these items into another set of buckets. Keep going until no bucket has 
more than one item.

"BUT WAIT", you say. "We could go on hashing forever!". Well, yes IF your hash functions were random.
But, if you hash deterministically, then the hashing must stop. The easiest way to do this is to
recursively hash into two buckets, based on the bit value of the item's number.

Simple Example:
Let us hash these 4-bit values 12, 7, 4, 2, 1
1. First hash using the top bit.   1000
Bucket Zero = 0111,  0100,  0010,  0001   
Bucket One = 1100   -> Done hashing

2. Second hash using the 2nd bit.   0100 
Bucket Zero =  0010,  0001   
Bucket One = 0111,  0100

3. Third hash using 0010
Bucket Zero     
> Bucket Zero = 0001    -> Done hashing
> Bucket One = 0010   -> Done hashing

Bucket One 
> Bucket Zero =   0100  -> Done hashing
> Bucket One = 0111 -> Done hashing

Let's analyze this. If these were 64 Bit numbers, then we would hash as much as 64 times before we were done.
"OMG Martha! 64 Times? That's too much." No it's not. O(64 * n) == O(constant * n) == O(n)
If you don't understand this, well . . .



© 2018 JacobIsrael@mail.USF.edu
