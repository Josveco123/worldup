#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT  WINNER_GOALS OPPONENT_GOALS
do
echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS 
  if [[ $WINNER != "winner" ]]
  then
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      if [[ -z $TEAM_ID ]]
      then
          INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
          then
              echo Inserted into majors, $WINNER
          fi
      fi
  fi
#  inserta oponentes si no existen en teams.
  if [[ $OPPONENT != "opponent" ]]
  then
      TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      if [[ -z $TEAM_ID1 ]]
      then
          INSERT_TEAM_RESULT1=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $INSERT_TEAM_RESULT1 == "INSERT 0 1" ]]
          then
              echo Inserted into majors, $OPPONENT
          fi
      fi
  fi
  # insertar filas en games
 TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
 TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID1, $TEAM_ID2, $WINNER_GOALS, $OPPONENT_GOALS)")
 if [[ $INSERT_TEAM_RESULT1 == "INSERT 0 1" ]]
    then
      echo Inserted into WINNER Y OPPONET, $TEAM_ID1 $TEAM_ID2
    fi    
done
