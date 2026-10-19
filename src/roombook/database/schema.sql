
PRAGMA foreign_keys = ON;


DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS forms;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS room_types;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user_roles;

CREATE TABLE user_roles (
    user_role_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE room_types (
    room_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    patronymic TEXT,
    password_hash TEXT NOT NULL,
    user_role INTEGER NOT NULL,

    FOREIGN KEY (user_role)
        REFERENCES user_roles (user_role_id)
);

CREATE TABLE rooms (
    room_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    square REAL NOT NULL,
    room_type INTEGER NOT NULL,

    FOREIGN KEY (room_type)
        REFERENCES room_types (room_type_id),

    CHECK (square > 0)
);

CREATE TABLE forms (
    form_id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_type_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    datastart TEXT NOT NULL,
    dataend TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',

    FOREIGN KEY (room_type_id) REFERENCES room_types (room_type_id),

    FOREIGN KEY (user_id) REFERENCES users (user_id),

    CHECK (dataend > datastart),
    CHECK (status IN ('pending', 'accepted', 'rejected'))
);


CREATE TABLE reservations (
    reservation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    datastart TEXT NOT NULL,
    dataend TEXT NOT NULL,

    FOREIGN KEY (room_id) REFERENCES rooms (room_id),

    FOREIGN KEY (user_id) REFERENCES users (user_id),

    CHECK (dataend > datastart)
);

INSERT INTO user_roles (name, description)
VALUES
    ('Client', 'User who submits room booking applications'),
    ('Employee', 'Employee who manages booking applications');

INSERT INTO room_types (name, description)
VALUES
    ('Office', 'Office room for individual or small team work'),
    ('Conference room', 'Room for meetings and negotiations'),
    ('Event hall', 'Large room for presentations and events');

INSERT INTO users
    (name, surname, patronymic, password_hash, user_role)
VALUES
    ('Ivan', 'Petrov', 'Sergeevich', 'hash_ivan_123', 1),
    ('Anna', 'Smirnova', 'Ivanovna', 'hash_anna_456', 1),
    ('Pavel', 'Sidorov', NULL, 'hash_pavel_789', 1),
    ('Maria', 'Ivanova', 'Petrovna', 'hash_maria_321', 2);

INSERT INTO rooms (name, square, room_type)
VALUES
    ('Office 101', 18.5, 1),
    ('Office 102', 24.0, 1),
    ('Conference room A', 45.5, 2),
    ('Conference room B', 60.0, 2),
    ('Event hall 1', 120.0, 3);

INSERT INTO forms
    (room_type_id, user_id, datastart, dataend, status)
VALUES
    (2, 1, '2026-11-01 10:00', '2026-11-01 12:00', 'pending'),
    (1, 2, '2026-11-03 09:00', '2026-11-03 18:00', 'accepted'),
    (3, 3, '2026-11-05 14:00', '2026-11-05 17:00', 'rejected'),
    (2, 2, '2026-11-10 11:00', '2026-11-10 13:00', 'pending'),
    (1, 1, '2026-11-12 09:00', '2026-11-12 17:00', 'accepted');

INSERT INTO reservations
    (room_id, user_id, datastart, dataend)
VALUES
    (3, 2, '2026-11-03 09:00', '2026-11-03 18:00'),
    (1, 1, '2026-11-12 09:00', '2026-11-12 17:00');