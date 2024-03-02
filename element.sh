#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $1 ]] #there is an argument
then
  if [[ $1 =~ ^[0-9]+$ ]] 
  then
      #its a valid number
      USER_INPUT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number WHERE e.atomic_number = $1")
  else #its a valid symbol or name
      USER_INPUT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number WHERE e.symbol= '$1'")
      if [[ -z $USER_INPUT ]]
      then
        USER_INPUT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number WHERE e.name= '$1'")
      fi
  fi

  if [[ -z $USER_INPUT ]] #its not a valid number, symbol or name (its not a valid elment)
  then
    echo "I could not find that element in the database."
  else
    echo "$USER_INPUT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

  
else #there is no argument
  echo -e "Please provide an element as an argument."
fi 