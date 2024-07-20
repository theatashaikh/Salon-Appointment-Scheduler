# Salon Appointment Scheduler

This project is part of the freeCodeCamp Relational Databases certificate course. It is the third project named "Salon Appointment Scheduler". The aim of this project is to create a scheduling system for a salon using PostgreSQL and bash scripting.

## Database Structure

The database named salon consists of three tables:

1. **services**

   service_id: serial PRIMARY KEY
   name: varchar(50) NOT NULL

2. **customers**

   customer_id: serial PRIMARY KEY
   name: varchar(50) NOT NULL
   phone: varchar(15) UNIQUE NOT NULL

3. **appointments**

   appointment_id: serial PRIMARY KEY
   customer_id: int REFERENCES customers(customer_id)
   service_id: int REFERENCES services(service_id)
   time: varchar(100)

The services table is populated with at least
three services.

```sql
INSERT INTO services(name) VALUES
('Haircut'),
('Haircolor'),
('Hair styling');
```

## Bash Script

A bash script named salon.sh is created to manage salon appointments. The script allows users to:

1. View a numbered list of available services.
2. Enter a service ID, phone number, customer name (if they are a new customer), and appointment time.
3. Add new customers to the customers table if they do not already exist.
4. Schedule appointments by adding entries to the appointments table.

### Script Details

The script includes the following features:

- A shebang (#!/bin/bash) to specify that the script should be executed using bash.
- Executable permissions (chmod +x salon.sh).
- No usage of the clear command.
- Re-prompting for a valid service ID if an invalid one is entered.
- Reading user inputs into variables SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME.
- Inserting new customers into the customers table if they do not already exist.
- Scheduling appointments in the appointments table.

### Bash Script (`salon.sh`)

```bash
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

  # print the availble services in this format 1) Hair cut 2) Hair color ...
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

```

## Database Dump

To create a dump of the salon database, the following command was used:

```bash
pg_dump -cC --inserts -U freecodecamp salon > salon.sql
```

## Project structure

```bash
/project
 - salon.sh
 - salon.sql
```

## Contributing

If you wish to contribute to the Salon Appointment Scheduler project, you can follow these steps:

1. Fork the repository.
2. Create a new branch (git checkout -b feature-branch).
3. Make your changes and commit them (git commit -am 'Add new feature').
4. Push to the branch (git push origin feature-branch).
5. Open a pull request.

Your contributions are welcome and appreciated!

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
