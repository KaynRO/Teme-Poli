  create table if not exists tari(id serial,
          nume varchar(30) unique,
          latitudine float,
          longitudine float,
          primary key(id));
  create table if not exists orase(id serial,
            id_tara int,
            nume varchar(30),
            latitudine float, longitudine float,
            primary key(id),
            constraint cst foreign key(id_tara) references tari(id));
  create table if not exists temperaturi(id serial,
            valoare float,
            ttimestamp timestamp not null default CURRENT_TIMESTAMP,
            id_oras int,
            primary key(id),
            constraint ccst foreign key(id_oras) references orase(id));