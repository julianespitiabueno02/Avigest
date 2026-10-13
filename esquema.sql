-- Referencia generada desde modelos; inicializar con la fábrica de aplicación.


CREATE TABLE configuration (
	id INTEGER NOT NULL, 
	minimum INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	CHECK (id = 1), 
	CHECK (minimum >= 0)
)

;


CREATE TABLE feed_lots (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	supplier VARCHAR(200) NOT NULL, 
	received_on DATE NOT NULL, 
	expires_on DATE NOT NULL, 
	CHECK (expires_on >= received_on)
)

;

CREATE INDEX ix_feed_lots_expires_on ON feed_lots (expires_on);


CREATE TABLE pens (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	name VARCHAR(120) NOT NULL, 
	registered_at DATETIME NOT NULL, 
	active BOOLEAN NOT NULL
)

;


CREATE TABLE profiles (
	id INTEGER NOT NULL, 
	name VARCHAR(60) NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (name)
)

;


CREATE TABLE users (
	id INTEGER NOT NULL, 
	name VARCHAR(120) NOT NULL, 
	username VARCHAR(80) NOT NULL, 
	password_hash VARCHAR(255) NOT NULL, 
	role_id INTEGER NOT NULL, 
	active BOOLEAN NOT NULL, 
	session_version INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (username), 
	FOREIGN KEY(role_id) REFERENCES profiles (id) ON DELETE RESTRICT
)

;


CREATE TABLE animal_movements (
	id INTEGER NOT NULL, 
	kind VARCHAR(20) NOT NULL, 
	pen_id INTEGER NOT NULL, 
	destination_id INTEGER, 
	quantity INTEGER NOT NULL, 
	delta INTEGER NOT NULL, 
	"before" INTEGER, 
	"after" INTEGER, 
	occurred_on DATE NOT NULL, 
	recorded_at DATETIME NOT NULL, 
	user_id INTEGER NOT NULL, 
	note VARCHAR(500) NOT NULL, 
	PRIMARY KEY (id), 
	CHECK (kind IN ('ingreso','muerte','venta','traslado','ajuste')), 
	CHECK (quantity >= 0 AND (kind = 'ajuste' OR quantity > 0)), 
	CHECK ((kind = 'traslado' AND destination_id IS NOT NULL AND destination_id != pen_id) OR (kind != 'traslado' AND destination_id IS NULL)), 
	CHECK (kind != 'ajuste' OR (before IS NOT NULL AND after IS NOT NULL AND before >= 0 AND after >= 0 AND length(trim(note)) > 0 AND delta = after - before)), 
	CHECK (kind = 'ajuste' OR (kind IN ('ingreso') AND delta = quantity) OR (kind IN ('muerte','venta','traslado') AND delta = -quantity)), 
	FOREIGN KEY(pen_id) REFERENCES pens (id) ON DELETE RESTRICT, 
	FOREIGN KEY(destination_id) REFERENCES pens (id) ON DELETE RESTRICT, 
	FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE RESTRICT
)

;

CREATE INDEX ix_animal_pen_date ON animal_movements (pen_id, occurred_on);

CREATE INDEX ix_animal_destination_date ON animal_movements (destination_id, occurred_on);


CREATE TABLE audit_events (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	action VARCHAR(80) NOT NULL, 
	target VARCHAR(100) NOT NULL, 
	detail VARCHAR(500) NOT NULL, 
	recorded_at DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE RESTRICT
)

;


CREATE TABLE feed_movements (
	id INTEGER NOT NULL, 
	kind VARCHAR(20) NOT NULL, 
	lot_id INTEGER NOT NULL, 
	pen_id INTEGER, 
	quantity INTEGER NOT NULL, 
	delta INTEGER NOT NULL, 
	"before" INTEGER, 
	"after" INTEGER, 
	occurred_on DATE NOT NULL, 
	recorded_at DATETIME NOT NULL, 
	user_id INTEGER NOT NULL, 
	note VARCHAR(500) NOT NULL, 
	PRIMARY KEY (id), 
	CHECK (kind IN ('entrada','salida','ajuste')), 
	CHECK (quantity > 0), 
	CHECK ((kind = 'salida' AND pen_id IS NOT NULL) OR (kind != 'salida' AND pen_id IS NULL)), 
	CHECK (kind != 'ajuste' OR (before IS NOT NULL AND after IS NOT NULL AND before >= 0 AND after >= 0 AND length(trim(note)) > 0 AND delta = after - before)), 
	CHECK ((kind = 'entrada' AND delta = quantity) OR (kind = 'salida' AND delta = -quantity) OR (kind = 'ajuste' AND (delta = quantity OR delta = -quantity))), 
	FOREIGN KEY(lot_id) REFERENCES feed_lots (id) ON DELETE RESTRICT, 
	FOREIGN KEY(pen_id) REFERENCES pens (id) ON DELETE RESTRICT, 
	FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE RESTRICT
)

;

CREATE INDEX ix_feed_lot_date ON feed_movements (lot_id, occurred_on);

CREATE INDEX ix_feed_date ON feed_movements (occurred_on);

CREATE INDEX ix_feed_pen_date ON feed_movements (pen_id, occurred_on);

CREATE TRIGGER IF NOT EXISTS animal_no_update BEFORE UPDATE ON animal_movements BEGIN SELECT RAISE(ABORT, 'Historial inmutable'); END;

CREATE TRIGGER IF NOT EXISTS animal_no_delete BEFORE DELETE ON animal_movements BEGIN SELECT RAISE(ABORT, 'Historial inmutable'); END;

CREATE TRIGGER IF NOT EXISTS feed_no_update BEFORE UPDATE ON feed_movements BEGIN SELECT RAISE(ABORT, 'Historial inmutable'); END;

CREATE TRIGGER IF NOT EXISTS feed_no_delete BEFORE DELETE ON feed_movements BEGIN SELECT RAISE(ABORT, 'Historial inmutable'); END;

CREATE TRIGGER IF NOT EXISTS audit_no_update BEFORE UPDATE ON audit_events BEGIN SELECT RAISE(ABORT, 'Historial inmutable'); END;

CREATE TRIGGER IF NOT EXISTS audit_no_delete BEFORE DELETE ON audit_events BEGIN SELECT RAISE(ABORT, 'Historial inmutable'); END;