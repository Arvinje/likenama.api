--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: campaign_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE campaign_type AS ENUM (
    'instagram',
    'web'
);


--
-- Name: payment_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE payment_type AS ENUM (
    'like_getter',
    'money_getter'
);


--
-- Name: product_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE product_type AS ENUM (
    'mobiletopup'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bundles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bundles (
    id integer NOT NULL,
    price integer DEFAULT 0,
    coins integer DEFAULT 0,
    free_coins integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bundles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bundles_id_seq OWNED BY bundles.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE campaigns (
    id integer NOT NULL,
    total_likes integer DEFAULT 0,
    waiting_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner_id integer,
    campaign_type campaign_type,
    payment_type payment_type,
    price_id integer,
    budget integer,
    available boolean,
    verified boolean
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE campaigns_id_seq OWNED BY campaigns.id;


--
-- Name: instagram_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instagram_details (
    id integer NOT NULL,
    short_code character varying DEFAULT ''::character varying,
    description text DEFAULT ''::text,
    phone character varying DEFAULT ''::character varying,
    website character varying DEFAULT ''::character varying,
    address text DEFAULT ''::text,
    campaign_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    photo_url character varying
);


--
-- Name: instagram_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE instagram_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instagram_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE instagram_details_id_seq OWNED BY instagram_details.id;


--
-- Name: key_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE key_values (
    id integer NOT NULL,
    key character varying,
    value integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: key_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE key_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: key_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE key_values_id_seq OWNED BY key_values.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE likes (
    id integer NOT NULL,
    user_id integer,
    campaign_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: managers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE managers (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    failed_attempts integer DEFAULT 0 NOT NULL,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE managers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE managers_id_seq OWNED BY managers.id;


--
-- Name: prices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prices (
    id integer NOT NULL,
    campaign_value integer DEFAULT 0,
    users_share integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    campaign_type campaign_type,
    payment_type payment_type
);


--
-- Name: prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prices_id_seq OWNED BY prices.id;


--
-- Name: product_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_details (
    id integer NOT NULL,
    code text DEFAULT ''::text,
    description text DEFAULT ''::text,
    available boolean DEFAULT true,
    product_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_details_id_seq OWNED BY product_details.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    title character varying,
    description text,
    price integer,
    available boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_type product_type
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE purchases (
    id integer NOT NULL,
    user_id integer,
    product_detail_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE purchases_id_seq OWNED BY purchases.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    id_get character varying DEFAULT ''::character varying,
    trans_id character varying DEFAULT ''::character varying,
    user_id integer,
    bundle_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uid character varying,
    provider character varying DEFAULT ''::character varying,
    omni_id character varying DEFAULT ''::character varying,
    auth_token character varying,
    like_credit integer DEFAULT 0,
    coin_credit integer DEFAULT 0,
    username character varying DEFAULT ''::character varying,
    locked_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: waitings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE waitings (
    id integer NOT NULL,
    period integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    campaign_type campaign_type,
    payment_type payment_type
);


--
-- Name: waitings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE waitings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: waitings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE waitings_id_seq OWNED BY waitings.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundles ALTER COLUMN id SET DEFAULT nextval('bundles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns ALTER COLUMN id SET DEFAULT nextval('campaigns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY instagram_details ALTER COLUMN id SET DEFAULT nextval('instagram_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY key_values ALTER COLUMN id SET DEFAULT nextval('key_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY managers ALTER COLUMN id SET DEFAULT nextval('managers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prices ALTER COLUMN id SET DEFAULT nextval('prices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_details ALTER COLUMN id SET DEFAULT nextval('product_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY purchases ALTER COLUMN id SET DEFAULT nextval('purchases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY waitings ALTER COLUMN id SET DEFAULT nextval('waitings_id_seq'::regclass);


--
-- Name: bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bundles
    ADD CONSTRAINT bundles_pkey PRIMARY KEY (id);


--
-- Name: campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: instagram_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instagram_details
    ADD CONSTRAINT instagram_details_pkey PRIMARY KEY (id);


--
-- Name: key_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY key_values
    ADD CONSTRAINT key_values_pkey PRIMARY KEY (id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (id);


--
-- Name: prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: product_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_details
    ADD CONSTRAINT product_details_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: waitings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY waitings
    ADD CONSTRAINT waitings_pkey PRIMARY KEY (id);


--
-- Name: index_campaigns_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_campaigns_on_owner_id ON campaigns USING btree (owner_id);


--
-- Name: index_campaigns_on_price_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_campaigns_on_price_id ON campaigns USING btree (price_id);


--
-- Name: index_instagram_details_on_campaign_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_instagram_details_on_campaign_id ON instagram_details USING btree (campaign_id);


--
-- Name: index_key_values_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_key_values_on_key ON key_values USING btree (key);


--
-- Name: index_likes_on_campaign_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_campaign_id ON likes USING btree (campaign_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_user_id ON likes USING btree (user_id);


--
-- Name: index_managers_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_managers_on_email ON managers USING btree (email);


--
-- Name: index_managers_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_managers_on_reset_password_token ON managers USING btree (reset_password_token);


--
-- Name: index_users_on_auth_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_auth_token ON users USING btree (auth_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_provider_and_omni_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_provider_and_omni_id ON users USING btree (provider, omni_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_uid ON users USING btree (uid);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_1e09b5dabf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT fk_rails_1e09b5dabf FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_933b12bfd8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaigns
    ADD CONSTRAINT fk_rails_933b12bfd8 FOREIGN KEY (price_id) REFERENCES prices(id);


--
-- Name: fk_rails_a0a47c1dbb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT fk_rails_a0a47c1dbb FOREIGN KEY (campaign_id) REFERENCES campaigns(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150719170727');

INSERT INTO schema_migrations (version) VALUES ('20150719180400');

INSERT INTO schema_migrations (version) VALUES ('20150720035718');

INSERT INTO schema_migrations (version) VALUES ('20150724080659');

INSERT INTO schema_migrations (version) VALUES ('20150724083127');

INSERT INTO schema_migrations (version) VALUES ('20150724120818');

INSERT INTO schema_migrations (version) VALUES ('20150725081017');

INSERT INTO schema_migrations (version) VALUES ('20150726131409');

INSERT INTO schema_migrations (version) VALUES ('20150731175109');

INSERT INTO schema_migrations (version) VALUES ('20150802124712');

INSERT INTO schema_migrations (version) VALUES ('20150808155022');

INSERT INTO schema_migrations (version) VALUES ('20150809061405');

INSERT INTO schema_migrations (version) VALUES ('20150811073548');

INSERT INTO schema_migrations (version) VALUES ('20150815102402');

INSERT INTO schema_migrations (version) VALUES ('20150815102516');

INSERT INTO schema_migrations (version) VALUES ('20150815114332');

INSERT INTO schema_migrations (version) VALUES ('20150815131523');

INSERT INTO schema_migrations (version) VALUES ('20150816030259');

INSERT INTO schema_migrations (version) VALUES ('20150822115857');

INSERT INTO schema_migrations (version) VALUES ('20150822120244');

INSERT INTO schema_migrations (version) VALUES ('20150822145356');

INSERT INTO schema_migrations (version) VALUES ('20150824074337');

INSERT INTO schema_migrations (version) VALUES ('20150824125110');

INSERT INTO schema_migrations (version) VALUES ('20150824134029');

INSERT INTO schema_migrations (version) VALUES ('20150901104732');

INSERT INTO schema_migrations (version) VALUES ('20150914201021');

INSERT INTO schema_migrations (version) VALUES ('20150914202028');

INSERT INTO schema_migrations (version) VALUES ('20151123203138');

INSERT INTO schema_migrations (version) VALUES ('20151127125725');

INSERT INTO schema_migrations (version) VALUES ('20151129131754');

INSERT INTO schema_migrations (version) VALUES ('20151224053301');

