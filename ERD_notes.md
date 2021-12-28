# stock app

USER

- ID
<!-- * user_type - ADMIN, CLIENT -->
- fullname
- email
- password
- password_confirmation
- STATUS -

ADMIN < USER
\*\*create another admin account method

CLIENT < USER

USER_ACCT_VALIDATION

- ID
- STATUS - BOOL, FALSE (:PENDING, :REJECTED), TRUE (APPROVED)

STOCK

- ID
- stock_name
- units
- price_per_unit

CLIENT_STOCK

- ID
- client_id FK
- stock_id FK
- units

TRANSACTION_LOG >

- client_id FK
- datetime
- transaction_action - BUY, SELL

# LIST OF CONTROLLERS (NOT COMPLETE)

- stock_controller CRUD
-

1. Admin
   User Story #1: As an Admin, I want to create a new user to manually add them to the app
   User Story #2: As an Admin, I want to edit a specific user to update his/her details: fullname
   User Story #3: As an Admin, I want to view a specific user to show his/her details: fullname, email
   User Story #4: As an Admin, I want to see all the users that registered in the app so I can track all the users and approve/reject them

# CRUD user_controller methods access; check if logged_in as ADMIN

2. Client
   User Story #1: As a User, I want to create an account

# user_controller .create() method // params

User Story #2: As a User, I want to receive an email after my registration to see if my registration is successful

# user_account_validation_controller .create() method

User Story #2: As a User, I want to receive an email to confirm my pending User Account signup. When admin approves my account

# POST .send_email() to user_account_validation_controller

User Story #1: As a User, I want to login my credentials so that I can access my account on the app

# session_controller ?? .create() method; creates a session <throughDevice>

User Story #3: As a User, I want to buy a stock from the stock market to add to my investment. Dropdown https://github.com/dblock/iex-ruby-client#get-symbols

# POST .buy() <customMethod> from user_contoller

User Story #2: As a User, I want to see my trading history

# transaction_log_controller .index() method

User Story #2: As a User, I want to sell the stocks I bought

#

User Story #2: As a User, I want to cash in (dummy)

#

3. Seed
   a. Admin account

# 3 admin accounts

5. Install gem
   https://github.com/dblock/iex-ruby-client
   implement this gem
   read documentation

Notes:

1. User can buy and sell
2. Market stock prices are from iex-ruby-client
3. HOW TO CONNECT BOOLEAN VAL FROM ADMIN TO CLIENT
