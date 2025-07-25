-- Enable pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to generate KSUIDs
CREATE OR REPLACE FUNCTION ksuid() RETURNS text AS $$
DECLARE
    v_time timestamp with time zone := clock_timestamp();
    v_seconds numeric(50);
    v_numeric numeric(50);
    v_epoch numeric(50) := 1400000000; -- 2014-05-13T16:53:20Z
    v_base62 text := '';
    v_alphabet char array[62] := ARRAY[
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
        'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 
        'U', 'V', 'W', 'X', 'Y', 'Z', 
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 
        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
        'u', 'v', 'w', 'x', 'y', 'z'];
BEGIN
    -- Calculate seconds since epoch and random numeric ID
    v_seconds := EXTRACT(EPOCH FROM v_time) - v_epoch;
    v_numeric := v_seconds * pow(2::numeric, 128)
                 + ((random()::numeric * pow(2::numeric, 128))::numeric);

    -- Encode the numeric ID to base62
    WHILE v_numeric <> 0 LOOP
        v_base62 := v_base62 || v_alphabet[mod(v_numeric, 62) + 1];
        v_numeric := div(v_numeric, 62);
    END LOOP;

    v_base62 := reverse(v_base62);
    RETURN lpad(v_base62, 27, '0');
END;
$$ LANGUAGE plpgsql;

-- Generic function to update 'updated_at' column
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;