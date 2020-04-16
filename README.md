# CAs Lab 01
Laboratory 01 of the course Computer Architectures 2019.<br/>
Tested with EMU8086 version 4.08

## Read in input a short text of 4 lines, each of these lines long from 20 to 50 characters
The program reads the lines with the instruction INT 21H and stores them in:<br/>
`first_line DB 50 DUP(?)`<br/>
`second_line DB 50 DUP(?)`<br/>
`third_line DB 50 DUP(?)`<br/>
`fourth_line DB 50 DUP(?)`

Reading stops when one of this conditions is satisfied:
- After at least 20 characters, an `ENTER` has been read.
- 50 characters have been read without any `ENTER`, after the first 20 characters.<br/>

The `ENTER` character corresponds to 13 in ASCII table.<br/>
PLEASE NOTE: if you read an `ENTER` in the first 20 characters, the reading must continue.

## Count number of occurrences of the letters
For each line, the program has to count how many times a certain character appears.<br/>
Consider only letters, `a...z`, `A...Z`, discerning upper and lower case.
- For each line, output the most frequent character (appearing `MAX` times).
- For each line, print the list of characters appearing at least `MAX/2` times.
- After each character printed, print also the number of occurrences.

## Apply a cryptographic algorithm
Print the text using Caesar cipher, only applied to `a...z`, `A...Z` characters.<br/>
Given parameter `k`, the Caesar cipher transforms the letter in `a+k`, considering the following pattern: `a...zA...Za...zA...Z` etc.<br/>
Non-alphabetic characters stay the same.<br/>
`k = 1` for the first row, `k =2` for the second, `k =3` for the third, `k =4` for the fourth.<br/>
Example with `k = 3`: piZza -> slcCd
