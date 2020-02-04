#!/bin/bash 
echo "WELCOME TO TIC TAC TOE"
declare -a board
#variable
rows=3
columns=3
player=O
function initializeBoard () {
	for((i=0;i<$rows;i++))
	do
		for((j=0;j<$columns;j++))
		do
			board[$i,$j]=" "
		done
	done
}
function assignLetter () {
	if [ $((RANDOM%2)) -eq 0 ]
	then
		player=X
	else
		player=O
	fi
	echo "player = $player"
}
function tossForFirstTurn () {
	if [ $((RANDOM%2)) -eq 1 ]
	then
		echo "Player will play first"
	else
		echo "Player will play second"
	fi
}
function displayBoard () {
	echo "----||---||----"
	for((i=0;i<rows;i++))
	do
		for((j=0;j<columns;j++))
		do
			echo -n "| ${board[i,j]} |"
		done
		echo
		echo "----||---||----"
	done
}
initializeBoard
assignLetter
tossForFirstTurn
displayBoard
