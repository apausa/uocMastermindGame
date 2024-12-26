# Mastermind Game

Selected exercise from the 'Computer Structure' course within the Bachelor's degree in Software Development. This project consisted in programming a set of subroutines in assembly language x86_64, which are called from a C program. 

## Description

"The practical work consists in implementing the Mastermind game, where a 5 digits secret code between 0 and 9 must be typed, and then, type 5-digit combinations (tries) until discovering the secret code or run out the maximum number of tries."

### First part

"In the first part, only each try is compared with the secret code and indicates how many digits are in the right place (hits)."

The subroutines implemented in assembly language for this part are:
- posCurScreenP1 
- updateColP1 
- updateMatrixBoardP1 
- getSecretPlayP1 
- printSecretP1 
- checkSecretP1 
- printHitsP1 
- checkPlayP1 
 
### Second part

"In the second part, the game will have all the functionalities, it will be necessary to indicate for each try how many digits of the secret code are correct, and if they are hits in place or hits out of place."
 
The subroutines implemented in assembly language for this part are:
- posCurScreenP2 
- updateColP2 
- updateMatrixBoardP2 
- getSecretPlayP2 
- printSecretPlayP2 
- checkSecretP2 
- printHitsP2 
- checkPlayP2 
