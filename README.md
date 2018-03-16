# Progressive-Tree
The Progressive Tree is a Dictionary that uses progressive hashing. 
The Dictionary keys are integers and the values can be any object type. Unlike regular hashing, 
it is completely deterministic. The worst case for Find, Add and Remove operations is O(log n). 
The best case is O(1). So, the worst case to Find / Add / Remove N objects is O(n log n), guaranteed. 
The Progressive Tree consists of internal nodes and leaf nodes. The leaf nodes hold the Dictionary values. 
The Progressive Tree has no empty(nil) nodes. The only exception is the top node (when the Progressive Tree is empty). 
Internal nodes always have two children. Each internal node holds an 'index bit' which is an integer that represents 
the bit where its two children differ in their values.

© 2018 JacobIsrael@mail.USF.edu
