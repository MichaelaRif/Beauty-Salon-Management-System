------------------------
-- pgAdmin SQL dump file
------------------------

CREATE EXTENSION IF NOT EXISTS citext;

------------------------
-- ENUMs
------------------------
CREATE TYPE "public"."appointment_status" AS ENUM (
  'Booked',
  'Completed',
  'Cancelled',
  'Postponed',
  'Other'
);
ALTER TYPE "public"."appointment_status" OWNER TO "postgres";

CREATE TYPE "public"."form_type" AS ENUM (
  'Test',
  'Quiz',
  'Survey',
  'Other'
);
ALTER TYPE "public"."form_type" OWNER TO "postgres";

CREATE TYPE "public"."transaction_status" AS ENUM (
  'Pending',
  'Completed',
  'Failed'
);
ALTER TYPE "public"."transaction_status" OWNER TO "postgres";

CREATE TYPE "public"."pronouns" AS ENUM (
  'He/Him',
  'She/Her',
  'They/Them',
  'Other'
);
ALTER TYPE "public"."pronouns" OWNER TO "postgres";

------------------------
-- Domains
------------------------
CREATE DOMAIN name_domain AS citext
CHECK(VALUE ~* '^[A-Za-z'' -]+( [A-Za-z'' -]+)*$');

CREATE DOMAIN pn_domain AS citext
CHECK(VALUE ~* '^[0-9]{7,15}$');

CREATE DOMAIN email_domain AS citext
CHECK(VALUE ~* '^.+@[A-Za-z]+\\.[A-Za-z]+$');

------------------------
-- Tables & Sequences
------------------------
CREATE TABLE public.appointments (
    appointment_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_id integer NOT NULL,
    employee_id integer,
    appointment_date timestamp without time zone NOT NULL,
    appointment_status public.appointment_status NOT NULL,
    is_walk_in boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.appointments OWNER TO postgres;

CREATE SEQUENCE public.appointments_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.appointments_appointment_id_seq OWNER TO postgres;
ALTER SEQUENCE public.appointments_appointment_id_seq OWNED BY public.appointments.appointment_id;


CREATE TABLE public.attendances (
    attendance_id integer NOT NULL,
    employee_id integer NOT NULL,
    employee_check_in timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_check_out timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.attendances OWNER TO postgres;

CREATE SEQUENCE public.attendances_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.attendances_attendance_id_seq OWNER TO postgres;
ALTER SEQUENCE public.attendances_attendance_id_seq OWNED BY public.attendances.attendance_id;

CREATE TABLE public.bundle_items (
    bundle_item_id integer NOT NULL,
    bundle_id integer NOT NULL,
    product_id integer NOT NULL,
    bundle_product_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.bundle_items OWNER TO postgres;

CREATE SEQUENCE public.bundle_items_bundle_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bundle_items_bundle_item_id_seq OWNER TO postgres;
ALTER SEQUENCE public.bundle_items_bundle_item_id_seq OWNED BY public.bundle_items.bundle_item_id;

CREATE TABLE public.bundles (
    bundle_id integer NOT NULL,
    bundle_name character varying(255) NOT NULL,
    bundle_description character varying(255),
    bundle_price money NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.bundles OWNER TO postgres;

CREATE SEQUENCE public.bundles_bundle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bundles_bundle_id_seq OWNER TO postgres;
ALTER SEQUENCE public.bundles_bundle_id_seq OWNED BY public.bundles.bundle_id;

CREATE TABLE public.cities (
    city_id integer NOT NULL,
    city_name character varying(255) NOT NULL,
    country_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.cities OWNER TO postgres;

CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.cities_city_id_seq OWNER TO postgres;
ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;

CREATE TABLE public.countries (
    country_id integer NOT NULL,
    country_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.countries OWNER TO postgres;

CREATE SEQUENCE public.countries_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.countries_country_id_seq OWNER TO postgres;
ALTER SEQUENCE public.countries_country_id_seq OWNED BY public.countries.country_id;

CREATE TABLE public.customer_forms (
    customer_form_id integer NOT NULL,
    customer_id integer NOT NULL,
    form_id integer NOT NULL,
    customer_form_time_started timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_form_time_completed timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.customer_forms OWNER TO postgres;

CREATE SEQUENCE public.customer_forms_customer_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customer_forms_customer_form_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customer_forms_customer_form_id_seq OWNED BY public.customer_forms.customer_form_id;

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    customer_fn public.name_domain NOT NULL,
    customer_ln public.name_domain NOT NULL,
    customer_email public.email_domain,
    customer_pn public.pn_domain,
    customer_dob date NOT NULL,
    customer_pronoun public.pronouns NOT NULL,
    customer_city_id integer NOT NULL,
    preferences jsonb,
    promotions boolean DEFAULT false NOT NULL,
    customer_pfp character varying(255),
    is_google boolean DEFAULT false NOT NULL,
    is_apple boolean DEFAULT false NOT NULL,
    is_2fa boolean DEFAULT false NOT NULL,
    customer_registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_last_login timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_customers_auth CHECK ((NOT (is_google AND is_apple)))
);
ALTER TABLE public.customers OWNER TO postgres;

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;

CREATE TABLE public.discounts (
    discount_id integer NOT NULL,
    product_id integer NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    discount_start_date timestamp without time zone NOT NULL,
    discount_end_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.discounts OWNER TO postgres;

CREATE SEQUENCE public.discounts_discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.discounts_discount_id_seq OWNER TO postgres;
ALTER SEQUENCE public.discounts_discount_id_seq OWNED BY public.discounts.discount_id;

CREATE TABLE public.employee_reviews (
    employee_review_id integer NOT NULL,
    employee_id integer NOT NULL,
    customer_id integer NOT NULL,
    employee_stars_count integer NOT NULL,
    customer_product_review text,
    customer_product_review_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_reviews OWNER TO postgres;

CREATE SEQUENCE public.employee_reviews_employee_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employee_reviews_employee_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_reviews_employee_review_id_seq OWNED BY public.employee_reviews.employee_review_id;

CREATE TABLE public.employee_roles (
    employee_role_id integer NOT NULL,
    employee_id integer NOT NULL,
    role_id integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_roles OWNER TO postgres;

CREATE SEQUENCE public.employee_roles_employee_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
ALTER SEQUENCE public.employee_roles_employee_role_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_roles_employee_role_id_seq OWNED BY public.employee_roles.employee_role_id;

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    employee_fn public.name_domain,
    employee_ln public.name_domain NOT NULL,
    employee_email public.email_domain,
    employee_pn public.pn_domain,
    employee_dob date NOT NULL,
    employee_pronoun public.pronouns NOT NULL,
    employee_city_id integer NOT NULL,
    employee_pfp character varying(255),
    employee_role_id integer NOT NULL,
    hire_date date NOT NULL,
    employee_registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_last_login timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employees OWNER TO postgres;

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;

CREATE TABLE public.form_types (
    form_type_id integer NOT NULL,
    form_type public.form_type,
    form_type_description text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.form_types OWNER TO postgres;

CREATE SEQUENCE public.form_types_form_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.form_types_form_type_id_seq OWNER TO postgres;
ALTER SEQUENCE public.form_types_form_type_id_seq OWNED BY public.form_types.form_type_id;

CREATE TABLE public.forms (
    form_id integer NOT NULL,
    form_name character varying(255) NOT NULL,
    form_description character varying(255),
    form_type_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.forms OWNER TO postgres;

CREATE SEQUENCE public.forms_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.forms_form_id_seq OWNER TO postgres;
ALTER SEQUENCE public.forms_form_id_seq OWNED BY public.forms.form_id;

CREATE TABLE public.inventory (
    inventory_id integer NOT NULL,
    product_id integer NOT NULL,
    production_date date,
    expiry_date date,
    stock_in_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    stock_out_date date,
    is_restocked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.inventory OWNER TO postgres;

CREATE SEQUENCE public.inventory_inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.inventory_inventory_id_seq OWNER TO postgres;
ALTER SEQUENCE public.inventory_inventory_id_seq OWNED BY public.inventory.inventory_id;

CREATE TABLE public.product_brands (
    product_brand_id integer NOT NULL,
    product_brand character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_brands OWNER TO postgres;

CREATE SEQUENCE public.product_brands_product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_brands_product_brand_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_brands_product_brand_id_seq OWNED BY public.product_brands.product_brand_id;

CREATE TABLE public.product_categories (
    product_category_id integer NOT NULL,
    product_category character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_categories OWNER TO postgres;

CREATE SEQUENCE public.product_categories_product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_categories_product_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_categories_product_category_id_seq OWNED BY public.product_categories.product_category_id;

CREATE TABLE public.product_favorites (
    product_favorite_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    favorited_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unfavorited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_favorites OWNER TO postgres;

CREATE SEQUENCE public.product_favorites_product_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_favorites_product_favorite_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_favorites_product_favorite_id_seq OWNED BY public.product_favorites.product_favorite_id;

CREATE TABLE public.product_reviews (
    product_review_id integer NOT NULL,
    product_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_stars_count integer NOT NULL,
    customer_product_review text,
    customer_product_review_date timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_reviews OWNER TO postgres;

CREATE SEQUENCE public.product_reviews_product_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_reviews_product_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_reviews_product_review_id_seq OWNED BY public.product_reviews.product_review_id;

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    product_description character varying(255),
    product_price money NOT NULL,
    product_brand_id integer NOT NULL,
    product_category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.products OWNER TO postgres;

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;
ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(255) NOT NULL,
    role_description character varying(255),
    role_salary numeric NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone
);
ALTER TABLE public.roles OWNER TO postgres;

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;
ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;

CREATE TABLE public.service_categories (
    service_category_id integer NOT NULL,
    service_category_name character varying(255) NOT NULL,
    service_category_description character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_categories OWNER TO postgres;

CREATE SEQUENCE public.service_categories_service_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_categories_service_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_categories_service_category_id_seq OWNED BY public.service_categories.service_category_id;

CREATE TABLE public.service_favorites (
    service_favorite_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_id integer NOT NULL,
    favorited_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unfavorited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_favorites OWNER TO postgres;

CREATE SEQUENCE public.service_favorites_service_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_favorites_service_favorite_id_seq OWNER TO postgres;


ALTER SEQUENCE public.service_favorites_service_favorite_id_seq OWNED BY public.service_favorites.service_favorite_id;



CREATE TABLE public.service_reviews (
    service_review_id integer NOT NULL,
    service_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_stars_count integer NOT NULL,
    customer_service_review text,
    customer_service_review_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.service_reviews OWNER TO postgres;


CREATE SEQUENCE public.service_reviews_service_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_reviews_service_review_id_seq OWNER TO postgres;


ALTER SEQUENCE public.service_reviews_service_review_id_seq OWNED BY public.service_reviews.service_review_id;



CREATE TABLE public.services (
    service_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    service_description character varying(255),
    service_price money,
    service_category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.services OWNER TO postgres;


CREATE SEQUENCE public.service_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_service_id_seq OWNER TO postgres;


ALTER SEQUENCE public.service_service_id_seq OWNED BY public.services.service_id;


CREATE TABLE public.transaction_categories (
    transaction_category_id integer NOT NULL,
    transaction_category character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transaction_categories OWNER TO postgres;


CREATE SEQUENCE public.transaction_categories_transaction_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_categories_transaction_category_id_seq OWNER TO postgres;


ALTER SEQUENCE public.transaction_categories_transaction_category_id_seq OWNED BY public.transaction_categories.transaction_category_id;



CREATE TABLE public.transaction_types (
    transaction_type_id integer NOT NULL,
    transaction_type character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transaction_types OWNER TO postgres;


CREATE SEQUENCE public.transaction_types_transaction_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_types_transaction_type_id_seq OWNER TO postgres;


ALTER SEQUENCE public.transaction_types_transaction_type_id_seq OWNED BY public.transaction_types.transaction_type_id;



CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    customer_id integer NOT NULL,
    transaction_category_id integer NOT NULL,
    transaction_price money NOT NULL,
    transaction_type_id integer NOT NULL,
    transaction_time timestamp without time zone NOT NULL,
    transaction_status public.transaction_status NOT NULL,
    is_deposit boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transactions OWNER TO postgres;


CREATE SEQUENCE public.transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;


ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;



ALTER TABLE ONLY public.appointments ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointments_appointment_id_seq'::regclass);



ALTER TABLE ONLY public.attendances ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendances_attendance_id_seq'::regclass);



ALTER TABLE ONLY public.bundle_items ALTER COLUMN bundle_item_id SET DEFAULT nextval('public.bundle_items_bundle_item_id_seq'::regclass);



ALTER TABLE ONLY public.bundles ALTER COLUMN bundle_id SET DEFAULT nextval('public.bundles_bundle_id_seq'::regclass);


ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);



ALTER TABLE ONLY public.countries ALTER COLUMN country_id SET DEFAULT nextval('public.countries_country_id_seq'::regclass);



ALTER TABLE ONLY public.customer_forms ALTER COLUMN customer_form_id SET DEFAULT nextval('public.customer_forms_customer_form_id_seq'::regclass);



ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);



ALTER TABLE ONLY public.discounts ALTER COLUMN discount_id SET DEFAULT nextval('public.discounts_discount_id_seq'::regclass);



ALTER TABLE ONLY public.employee_reviews ALTER COLUMN employee_review_id SET DEFAULT nextval('public.employee_reviews_employee_review_id_seq'::regclass);



ALTER TABLE ONLY public.employee_roles ALTER COLUMN employee_role_id SET DEFAULT nextval('public.employee_roles_employee_role_id_seq'::regclass);

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


ALTER TABLE ONLY public.form_types ALTER COLUMN form_type_id SET DEFAULT nextval('public.form_types_form_type_id_seq'::regclass);



ALTER TABLE ONLY public.forms ALTER COLUMN form_id SET DEFAULT nextval('public.forms_form_id_seq'::regclass);



ALTER TABLE ONLY public.inventory ALTER COLUMN inventory_id SET DEFAULT nextval('public.inventory_inventory_id_seq'::regclass);



ALTER TABLE ONLY public.product_brands ALTER COLUMN product_brand_id SET DEFAULT nextval('public.product_brands_product_brand_id_seq'::regclass);



ALTER TABLE ONLY public.product_categories ALTER COLUMN product_category_id SET DEFAULT nextval('public.product_categories_product_category_id_seq'::regclass);



ALTER TABLE ONLY public.product_favorites ALTER COLUMN product_favorite_id SET DEFAULT nextval('public.product_favorites_product_favorite_id_seq'::regclass);



ALTER TABLE ONLY public.product_reviews ALTER COLUMN product_review_id SET DEFAULT nextval('public.product_reviews_product_review_id_seq'::regclass);



ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);

ALTER TABLE ONLY public.service_categories ALTER COLUMN service_category_id SET DEFAULT nextval('public.service_categories_service_category_id_seq'::regclass);


--
-- TOC entry 5021 (class 2604 OID 52149)
-- Name: service_favorites service_favorite_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_favorites ALTER COLUMN service_favorite_id SET DEFAULT nextval('public.service_favorites_service_favorite_id_seq'::regclass);


--
-- TOC entry 4963 (class 2604 OID 51619)
-- Name: service_reviews service_review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_reviews ALTER COLUMN service_review_id SET DEFAULT nextval('public.service_reviews_service_review_id_seq'::regclass);


--
-- TOC entry 4948 (class 2604 OID 51492)
-- Name: services service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.service_service_id_seq'::regclass);


--
-- TOC entry 5025 (class 2604 OID 52191)
-- Name: transaction_categories transaction_category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_categories ALTER COLUMN transaction_category_id SET DEFAULT nextval('public.transaction_categories_transaction_category_id_seq'::regclass);


--
-- TOC entry 5014 (class 2604 OID 52120)
-- Name: transaction_types transaction_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_types ALTER COLUMN transaction_type_id SET DEFAULT nextval('public.transaction_types_transaction_type_id_seq'::regclass);


--
-- TOC entry 5028 (class 2604 OID 52242)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);

--
-- TOC entry 5391 (class 0 OID 0)
-- Dependencies: 226
-- Name: appointments_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_appointment_id_seq', 1, false);


--
-- TOC entry 5392 (class 0 OID 0)
-- Dependencies: 248
-- Name: attendances_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendances_attendance_id_seq', 1, false);


--
-- TOC entry 5393 (class 0 OID 0)
-- Dependencies: 246
-- Name: bundle_items_bundle_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bundle_items_bundle_item_id_seq', 1, false);


--
-- TOC entry 5394 (class 0 OID 0)
-- Dependencies: 244
-- Name: bundles_bundle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bundles_bundle_id_seq', 1, false);


--
-- TOC entry 5395 (class 0 OID 0)
-- Dependencies: 250
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 1, false);


--
-- TOC entry 5396 (class 0 OID 0)
-- Dependencies: 252
-- Name: countries_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_country_id_seq', 1, false);


--
-- TOC entry 5397 (class 0 OID 0)
-- Dependencies: 240
-- Name: customer_forms_customer_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_forms_customer_form_id_seq', 1, false);


--
-- TOC entry 5398 (class 0 OID 0)
-- Dependencies: 216
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 1, false);


--
-- TOC entry 5399 (class 0 OID 0)
-- Dependencies: 242
-- Name: discounts_discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discounts_discount_id_seq', 1, false);


--
-- TOC entry 5400 (class 0 OID 0)
-- Dependencies: 232
-- Name: employee_reviews_employee_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_reviews_employee_review_id_seq', 1, false);


--
-- TOC entry 5401 (class 0 OID 0)
-- Dependencies: 270
-- Name: employee_roles_employee_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_roles_employee_role_id_seq', 1, false);


--
-- TOC entry 5402 (class 0 OID 0)
-- Dependencies: 218
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 1, false);


--
-- TOC entry 5403 (class 0 OID 0)
-- Dependencies: 238
-- Name: form_types_form_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.form_types_form_type_id_seq', 1, false);


--
-- TOC entry 5404 (class 0 OID 0)
-- Dependencies: 236
-- Name: forms_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.forms_form_id_seq', 1, false);


--
-- TOC entry 5405 (class 0 OID 0)
-- Dependencies: 224
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_inventory_id_seq', 1, false);


--
-- TOC entry 5406 (class 0 OID 0)
-- Dependencies: 256
-- Name: product_brands_product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brands_product_brand_id_seq', 1, false);


--
-- TOC entry 5407 (class 0 OID 0)
-- Dependencies: 258
-- Name: product_categories_product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_categories_product_category_id_seq', 1, false);


--
-- TOC entry 5408 (class 0 OID 0)
-- Dependencies: 262
-- Name: product_favorites_product_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_favorites_product_favorite_id_seq', 1, false);


--
-- TOC entry 5409 (class 0 OID 0)
-- Dependencies: 230
-- Name: product_reviews_product_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_reviews_product_review_id_seq', 1, false);


--
-- TOC entry 5410 (class 0 OID 0)
-- Dependencies: 222
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);


--
-- TOC entry 5411 (class 0 OID 0)
-- Dependencies: 234
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);


--
-- TOC entry 5412 (class 0 OID 0)
-- Dependencies: 254
-- Name: service_categories_service_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_categories_service_category_id_seq', 1, false);


--
-- TOC entry 5413 (class 0 OID 0)
-- Dependencies: 264
-- Name: service_favorites_service_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_favorites_service_favorite_id_seq', 1, false);


--
-- TOC entry 5414 (class 0 OID 0)
-- Dependencies: 228
-- Name: service_reviews_service_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_reviews_service_review_id_seq', 1, false);


--
-- TOC entry 5415 (class 0 OID 0)
-- Dependencies: 220
-- Name: service_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_service_id_seq', 1, false);


--
-- TOC entry 5416 (class 0 OID 0)
-- Dependencies: 266
-- Name: transaction_categories_transaction_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_categories_transaction_category_id_seq', 1, false);


--
-- TOC entry 5417 (class 0 OID 0)
-- Dependencies: 260
-- Name: transaction_types_transaction_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_types_transaction_type_id_seq', 1, false);


--
-- TOC entry 5418 (class 0 OID 0)
-- Dependencies: 268
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 1, false);


--
-- TOC entry 5066 (class 2606 OID 51568)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointment_id);


--
-- TOC entry 5100 (class 2606 OID 51983)
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (attendance_id);


--
-- TOC entry 5098 (class 2606 OID 51907)
-- Name: bundle_items bundle_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundle_items
    ADD CONSTRAINT bundle_items_pkey PRIMARY KEY (bundle_item_id);


--
-- TOC entry 5094 (class 2606 OID 51895)
-- Name: bundles bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles
    ADD CONSTRAINT bundles_pkey PRIMARY KEY (bundle_id);


--
-- TOC entry 5102 (class 2606 OID 51992)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 5104 (class 2606 OID 52001)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- TOC entry 5090 (class 2606 OID 51815)
-- Name: customer_forms customer_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_forms
    ADD CONSTRAINT customer_forms_pkey PRIMARY KEY (customer_form_id);


--
-- TOC entry 5038 (class 2606 OID 51462)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 5092 (class 2606 OID 51884)
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (discount_id);


--
-- TOC entry 5076 (class 2606 OID 51651)
-- Name: employee_reviews employee_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_reviews
    ADD CONSTRAINT employee_reviews_pkey PRIMARY KEY (employee_review_id);


--
-- TOC entry 5122 (class 2606 OID 52648)
-- Name: employee_roles employee_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT employee_roles_pkey PRIMARY KEY (employee_role_id);


--
-- TOC entry 5046 (class 2606 OID 51484)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 5088 (class 2606 OID 51799)
-- Name: form_types form_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_types
    ADD CONSTRAINT form_types_pkey PRIMARY KEY (form_type_id);


--
-- TOC entry 5084 (class 2606 OID 51767)
-- Name: forms forms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (form_id);


--
-- TOC entry 5064 (class 2606 OID 51523)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- TOC entry 5108 (class 2606 OID 52089)
-- Name: product_brands product_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brands
    ADD CONSTRAINT product_brands_pkey PRIMARY KEY (product_brand_id);


--
-- TOC entry 5110 (class 2606 OID 52098)
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (product_category_id);


--
-- TOC entry 5114 (class 2606 OID 52134)
-- Name: product_favorites product_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_favorites
    ADD CONSTRAINT product_favorites_pkey PRIMARY KEY (product_favorite_id);


--
-- TOC entry 5074 (class 2606 OID 51638)
-- Name: product_reviews product_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (product_review_id);


--
-- TOC entry 5058 (class 2606 OID 51513)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 5080 (class 2606 OID 51663)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 5106 (class 2606 OID 52015)
-- Name: service_categories service_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_categories
    ADD CONSTRAINT service_categories_pkey PRIMARY KEY (service_category_id);


--
-- TOC entry 5116 (class 2606 OID 52154)
-- Name: service_favorites service_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_favorites
    ADD CONSTRAINT service_favorites_pkey PRIMARY KEY (service_favorite_id);


--
-- TOC entry 5053 (class 2606 OID 51498)
-- Name: services service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);


--
-- TOC entry 5070 (class 2606 OID 51625)
-- Name: service_reviews service_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_pkey PRIMARY KEY (service_review_id);


--
-- TOC entry 5118 (class 2606 OID 52195)
-- Name: transaction_categories transaction_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_categories
    ADD CONSTRAINT transaction_categories_pkey PRIMARY KEY (transaction_category_id);


--
-- TOC entry 5112 (class 2606 OID 52124)
-- Name: transaction_types transaction_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (transaction_type_id);


--
-- TOC entry 5120 (class 2606 OID 52246)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 5096 (class 2606 OID 51897)
-- Name: bundles uq_bundles_bundle_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles
    ADD CONSTRAINT uq_bundles_bundle_name UNIQUE (bundle_name);


--
-- TOC entry 5044 (class 2606 OID 51471)
-- Name: customers uq_customers_customer_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT uq_customers_customer_email UNIQUE (customer_email);


--
-- TOC entry 5086 (class 2606 OID 51769)
-- Name: forms uq_forms_form_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forms
    ADD CONSTRAINT uq_forms_form_name UNIQUE (form_name);


--
-- TOC entry 5082 (class 2606 OID 51665)
-- Name: roles uq_roles_role_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT uq_roles_role_name UNIQUE (role_name);


--
-- TOC entry 5055 (class 2606 OID 51502)
-- Name: services uq_services_service_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT uq_services_service_name UNIQUE (service_name);


--
-- TOC entry 5047 (class 1259 OID 52664)
-- Name: fki_fk_employees_employee_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_fk_employees_employee_role_id ON public.employees USING btree (employee_role_id);


--
-- TOC entry 5039 (class 1259 OID 51468)
-- Name: idx_customers_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_address ON public.customers USING btree (customer_city_id);


--
-- TOC entry 5040 (class 1259 OID 51466)
-- Name: idx_customers_customer_dob; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_customer_dob ON public.customers USING btree (customer_dob);


--
-- TOC entry 5041 (class 1259 OID 51467)
-- Name: idx_customers_customer_pronouns; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_customer_pronouns ON public.customers USING btree (customer_pronouns);


--
-- TOC entry 5042 (class 1259 OID 51469)
-- Name: idx_customers_preferences; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_preferences ON public.customers USING btree (preferences);


--
-- TOC entry 5077 (class 1259 OID 51652)
-- Name: idx_employee_reviews_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_reviews_employee_id ON public.employee_reviews USING btree (employee_id);


--
-- TOC entry 5078 (class 1259 OID 51653)
-- Name: idx_employee_reviews_employee_stars_count; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_reviews_employee_stars_count ON public.employee_reviews USING btree (employee_stars_count);


--
-- TOC entry 5123 (class 1259 OID 52645)
-- Name: idx_employee_roles_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_roles_employee_id ON public.employee_roles USING btree (employee_id);


--
-- TOC entry 5124 (class 1259 OID 52646)
-- Name: idx_employee_roles_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_roles_role_id ON public.employee_roles USING btree (role_id);


--
-- TOC entry 5048 (class 1259 OID 51486)
-- Name: idx_employees_employee_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_employee_address_id ON public.employees USING btree (employee_city_id);


--
-- TOC entry 5049 (class 1259 OID 51487)
-- Name: idx_employees_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_role_id ON public.employees USING btree (employee_role_id);


--
-- TOC entry 5059 (class 1259 OID 51529)
-- Name: idx_inventory_inventory_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_inventory_id ON public.inventory USING btree (inventory_id);


--
-- TOC entry 5060 (class 1259 OID 51532)
-- Name: idx_inventory_is_restocked; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_is_restocked ON public.inventory USING btree (is_restocked);


--
-- TOC entry 5061 (class 1259 OID 51530)
-- Name: idx_inventory_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_product_id ON public.inventory USING btree (product_id);


--
-- TOC entry 5062 (class 1259 OID 51531)
-- Name: idx_inventory_stock_out_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_stock_out_date ON public.inventory USING btree (stock_out_date);


--
-- TOC entry 5071 (class 1259 OID 51639)
-- Name: idx_product_reviews_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_reviews_product_id ON public.product_reviews USING btree (product_id);


--
-- TOC entry 5072 (class 1259 OID 51640)
-- Name: idx_product_reviews_product_stars_count; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_reviews_product_stars_count ON public.product_reviews USING btree (product_stars_count);


--
-- TOC entry 5056 (class 1259 OID 51514)
-- Name: idx_products_product_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_product_price ON public.products USING btree (product_price);


--
-- TOC entry 5067 (class 1259 OID 51626)
-- Name: idx_service_reviews_service_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_service_reviews_service_id ON public.service_reviews USING btree (service_id);


--
-- TOC entry 5068 (class 1259 OID 51627)
-- Name: idx_service_reviews_service_stars_count; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_service_reviews_service_stars_count ON public.service_reviews USING btree (service_stars_count);


--
-- TOC entry 5050 (class 1259 OID 51503)
-- Name: idx_services_service_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_service_category_id ON public.services USING btree (service_category_id);


--
-- TOC entry 5051 (class 1259 OID 51504)
-- Name: idx_services_service_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_service_price ON public.services USING btree (service_price);


--
-- TOC entry 5132 (class 2606 OID 51846)
-- Name: appointments fk_appointments_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5133 (class 2606 OID 52175)
-- Name: appointments fk_appointments_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 5134 (class 2606 OID 52170)
-- Name: appointments fk_appointments_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);


--
-- TOC entry 5147 (class 2606 OID 52031)
-- Name: attendances fk_attendances_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_attendances_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 5145 (class 2606 OID 51908)
-- Name: bundle_items fk_bundle_items_bundle_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundle_items
    ADD CONSTRAINT fk_bundle_items_bundle_id FOREIGN KEY (bundle_id) REFERENCES public.bundles(bundle_id);


--
-- TOC entry 5146 (class 2606 OID 51913)
-- Name: bundle_items fk_bundle_items_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundle_items
    ADD CONSTRAINT fk_bundle_items_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5148 (class 2606 OID 52046)
-- Name: cities fk_cities_country_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT fk_cities_country_id FOREIGN KEY (country_id) REFERENCES public.countries(country_id);


--
-- TOC entry 5142 (class 2606 OID 51821)
-- Name: customer_forms fk_customer_forms_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_forms
    ADD CONSTRAINT fk_customer_forms_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5143 (class 2606 OID 51816)
-- Name: customer_forms fk_customer_forms_form_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_forms
    ADD CONSTRAINT fk_customer_forms_form_id FOREIGN KEY (form_id) REFERENCES public.forms(form_id);


--
-- TOC entry 5125 (class 2606 OID 52670)
-- Name: customers fk_customers_customer_city_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customers_customer_city_id FOREIGN KEY (customer_city_id) REFERENCES public.cities(city_id);


--
-- TOC entry 5144 (class 2606 OID 52051)
-- Name: discounts fk_discounts_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT fk_discounts_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5139 (class 2606 OID 51861)
-- Name: employee_reviews fk_employee_reviews_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_reviews
    ADD CONSTRAINT fk_employee_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5140 (class 2606 OID 51866)
-- Name: employee_reviews fk_employee_reviews_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_reviews
    ADD CONSTRAINT fk_employee_reviews_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 5156 (class 2606 OID 52649)
-- Name: employee_roles fk_employee_roles_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT fk_employee_roles_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 5157 (class 2606 OID 52654)
-- Name: employee_roles fk_employee_roles_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT fk_employee_roles_role_id FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- TOC entry 5126 (class 2606 OID 52665)
-- Name: employees fk_employees_employee_city_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_employee_city_id FOREIGN KEY (employee_city_id) REFERENCES public.cities(city_id);


--
-- TOC entry 5127 (class 2606 OID 52659)
-- Name: employees fk_employees_employee_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_employee_role_id FOREIGN KEY (employee_role_id) REFERENCES public.employee_roles(employee_role_id);


--
-- TOC entry 5141 (class 2606 OID 51800)
-- Name: forms fk_forms_form_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forms
    ADD CONSTRAINT fk_forms_form_type_id FOREIGN KEY (form_type_id) REFERENCES public.form_types(form_type_id);


--
-- TOC entry 5131 (class 2606 OID 51524)
-- Name: inventory fk_inventory_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5149 (class 2606 OID 52135)
-- Name: product_favorites fk_product_favorites_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_favorites
    ADD CONSTRAINT fk_product_favorites_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5150 (class 2606 OID 52140)
-- Name: product_favorites fk_product_favorites_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_favorites
    ADD CONSTRAINT fk_product_favorites_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5137 (class 2606 OID 51836)
-- Name: product_reviews fk_product_reviews_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT fk_product_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5138 (class 2606 OID 51841)
-- Name: product_reviews fk_product_reviews_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT fk_product_reviews_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 5129 (class 2606 OID 52099)
-- Name: products fk_products_product_brand_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_product_brand_id FOREIGN KEY (product_brand_id) REFERENCES public.product_brands(product_brand_id);


--
-- TOC entry 5130 (class 2606 OID 52104)
-- Name: products fk_products_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_product_category_id FOREIGN KEY (product_category_id) REFERENCES public.product_categories(product_category_id);


--
-- TOC entry 5151 (class 2606 OID 52155)
-- Name: service_favorites fk_service_favorites_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_favorites
    ADD CONSTRAINT fk_service_favorites_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5152 (class 2606 OID 52160)
-- Name: service_favorites fk_service_favorites_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_favorites
    ADD CONSTRAINT fk_service_favorites_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);


--
-- TOC entry 5135 (class 2606 OID 51851)
-- Name: service_reviews fk_service_reviews_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT fk_service_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5136 (class 2606 OID 51856)
-- Name: service_reviews fk_service_reviews_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT fk_service_reviews_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);


--
-- TOC entry 5128 (class 2606 OID 52016)
-- Name: services fk_services_service_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_services_service_category_id FOREIGN KEY (service_category_id) REFERENCES public.service_categories(service_category_id);


--
-- TOC entry 5153 (class 2606 OID 52252)
-- Name: transactions fk_transactions_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 5154 (class 2606 OID 52257)
-- Name: transactions fk_transactions_transaction_category_id_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_transaction_category_id_id FOREIGN KEY (transaction_category_id) REFERENCES public.transaction_categories(transaction_category_id);


--
-- TOC entry 5155 (class 2606 OID 52262)
-- Name: transactions fk_transactions_transaction_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_transaction_type_id FOREIGN KEY (transaction_type_id) REFERENCES public.transaction_types(transaction_type_id);
