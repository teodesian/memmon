CREATE TABLE IF NOT EXISTS processes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE INDEX IF NOT EXISTS process_name_idx ON processes(name);

CREATE TABLE IF NOT EXISTS observations (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    time INTEGER NOT NULL,
    rss  INTEGER NOT NULL,
    process_id INTEGER NOT NULL REFERENCES processes(id)
);

CREATE INDEX IF NOT EXISTS observations_time_idx ON observations(time);
CREATE INDEX IF NOT EXISTS observations_process_id_idx ON observations(process_id);

CREATE VIEW IF NOT EXISTS procsummary AS
SELECT
    p.name      as name,
    o.time      as time,
    max(o.rss)  as max_rss,
    avg(o.rss)  as avg_rss,
    sum(o.rss)  as rss,
    count(o.id) as num_procs
FROM
    observations AS o
JOIN
    processes AS p ON
    p.id = o.process_id
GROUP BY
    o.time, p.name
;

/* Writable view for simplicity's sake */
CREATE TRIGGER IF NOT EXISTS
    procsummary_wv_processes
INSTEAD OF INSERT ON
    procsummary
BEGIN
    INSERT OR IGNORE INTO processes (name) VALUES (new.name);
    INSERT INTO observations (time,rss,process_id) VALUES ( strftime("%s", "now"), new.rss, (SELECT id FROM processes AS p WHERE p.name=new.name) );
END;
