
# DataStructure

This repo contains double-linked-list, stack (implemented as linked-list), queue (implemented using swift array), bitmap and RingBuffer(using swift array as underlying data structure)

## LinkedList

Since the LinkedList allocates buffers in the Heap, and uses pointesr to bypass ARC, it is implemented as Reference type. Despite confirming the protocol Collection. Some Collection function are broken. Supporting methods include "removeFirst, removeLast, remove(at:), count, capacity, for .. in .. , iterator, subscript". 

Removing and accessing random items from the linked list are O(n) operations. The linked list will automatically grow in the rate of 12.5% (minimum of 5 nodes) each time and collections of new nodes will allocate as contingous memory when it run out of nodes. This is to minimize allocation overheads and (hopefully) prevent cache misses as the neighbors of the node should live in the same page.

Performance of the LinkedList in this repo is around 50% slower than swift array. Yet `removeFirst()` is much faster with the LinkedList. 

## Stack

The stack in this repo is implemented as linked list. It is basically same as the LinkedList. The performance of the implementation of the stack is somehow slightly worse than LinkedList. If you care about performance, you should use swift array.

## Bitmap

Bitmap supports three different compressions.

With low compression, the max capacity of the bitmap is ((2^48) - 1) * 16. However for each 4 bytes of integer the bitmap can only store 16 boolean values.

With medium compression, the max capacity of the bitmap is ((2^32) - 1) * 32. For each 4 bytes the bitmap can store 32 boolean values.

With high compression, the max capacity of the bitmap is ((2^16) - 1) * 48. For each 4 bytes the bitmap can store 48 boolean values.
## RingBuffer


