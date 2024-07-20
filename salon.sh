#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?\n"

  # query the services table
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services;")

  # print the availble sevices in this format 1) Hair cut 2) Hair color ...
  echo $AVAILABLE_SERVICES | sed 's/ |/)/g'

  # Take user input
  read SERVICE_ID_SELECTED

  # Query the services table for that particular service entered by the user
  SERVICE_ID_SELECTED_RESULT=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED';")

  # If the user has entered invalid service_id
  if [[ -z $SERVICE_ID_SELECTED_RESULT ]]
  then
    # return to the main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # read customer's phone number 
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    # check if customer exist in customer table
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    
    # if customer doesn't exist
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get new customer name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      echo -e "\nWhat time would you like your $SERVICE_ID_SELECTED_RESULT, $CUSTOMER_NAME?"
      read SERVICE_TIME

      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
      
      # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
      
      # insert appointment
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
      
      echo -e "\nI have put you down for a $SERVICE_ID_SELECTED_RESULT at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
 
}

MAIN_MENU