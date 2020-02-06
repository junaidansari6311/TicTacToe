#!/bin/bash
echo "WELCOME TO TIC TAC TOE"
declare -A board
#variable
player=O
count=0
function initializeBoard () {
	for((rows=0;rows<3;rows++))
	do
		for((columns=0;columns<3;columns++))
		do
			board[$rows,$columns]="-"
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
	for((rows=0;rows<3;rows++))
	do
		for((columns=0;columns<3;columns++))
		do
			echo -n "| ${board[$rows,$columns]} |"
		done
		echo
		echo "----||---||----"
	done
}
function populateBoard () {
	read -p "Enter the row between (0,1,2) : " row
	read -p "Enter the column between (0,1,2) : " column
	isCellEmpty $row $column
}
function isCellEmpty () {
	if [[ $1 -lt 3 && $1 -ge 0 ]] && [[ $2 -lt 3 && $2 -ge 0 ]]
	then
		if [[ ${board[$1,$2]} == "-" ]]
		then
			board[$1,$2]=$player
			checkWinner $player
			((count++))
		else
			echo "Cell is not empty"
		fi
	else
		echo "Invalid $1 or $2"
	fi
}
function checkWinner () {
	displayBoard
	CountOfDiagonal=0
	CountOfAntiDiagonal=0
	for((rows=0;rows<3;rows++))
   do
		CountOfRow=0
		CountOfColumn=0
		for((columns=0;columns<3;columns++))
		do
			if [[ ${board[$rows,$columns]} == $1 ]]
			then
				((CountOfRow++))
			fi
			if [[ ${board[$columns,$rows]} == $1 ]]
			then
				((CountOfColumn++))
			fi
			if [[ $rows == $columns && ${board[$rows,$columns]} == $1 ]]
			then
				((CountOfDiagonal++))
			fi
			if [[ $(( rows+columns )) -eq 2 && ${board[$rows,$columns]} == $1 ]]
			then
				((CountOfAntiDiagonal++))
			fi
			if [[ $CountOfRow -eq 3 || $CountOfColumn -eq 3 || $CountOfDiagonal -eq 3 || $CountOfAntiDiagonal -eq 3 ]]
			then
				echo "$1 is a winner"
				exit
			fi

      done
   done
}
function startGame () {
	displayBoard
	while [ $count -lt 9 ]
	do
		populateBoard
	done
}
initializeBoard
assignLetter
tossForFirstTurn
startGame
