PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
#!/bin/bash
GET_MODIFIED(){
  GET_ATOMIC_NUMBER_MODIFIED=$(echo $ATOMIC_NUMBER | sed 's/^ *| *$/""/')
  GET_NAME_MODIFIED=$(echo $GET_NAME | sed 's/^ *| *$/""/')
  GET_SYMBOL_MODIFIED=$(echo $GET_SYMBOL | sed 's/^ *| *$/""/')
  GET_TYPE_MODIFIED=$(echo $GET_TYPE | sed 's/^ *| *$/""/')
  GET_ATOMIC_MASS_MODIFIED=$(echo $GET_ATOMIC_MASS | sed 's/^ *| *$/""/')
  GET_MELTING_POINT_MODIFIED=$(echo $GET_MELTING_POINT | sed 's/^ *| *$/""/')
  GET_BOILING_POINT_MODIFIED=$(echo $GET_BOILING_POINT | sed 's/^ *| *$/""/')
}
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else 
  GET_INPUT=$1

if [[ $GET_INPUT =~ ^[0-9]+$ ]] 
then
  ATOMIC_NUMBER=$GET_INPUT
  GET_SYMBOL=$($PSQL "select symbol from elements where atomic_number= $ATOMIC_NUMBER")
  if [[ -z $GET_SYMBOL ]]
  then
    echo "I could not find that element in the database."
  else
    GET_NAME=$($PSQL "select name from elements where atomic_number= $ATOMIC_NUMBER")
    GET_TYPE=$($PSQL "select type from types inner join properties using(type_id) where atomic_number= $ATOMIC_NUMBER")
    GET_ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number= $ATOMIC_NUMBER")
    GET_MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number= $ATOMIC_NUMBER")
    GET_BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number= $ATOMIC_NUMBER")
    GET_MODIFIED
    echo "The element with atomic number $ATOMIC_NUMBER is $GET_NAME_MODIFIED ($(echo $GET_SYMBOL_MODIFIED)). It's a $GET_TYPE_MODIFIED, with a mass of $GET_ATOMIC_MASS_MODIFIED amu. $GET_NAME_MODIFIED has a melting point of $GET_MELTING_POINT_MODIFIED celsius and a boiling point of $GET_BOILING_POINT_MODIFIED celsius."
  fi
elif [[ $GET_INPUT =~ ^[A-Z][a-z]?$ ]]
then 
  GET_SYMBOL=$GET_INPUT
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$GET_SYMBOL'" )
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo "I could not find that element in the database."
  else
    GET_NAME=$($PSQL "select name from elements where symbol='$GET_SYMBOL'")
    GET_TYPE=$($PSQL "select type from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER")
    GET_ATOMIC_MASS=$($PSQL "select atomic_mass from properties inner join elements using (atomic_number) where symbol='$GET_SYMBOL'")
    GET_MELTING_POINT=$($PSQL "select melting_point_celsius from properties inner join elements using(atomic_number) where symbol='$GET_SYMBOL'")
    GET_BOILING_POINT=$($PSQL "select boiling_point_celsius from properties inner join elements using(atomic_number) where symbol='$GET_SYMBOL'")
    GET_MODIFIED
    echo "The element with atomic number $GET_ATOMIC_NUMBER_MODIFIED is $GET_NAME_MODIFIED ($GET_SYMBOL). It's a $GET_TYPE_MODIFIED, with a mass of $GET_ATOMIC_MASS_MODIFIED amu. $GET_NAME_MODIFIED has a melting point of $GET_MELTING_POINT_MODIFIED celsius and a boiling point of $GET_BOILING_POINT_MODIFIED celsius."
  fi
elif [[ $GET_INPUT =~ ^[A-Z][a-z]+$ ]]
then 
  GET_NAME=$GET_INPUT
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$GET_NAME'" )
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo "I could not find that element in the database."
  else
    GET_SYMBOL=$($PSQL "select symbol from elements where name='$GET_NAME'")
    GET_TYPE=$($PSQL "select type from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER")
    GET_ATOMIC_MASS=$($PSQL "select atomic_mass from properties inner join elements using (atomic_number) where name='$GET_NAME'")
    GET_MELTING_POINT=$($PSQL "select melting_point_celsius from properties inner join elements using(atomic_number) where name='$GET_NAME'")
    GET_BOILING_POINT=$($PSQL "select boiling_point_celsius from properties inner join elements using(atomic_number) where name='$GET_NAME'")
    GET_MODIFIED
    echo "The element with atomic number $GET_ATOMIC_NUMBER_MODIFIED is $GET_NAME_MODIFIED ($GET_SYMBOL_MODIFIED). It's a $GET_TYPE_MODIFIED, with a mass of $GET_ATOMIC_MASS_MODIFIED amu. $GET_NAME_MODIFIED has a melting point of $GET_MELTING_POINT_MODIFIED celsius and a boiling point of $GET_BOILING_POINT_MODIFIED celsius."
  fi
else 
  echo "I could not find that element in the database."
fi
fi
