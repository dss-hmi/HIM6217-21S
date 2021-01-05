CREATE TABLE company (
    company_id              INTEGER      PRIMARY KEY AUTOINCREMENT,
    name                    VARCHAR (30) NOT NULL,
    description             VARCHAR (60) NOT NULL,
    primary_contact_id      INTEGER NOT NULL
);

CREATE TABLE room (
    room_id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    floor_number             INTEGER NOT NULL,
    seat_capacity            INTEGER NOT NULL    
);

CREATE TABLE presentation (
    presentation_id         INTEGER      PRIMARY KEY AUTOINCREMENT,
    booked_company_id       INTEGER NOT NULL,
    booked_room_id          INTEGER NOT NULL,
    start_time              TIME,
    end_time                TIME
);

CREATE TABLE attendee (
    attendee_id              INTEGER      PRIMARY KEY AUTOINCREMENT,
    first_name               VARCHAR (30) NOT NULL,
    last_name                VARCHAR (30) NOT NULL,
    phone                    INTEGER,
    email                    VARCHAR (30),
    vip                      BOOLEAN DEFAULT (0)
);


CREATE TABLE presentation_attendance (
    ticket_id                INTEGER      PRIMARY KEY AUTOINCREMENT,
    presentation_id          INTEGER,
    attendee_id              INTEGER
);

