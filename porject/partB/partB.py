import matplotlib.pyplot as plt
import psycopg2
import math

# Update connection string information
host = "databaselesson.postgres.database.azure.com"
dbname = "MOVIES"
user = "p3180195@databaselesson"
password = "Xf3180195"
sslmode = "require"

# Construct connection string
conn_string = "host={0} user={1} dbname={2} password={3} sslmode={4}".format(host, user, dbname, password, sslmode)
conn = psycopg2.connect(conn_string)
print("Connection established")

#Average rating per genre

cursor = conn.cursor()
cursor.execute("SELECT genres AS GENRE, AVG(rating) AS AVERAGE_RATING FROM Movies_Metadata INNER JOIN Ratings ON Movies_Metadata.id = Ratings.movieid GROUP BY GENRE ORDER BY GENRE")
rows = cursor.fetchall()

zip(*rows)
plt.scatter(*zip(*rows))
plt.title('Average rating per genre')
plt.xlabel('gerne')
plt.ylabel('rating')
plt.show()

#Average Rating per User

cursor = conn.cursor()
cursor.execute("SELECT userid AS USER, AVG(rating) AS AVERAGE_RATING FROM Ratings GROUP BY userid ORDER BY AVERAGE_RATING DESC")
rows = cursor.fetchall()

zip(*rows)
plt.scatter(*zip(*rows))
plt.title('Average Rating per User')
plt.xlabel('user')
plt.ylabel('rating')
plt.show()

#Movies per Year
cursor = conn.cursor()
cursor.execute("select extract(year from release_date) as year, count(*) as movies_per_year from movies_metadata group by year order by year;")
rows = cursor.fetchall()

zip(*rows)
plt.plot(*zip(*rows))
plt.title('Movies per Year')
plt.xlabel('Year')
plt.ylabel('Movies')
plt.show()

#Number of movies per gerne
cursor = conn.cursor()
cursor.execute("SELECT substring(T.genre,9), count(T.movieID) AS number_Of_Movies FROM (SELECT regexp_split_to_table(genres, ',') AS genre, id AS movieID  from movies_metadata) AS T WHERE T.genre NOT LIKE '%id%'  GROUP BY substring(T.genre,9);")
rows = cursor.fetchall()

zip(*rows)

plt.scatter(*zip(*rows))
plt.title('Number of movies per gerne')
plt.xlabel('gerne')
plt.ylabel('movies')
plt.show()

#Ratings per user
cursor = conn.cursor()
cursor.execute("SELECT userid AS USER, COUNT(rating) AS TOTAL_RATINGS FROM Ratings GROUP BY userid ORDER BY TOTAL_RATINGS DESC")
rows = cursor.fetchall()

zip(*rows)
plt.scatter(*zip(*rows))
plt.title('Ratings per user')
plt.xlabel('User')
plt.ylabel('Rating')
plt.show()

#Average rating and Numbers of ratings per user//VIEW TABLE
cursor = conn.cursor()
cursor.execute("SELECT userid AS USER, count(rating) AS NUMBER_OF_RATINGS, AVG(rating) AS AVERAGE_RATING FROM ratings GROUP BY userid ORDER BY NUMBER_OF_RATINGS DESC")
rows = cursor.fetchall()
zip(*rows)

plt.plot(*zip(*rows))
plt.title('Average rating and Numbers of ratings per user')
plt.xlabel('Number of ratings')
plt.ylabel('Average rating')
plt.show()


# Clean up
conn.commit()
cursor.close()
conn.close()
