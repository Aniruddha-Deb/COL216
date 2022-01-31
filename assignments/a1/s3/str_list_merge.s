    .global str_list_merge
    
    .text

@ merges two sorted lists of strings
@ parameters:
@ r0: address of the first list
@ r1: address of the second list
@ r2: length of first list
@ r3: length of second list
@ r4: parameters (bit0 - 1 to ignore case, bit1 - 1 to ignore duplicate)
@
@ returns:
@ r0: address of the final sorted list of string pointers
@ r1: length of final stored list of string pointers
@ 
@ merge pseudocode:
@ l1 := length of first sorted list
@ i1 := 0 (pointer to current location in l1)
@ l2 := length of second sorted list
@ i2 := 0 (pointer to current location in l2)
@ i3 := 0 (pointer to head of target list l3)
@ for i in 0...min(l1,l2)-1 do
@   if l1[i] < l2[i] then min_str = *l1[i] else min_str = *l2[i]
@     if ignore_duplicates and i3 > 0 and l1[i] = l3[i3--] then
@       i1++
@     else
@       l3[i3++] = l1[i1++]
@   else 
@     if ignore_duplicates and i3 > 0 and l2[i] = l3[i3--] then
@       i2++
@     else
@       l3[i3++] = l1[i1++]
@ end
@ while i1 < l1 do
@     if ignore_duplicates and i3 > 0 and l2[i] = l3[i3--] then
@       i2++
@     else
@       l3[i3++] = l1[i1++]
@   l3[i3++] = l1[i1++]
@ end
@ while i2 < l2 do
@   l3[i3++] = l2[i2++]
@ end
@
@ return l3
@ 
@ proc 
str_list_merge:
    
