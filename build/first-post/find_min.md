# Finding the minimum number from the array

The goal of this program is to find the minimum number from an array and then exit

We will be using the following registers
* __%edi__ - to hold the index of the element
* __%eax__ - to hold the element being considered / to indicate which syscall 
* __%ebx__ - to hold the largest element / the return after calling exit

The data will be in an array of longs, and we are assuming the `0` value is the 
terminator.

* here we use the %edi register as index it is incremented using `incl`
* we are using the indexed addressing mode here we add to the memory address `data_array` the value in %edi multiplied by the multiplier provided
* we choose the multiplier depending on the size of the data, here since it is a long we choose 4
* the jmp and jle instructions are used to implement conditionals and loops
* the loops are done by labelling certain points and referencing them as jump-pts
* the jle check the status register after a cmp operation, the content of cmp are usually dst-src and the status bits are set based on this
* like the last time we return the answer using %ebx

__Here is a nuance that I found we can only use the %ebx to return answer methods 
for values of upto 1 byte, since even though %ebx can store a word of 4 bytes the 
exit() syscall stores only the least significant byte. i.e %ebx & 0x000000FF__

```gnuassembler

# FIND_MIN.S

# This program finds the max number of set of data items
#
# Variables
# %edi		-	holds the index of the data being considered
# %ebx		- 	largest data item till now
# %eax		- 	Current data item
# 
# data_array	-	contains the item data is terminated by a zero assuming the items are all positive

.section .data

data_array :
	.long 256,2,3,4,1,23,6,3,5,231,234

.section .text

.global _start 
	_start:
		movl $0, %edi			# Initialize the index value to 0
		movl data_array(,%edi,4),%eax	# Load the word of size 4 from position edi from start of data_array
		movl %eax,%ebx			# Load it as the first largest item till now

	comp_loop:				# Label to mark start of the loop
		cmpl $0, %eax			# Check if we've hit the delimiter which we set as 0 
		je   exit
		incl %edi			# Increment the index
		movl data_array(,%edi,4),%eax	# Loading the long to eax as before
		cmpl %ebx,%eax			# compare ebx with eax
		jle  comp_loop			# if eax is less than or equal to ebx go to next iteration
		movl %eax,%ebx
		jmp  comp_loop

	exit:
		movl $1,%eax			# Fill in the syscall number the result is already in ebx just echo it after executing
		int  $0x80
		
		
```
