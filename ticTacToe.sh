#!/bin/bash 
echo "WELCOME TO TIC TAC TOE"
declare -a board
#variable
rows=3
columns=3
function initializeBoard () {
	for((i=0;i<$rows;i++))
	do
		for((j=0;j<$columns;j++))
		do
			board[$i,$j]='-'
		done
	done
}
initializeBoard
