# Design Document

## Scope

The database basically works as a music platform. It mainly helps users to find and organize their favourite musics.
Database's scope is:

* Users with identifying account informations, and number of playlist created.
* Artist with basic account informations.
* Songs which are from albums and can be added to playlists, and also can be liked by users. They presented with duration, release year, type and title.
* Albums with basic informations like creator, title, release year, number of songs, and duration.
* Playlists with identifying informations like creator,title and also number of saves to showcase its popularity and its duration.

Out of scope are elements like timestamps of actions, suggested albums/playlists, songs that are not a part of albums(for ex. singles), precise durations.

## Functional Requirements

This database allows users to:

* Create/save a playlist, add or remove a song to track its duration when a song added/removed and check number of saves to observe its popularity.
* Like a song rather than saving it as an album or playlist.
* Follow a user or an artist
* Save an album

System will not allow users to save an individual song or not act artists as users (they are not able to follow users), and users also not able to release an album.

## Representation

### Entities

The database includes the following entities:

#### Users

The `users` table includes:

* `id`, which specifies the unique ID for the user as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `username`, which specifies the user's username as `TEXT`, given `TEXT` is appropriate for username fields. `NOT NULL` and `UNIQUE` constraints applied cause `username` must be filled and it must be different from everyone else.
* `password`, which specifies the user's password. `TEXT` is used for the same reason as `username`. `NOT NULL` constraint applied cause it must be filled.
* `followers`, which specifies the user's number of followers. `INTEGER` is appropriate for fields with numbers. A default values is given as 0 in the very beggining, as denoted by `DEFAULT 0`.
* `following`, which specifies the user's number of followed accounts . `INTEGER` is appropriate for fields with numbers. A default values is given as 0 in the very beggining, as denoted by `DEFAULT 0`.
* `number_of_playlist`, which specifies the user's number of playlists he/she created. `INTEGER` is appropriate for fields with numbers. A default values is given as 0 in the very beggining, as denoted by `DEFAULT 0`.

#### Artists

The `artists` table includes:

* `id`, which specifies the unique ID for the artist as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the artist's username as `TEXT`, given `TEXT` is appropriate for name fields. `NOT NULL` constraint applied cause `name` must be filled.
* `followers`, which specifies the artist's number of followers. `INTEGER` is appropriate for fields with numbers. A default values is given as 0 in the very beggining, as denoted by `DEFAULT 0`.

#### Albums

The `albums` table includes:

* `id`, which specifies the unique ID for the album as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `artist_id`, which is the ID of the artist who released the album as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `artists` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `title`, which specifies the album's title as `TEXT`, given `TEXT` is appropriate for title fields. `NOT NULL` constraint applied cause `title` must be exist.
* `year`, which specifies the album's release year. `INTEGER` is appropriate for fields with numbers.
* `number_of_songs`, which specifies the albums's number of songs it consists of. `INTEGER` is appropriate for fields with numbers.
* `duration`, which specifies the album's duration. `NUMERIC` is appropriate for fields with numbers like reals, etc.

#### Playlists

The `playlists` table includes:

* `id`, which specifies the unique ID for the playlist as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `user_id`, which is the ID of the user who created the playlist as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `title`, which specifies the playlist's title as `TEXT`, given `TEXT` is appropriate for title fields. `NOT NULL` constraint applied cause `title` must be exist.
* `number_of_saves`, which specifies the playlist's number of saves among users to address popularity. `INTEGER` is appropriate for fields with numbers. A default values is given as 0 in the very beggining, as denoted by `DEFAULT 0`.
* `duration`, which specifies the playlist's duration. `NUMERIC` is appropriate for fields with numbers like reals, etc.

#### Songs

The `songs` table includes:

* `id`, which specifies the unique ID for the song as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `album_id`, which is the ID of the album which includes the song as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `albums` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `title`, which specifies the playlist's title as `TEXT`, given `TEXT` is appropriate for title fields. `NOT NULL` constraint applied cause `title` must be exist.
* `year`, which specifies the songs's release year. `INTEGER` is appropriate for fields with numbers.
* `duration`, which specifies the song's duration. `NUMERIC` is appropriate for fields with numbers like reals, etc.
* `type`, which specifies the song's types. `TEXT`, given `TEXT` is appropriate for title fields.

#### Liked Songs

The `liked_songs` table includes:

* `user_id`, which is the ID of the user who liked the song as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `song_id`, which is the ID of the song as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `songs` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `user_id`,`song_id`pair used as a `PRIMARY KEY` to ensure consistency and uniqueness.

#### Playlist Songs

The `playlist_songs` table includes:

* `playlist_id`, which is the ID of the playlist as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `playlists` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `song_id`, which is the ID of the song in the corresponding playlist as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `songs` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `playlist_id`,`song_id`pair used as a `PRIMARY KEY` to ensure consistency and uniqueness.

#### User follows Artist

The `user_follows_artist` table includes:

* `user_id`, which is the ID of the user that follows the artist as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `artist_id`, which is the ID of the artist that being followed as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `artists` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `user_id`,`artist_id`pair used as a `PRIMARY KEY` to ensure consistency and uniqueness.

#### User follows User

The `user_follows_user` table includes:

* `user1_id`, which is the ID of the user that follows the artist as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `user2_id`, which is the ID of the user that being followed as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `songs` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `user1_id`,`user2_id`pair used as a `PRIMARY KEY` to ensure consistency and uniqueness.

#### Saved Album

The `saved_album` table includes:

* `user_id`, which is the ID of the user that saved the album as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `album_id`, which is the ID of the album that being saved as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `albums` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `user_id`,`album_id`pair used as a `PRIMARY KEY` to ensure consistency and uniqueness.

#### Saved Playlist

The `saved_playlist` table includes:

* `user_id`, which is the ID of the user that saved the playlist as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `users` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `playlist_id`, which is the ID of the playlist that being saved as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `playlists` table to ensure data integrity. `ON DELETE CASCADE` is used to manipulate deleting actions safely.
* `user_id`,`playlist_id`pair used as a `PRIMARY KEY` to ensure consistency and uniqueness.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](diagram.png)

As detailed by the diagram:

* A User can follow 0 to many users, a user also can be followed by 0 to many users.
* A User can follow 0 to many artists, an artist also can be followed by 0 to many users.
* A User is able to like a 0 to many songs, a song also can be liked by 0 to many user.
* A User is able to create 0 to many playlists, a playlist can be created one and only one user. Individual submissions accepted.
* A User can save 0 to many playlists, a playlist can be saved by 0 to many users.
* A User is able to save 0 to many albums, an album can be saved by 0 to many users.
* A Playlist contains 0 to many songs, a song can be included in 0 to many playlists. Considered the initialization step of creating a playlist.
* An Album contains 0 to many songs, a song can be included in one and only one album.
* An Artist releases 0 to many albums, an album can be released by one and only one artist. Does not include albums released by multiple artists.

## Optimizations

It is common practice for a user of the database to concerned with viewing all the albums that an artist released. Therefore the view called `artist_albums` is created to address this need.
It is also common practice for a user of the database to concerned with viewing all the songs in a given album. Therefore the view called `album_songs` is created to address this need.
Also, a user of the database to concerned with viewing all the albums and playlists he/she saved. Therefore views called `user_saved_albums`and `user_saved_playlists` are created to address this need.
It is also common for a user to check the playlists he/she creates to listen his/her favourite musics for spesific moods. The view called `user_created_playlists` is created to address this need. And when a user opens that playlist it is also common to look up the songs inside of that playlist. The view called `playlist_songs_view` is created to address this need.

In addition to these needs to speed up those processes lots of indexes are created.`idx_users_username` for username searchs, `idx_artists_name` for artist searchs, `idx_albums_artist_id` for albums an artist released, `idx_albums_year` for checking recent/old albums,`idx_playlists_user_id` for playlist that a user created, `idx_songs_album_id` for checking songs in an album, `user_follows_user_us1_id`and `user_follows_user_us2_id` for chechking who follows who, `idx_users_high_followers` for finding popular accounts, `idx_artists_high_followers` for finding popular artists, `idx_albums_old` for looking up old classics, `idx_playlists_high_saves` for the most listened playlists and `idx_songs_type_rock` for searching rock musics.

## Limitations

The design assumes each album or song belongs to only one artist, which doesn’t support collaborations. Users can’t comment or rate songs, and there’s no genre categorization for playlists. Follower and following counts are manually updated, which could lead to inconsistencies. There’s no tracking of changes over time, meaning historical data isn’t stored.
