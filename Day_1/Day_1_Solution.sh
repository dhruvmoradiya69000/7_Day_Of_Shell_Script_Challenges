#!/bin/bash

# task 1:
# type-1 single line commnet
# This is a comment
# explaining how the script works.
# Each line needs to start with a #.

# type-2 Multiline commnet
<<note
This is a multiline comment
that will not be executed. 
You can write as much as you like here.
note

# Task 2: use echo print any value.
echo "Hello Dosto!"
echo ""

# Task 3: Declare variable and assign values
name1="dhruv"
name2="raju"

echo "Hello,$name1"
echo "what your name?"
echo "my name is $name2"
echo ""

# Task 4: Takking 2 number and as input & print value
num1=10
num2=20
sum=$((num1 + num2))
echo "$num1 and $num2 sum is: $sum"
echo ""

# Task 5: use Built In Variables
echo "my name is $USER."
echo "I am using $OSTYPE"
echo "This is my id: $UID"
echo "This is my hostname $HOSTNAME"
echo ""

# Task 6: wildcards
ls ~/wildcard/*.txt
