# Introduction:
Before we learn about the SQL Injections, we need to learn more about the database structuerre Query Language, which database will perform the necesary queries.
Web app utilize back-end database to store varius content and info related to the web app.
Thhs can be core web app assents like images and files, content like posts and updates, or user data like user and pass.
There are many different types of database, each of which fits a particular type of use. An app used fiel-based databese, which was very slow with the increase in size.
[Data Magment System(DBMS)]

- Data Base Magnament Systems:
This systems helps to create, define, host, and manage the database. Varius kinds of DBMS were designed over time such a file-based, Relational DBMS, NoSql, Graph based and key value.
There are multiple ways to interact with a DBMS, such a commnad-line, interact, API....
Some essecial of ft of DBMS:
    - Concurrency: A real-app might have a multiple users  interacting with it simultaneouslu.
    - Consitency: Whit so may concurrent interactions, the DBMS  need to ensure that the data remains consistent and valid throughtout the db.
    - Security: Provides fine-grained security controls throuigh user auth and permission, this will prevent unauthoirized viewing or editing of sesitive data.
    - Reliability: Ez to backup and rolls them back to a previus state in case of data loss a breach.
    - Structure Query Language: SQL simplifies user interactions with the db with intuitive syntax supporting operations.

## Architecture:
- Tier 1: Usually consists of client-side app such as website or GUI programs, These apps consist of high-level interactions such as user login or commenting, The databse these interactions is passed to Tier 2
throght API calls or other requests.
The second tier is middleware, which interprets these events puts them in a form required by the DBMS, The app layer uses specific layer and specific libraries  and drivers based on th type of DBMS to interact with.
The DBMS recieves queries form the secon tire an perform the requested operations. These operations could include isertion, retrival, deletion or updating of data.

## Types of Database:
Are catagorized into realtional Dabase and Non-Relational database
- Relational DB:
Is most cooomon type of database, it use a schema, a template, to dictate the data structure stored in the database. We can imagine a company that sell products to it customesr having some form of stored knowledge about
where those products go to, and in what quantity, This is often done in the back-end and whit-out information in the front-end.
Tables in a realtiona db are associated with keys that provides as quick db summary or access to specific row or columns when specific data needs to be reviwed.
Also called entities, are all related to each other. The customer information table can provide each customer with a specific ID that can indicate everything we need to know about the customers.
Also the product description table can assign a specific ID to each product.
When precessing an integrated DB, a concept is required to link one table to another using its key, called [relational db managment system].
We can have a user table in relational db containing columns like id, username, firt_name.
The id can be used as the table key, post may contain all users columns like id, user_id, date, content...
We can link the id form the user table to the user_id in the post table to retrieve the user details for each post witout storing all user details with each post, a table cn have more than one key, as anotehre column can be used
as a key to link with another table. The id column can be used as a key to a link the post table to another table containing comments, each os which belongs to a particular post.

[The realtioship between tables within a db is called schema].
MSQL.

- Non-Relational DB:
This db dont use tables, rows, and columns or prime keys, relationship, or schemas. NoSQL database stores data using varios storage models depending on the type of data stored.
Due to the lack of the define structure for the db, NoSQL db are very scalable and flexible. When dealing with datasets that are not vewwy wll defined and structure, a NoSQL dataase whoud be the best choice  for storing data.
    - Key-value
    - Docuemnt-Based
    - Wide-Column
    - Graph
Each of the abocve different way of storing data, The Key-value model usually stored data in JS or XML, and have key for each pair.
```js
{
  "100001": {
    "date": "01-01-2021",
    "content": "Welcome to this web application."
  },
  "100002": {
    "date": "02-01-2021",
    "content": "This is the first post on this web app."
  },
  "100003": {
    "date": "02-01-2021",
    "content": "Reminder: Tomorrow is the ..."
  }
}
```
The most common is MongoDB.
[Non-Relational db have dff method for injection, as NoSQL injection]a

