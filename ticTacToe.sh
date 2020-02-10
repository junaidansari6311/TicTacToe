#!/bin/bash
echo "WELCOME TO TIC TAC TOE"
declare -A board
#constants
NO_OF_ROWS=3
NO_OF_COLUMNS=3
TOTAL_COUNT=$(($NO_OF_ROWS*$NO_OF_COLUMNS))
#variable
player=O
computer=O
count=0
flag=0
tieFlag=0
winnerFlag=0
function initializeBoard () {
	for((rows=0;rows<$NO_OF_ROWS;rows++))
	do
		for((columns=0;columns<$NO_OF_COLUMNS;columns++))
		do
			board[$rows,$columns]="-"
		done
	done
}
function assignLetter () {
	if [ $((RANDOM%2)) -eq 0 ]
	then
		player=X
		flag=1
	else
		computer=X
		flag=0
	fi
}
function displayBoard () {
	echo "Player = $player  Computer = $computer"
	echo "----||---||----"
	for((rows=0;rows<$NO_OF_ROWS;rows++))
	do
		for((columns=0;columns<$NO_OF_COLUMNS;columns++))
		do
			echo -n "| ${board[$rows,$columns]} |"
		done
		echo
		echo "----||---||----"
	done
	echo "*-------------*--------------*"
}
function populateBoard () {
	board[$1,$2]=$3
	((count++))
	clear
	displayBoard
	checkWinner $3
	if [[ $winnerFlag -eq 1 ]]
	then
		echo "$3 Won!!!"
		exit
	fi
}
function isCellEmpty () {
	if [[ $1 -lt $NO_OF_ROWS && $1 -ge 0 ]] && [[ $2 -lt $NO_OF_COLUMNS && $2 -ge 0 ]]
	then
		if [[ ${board[$1,$2]} == "-" ]]
		then
			populateBoard $row $column $switchPlayerLetter
		else
			echo "Cell is not empty"
			switchTurns
		fi
	else
		echo "Invalid $1 or $2"
		switchTurns
	fi
}
function checkWinner () {
	CountOfDiagonal=0
	CountOfAntiDiagonal=0
	for((rows=0;rows<$NO_OF_ROWS;rows++))
	do
		CountOfRow=0
		CountOfColumn=0
		for((columns=0;columns<$NO_OF_COLUMNS;columns++))
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
			if [[ $CountOfRow -eq $NO_OF_COLUMNS || $CountOfColumn -eq $NO_OF_COLUMNS || $CountOfDiagonal -eq $NO_OF_COLUMNS || $CountOfAntiDiagonal -eq $NO_OF_COLUMNS ]]
			then
				winnerFlag=1
				tieFlag=1
			fi
		done
	done
}
function checkTie () {
	if [[ $tieFlag -eq 0 ]]
	then
		echo "It's a tie!!!"
	fi
}
function computerMoveForWinning () {
	for ((rowCount=0;rowCount<$NO_OF_ROWS;rowCount++))
	do
		for ((columnCount=0;columnCount<$NO_OF_COLUMNS;columnCount++))
		do
			if [[ ${board[$rowCount,$columnCount]} == "-" ]]
			then
				board[$rowCount,$columnCount]=$computer
				checkWinner $computer
				if [[ winnerFlag -eq 1 ]]
				then
					populateBoard $rowCount $columnCount $computer
					exit
				else
					board[$rowCount,$columnCount]="-"
				fi
			fi
		done
	done
}
function switchTurns () {
	if [[ $flag -eq 1 ]]
	then
		echo "Player's turn!!!"
		read -p "Enter the row between (0,1,2) : " row
		read -p "Enter the column betwwn (0,1,2) : " column
		switchPlayerLetter=$player
		isCellEmpty $row $column $switchPlayerLetter
		flag=0
	else
		echo "Computer's turn!!!"
		computerMoveForWinning
		row=$((RANDOM%$NO_OF_ROWS))
		column=$((RANDOM%$NO_OF_COLUMNS))
		switchPlayerLetter=$computer
		isCellEmpty $row $column $switchPlayerLetter
		flag=1
	fi
}
function startGame () {
	while [[ $count -lt $TOTAL_COUNT ]]
	do
		switchTurns
	done
}
initializeBoard
assignLetter
displayBoard
startGame
checkTie
