# **Competitive Shooter Database**

This is a MySQL Database project simulating the database of a user profile system in a competitive shooter.

## Purpose

The purpose of this database is to store information related to user accounts and track information related to user information, including player reports, store transactions, and statistics related to gameplay.

## Technologies Used
MySQL, OpenOffice Calc, Mockaroo

## How To Run SQL Scripts

## Design Summary

When designing my database, I focused on the most important data table first, in this case AccountInfo, and built out the connections between other tables from there. Wallet, LoginHistory, and GameplayStats are each designed with a 1-to-1 relationship with AccountInfo, since there does not need to be multiple records kept for each of those instances. MicrotransactionRecord has a 1-to-many relationship with AccountInfo because the database needs to store multiple purchases being done by the same player. UserReport has a 1-to-many relationship with AccountInfo because the same player can make multiple reports against other players. 

I found it challenging to get 1-to-1 relationships to display correctly in MySQL. I couldn't find any guidance online on how to set up the relationship correctly; MySQL seems to display a 1-to-many relationship, even though the PK of different tables is a foreign key of AccountInfo with a unique constraint.

## EER Diagram
![EER Diagram of Competitive Shooter Database](./eer/EER_Diagram.png "EER Diagram")
