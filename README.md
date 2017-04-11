
# DataStructure

This repo contains double-linked-list, Stack (implemented as linked-list), Bitmap and RingBuffer(using swift array as underlying data structure), BipBuffer, Min/Max heap and Queue (implemented using swift array).

# Table of Conents
1. [LinkedList](#linkedlist)
2. [Stack](#stack)
3. [Bitmap](#bitmap)
4. [RingBuffer](#ringbuffer)
5. [BipBuffer](#bipbuffer)
6. [Min/Max Heap](#heap)
7. [Queue](#queue)

## LinkedList<a name="linkedlist"></a>

Since the LinkedList allocates buffers in the Heap, and uses pointesr to bypass ARC, it is implemented as Reference type. Despite confirming the protocol Collection. Some Collection function are broken. Supporting methods include "removeFirst, removeLast, remove(at:), count, capacity, for .. in .. , iterator, subscript". 

Removing and accessing random items from the linked list are O(n) operations. The linked list will automatically grow in the rate of 12.5% (minimum of 5 nodes) each time and collections of new nodes will allocate as contingous memory when it run out of nodes. This is to minimize allocation overheads and (hopefully) prevent cache misses as the neighbors of the node should live in the same page.

Performance of the LinkedList in this repo is around 50% slower than swift array. Yet `removeFirst()` is much faster with the LinkedList. 

## Stack<a name="stack"></a>

The stack in this repo is implemented as linked list. It is basically same as the LinkedList. The performance of the implementation of the stack is somehow slightly worse than LinkedList. If you care about performance, you should use swift array.

## Bitmap<a name="bitmap"></a>

The implementation of Bitmap in this package is storaging 64 bit integer as storing backend (for both 32bit and 64bit processors). The sparsity property of the bitmap determine the max capacity and storage efficientcy of the Bitmap.

The max capacity of the Bitmap is (s = sparsity) (2^s - 1) * (64 - s). The efficientcy of the Bitmap is (64 - s) boolean values per 4 bytes. Bitmap with higher sparsity has higher max capacity therefore can store a wider range of indices but less values can be stored per byte. Bitmap with lower sparsity has fewer maximum capacity but can store more items per byte.

## RingBuffer<a name="ringbuffer"></a>

See [Circular Buffer](https://en.wikipedia.org/wiki/Circular_buffer). The Ring buffer is implemented using array and can be use as a queue. It is not growable under current implementation. Both enqueue a full buffer and dequeue an empty buffer are not implicitly guarded. Enqueue a full buffer will start override pervious contents. Dequeue an empty buffer will result in undefined behaviour.  

Subscript can use to set and read elements in the buffer, reading a full buffer with an out of range index will result in duplicated elements, and undefined behaviour when reading from a non-full buffer with out of range indices.

## BipBuffer<a name="bipbuffer"></a>

A bip buffer behaves the same as ring buffer except 

1) it requires double amount of memory 
2) can extract a pointer that points to a buffer that contains all (logical) elements contiguously.

Note that the pointer extracted from the ring buffer is reused and underlying memory will change whenever changes made to the buffer.

## Min/Max Heap<a name="heap"></a>

Min/Max heap implemented using array and operates just like a normal heap you will expect. It can also be use as priority queue. 

## Queue<a name="queue"></a>

The queue in this package is implemented using two arraies in the simpliest way. Unlike generic swift arrays the Queue can dequeue a lot more faster than 'removeFirst' from an array.


