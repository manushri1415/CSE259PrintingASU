drawSymbol(_Symbol, 0).
drawSymbol(Symbol, N) :- N > 0, write(Symbol), N1 is N - 1, drawSymbol(Symbol, N1).

drawHorizontalLine(_Symbol, 0) :- nl.
drawHorizontalLine(Symbol, N) :- drawSymbol(Symbol, N).

drawVerticalLinesWithSpace(_Symbol, 0, _Width).
drawVerticalLinesWithSpace(Symbol, Height, Width) :- 
  Height > 0,
  write(Symbol),
  drawSymbol(' ', Width - 2),
  write(Symbol),
  nl,
  Height1 is Height - 1,
  drawVerticalLinesWithSpace(Symbol, Height1, Width).

/*-------------------------------------------------------------------------------------------------*/
/* draw A */
drawA(TextWidth, _TextHeight, _FontSize, _CurrentLine, ColumnNumber) :-
  ColumnNumber >= TextWidth.

/* 
 * Covers the left-most and the right-most columns that only have stars 
 */
drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber) :-
  (
    (ColumnNumber >= 0, ColumnNumber < FontSize);
    (ColumnNumber >= FontSize * 2, ColumnNumber < TextWidth )
  ),
  drawSymbol('*', FontSize),
  NextColumn is ColumnNumber + FontSize,
  drawA(TextWidth, TextHeight, FontSize, CurrentLine, NextColumn).

/* 
 * Covers the middle segment
 * Will have either stars or spaces 
 */
drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber) :-
  (ColumnNumber >= FontSize, ColumnNumber < FontSize * 2),
  (
    (CurrentLine >= 0, CurrentLine < FontSize);
    (CurrentLine >= FontSize * 2 , CurrentLine < FontSize * 3)
  ),
  drawSymbol('*', FontSize),
  NextColumn is ColumnNumber + FontSize,
  drawA(TextWidth, TextHeight, FontSize, CurrentLine, NextColumn).


drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber) :-
  (ColumnNumber >= FontSize, ColumnNumber < FontSize * 2),
  (
    (CurrentLine >= FontSize, CurrentLine < 2 * FontSize);
    (CurrentLine >= FontSize * 3, CurrentLine < TextHeight)
  ),
  drawSymbol(' ', FontSize),
  NextColumn is ColumnNumber + FontSize,
  drawA(TextWidth, TextHeight, FontSize, CurrentLine, NextColumn).
/* draw A */
/*-------------------------------------------------------------------------------------------------*/

/* WRITE RULES FOR drawS HERE*/
/*-------------------------------------------------------------------------------------------------*/
drawS(TextWidth,_TextHeight,_FontSize,_CurrentLine,ColumnNumber) :-
  ColumnNumber >= TextWidth.  %similar to A letter part 

/* this is the top part of the 
s->      ****
         ****  (changes based on the width) */
drawS(TextWidth,_TextHeight,FontSize,CurrentLine,_ColumnNumber) :-
  CurrentLine < FontSize,   %prints only until the fontsize (eg, FontSize= 2 then "**")
  drawSymbol('*',TextWidth).

/* the left part of S after the top band
s-> ****
    ****  (changes based on the width) */
drawS(TextWidth,_TextHeight,FontSize,CurrentLine,_ColumnNumber) :-
  CurrentLine >= FontSize,  %to ensure we are after the top part
  CurrentLine < 2* FontSize, %since we are prinitig on the left side not the entire FontSize
  drawSymbol('*',FontSize), 
  drawSymbol(' ',TextWidth - FontSize).

/* middle line
s->      ****
         ****  (changes based on the width) */
drawS(TextWidth, _TextHeight, FontSize, CurrentLine, _ColumnNumber) :-
  CurrentLine < 3* FontSize, %to ensure we are not accidently prinitng left side part
  CurrentLine >= 2* FontSize,
  drawSymbol('*',TextWidth).

/*right part of the S
s->            ****
               ****  (changes based on the width) */
drawS(TextWidth, _TextHeight, FontSize, CurrentLine, _ColumnNumber) :-
  CurrentLine >= 3* FontSize, %to ensure we are not accidently printing the middle part
  CurrentLine < 4* FontSize,
  drawSymbol(' ', TextWidth - FontSize), 
  drawSymbol('*',FontSize).

/* bottom part, simialr to the top one
s-> ****
    ****  (changes based on the width) */
drawS(TextWidth,TextHeight,FontSize,CurrentLine,_ColumnNumber) :-
  CurrentLine >= 4*FontSize, 
  CurrentLine <TextHeight, %printing until the height of the text
  drawSymbol('*',TextWidth).

/* draw S */
/*-------------------------------------------------------------------------------------------------*/

/* WRITE RULES FOR drawU HERE*/
%base case, return true when finished printing
drawU(TextWidth,_TextHeight,_FontSize,_CurrentLine, ColumnNumber):-
  ColumnNumber >= TextWidth.

%2 columns up the sides
drawU(TextWidth,TextHeight,FontSize,CurrentLine,ColumnNumber):-
  (
      (ColumnNumber >= 0, ColumnNumber < FontSize);
      (ColumnNumber >= FontSize *2, ColumnNumber < TextWidth)
  ),
  drawSymbol('*',FontSize),
  NextColumn is ColumnNumber + FontSize,
  drawU(TextWidth,TextHeight,FontSize,CurrentLine,NextColumn).

%Middle Part at the bottom
drawU(TextWidth,TextHeight,FontSize,CurrentLine,ColumnNumber):-
  (ColumnNumber >= FontSize,ColumnNumber< FontSize * 2),
  (
      (CurrentLine >= FontSize * 4, CurrentLine < TextHeight)
  ),
  drawSymbol('*',FontSize),
  NextColumn is ColumnNumber + FontSize,
  drawU(TextWidth,TextHeight,FontSize,CurrentLine,NextColumn).

%Filling in spaces in the middle
drawU(TextWidth,TextHeight,FontSize,CurrentLine,ColumnNumber):-
  (ColumnNumber >= FontSize,ColumnNumber< FontSize*2),
  (
      (CurrentLine >= 0,CurrentLine < 4 * FontSize)
  ),
  drawSymbol(' ',FontSize),
  NextColumn is ColumnNumber + FontSize,
  drawU(TextWidth,TextHeight,FontSize,CurrentLine,NextColumn).

/* draw the text with appropriate spacing*/
draw(_LeftRightMargin, _SpaceBetweenCharacters, _FontSize, CurrentLine, _TextWidth, TextHeight) :-
  CurrentLine >= TextHeight.
draw(LeftRightMargin, SpaceBetweenCharacters, FontSize, CurrentLine, TextWidth, TextHeight) :-
  CurrentLine < TextHeight,
  ColumnNumber is 0,
  write('|'), drawSymbol(' ', LeftRightMargin),
  drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber),

  /*---------------------------------------------*/
  /** CALL YOUR RULES HERE **/
  % add spaces here between A and S
  drawSymbol(' ', SpaceBetweenCharacters),

  % call drawS
  drawS(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber),

  % add spaces here between S and U
  drawSymbol(' ', SpaceBetweenCharacters),

  % call drawU
  ColumnNumber is 0,
  drawU(TextWidth,TextHeight,FontSize,CurrentLine,ColumnNumber),

  /*---------------------------------------------*/

  drawSymbol(' ', LeftRightMargin),
  write('|'),
  nl,
  NextLine is CurrentLine + 1,
  draw(LeftRightMargin, SpaceBetweenCharacters, FontSize, NextLine, TextWidth, TextHeight).

/* this will be initiating the variables and will be called from asu() */
drawVerticalLinesWithCharacters(LeftRightMargin, _BottomTopMargin, SpaceBetweenCharacters, FontSize) :-
  CurrentLine is 0,
  TextWidth is FontSize * 3,
  TextHeight is FontSize * 5,
  draw(LeftRightMargin, SpaceBetweenCharacters, FontSize, CurrentLine, TextWidth, TextHeight).

/* this will be used from the console */
/* adding a case to ensure if there is a -ve number then print false  */
asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize) :-
  (LeftRightMargin<0;BottomTopMargin<0; SpaceBetweenCharacters<0; FontSize=< 0),
  !,
  false.

asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize) :-
  /* verify that the variables are integers */
  integer(LeftRightMargin), integer(BottomTopMargin), integer(SpaceBetweenCharacters), integer(FontSize),

  /* calculate the height and width */
  Width is (LeftRightMargin * 2 + SpaceBetweenCharacters * 2 + FontSize * 3 * 3 + 2),
  Height is (BottomTopMargin * 2 + FontSize * 5),

  /* top horizontal line of the box */
  drawHorizontalLine('-', Width),
  nl,

  /* the empty space in the top */
  drawVerticalLinesWithSpace('|', BottomTopMargin, Width),

  /* the actual text */
  drawVerticalLinesWithCharacters(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize),

  /* the empty space in the bottom */
  drawVerticalLinesWithSpace('|', BottomTopMargin, Width),

  /* bottom horizontal line of the box */
  drawHorizontalLine('-', Width).