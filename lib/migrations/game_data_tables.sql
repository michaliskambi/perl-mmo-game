-- 1 up

CREATE TABLE gd_languages (
	id VARCHAR(2) PRIMARY KEY,
	complete BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE gd_lores (
	id VARCHAR(20) PRIMARY KEY
);

CREATE TABLE gd_lore_names (
	id SERIAL PRIMARY KEY,
	lore_id VARCHAR(20) NOT NULL,
	language_id VARCHAR(2) NOT NULL,
	name VARCHAR(255) NOT NULL,
	CONSTRAINT fk_lore
		FOREIGN KEY(lore_id)
		REFERENCES gd_lores(id),
	CONSTRAINT fk_language
		FOREIGN KEY(language_id)
		REFERENCES gd_languages(id)
);

CREATE INDEX ind_lore_names_lookup ON gd_lore_names (language_id, lore_id);

CREATE TABLE gd_lore_descriptions (
	id SERIAL PRIMARY KEY,
	lore_id VARCHAR(20) NOT NULL,
	language_id VARCHAR(2) NOT NULL,
	description TEXT NOT NULL,
	CONSTRAINT fk_lore
		FOREIGN KEY(lore_id)
		REFERENCES gd_lores(id),
	CONSTRAINT fk_language
		FOREIGN KEY(language_id)
		REFERENCES gd_languages(id)
);

CREATE INDEX ind_lore_descriptions_lookup ON gd_lore_descriptions (language_id, lore_id);

CREATE TABLE gd_classes (
	id VARCHAR(20) PRIMARY KEY,
	CONSTRAINT fk_lore
		FOREIGN KEY(id)
		REFERENCES gd_lores(id)
);

CREATE TABLE gd_locations (
	id VARCHAR(20) PRIMARY KEY,
	pseudo BOOLEAN DEFAULT false,
	CONSTRAINT fk_lore
		FOREIGN KEY(id)
		REFERENCES gd_lores(id)
);

CREATE INDEX ind_locations_lookup ON gd_locations (pseudo);

CREATE TABLE gd_location_paths (
	id SERIAL PRIMARY KEY,
	location_id VARCHAR(20) NOT NULL,
	location_from_id VARCHAR(20) NOT NULL,
	location_to_id VARCHAR(20) NOT NULL,
	travel_distance FLOAT NOT NULL,
	CONSTRAINT fk_location_id
		FOREIGN KEY(location_id)
		REFERENCES gd_locations(id),
	CONSTRAINT fk_location_from_id
		FOREIGN KEY(location_id)
		REFERENCES gd_locations(id),
	CONSTRAINT fk_location_to_id
		FOREIGN KEY(location_id)
		REFERENCES gd_locations(id)
);

CREATE INDEX ind_location_paths_lookup_1 ON gd_location_paths (location_from_id, location_to_id);
CREATE INDEX ind_location_paths_lookup_2 ON gd_location_paths (location_to_id);

CREATE TABLE gd_ability_effect_types (
	id VARCHAR(20) PRIMARY KEY,
	CONSTRAINT fk_lore
		FOREIGN KEY(id)
		REFERENCES gd_lores(id)
);

CREATE TABLE gd_ability_attributes (
	id VARCHAR(20) PRIMARY KEY,
	CONSTRAINT fk_lore
		FOREIGN KEY(id)
		REFERENCES gd_lores(id)
);

CREATE TABLE gd_abilities (
	id VARCHAR(20) PRIMARY KEY,
	attribute_id VARCHAR(20) NOT NULL,
	passive BOOLEAN,
	cost INT NULL,
	cooldown INT NULL,
	range INT NULL,
	target_self BOOLEAN NULL,
	target_ally BOOLEAN NULL,
	target_foe BOOLEAN NULL,
	target_ground BOOLEAN NULL,
	CONSTRAINT fk_lore
		FOREIGN KEY(id)
		REFERENCES gd_lores(id),
	CONSTRAINT fk_ability_attribute
		FOREIGN KEY(attribute_id)
		REFERENCES gd_ability_attributes(id)
);

CREATE TABLE gd_ability_effects (
	id SERIAL PRIMARY KEY,
	ability_id VARCHAR(20) NOT NULL,
	type_id VARCHAR(20) NOT NULL,
	attribute_id VARCHAR(20) NOT NULL,
	effect_group INT NOT NULL DEFAULT 1,
	value FLOAT NULL,
	deviation FLOAT NULL,
	CONSTRAINT fk_ability
		FOREIGN KEY(ability_id)
		REFERENCES gd_abilities(id),
	CONSTRAINT fk_ability_attribute
		FOREIGN KEY(attribute_id)
		REFERENCES gd_ability_attributes(id),
	CONSTRAINT fk_ability_effect_type
		FOREIGN KEY(type_id)
		REFERENCES gd_ability_effect_types(id)
);

CREATE INDEX ind_ability_effects_lookup ON gd_ability_effects (ability_id, effect_group);

-- 1 down

DROP TABLE gd_ability_effects;
DROP TABLE gd_abilities;
DROP TABLE gd_ability_effect_types;
DROP TABLE gd_ability_attributes;
DROP TABLE gd_location_paths;
DROP TABLE gd_classes;
DROP TABLE gd_locations;
DROP TABLE gd_lore_names;
DROP TABLE gd_lore_descriptions;
DROP TABLE gd_lores;
DROP TABLE gd_languages;
