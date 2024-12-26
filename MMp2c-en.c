/**
 * C-Implementation of the code, to have a high-level 
 * functional version with all the features you have to implement 
 * in assembly language.
 * From this code calls are made to assembly subroutines. 
 * THIS CODE CANNOT BE MODIFIED AND SHOULD NOT BE DELIVERED. 
 **/

#include <stdio.h>
#include <termios.h>    //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>     //STDIN_FILENO

/**
 *Constants
 */
#define DIMMATRIX 5

/**
 * Global variables definition
 */
 extern int developer;	//Variable declarada en assemblador que indica el nom del programador

/**
 * C functions definition
 */
void  clearScreen_C();
void  gotoxyP2_C(int, int);
void  printchP2_C(char);
char  getchP2_C();
char  printMenuP2_C();
void  printBoardP2_C(long);

void  posCurScreenP2_C(int, long, int);
int   updateColP2_C(char, int);
void  updateMatrixBoardP2_C(char, char[2][DIMMATRIX], int, int);
int   getSecretPlayP2_C(char[2][DIMMATRIX], int, long);
void  printSecretP2_C(char[2][DIMMATRIX]);
int   checkSecretP2_C(char[2][DIMMATRIX]);
void  printHitsP2_C(short, short, long);
int   checkPlayP2_C(char[2][DIMMATRIX], int, long);

void  printMessageP2_C(int);
void  playP2_C(char[2][DIMMATRIX]);

/**
 * Definition of assembly language subroutines called from C.
 */
void  posCurScreenP2(int, long, int);
int   updateColP2(char, int);
void  updateMatrixBoardP2(char, char[2][DIMMATRIX], int, int);
int   getSecretPlayP2(char[2][DIMMATRIX], int, long);
void  printSecretP2(char[2][DIMMATRIX]);
int   checkSecretP2(char[2][DIMMATRIX]);
void  printHitsP2(short, short, long);
int   checkPlayP2(char[2][DIMMATRIX], int, long);
void  playP2(char[2][DIMMATRIX]);


/**
 * Clear screen.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * None
 *   
 * Output parameters: 
 * None
 * 
 * This function is not called from assembly code
 * and an equivalent assembly subroutine is not defined.
 */
void clearScreen_C(){
	
    printf("\x1B[2J");
    
}


/**
 * Place the cursor at a position on the screen.  
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * rdi(edi): (rowScreen): Row
 * rsi(esi): (colScreen): Column
 * 
 * Output parameters: 
 * None
 * 
 * An assembly language subroutine 'gotoxyP2' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers. The parameters are equivalent.
 */
void gotoxyP2_C(int rowScreen, int colScreen){
	
   printf("\x1B[%d;%dH",rowScreen,colScreen);
   
}



/**
 * Show a character on the screen at the cursor position.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * rdi(dil): (c):  Character to show.
 * 
 * Output parameters: 
 * None
 * 
 * An assembly language subroutine 'printchP2' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers. The parameters are equivalent.
 */
void printchP2_C(char c){
	
   printf("%c",c);
   
}


/**
 * Read a character from the keyboard without displaying it 
 * on the screen and return it.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * None
 * 
 * Output parameters: 
 * rax(al): (c): Character read from the keyboard.
 * 
 * An assembly language subroutine 'getchP2' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers. The parameters are equivalent.
 */
char getchP2_C(){

   char c;   

   static struct termios oldt, newt;

   /*tcgetattr get terminal parameters
   STDIN_FILENO indicates that standard input parameters (STDIN) are written on oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*copy parameters*/
   newt = oldt;

   /* ~ICANON to handle keyboard input character to character, not as an entire line finished with /n
      ~ECHO so that it does not show the character read*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fix new terminal parameters for standard input (STDIN)
   TCSANOW tells tcsetattr to change the parameters immediately.*/
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Read a character*/
   c=getchar();                 
    
   /*Restore the original settings*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);

   /*Return the read character*/
   return (char)c;
   
}


/**
 * Show the game menu on the screen and ask for an option.
 * Only accepts one of the correct menu options ('0'-'9').
 * 
 * Global variables :   
 * developer:((char;)&developer): Variable defined in the assembly code.
 * 
 * Input parameters : 
 * None.
 * 
 * Output parameters: 
 * (charac): rax(al): Character read from the keyboard.
 * 
 * This function is not called from the assembly code and 
 * an equivalent subroutine has not been defined in assembly language.
 **/
char printMenuP2_C(){
	
   clearScreen_C();
   gotoxyP2_C(1,1);
   printf("                               \n");
   printf("         Developed by:         \n");
   printf("     ( %s )    \n",(char *)&developer);
   printf(" _____________________________ \n");
   printf("|                             |\n");
   printf("|    MENU MASTERMIND v2.0     |\n");
   printf("|_____________________________|\n");
   printf("|                             |\n");
   printf("|     1.  PosCurScreen        |\n");
   printf("|     2.  UpdateCol           |\n");
   printf("|     3.  UpdateMatrixBoard   |\n");
   printf("|     4.  getSecretPlay       |\n");
   printf("|     5.  PrintSecret         |\n");
   printf("|     6.  CheckSecret         |\n");
   printf("|     7.  PrintHits           |\n");
   printf("|     8.  CheckPlay           |\n");
   printf("|     9.  Play Game           |\n");
   printf("|     0.  Play Game C         |\n");
   printf("|    ESC. Exit game           |\n");
   printf("|                             |\n");
   printf("|         OPTION:             |\n");
   printf("|_____________________________|\n"); 
   
   char charac =' ';
   while (charac!=27 && (charac < '0' || charac > '9')) {
      gotoxyP2_C(21,19);      
      charac = getchP2_C();   
   }
   return charac;
   
}


/**
 * Show the game board on the screen. Lines of the board.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (tries): rdi(rdi): Remaining tries.
 * 
 * Output parameters: 
 * None
 * 
 * This function is not called from the assembly code and 
 * an equivalent subroutine has not been defined in assembly language.
 **/
void printBoardP2_C(long tries){
   int i;

   clearScreen_C();
   gotoxyP2_C(1,1);
   printf(" _______________________________ \n");//1
   printf("|                               |\n");//2
   printf("|      _ _ _ _ _   Secret Code  |\n");//3
   printf("|_______________________________|\n");//4
   printf("|                 |             |\n");//5
   printf("|       Play      |     Hits    |\n");//6
   printf("|_________________|_____________|\n");//7
   for (i=0;i<tries;i++){                        //8-19
     printf("|   |             |             |\n");
     printf("| %d |  _ _ _ _ _  |  _ _ _ _ _  |\n",i+1);
   }
   printf("|___|_____________|_____________|\n");//20
   printf("|       |                       |\n");//21
   printf("| Tries |                       |\n");//22
   printf("|  ___  |                       |\n");//23
   printf("|_______|_______________________|\n");//24
   printf(" (ENTER) next Try       (ESC)Exit \n");//25
   printf(" (0-9) values    (j)Left (k)Right   ");//26
   
}


/**
 * Place the cursor inside the board according to the position of the
 * cursor (col), the remaining tries (tries) and the game state (state).
 * If we are typing the secret code (state==0) we will place 
 * the cursor in row 3 (rowScreen=3), if we are typing a try (state==1) 
 * the row is calculated with the formula: (rowScreen=9+(DIMMATRIX-tries)*2).
 * The column is calculated with the formula (colScreen= 8+(pos*2)).
 * Place the cursor calling the gotoxyP2_C function.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (state):rdi(edi):  State of the game.
 * (tries):rsi(rsi):  Remaining tries.
 * (col)  :rdx(edx):  Column where the cursor is.
 * 
 * Output parameters: 
 * None
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'posCurScreenP2' 
 * is defined, the parameters are equivalent.
 **/
void posCurScreenP2_C(int state, long tries, int col){
   int rowScreen, colScreen;
   if (state==0) {
      rowScreen = 3;
   } else {
      rowScreen = 9+(DIMMATRIX-tries)*2;
   }
   colScreen = 8+(col*2);
   gotoxyP2_C(rowScreen, colScreen);
}


/**
 * Update the column (col) where the cursor is.
 * If we read (charac=='j') move left or (charac=='k') right
 * update cursor position (col +/- 1)
 * checking that it does not leave the array [0..DIMMATRIX-1].
 * Return the updated value of (col).
 *  
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (charac): rdi(dil): Character read from the keyboard.
 * (col)   : rsi(esi): Column where the cursor is.
 * 
 * Output parameters: 
 * (col)   : rax(eax): Column where the cursor is.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'updateColP2' 
 * is defined, the parameters are equivalent.
 **/
int updateColP2_C(char charac, int col){
	
   if ((charac=='j') && (col>0)){             
      col--;
   }
   if ((charac=='k') && (col<DIMMATRIX-1)){
      col++;
   }
   return col;
}


/**
 * Store the read character ['0' - '9'] (charac) in the matrix 
 * (mSecretPlay) in the row indicated by the variable (state) and
 * the column indicated by the variable (col).
 * If (state==0) we will change the character read by a '*' 
 * (charac = '*') for which the secret code we write is not seen.
 * Finally, we show the character (charac) on the screen at the position 
 * where the cursor is by calling the printchP2_C function.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (charac)    : rdi(dil): Character to show.
 * (mSecrePlay): rsi(rsi): Address of the matrix where we store the secret code and the try.
 * (col)       : rdx(edx): Column where the cursor is.
 * (state)     : rcx(ecx): State of the game.
 * 
 * Output parameters: 
 * None
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'updateMatrixBoardP2' 
 * is defined, the parameters are equivalent.
 **/
void updateMatrixBoardP2_C(char charac, char mSecretPlay[2][DIMMATRIX], int col, int state){

   mSecretPlay[state][col]=charac;   
   if (state==0) {
      charac='*';
   } 
   printchP2_C(charac);
}


/**
 * Read the characters of the secret code or the try.
 * While ENTER(10) or ESC(27) is not pressed do the following:
 * · Place the cursor on the screen by calling the posCurScreenP2_C function,
 * according to the value of the variables (col, tries and state).
 * · Read a keyboard character by calling the getchP2_C function 
 * which returns to (charac) the ASCII code of the character read.
 * - If a 'j' (left) or a 'k' (right) has been read, move the
 * cursor through the 5 positions of combination updating 
 * the value of the variable (col) by calling the updateColP2_C function 
 * depending on the variables (col, tries and state).
 * - If a number ['0'-'9'] has been read we store it in the array
 * (mSecretPlay) and we display it by calling the updateMatrixBoardP2_C function
 * depending on the variables (charac, mSecretPlay, col and state).
 * If ESC(27) has been pressed, set (state=-1) to indicate that we must exit.
 * Pressing ENTER(10) will accept the combination as is.
 * NOTE: Please note that if ENTER is pressed without having been assigned
 * values in all positions of the combination, there will be positions
 * which will be a space (value used to initialise the array).
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
 * (state)      : rsi(esi): State of the game.
 * (tries)      : rdx(rdx): Remaining tries.
 * 
 * Output parameters: 
 * (state)      : rax(eax): State of the game.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'getSecretPlayP2' 
 * is defined, the parameters are equivalent.
 **/
int getSecretPlayP2_C(char mSecretPlay[2][DIMMATRIX], int state, long tries ){
	
   int  rowScreen, colScreen;
   char charac;
   int  col = 0;
   
   do {
	 posCurScreenP2_C(state, tries, col);
	 charac = getchP2_C();
     if (charac=='j' || charac=='k'){             
       col = updateColP2_C(charac, col);
     } else if (charac>='0' && charac<='9') {   
       updateMatrixBoardP2_C(charac, mSecretPlay, col, state);
     }  
   } while (charac!=10 && charac!=27);  

   if (charac == 27) {
     state = -1;    
   }
   
   return state;
}


/**
 * Verify that the secret code does not have the initial value (' '), 
 * or repeated numbers.
 * For each element of the row [0] of the matrix (mSecretPlay) check 
 * that there is no space (' ') and that it is not repeated in the
 * (from the next position to the current one until the end). 
 * To indicate that the secret code is not correct we set (secretError=1).
 * If the secret code is incorrect, set (state = 2) to request it again.
 * else, the secret code is correct, set (state = 1) to read tries.
 * Return the actual state of the game (state).
 * 
 * Global variables :
 * None	
 * 
 * Input parameters : 
 * (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
 * 
 * Output parameters: 
 * (state)      : rax(eax): State of the game.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'checkSecretP2' 
 * is defined, the parameters are equivalent.
 **/
int checkSecretP2_C(char mSecretPlay[2][DIMMATRIX]) {
   int i,j;
   int secretError = 0;
   int state;
     
   for (i=0;i<DIMMATRIX;i++) {
     if (mSecretPlay[0][i]==' ') {
       secretError=1;
     }
     for (j=i+1;j<DIMMATRIX;j++) {
       if (mSecretPlay[0][i]==mSecretPlay[0][j]) {
		 secretError=1;
	   }
     }
   }
   
   if (secretError==1) state = 2; 
   else state = 1; 

   return state;

}


/**
 * Show the secret code.
 * Show the secret code (row 0 of the mSecretPlay matrix)
 * at the top of the board when the game ends.
 * To show the values, the gotoxyP2_C function must be called to
 * place cursor, in row 3 (rowScreen=3) and from 
 * column 8 (colScreen=8) and printchP2_C to display each character.
 * Increase the column (colScreen) by 2.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
 * 
 * Output parameters: 
 * None
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'printSecretP2' 
 * is defined, the parameters are equivalent.
 **/
void printSecretP2_C(char mSecretPlay[2][DIMMATRIX]) {
	
   int  i;
   char charac;
   int  rowScreen = 3;
   int  colScreen = 8;
   
   for (i=0; i<DIMMATRIX; i++){
	 gotoxyP2_C(rowScreen, colScreen);
	 charac = mSecretPlay[0][i];
     printchP2_C(charac);
     colScreen = colScreen + 2;     
   } 
   
}


/**
 * Show the hits in place and out of place.
 * Place the cursor in the row (rowScreen=9+(DIMMATRIX-tries)*2) and 
 * column (colScreen=22) (right side of the board) to show 
 * the hits on the game board.
 * First, the hits in place (hX) are shown, as many 'X' as hits in place,
 * and then, as many 'O' as hits out of place (hO) are shown.
 * To display the hits, the gotoxyP2_C function must be called to 
 * place the cursor and printchP2_C to display the characters.
 * Each time a hit is displayed, the column (colScreen) 
 * must be incremented by 2.
 * NOTE: (hX + hO must always be smaller or equal than DIMMATRIX).
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (hX)   : rdi(di) : Hits in place.
 * (hO)   : rsi(si) : Hits out of place.
 * (tries): rdx(rdx): Remaining tries.
 * 
 * Output parameters: 
 * None
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'printHitsP2' 
 * is defined, the parameters are equivalent.
 **/ 
void printHitsP2_C(short hX, short hO, long tries) {
   int i;
   int rowScreen = 9 + (DIMMATRIX-tries)*2;
   int colScreen = 22;
   
   for(i=hX;i>0;i--) {
     gotoxyP2_C(rowScreen,colScreen);
     printchP2_C('X');
     colScreen = colScreen + 2;
   }
   for(i=hO;i>0;i--) {
     gotoxyP2_C(rowScreen,colScreen);
     printchP2_C('O');
     colScreen = colScreen + 2;
   }
}


/**
 * Count hits in place and out of place of the try with 
 * respect to the secret code.
 * To do the comparison you must do:
 * For each element of the secret code (row 0 of the mSecretPlay matrix)
 * (used as reference because it has no repeated values).
 * Compare it to all elements of the play (row 1 of the mSecretPlay matrix).
 * If an element of the secret code (mSecretPlay[0][i]) is equal to 
 * the element of the same position in the play (mSecretPlay[1][i]) 
 * it will be a hit in place 'X' and the hits in place variable must 
 * be increased (hX++), otherwise, it will be a hit out of place 'O'  
 * if an element of the secret combination (mSecretPlay[0][i]) is 
 * equal to an element of the try mSecretPlay[1][j]), but they occupy 
 * different positions (i !=j), the hits out of place variable must be
 * increased (hO++) and stop going through the try positions to count
 * each hit only once.
 * If all the positions of the secret code and the try are the same 
 * (hX=DIMMATRIX) we have won and the game state must be modified 
 * to indicate this (state=3), otherwise, check if the attempts are
 * over (tries==1), if attempts are over modify the state of the game
 * to indicate this (state=4).
 * Show the hits in place in the game board calling the printHitsP2_C function.
 * Return the actual state of the game (state).
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
 * (state)      : rsi(esi): State of the game.
 * (tries)      : rdx(rdx): Hits in place.
 * 
 * Output parameters: 
 * (state)      : rax(eax): State of the game.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'checkPlayP2' 
 * is defined, the parameters are equivalent.
 **/
int checkPlayP2_C(char mSecretPlay[2][DIMMATRIX], int state, long tries){
   int i,j;
   short hO = 0;
   short hX = 0;
   
   for (i=0;i<DIMMATRIX;i++) {
	 if (mSecretPlay[0][i]==mSecretPlay[1][i]) {
       hX++;
     } else {
       for (j=0;j<DIMMATRIX;j++) {
         if (mSecretPlay[0][i]==mSecretPlay[1][j]) {
           hO++;
           j=DIMMATRIX;  
         }
       }
     }
   }
    
   if (hX == DIMMATRIX ) {
     state = 3;
   } else if (tries==1) {
		 state = 4;
   }
   printHitsP2_C(hX, hO, tries);
   
   return state;
}


/**
 * Show a message at the bottom right of the game board according to 
 * the value of the variable (state). 
 * (state) -1: ESC was pressed to exit.
 *          0: We are typing the secret code. 
 *          1: We are typing a tray.
 *          2: The secret code has spaces or repeated numbers.
 *          3: Won, try = secret code.
 *          4: The tries have run out.
 *          
 * Is expected to press a key to continue. 
 * Show a message below on the  game board to indicate this, 
 * and pressing a key, it is deleted.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (state): rdi(edi): State of the game.
 * 
 * Output parameters: 
 * None
 *  
 * An assembly language subroutine 'printMessageP2' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers.
 * The parameters are equivalent.
 **/
void printMessageP2_C(int state){

   gotoxyP2_C(20,11);
   switch(state){
	 case -1:
       printf(" EXIT: (ESC) PRESSED ");
     break;
     case 0: 
       printf("Write the Secret Code");
     break;
     case 1:
       printf(" Write a combination ");
     break;
     case 2:
       printf("Secret Code ERROR!!! ");
     break;
     case 3:
       printf("YOU WIN: CODE BROKEN!");
     break;
     case 4:
       printf("GAME OVER: No tries! ");
     break;
   }
   gotoxyP2_C(21,11); 
   printf("    Press any key ");
   getchP2_C();	  
   gotoxyP2_C(21,11);  
   printf("                  ");
   
}


/**
 * Main game function
 * Read the secret code and verify that it is correct.
 * Then a try is read, compare the try with 
 * the secret code to check hits.
 * Repeat the process until the secret code is guessed or 
 * while there aren't tries left. If 'ESC' key is pressed while reading
 * the secret code or a try, exit.
 * 
 * Pseudo-code:
 * The player has 5 tries (tries=5) to guess the secret code, 
 * the initial state of the game is 0 (state=0) and the cursor is set 
 * to column 0 (col=0).
 * Show the game board by calling the printBoardP2_C function.
 * 
 * While (state == 0) read the secret code or (state == 1) read
 * the try:
 *   - Show the remaining tries (tries) to guess the secret code, 
 *     place the cursor in row 21, column 5 calling the gotoxyP2_C 
 *     function and show the character associated with the value of the 
 *     variable (tries) adding '0' and calling the printchP2_C function.
 *   - Show a message according to the state of the game (state) calling
 *     the  printMessageP2_C function.
 *   - Place the cursor on the game board calling the posCurBoardP2_C function.
 *   - Read the characters of the secret combination or the try
 *     and update the game state by calling the getSecretPlayP2_C function.
 *   - If we are typing the secret code (state==0), verify
 *     that is correct by calling the checkSecretP2_C function.
 *     Else, if we are typing a try (state==1) check
 *     hits of the try calling the checkPlayP2_C function,
 *     decrease tries (tries). Initialize the try that we have saved 
 *     in row 1 of the array mSecretPlay with spaces (' ') 
 *     to be able to enter a new try.
 * 
 * Finally, show the remaining tries (tries) to guess the 
 * secret code, place the cursor in row 21, column 5 by calling the 
 * gotoxyP2_C function and show the character associated with the 
 * value of the variable (tries) by adding '0' and calling the 
 * printchP2_C function, show the secret code by calling the
 * printSecretP2_C  function and finally show the message indicating the 
 * reason calling the printMessageP2_C function.
 * Game is over.
 * 
 * Global variables :	
 * None
 * 
 * Input parameters : 
 * (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
 * 
 * Output parameters: 
 * None
 *  
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'playP2' 
 * is defined, the parameters are equivalent.
 **/
void playP2_C(char mSecretPlay[2][DIMMATRIX]) {
	
   int  col = 0;    //Column where the cursor is placed.

   int  state = 0;  //State of the game
                    //-1: ESC was pressed to exit.
                    //0: We are typing the secret code. 
                    //1: We are typing a tray.
                    //2: The secret code has spaces or repeated numbers.
                    //3: Won, try = secret code.
                    //4: The tries have run out.

   long  tries = 5; //Remaining tries.
   
   printBoardP2_C(tries);
           
   int   i;

   while (state == 0 || state == 1) {
	   
	 gotoxyP2_C(21,5);
     printchP2_C((char)tries + '0');
     printMessageP2_C(state);
     posCurScreenP2_C(state, tries, col);
     
	 state = getSecretPlayP2_C(mSecretPlay, state, tries);
	 if (state==0) {
	   state = checkSecretP2_C(mSecretPlay);
     } else {
       if (state==1) {
	     state = checkPlayP2_C(mSecretPlay, state, tries);
	     tries --;
	   }
	   for (i=0;i<DIMMATRIX;i++) {
		   mSecretPlay[1][i]=' ';
	   }
	 }
     
   }
   gotoxyP2_C(21,5);
   printchP2_C((char)tries + '0');
   printSecretP2_C(mSecretPlay);
   printMessageP2_C(state);
   
}


/**
 * Main Program
 * 
 * ATTENTION: In each option an assembly subroutine is called.
 * Below them there is a line comment with the equivalent C function 
 * that we give you done in case you want to see how it works.
 * For the full game there is an option for the assembler version and
 * an option for the game in C.
 **/
void main(void){   
   /**
   * Variables Locals del joc
   **/
   char c;          // Character read from the keyboard and to show.
   int i;
   //int  rowScreen;  //Row of the screen where the cursor is placed.
   //int  colScreen;  //Column of the screen where the cursor is placed.

   char mSecretPlay[2][DIMMATRIX] = { {' ',' ',' ',' ',' '},   //Row 0: Secret code
                                      {' ',' ',' ',' ',' '}};  //Row 1: Try.
   int  col = 0;    //Column where the cursor is placed.

   int  state = 0;  //State of the game
                    //-1: ESC was pressed to exit.
                    //0: We are typing the secret code. 
                    //1: We are typing a tray.
                    //2: The secret code has spaces or repeated numbers.
                    //3: Won, try = secret code.
                    //4: The tries have run out.

   long  tries = 5; //Remaining tries.
   short hitsO;     //Hits out of place.
   short hitsX;     //Hits in place.
   
   
   int op=' ';      
   
   while (op!=27) {
     op = printMenuP2_C();	  
     switch(op){
       case 27:
         gotoxyP2_C(23,1); 
         break;
       case '1':	          //Place the cursor in the game board.
         state=1;
         tries=5;
         col = 0;		
         printBoardP2_C(tries);
         gotoxyP2_C(21,11);
         printf("   Press any key  ");   
         //=======================================================
         posCurScreenP2(state, tries, col);
         ///posCurScreenP2_C(state, tries, col);
         //=======================================================
         getchP2_C();
         break;
       case '2':	          //Update cursor column.
         state=1;
         tries=5;
	     col = 4;
         printBoardP2_C(tries);
         gotoxyP2_C(21,11);
         printf(" Press 'j' or 'k' ");
         posCurScreenP2_C(state, tries, col);
         c = getchP2_C();
         if (c=='j' || c=='k') {
         //=======================================================
         col = updateColP2(c, col);
         ///col = updateColP2_C(c, col);	    
         //=======================================================
         }
         gotoxyP2_C(21,11);
         printf("   Press any key   ");
         posCurScreenP2_C(state, tries, col);
         getchP2_C();
         break;
       case '3': 	     //Update array and show it on the game board.
         state=0;
         tries=5;
         col=2;		  
         printBoardP2_C(tries);
         gotoxyP2_C(21,11);
         printf(" Press (0-9) value ");
         posCurScreenP2_C(state, tries, col);
         c = getchP2_C();
         if (c>='0' && c<='9'){       
         //=======================================================
         updateMatrixBoardP2(c, mSecretPlay, col, state);
         ///updateMatrixBoardP2_C(c, mSecretPlay, col, state);
         //=======================================================
         }
         gotoxyP2_C(20,11);
         printf("   To show Secret  "); 
         gotoxyP2_C(21,11);
         printf("   Press any key   ");
         getchP2_C();
         printSecretP2_C(mSecretPlay);
         gotoxyP2_C(20,11);
         printf("                   "); 
         gotoxyP2_C(21,11);
         printf("    Press any key  "); 
         getchP2_C();
         break;
       case '4': 	     //Read the secret code and the try
         state=0;
         tries=5;
         col=0;
         for (i=0;i<DIMMATRIX;i++) {
		   mSecretPlay[state][i]=' ';
	     }
         printBoardP2_C(tries);
         printMessageP2_C(state);	
         //=======================================================
         state = getSecretPlayP2(mSecretPlay, state, tries);
         ///state = getSecretPlayP2_C(mSecretPlay, state, tries);
         //=======================================================
         printSecretP2_C(mSecretPlay);
         state = checkSecretP2_C(mSecretPlay);
         printMessageP2_C(state);	
         break;  
       case '5': 	     //Show the secret code
         state=0;
         tries=5;
         col=0;	
         printBoardP2_C(tries);  
         //=======================================================
         printSecretP2(mSecretPlay);
         ///printSecretP2_C(mSecretPlay);		
         //=======================================================
         gotoxyP2_C(21,11);
         printf("   Press any key  ");
         getchP2_C();
         break;
       case '6': 	     //Check the secret code
         state=0;
         tries=5;
         col=0;
         printBoardP2_C(tries);
         //=======================================================
         state = checkSecretP2(mSecretPlay);
         ///state = checkSecretP2_C(mSecretPlay);
         //=======================================================
         printSecretP2_C(mSecretPlay);		
         printMessageP2_C(state);
         break;
       case '7': 	     //Show hits.
         state=1;
         tries=5;
         col=0;
         printBoardP2_C(tries);
         hitsO = 2;
         hitsX = 1;
         //=======================================================
         printHitsP2(hitsX, hitsO, tries);
         ///printHitsP2_C(hitsX, hitsO, tries);
         //=======================================================
         gotoxyP2_C(21,11);
         printf("   Press any key  ");
         getchP2_C();
         break;
       case '8': 	     //Check hits in place and out of place
         state=0;
         tries=5;
         col=0;
         printBoardP2_C(tries);
         char  msecretplay2[2][DIMMATRIX] = {{'1','2','3','4','5'}, //Secret code
                                             {'1','4','3','1','4'}};//Try
         printSecretP2_C(msecretplay2);
         state=1;
         int rowScreen = 9+(DIMMATRIX-tries)*2;;
         int colScreen = 8;
         for (i=0; i<DIMMATRIX; i++){
	       gotoxyP2_C(rowScreen, colScreen);
	       c = msecretplay2[1][i];
           printchP2_C(c);
           colScreen = colScreen + 2;     
         } 	
         //=======================================================
         state = checkPlayP2(msecretplay2, state, tries);
         ///state = checkPlayP2_C(msecretplay2, state, tries);
         //=======================================================
         printMessageP2_C(state);
         break;
       case '9': 	//Complet game in assembly language.
         i=0;
         for (i=0;i<DIMMATRIX;i++) {
           mSecretPlay[0][i]=' ';
           mSecretPlay[1][i]=' ';
         } 
         //=======================================================
         playP2(mSecretPlay);
         //=======================================================
         break;
       case '0': 	//Complet game in C.
         i=0;
         for (i=0;i<DIMMATRIX;i++) {
           mSecretPlay[0][i]=' ';
           mSecretPlay[1][i]=' ';
         } 
         //=======================================================
         playP2_C(mSecretPlay);
         //=======================================================
         break;
     }
   }

}
