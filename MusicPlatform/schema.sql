-- Represent users that opened an account
CREATE TABLE "users" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "followers" INTEGER DEFAULT 0,
    "following" INTEGER DEFAULT 0,
    "number_of_playlist" INTEGER DEFAULT 0,
    PRIMARY KEY("id")
);

-- Represent artists that opened an account
CREATE TABLE "artists" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "followers" INTEGER DEFAULT 0,
    PRIMARY KEY("id")
);

-- Represent albums that released by an artist
CREATE TABLE "albums" (
    "id" INTEGER,
    "artist_id" INTEGER,
    "title" TEXT NOT NULL,
    "year" INTEGER,
    "number_of_songs" INTEGER,
    "duration" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE
);

-- Represent playlists that created by a user
CREATE TABLE "playlists" (
    "id" INTEGER,
    "user_id" INTEGER,
    "title" TEXT NOT NULL,
    "number_of_saves" INTEGER DEFAULT 0,
    "duration" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

-- Represent songs that belongs to an album
CREATE TABLE "songs" (
    "id" INTEGER,
    "album_id" INTEGER,
    "title" TEXT NOT NULL,
    "year" INTEGER,
    "duration" NUMERIC,
    "type" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("album_id") REFERENCES "albums"("id") ON DELETE CASCADE
);

-- Represent songs that liked by the user
CREATE TABLE "liked_songs" (
    "user_id" INTEGER,
    "song_id" INTEGER,
    PRIMARY KEY("user_id", "song_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
    FOREIGN KEY("song_id") REFERENCES "songs"("id") ON DELETE CASCADE
);

-- Represent songs that a playlist have
CREATE TABLE "playlist_songs" (
    "playlist_id" INTEGER,
    "song_id" INTEGER,
    PRIMARY KEY("playlist_id", "song_id"),
    FOREIGN KEY("playlist_id") REFERENCES "playlists"("id") ON DELETE CASCADE,
    FOREIGN KEY("song_id") REFERENCES "songs"("id") ON DELETE CASCADE
);

-- Represent a user following an artist
CREATE TABLE "user_follows_artist" (
    "user_id" INTEGER,
    "artist_id" INTEGER,
    PRIMARY KEY("user_id", "artist_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
    FOREIGN KEY("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE
);

-- Represent a user following a user
CREATE TABLE "user_follows_user" (
    "user1_id" INTEGER,
    "user2_id" INTEGER,
    PRIMARY KEY("user1_id", "user2_id"),
    FOREIGN KEY("user1_id") REFERENCES "users"("id") ON DELETE CASCADE,
    FOREIGN KEY("user2_id") REFERENCES "users"("id") ON DELETE CASCADE
);

-- Represent an album that saved by a user
CREATE TABLE "saved_album" (
    "user_id" INTEGER,
    "album_id" INTEGER,
    PRIMARY KEY("user_id", "album_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
    FOREIGN KEY("album_id") REFERENCES "albums"("id") ON DELETE CASCADE
);

-- Represent a playlist that saved by a user
CREATE TABLE "saved_playlist" (
    "user_id" INTEGER,
    "playlist_id" INTEGER,
    PRIMARY KEY("user_id", "playlist_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
    FOREIGN KEY("playlist_id") REFERENCES "playlists"("id") ON DELETE CASCADE
);

-- VIEWS

-- Represent a view on albums & artists ordered by year of album's release
CREATE VIEW "artist_albums" AS
SELECT "artists"."name" AS "artist name", "albums"."title" AS "album title", "albums"."year" AS "release_year" FROM "artists"
JOIN "albums" ON "albums"."artist_id" = "artists"."id"
ORDER BY "albums"."year";

-- Represent a view on albums and songs it covers, ordered alphabetically
CREATE VIEW "album_songs" AS
SELECT "albums"."title" AS "album title", "songs"."title" AS "song title", "albums"."duration" FROM "albums"
JOIN "songs" ON "albums"."id" = "songs"."album_id"
ORDER BY "album title";

-- Represent a view on albums saved by a user, ordered alphabetically
CREATE VIEW "user_saved_albums" AS
SELECT "username", "albums"."title" AS "album title", "artists"."name" AS "artist" FROM "users"
JOIN "saved_album" ON "users"."id" = "saved_album"."user_id"
JOIN "albums" ON "saved_album"."album_id" = "albums"."id"
JOIN "artists" ON "artists"."id" = "albums"."artist_id"
ORDER BY "album title";

-- Represent a view on playlists saved by a user, ordered alphabetically
CREATE VIEW "user_saved_playlists" AS
SELECT "username", "playlists"."title" AS "saved playlist title" FROM "users"
JOIN "saved_playlist" ON "users"."id" = "saved_playlist"."user_id"
JOIN "playlists" ON "saved_playlist"."playlist_id" = "playlists"."id"
ORDER BY "saved playlist title";

-- Represent a view on playlists created by a user, ordered by number of saves
CREATE VIEW "user_created_playlists" AS
SELECT "username", "playlists"."title" AS "created playlist title", "number_of_saves", "duration" FROM "users"
JOIN "playlists" ON "users"."id" = "playlists"."user_id"
ORDER BY "number_of_saves" DESC;

-- Represent a view on songs that a playlist includes
CREATE VIEW "playlist_songs_view" AS
SELECT "playlists"."title" AS "playlist title", "songs"."title" FROM "playlists"
JOIN "playlist_songs" ON "playlists"."id" = "playlist_songs"."playlist_id"
JOIN "songs" ON "songs"."id" = "playlist_songs"."song_id";

-- INDEXES for common searches
CREATE INDEX "idx_users_username" ON "users"("username");
CREATE INDEX "idx_artists_name" ON "artists"("name");
CREATE INDEX "idx_albums_artist_id" ON "albums"("artist_id");
CREATE INDEX "idx_albums_year" ON "albums"("year");
CREATE INDEX "idx_playlists_user_id" ON "playlists"("user_id");
CREATE INDEX "idx_songs_album_id" ON "songs"("album_id");
CREATE INDEX "user_follows_user_us1_id" ON "user_follows_user"("user1_id");
CREATE INDEX "user_follows_user_us2_id" ON "user_follows_user"("user2_id");

CREATE INDEX "idx_users_high_followers" ON "users"("followers")
WHERE "followers" > 1000;
CREATE INDEX "idx_artists_high_followers" ON "artists"("followers")
WHERE "followers" > 10000;

CREATE INDEX "idx_albums_old" ON "albums"("year")
WHERE "year" <= 1980;

CREATE INDEX "idx_playlists_high_saves" ON "playlists"("number_of_saves")
WHERE "number_of_saves" > 100;

CREATE INDEX "idx_songs_type_rock" ON "songs"("type")
WHERE "type" = 'Rock';

-- TRIGGERS

-- Update playlist duration when a song added
CREATE TRIGGER "update_playlist_duration_add"
AFTER INSERT ON "playlist_songs"
FOR EACH ROW
BEGIN
    UPDATE "playlists"
    SET "duration" = "duration" + (SELECT "duration" FROM "songs" WHERE "id" = NEW."song_id")
    WHERE "id" = NEW."playlist_id";
END;

-- Update playlist duration when a song removed
CREATE TRIGGER "update_playlist_duration_remove"
AFTER DELETE ON "playlist_songs"
FOR EACH ROW
BEGIN
    UPDATE "playlists"
    SET "duration" = "duration" - (SELECT "duration" FROM "songs" WHERE "id" = OLD."song_id")
    WHERE "id" = OLD."playlist_id";
END;

-- Increment number of playlists when a user created one
CREATE TRIGGER "increment_user_playlist_count"
AFTER INSERT ON "playlists"
FOR EACH ROW
BEGIN
    UPDATE "users"
    SET "number_of_playlist" = "number_of_playlist" + 1
    WHERE "id" = NEW."user_id";
END;

-- Decrement number of playlists when a user deleted one
CREATE TRIGGER "decrement_user_playlist_count"
AFTER DELETE ON "playlists"
FOR EACH ROW
BEGIN
    UPDATE "users"
    SET "number_of_playlist" = "number_of_playlist" - 1
    WHERE "id" = OLD."user_id";
END;

-- Increment number of saves of a playlist when user saves it
CREATE TRIGGER "increment_playlist_save_count"
AFTER INSERT ON "saved_playlist"
FOR EACH ROW
BEGIN
    UPDATE "playlists"
    SET "number_of_saves" = "number_of_saves" + 1
    WHERE "id" = NEW."playlist_id";
END;

-- Decrement number of saves of a playlist when user deletes it
CREATE TRIGGER "decrement_playlist_save_count"
AFTER DELETE ON "saved_playlist"
FOR EACH ROW
BEGIN
    UPDATE "playlists"
    SET "number_of_saves" = "number_of_saves" - 1
    WHERE "id" = OLD."playlist_id";
END;

-- Increment number of followers
CREATE TRIGGER "increment_user_followers"
AFTER INSERT ON "user_follows_user"
FOR EACH ROW
BEGIN
    UPDATE "users"
    SET "followers" = "followers" + 1
    WHERE "id" = NEW."user2_id";
END;

-- Decrement number of followers
CREATE TRIGGER "decrement_user_followers"
AFTER DELETE ON "user_follows_user"
FOR EACH ROW
BEGIN
    UPDATE "users"
    SET "followers" = "followers" - 1
    WHERE "id" = OLD."user2_id";
END;


