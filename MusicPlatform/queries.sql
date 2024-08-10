-- Find all playlists created by a user by giving user's username
SELECT * FROM "playlists"
WHERE "user_id" IN (
    SELECT "id" FROM "users"
    WHERE "username" = 'yavuzskocyigit'
)
ORDER BY "number_of_saves" DESC;

-- Find number of followers and followings for a given account
SELECT "followers", "following" FROM "users"
WHERE "id" =     (
    SELECT "id" FROM "users"
    WHERE "username" = 'yavuzskocyigit'
);

-- Find all the albums by an artist, order them alpabetically
SELECT * FROM "albums"
WHERE "artist_id" IN (
    SELECT "id" FROM "artists"
    WHERE "name" = 'Metallica'
)
ORDER BY "title";

-- Find the oldest albums, order them by their year
SELECT "title", "year" FROM "albums"
WHERE "year" <= 1980
ORDER BY "year" ASC;

-- Find the most saved playlist and show the title and the username who created it
SELECT "username", "title", "number_of_saves" FROM "playlists"
JOIN "users" ON "playlists"."user_id" = "users"."id"
ORDER BY "number_of_saves" DESC;

-- Find top 5 users that has the most saves for their playlists
SELECT "username", SUM("number_of_saves") AS "total saves from all playlists" FROM "playlists"
JOIN "users" ON "playlists"."user_id" = "users"."id"
GROUP BY "username"
ORDER BY "total saves from all playlists" DESC
LIMIT 5;

-- Find songs in a given album
SELECT "songs"."title", "songs"."duration" FROM "songs"
JOIN "albums" ON "songs"."album_id" = "albums"."id"
WHERE "albums"."title" = 'Californication';

-- Find songs in a given playlist
SELECT "songs"."title", "songs"."duration" FROM "songs"
JOIN "playlist_songs" ON "playlist_songs"."song_id" = "songs"."id"
JOIN "playlists" ON "playlists"."id" = "playlist_songs"."playlist_id"
WHERE "playlists"."title" = '90s Hits';

-- Find 10 rock songs.
SELECT "title" FROM "songs"
WHERE "type" = 'Rock'
ORDER BY "title"
LIMIT 10;

-- Find liked songs by a given user
SELECT "songs"."title" FROM "liked_songs"
JOIN "songs" ON "songs"."id" =  "liked_songs"."song_id"
JOIN "users" ON "users"."id" = "liked_songs"."user_id"
WHERE "username" = 'yavuzskocyigit';

-- Find all accounts(artists & users) that a given user follows
SELECT "artists"."name" FROM "artists"
JOIN "user_follows_artist" ON "artists"."id" = "user_follows_artist"."artist_id"
JOIN "users" ON "users"."id" = "user_follows_artist"."user_id"
WHERE "username" = 'yavuzskocyigit'

UNION

SELECT "users_followed"."username" FROM "users"
JOIN "user_follows_user" ON "users"."id" = "user_follows_user"."user1_id"
JOIN "users" AS "users_followed" ON "user_follows_user"."user2_id" = "users_followed"."id"
WHERE "users"."username" = 'yavuzskocyigit';

-- Find albums that are saved by a user, ordered alphabetically
SELECT "albums"."title" FROM "albums"
JOIN "saved_album" ON "albums"."id" = "saved_album"."album_id"
JOIN "users" ON "users"."id" = "saved_album"."user_id"
WHERE "users"."username" = 'rhaenyratargaryen'
ORDER BY "albums"."title";

-- Find playlists that are saved by a user, ordered alphabetically
SELECT "playlists"."title" FROM "users"
JOIN "saved_playlist" ON "saved_playlist"."user_id" = "users"."id"
JOIN "playlists" ON "playlists"."id" = "saved_playlist"."playlist_id"
WHERE "users"."username" = 'yavuzskocyigit'
ORDER BY "playlists"."title";

-- Dummy data

-- Add users
INSERT INTO "users" ("username", "password", "followers", "following", "number_of_playlist")
VALUES
('yavuzskocyigit', 'password1', 100, 50, 5),
('rhaenyratargaryen', 'password2', 200, 80, 10),
('robertbaratheon', 'password3', 150, 100, 8),
('arya', 'password4', 120, 60, 6),
('jon', 'password5', 180, 90, 7),
('daenerys', 'password6', 300, 200, 12),
('tyrion', 'password7', 250, 150, 9),
('cersei', 'password8', 50, 30, 3),
('jaime', 'password9', 80, 40, 4),
('sansa', 'password10', 170, 85, 7),
('theon', 'password11', 110, 55, 5),
('bran', 'password12', 90, 45, 4);

-- Add artists
INSERT INTO "artists" ("name", "followers")
VALUES
('Metallica', 5000000),
('Nirvana', 4000000),
('The Beatles', 6000000),
('Queen', 7000000),
('Pink Floyd', 8000000),
('Led Zeppelin', 4500000),
('AC/DC', 4700000),
('The Rolling Stones', 6100000),
('Guns N Roses', 5200000),
('Red Hot Chili Peppers', 5500000),
('Linkin Park', 4600000),
('Green Day', 4200000);

-- Add albums
INSERT INTO "albums" ("artist_id", "title", "year", "number_of_songs", "duration")
VALUES
(1, 'Master of Puppets', 1986, 8, 54.5),
(2, 'Nevermind', 1991, 12, 49.0),
(3, 'Abbey Road', 1969, 17, 47.0),
(4, 'A Night at the Opera', 1975, 12, 43.0),
(5, 'The Dark Side of the Moon', 1973, 10, 42.5),
(6, 'Led Zeppelin IV', 1971, 8, 42.0),
(7, 'Back in Black', 1980, 10, 41.5),
(8, 'Sticky Fingers', 1971, 10, 46.0),
(9, 'Appetite for Destruction', 1987, 12, 53.0),
(10, 'Californication', 1999, 15, 56.0),
(1, 'Metallica', 1991, 12, 62.0),
(2, 'In Utero', 1993, 12, 41.0);

-- Add playlists
INSERT INTO "playlists" ("user_id", "title", "number_of_saves", "duration")
VALUES
(1, 'Rock Classics', 100, 120.0),
(1, 'Metal Favorites', 75, 110.0),
(1, 'Grunge Hits', 50, 90.0),
(1, 'Top Tracks', 30, 85.0),
(1, 'Favorite Songs', 20, 70.0),
(2, '90s Hits', 200, 130.0),
(3, 'Best of 80s', 150, 140.0),
(4, 'Workout Mix', 80, 60.0),
(5, 'Chill Vibes', 120, 110.0),
(6, 'Road Trip', 90, 105.0),
(7, 'Party Time', 300, 150.0),
(8, 'Relaxation', 60, 70.0),
(9, 'Study Playlist', 110, 100.0),
(10, 'Morning Motivation', 130, 95.0),
(11, 'Evening Relaxation', 70, 80.0),
(12, 'Driving Songs', 95, 120.0);

-- Add songs
INSERT INTO "songs" ("album_id", "title", "year", "duration", "type")
VALUES
(1, 'Battery', 1986, 5.12, 'Rock'),
(1, 'Master of Puppets', 1986, 8.35, 'Rock'),
(2, 'Smells Like Teen Spirit', 1991, 5.01, 'Grunge'),
(3, 'Come Together', 1969, 4.20, 'Rock'),
(4, 'Bohemian Rhapsody', 1975, 5.55, 'Rock'),
(5, 'Money', 1973, 6.22, 'Rock'),
(6, 'Stairway to Heaven', 1971, 8.02, 'Rock'),
(7, 'Back in Black', 1980, 4.15, 'Rock'),
(8, 'Wild Horses', 1971, 5.42, 'Rock'),
(9, 'Sweet Child O Mine', 1987, 5.56, 'Rock'),
(10, 'Californication', 1999, 5.21, 'Rock'),
(11, 'Enter Sandman', 1991, 5.32, 'Metal'),
(12, 'Heart-Shaped Box', 1993, 4.41, 'Grunge'),
(3, 'Hey Jude', 1968, 7.11, 'Pop'),
(4, 'We Will Rock You', 1977, 2.02, 'Rock'),
(5, 'Wish You Were Here', 1975, 5.35, 'Rock'),
(6, 'Black Dog', 1971, 4.55, 'Rock'),
(7, 'Hells Bells', 1980, 5.12, 'Rock');

-- Add liked songs
INSERT INTO "liked_songs" ("user_id", "song_id")
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(3, 15),
(4, 16),
(4, 17),
(4, 1),
(4, 2),
(4, 3),
(5, 4),
(5, 5),
(5, 6),
(5, 7),
(5, 8);

-- Add songs to playlists
INSERT INTO "playlist_songs" ("playlist_id", "song_id")
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(3, 15),
(4, 16),
(4, 17),
(4, 1),
(4, 2),
(4, 3),
(5, 4),
(5, 5),
(5, 6),
(5, 7),
(5, 8),
(6, 9),
(6, 10),
(6, 11),
(6, 12),
(6, 13),
(7, 14),
(7, 15),
(7, 16),
(7, 17),
(7, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(9, 7),
(9, 8),
(9, 9),
(9, 10),
(9, 11),
(10, 12),
(10, 13),
(10, 14),
(10, 15),
(10, 16);

-- Add user follows artist
INSERT INTO "user_follows_artist" ("user_id", "artist_id")
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 11),
(3, 12),
(3, 1),
(3, 2),
(3, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 1);

-- Add user follows user
INSERT INTO "user_follows_user" ("user1_id", "user2_id")
VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 11),
(11, 12),
(12, 1),
(1, 3),
(2, 4),
(3, 5),
(4, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10),
(9, 11),
(10, 12),
(11, 1),
(12, 2);

-- Add saved albums
INSERT INTO "saved_album" ("user_id", "album_id")
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 11),
(3, 12),
(3, 1),
(3, 2),
(3, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 1);

-- Add saved playlists
INSERT INTO "saved_playlist" ("user_id", "playlist_id")
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(3, 11),
(3, 12),
(3, 1),
(3, 2),
(3, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 1);

-- UPDATE & INSERT & DELETE

-- Update the number of saves for a playlist
UPDATE "playlists"
SET "number_of_saves" = "number_of_saves" + 50
WHERE "title" = '90s Hits';

-- Update the number of saves for a playlist by adding a user save
INSERT INTO "saved_playlist" ("user_id", "playlist_id")
VALUES (1, 7); -- yavuzskocyigit saves 'Best of 80s' playlist

-- Update the saved albums for a user by adding a saved album
INSERT INTO "saved_album" ("user_id", "album_id")
VALUES (2, 1); -- rhaenyratargaryen saves 'Master of Puppets' album

--  Insert a song into a playlist
INSERT INTO "playlist_songs" ("playlist_id", "song_id")
VALUES (6, 7);
--  Delete a song from a playlist
DELETE FROM "playlist_songs"
WHERE "playlist_id" = 6 AND "song_id" = 7;

-- User follows user
INSERT INTO "user_follows_user" ("user1_id", "user2_id")
VALUES (1, 5);
-- User unfollows user
DELETE FROM "user_follows_user"
WHERE "user1_id" = 1 AND "user2_id" = 5;

-- Delete a user
DELETE FROM "users"
WHERE "username" = 'arya';

-- Delete an artist
DELETE FROM "artists"
WHERE "name" = 'Nirvana';

-- Delete a playlist
DELETE FROM "playlists"
WHERE "title" = 'Chill Vibes';

-- Delete a saved playlist for a user
DELETE FROM "saved_playlist"
WHERE "user_id" = 1 AND "playlist_id" = 2;

-- Delete a saved album for a user
DELETE FROM "saved_album"
WHERE "user_id" = 2 AND "album_id" = 7;

-- Delete a song from a playlist
DELETE FROM "playlist_songs"
WHERE "playlist_id" = 1 AND "song_id" = 2;

-- Delete a liked song
DELETE FROM "liked_songs"
WHERE "user_id" = 1 AND "song_id" = 1;
