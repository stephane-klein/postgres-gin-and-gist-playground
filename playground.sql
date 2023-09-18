DROP TABLE IF EXISTS public.users CASCADE;
CREATE TABLE public.users (
    id           SERIAL PRIMARY KEY,
    username     VARCHAR NOT NULL,
    space_ids    INTEGER[] DEFAULT NULL
);

INSERT INTO public.users
    (
        username,
        space_ids
    )
    VALUES
        (
            'user1',
            ARRAY[1, 2]
        ),
        (
            'user2',
            ARRAY[1, 2, 3]
        ),
        (
            'user3',
            ARRAY[2, 3]
        ),
        (
            'user4',
            ARRAY[2]
        ),
        (
            'user5',
            ARRAY[1, 3]
        );

-- With index

DROP TABLE IF EXISTS public.users_gin CASCADE;
CREATE TABLE public.users_gin (
    id           SERIAL PRIMARY KEY,
    username     VARCHAR NOT NULL,
    space_ids    INTEGER[] DEFAULT NULL
);
CREATE INDEX space_ids_gin_index ON public.users_gin USING GIN (space_ids);

INSERT INTO public.users_gin
    (
        username,
        space_ids
    )
    VALUES
        (
            'user1',
            ARRAY[1, 2]
        ),
        (
            'user2',
            ARRAY[1, 2, 3]
        ),
        (
            'user3',
            ARRAY[2, 3]
        ),
        (
            'user4',
            ARRAY[2]
        ),
        (
            'user5',
            ARRAY[1, 3]
        );

CREATE EXTENSION IF NOT EXISTS intarray;

DROP TABLE IF EXISTS public.users_gist CASCADE;
CREATE TABLE public.users_gist (
    id           SERIAL PRIMARY KEY,
    username     VARCHAR NOT NULL,
    space_ids    INTEGER[] DEFAULT NULL
);
CREATE INDEX space_ids_gist_index ON public.users_gist USING GIST (space_ids gist__int_ops);

INSERT INTO public.users_gist
    (
        username,
        space_ids
    )
    VALUES
        (
            'user1',
            ARRAY[1, 2]
        ),
        (
            'user2',
            ARRAY[1, 2, 3]
        ),
        (
            'user3',
            ARRAY[2, 3]
        ),
        (
            'user4',
            ARRAY[2]
        ),
        (
            'user5',
            ARRAY[1, 3]
        );
