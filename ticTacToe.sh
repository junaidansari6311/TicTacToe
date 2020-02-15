
#!/bin/bash
echo "WELCOME TO TIC TAC TOE"
#2D array
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
winnerFlag=0
blockedFlag=0

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
	showWinner $3
}

function isCellEmpty () {
	if [[ $1 -lt $NO_OF_ROWS && $1 -ge 0 ]] && [[ $2 -lt $NO_OF_COLUMNS && $2 -ge 0 ]]
	then
		if [[ ${board[$1,$2]} == "-" ]]
		then
			populateBoard $1 $2 $3
		else
			echo "Cell is not empty"
			switchTurns
		fi
	else
		echo "Invalid $1 or $2"
		switchTurns
	fi
}

function showWinner () {
	if [[ $winnerFlag -eq 1 ]]
	then
		echo "$1 Won!!!"
		exit
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
			#checking winner in rows
			if [[ ${board[$rows,$columns]} == $1 ]]
			then
				((CountOfRow++))
			fi
			#checking winner in columns
			if [[ ${board[$columns,$rows]} == $1 ]]
			then
				((CountOfColumn++))
			fi
			#checking winner in diagonal
			if [[ $rows == $columns && ${board[$rows,$columns]} == $1 ]]
			then
				((CountOfDiagonal++))
			fi
			#checking winner in antidiagonal
			if [[ $(( rows+columns )) -eq 2 && ${board[$rows,$columns]} == $1 ]]
			then
				((CountOfAntiDiagonal++))
			fi
			if [[ $CountOfRow -eq $NO_OF_COLUMNS || $CountOfColumn -eq $NO_OF_COLUMNS || $CountOfDiagonal -eq $NO_OF_COLUMNS || $CountOfAntiDiagonal -eq $NO_OF_COLUMNS ]]
			then
				winnerFlag=1
			fi
		done
	done
}

function checkTie () {
	if [[ $count -eq $TOTAL_COUNT ]]
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
				board[$rowCount,$columnCount]=$1
				checkWinner $1
				if [[ $winnerFlag -eq 1 ]]
				then
					winnerFlag=0
					populateBoard $rowCount $columnCount $1
					break
				else
					board[$rowCount,$columnCount]="-"
				fi
			fi
		done
	done
}

function computerBlocksOpponent () {
	blockedFlag=0
	for((rowsCount=0;rowsCount<$NO_OF_ROWS;rowsCount++))
	do
		for((columnsCount=0;columnsCount<$NO_OF_COLUMNS;columnsCount++))
		do
			if [[ ${board[$rowsCount,$columnsCount]} == "-" ]]
			then
				board[$rowsCount,$columnsCount]=$1
				checkWinner $1
				if [[ $winnerFlag -eq 1 ]]
				then
					winnerFlag=0
					if [[ $blockedFlag -eq 0 ]]
					then
						blockedFlag=1
						populateBoard $rowsCount $columnsCount $2
						break
					fi
				else
					board[$rowsCount,$columnsCount]="-"
				fi
				if [[ $blockedFlag -eq 1 ]]
				then
					break
				fi
			fi
		done
		if [[ $blockedFlag -eq 1 ]]
		then
			break
		fi
	done
}

function checkIfCornersAreAvailable () {
	for((rowsCounter=0;rowsCounter<$NO_OF_ROWS;rowsCounter=$rowsCounter+2))
	do
		for((columnsCounter=0;columnsCounter<$NO_OF_COLUMNS;columnsCounter=$columnsCounter+2))
		do
			if [[ ${board[$rowsCounter,$columnsCounter]} == "-" ]]
			then
				populateBoard $rowsCounter $columnsCounter $1
				return
			fi
		done
	done
	rowsCounter=$(($NO_OF_ROWS/2))
	columnsCounter=$(($NO_OF_COLUMNS/2))
	if [[ ${board[$rowsCounter,$columnsCounter]} == "-" ]]
	then
		populateBoard $rowsCounter $columnsCounter $1
	else
		checkIfCenterIsAvailable $1
	fi
}

function checkIfCenterIsAvailable () {
	for((row=0;row<$NO_OF_ROWS;row++))
	do
		for((column=0;column<$NO_OF_COLUMN;column++))
		do
			row=$(($NO_OF_ROWS/2))
			column=$(($NO_OF_COLUMNS/2))
			if [[ ${board[$row,$column]} == "-" ]]
			then
				populateBoard $row $column $1
			else
				checkIfSidesAreAvailable $1
			fi
		done
	done
}

function checkIfSidesAreAvailable () {
	for((rowCounter;rowCounter<$NO_OF_ROWS;rowCounter++))
	do
		for((columnCounter;columnCounter<$NO_OF_COLUMNS;columnCounter++))
		do
			if [[ $(($(($rowCounter + $columnCounter))%2)) -eq 1 ]]
			then
				if [[ ${board[$rowCounter,$columnCounter]} == "-" ]]
				then
					populateBoard $rowCounter $columnCounter $1
					return
				fi
			fi
		done
	done
}

function playersTurn () {
	echo "Player's turn!!!"
	read -p "Enter the row between (0,1,2) : " row
	read -p "Enter the column between (0,1,2) : " column
	isCellEmpty $row $column $player
	showWinner $player
	flag=0
}

function computersTurn () {
	echo "Computer's turn!!!"
	computerMoveForWinning $computer
	computerBlocksOpponent $player $computer
	if [[ $blockedFlag -ne 1 ]]
	then
		checkIfCornersAreAvailable $computer
	fi
	showWinner $computer
	blockedFlag=0
}

function switchTurns () {
	if [[ $flag -eq 1 ]]
	then
		playersTurn
		flag=0
	else
		computersTurn
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
