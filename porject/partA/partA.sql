--We created the tables

CREATE TABLE Movies_Metadata(
   adult varchar(10),
   belongs_to_collection varchar(190),
   budget int,
   genres varchar(270),
   homepage varchar(250),
   id int,
   imdb_id varchar(10),
   original_language varchar(10),
   original_title varchar(110),
   overview varchar(1000),
   popularity varchar(10),
   poster_path varchar(40),
   production_companies varchar(1260),
   production_countries varchar(1040),
   release_date date,
   revenue bigint,
   runtime varchar(10),
   spoken_languages varchar(770),
   status varchar(20),
   tagline varchar(300),
   title varchar(110),
   video varchar(10),
   vote_average varchar(10),
   vote_count int
);

CREATE TABLE Credits(
   cast1 text,
   crew text,
   id int
);

CREATE TABLE Keywords(
   id int,
   keywords text
);

CREATE TABLE Links(
   movieId int,
   imdbId int,
   tmdbId int
);

CREATE TABLE Ratings(
   userId int,
   movieId int,
   rating varchar(10),
   timestamp int
);

CREATE TABLE Ratings_Small(
   userId int,
   movieId int,
   rating varchar(10),
   timestamp int
);

--we change the type of the rating column in ratings and ratings_small tables from varchar to numeric

ALTER TABLE ratings
ALTER COLUMN rating TYPE numeric(10,2) USING rating::numeric;

ALTER TABLE ratings_small
ALTER COLUMN rating TYPE numeric(10,2) USING rating::numeric;

--we replaced the tt in imdb_id column in movies_metadata table with nothing

UPDATE movies_metadata SET imdb_id = REPLACE(imdb_id, 'tt', '');
ALTER TABLE movies_metadata ALTER COLUMN imdb_id TYPE INT USING imdb_id::int;

--we deleted the duplicate rows in links, movies_metadata, keywords & credits

DELETE FROM Links WHERE movieId IN (SELECT movieId from (SELECT movieId, ROW_NUMBER() over (PARTITION BY tmdbId ORDER BY movieId) AS row_num FROM Links) t WHERE t.row_num > 1);
DELETE FROM movies_metadata WHERE id IN (SELECT id FROM (SELECT id, ROW_NUMBER() over (PARTITION BY imdb_id ORDER BY id) AS row_num FROM movies_metadata) t WHERE t.row_num > 1);
DELETE FROM Keywords WHERE keywords IN (SELECT keywords FROM (SELECT keywords, ROW_NUMBER() over (PARTITION BY id ORDER BY keywords) AS row_num FROM Keywords) t WHERE t.row_num > 1);
DELETE FROM Credits where crew IN (SELECT crew FROM (SELECT crew, ROW_NUMBER() over (PARTITION BY id ORDER BY crew) as number_row from Credits) t where t.number_row > 1);

--we deleted the movies in links, ratings, credits and keywords that didnt exist in the table movies_metadata

DELETE FROM Links WHERE tmdbId IN (SELECT tmdbId FROM Links WHERE tmdbId NOT IN (SELECT id FROM Movies_Metadata));

DELETE FROM Links WHERE imdbId NOT IN (SELECT imdb_id FROM Movies_Metadata JOIN Links ON imdb_id = imdbId);

DELETE FROM Ratings WHERE movieId IN (SELECT movieId FROM Ratings WHERE movieId NOT IN (SELECT movieId FROM Links));

DELETE FROM keywords WHERE id IN (SELECT id FROM keywords WHERE id NOT IN (SELECT id FROM movies_metadata));

DELETE FROM credits WHERE id IN (SELECT id FROM credits WHERE id NOT IN (SELECT id FROM movies_metadata));



--we declared the primary and foreign keys of the tables

ALTER TABLE Movies_Metadata ADD PRIMARY KEY (id);
ALTER TABLE Keywords ADD PRIMARY KEY (id);
ALTER TABLE Links ADD PRIMARY KEY (movieId);
ALTER TABLE Credits ADD PRIMARY KEY (id);
ALTER TABLE Credits ADD FOREIGN KEY (id) REFERENCES Movies_Metadata (id);
ALTER TABLE Ratings ADD FOREIGN KEY (movieId) REFERENCES Links (movieId);
ALTER TABLE Keywords ADD FOREIGN KEY (id) REFERENCES Movies_Metadata (id);