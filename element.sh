#/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if no argument entered
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # check what type of argument was input

  # check if a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")

  # check if a string of 2 characters starting with a capital letter
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    # get atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")

  # check if a valid string for the name of an element 
  elif [[ $1 =~ ^[A-Z]([a-z]{3,39})$ ]]
  then
    # get atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")

  else
    ATOMIC_NUMBER=""
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    # get data
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
    echo $ELEMENT_DATA | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

fi
