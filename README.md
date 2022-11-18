# SQL-Movies-Database
In the first part of the project we created and altered the necessary tables for the Movies database. The second part has the visualisation of some queries with python.

Step 1: We created empty tables in the MOVIES database with the create table command at partA file
Step 2: We imported the data from the csv files to the correct tables via the Import command in pgadmin or using the command /copy via cmd.
Step 3: We altered the column rating type in the ratings tables and ratings_small from Varchar to numeric with the alter column commands, we did this so we will be
able to calculate avg etc. in the rating columns.
Step 4: We edited the movies_metadata table and we removed the 'tt' with the update command to match the imdbId column in the links table.
Step 5: We removed the duplicates from all tables except the ratings, ratings_small.
Step 6: We also removed the data from that didnt match with the movies_metadata table with the delete command at partA file.
Step 7: We added the primary and the foreign keys to each table (at least to the tables that have unique elements).
