DROP FUNCTION IF EXISTS max_snaptime();
CREATE FUNCTION max_snaptime()
RETURNS TIMESTAMP
LANGUAGE SQL AS $$
SELECT max(t_time) from snapshot;
$$;
--*******************************************
DROP FUNCTION IF EXISTS snap_after();
CREATE FUNCTION snap_after() RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
	msg TEXT;
BEGIN
	SET msg = 'AFTER';
	RETURN msg;
END
$$;
--*******************************************
DROP FUNCTION IF EXISTS snap_after();
CREATE FUNCTION snap_after() RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE 
	msg TEXT;
BEGIN
	SET msg = 'BEFORE';
	RETURN msg;
END
$$;

--*******************************************
DROP FUNCTION IF EXISTS snap_same();
CREATE FUNCTION snap_same() RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
	msg TEXT;
BEGIN
	SET msg = 'SAME';
	RETURN msg;
END
$$;

--*******************************************
DROP FUNCTION IF EXISTS create_snapshot(query_time TIMESTAMP);
CREATE FUNCTION create_snapshot(query_time TIMESTAMP) RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE 
	snaptime TIMESTAMP;
	msg TEXT;
BEGIN
	SELECT max_snaptime() INTO snaptime;
	IF query_time > snaptime THEN
		SELECT snap_after();
	ELSE
		IF query_time < snaptime THEN
		SELECT snap_before();
		ELSE
		SELECT snap_same();
		END IF;
	END IF;
END;
$$;

