------------------------
-- Extensions
------------------------
CREATE EXTENSION IF NOT EXISTS citext;

------------------------
-- ENUMs
------------------------
--DO $$
--BEGIN
--    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'appointment_status') THEN
--        CREATE TYPE "public"."appointment_status" AS ENUM (
--            'Booked',
--            'Completed',
--            'Cancelled',
--            'Postponed',
--            'Other'
--        );
--    END IF;
--END $$;
--ALTER TYPE "public"."appointment_status" OWNER TO "postgres";
--
--DO $$
--BEGIN
--    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'form_type') THEN
--        CREATE TYPE "public"."form_type" AS ENUM (
--            'Test',
--            'Quiz',
--            'Survey',
--            'Other'
--        );
--    END IF;
--END $$;
--ALTER TYPE "public"."form_type" OWNER TO "postgres";
--
--DO $$
--BEGIN
--    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'pronoun') THEN
--        CREATE TYPE "public"."pronoun" AS ENUM (
--            'He/Him',
--            'She/Her',
--            'They/Them',
--            'Other'
--        );
--    END IF;
--END $$;
--ALTER TYPE "public"."pronoun" OWNER TO "postgres";
--
--DO $$
--BEGIN
--    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'transaction_status') THEN
--        CREATE TYPE "public"."transaction_status" AS ENUM (
--            'Pending',
--            'Completed',
--            'Failed'
--        );
--    END IF;
--END $$;
--ALTER TYPE "public"."transaction_status" OWNER TO "postgres";

------------------------
-- Domains
------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'appointment_status_domain') THEN
        CREATE DOMAIN "public"."appointment_status_domain" AS citext
        CHECK(VALUE ~* '^(Booked|Completed|Cancelled|Postponed|Other)$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'email_domain') THEN
        CREATE DOMAIN "public"."email_domain" AS citext
        CHECK(VALUE ~* '^[A-Za-z0-9.-_]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'form_type_domain') THEN
        CREATE DOMAIN "public"."form_type_domain" AS citext
        CHECK(VALUE ~* '^(Test|Quiz|Survey|Other)$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'keycloak_domain') THEN
        CREATE DOMAIN "public"."keycloak_domain" AS citext
        CHECK(VALUE ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'name_domain') THEN
        CREATE DOMAIN "public"."name_domain" AS citext
        CHECK(VALUE ~* '^[A-Za-z'' -]+( [A-Za-z'' -]+)*$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'pn_domain') THEN
        CREATE DOMAIN "public"."pn_domain" AS citext
        CHECK(VALUE ~* '^[0-9]{7,15}$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'pronoun_domain') THEN
        CREATE DOMAIN "public"."pronoun_domain" AS citext
        CHECK(VALUE ~* '^(He/Him|She/Her|They/Them|Other)$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'transaction_status_domain') THEN
        CREATE DOMAIN "public"."transaction_status_domain" AS citext
        CHECK(VALUE ~* '^(Pending|Completed|Failed)$');
    END IF;
END $$;

------------------------
-- Tables & Sequences
------------------------
CREATE TABLE IF NOT EXISTS public.addresses (
    address_id INT NOT NULL,
    address_street VARCHAR(255) NOT NULL,
    address_building VARCHAR(255) NOT NULL,
    address_floor INT NOT NULL,
    address_notes VARCHAR(255),
    address_city_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.addresses OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.addresses_address_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.addresses_address_id_seq OWNER TO postgres;
ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;

CREATE TABLE IF NOT EXISTS public.appointments (
    appointment_id INT NOT NULL,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    employee_id INT,
    appointment_date timestamp without time zone NOT NULL,
    appointment_status public.appointment_status_domain NOT NULL,
    is_walk_in boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.appointments OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.appointments_appointment_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.appointments_appointment_id_seq OWNER TO postgres;
ALTER SEQUENCE public.appointments_appointment_id_seq OWNED BY public.appointments.appointment_id;

CREATE TABLE IF NOT EXISTS public.attendances (
    attendance_id INT NOT NULL,
    employee_id INT NOT NULL,
    employee_check_in timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_check_out timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.attendances OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.attendances_attendance_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.attendances_attendance_id_seq OWNER TO postgres;
ALTER SEQUENCE public.attendances_attendance_id_seq OWNED BY public.attendances.attendance_id;

CREATE TABLE IF NOT EXISTS public.bundle_items (
    bundle_item_id INT NOT NULL,
    bundle_id INT NOT NULL,
    product_id INT NOT NULL,
    bundle_product_quantity INT DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.bundle_items OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.bundle_items_bundle_item_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bundle_items_bundle_item_id_seq OWNER TO postgres;
ALTER SEQUENCE public.bundle_items_bundle_item_id_seq OWNED BY public.bundle_items.bundle_item_id;

CREATE TABLE IF NOT EXISTS public.bundles (
    bundle_id INT NOT NULL,
    bundle_name VARCHAR(255) NOT NULL,
    bundle_description VARCHAR(255),
    bundle_price money NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.bundles OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.bundles_bundle_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.bundles_bundle_id_seq OWNER TO postgres;
ALTER SEQUENCE public.bundles_bundle_id_seq OWNED BY public.bundles.bundle_id;

CREATE TABLE IF NOT EXISTS public.categories (
    category_id INT NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    category_description VARCHAR(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.categories OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.categories_category_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;

CREATE TABLE IF NOT EXISTS public.cities (
    city_id INT NOT NULL,
    city_name VARCHAR(255) NOT NULL,
    country_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.cities OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.cities_city_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.cities_city_id_seq OWNER TO postgres;
ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;

CREATE TABLE IF NOT EXISTS public.countries (
    country_id INT NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.countries OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.countries_country_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.countries_country_id_seq OWNER TO postgres;
ALTER SEQUENCE public.countries_country_id_seq OWNED BY public.countries.country_id;

CREATE TABLE IF NOT EXISTS public.customer_addresses (
    customer_address_id INT NOT NULL,
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.customer_addresses OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.customer_addresses_customer_address_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customer_addresses_customer_address_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customer_addresses_customer_address_id_seq OWNED BY public.customer_addresses.customer_address_id;

CREATE TABLE IF NOT EXISTS public.customer_forms (
    customer_form_id INT NOT NULL,
    customer_id INT NOT NULL,
    form_id INT NOT NULL,
    customer_form_time_started timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_form_time_completed timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.customer_forms OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.customer_forms_customer_form_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customer_forms_customer_form_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customer_forms_customer_form_id_seq OWNED BY public.customer_forms.customer_form_id;

CREATE TABLE IF NOT EXISTS public.customers (
    customer_id INT NOT NULL,
    customer_keycloak_id public.keycloak_domain NOT NULL,
    customer_fn public.name_domain NOT NULL,
    customer_ln public.name_domain NOT NULL,
    customer_email public.email_domain,
    customer_pn public.pn_domain,
    customer_dob date NOT NULL,
    customer_pronoun_id INT NOT NULL,
    promotions boolean DEFAULT false NOT NULL,
    customer_pfp VARCHAR(255),
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

CREATE SEQUENCE IF NOT EXISTS public.customers_customer_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;

CREATE TABLE IF NOT EXISTS public.customer_preferences (
    customer_preference_id INT NOT NULL,
    customer_id INT NOT NULL,
    preference_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.customer_preferences OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.customer_preferences_customer_preference_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.customer_preferences_customer_preference_id_seq OWNER TO postgres;
ALTER SEQUENCE public.customer_preferences_customer_preference_id_seq OWNED BY public.customer_preferences.customer_preference_id;

CREATE TABLE IF NOT EXISTS public.discounts (
    discount_id INT NOT NULL,
    product_id INT NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    discount_start_date timestamp without time zone NOT NULL,
    discount_end_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.discounts OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.discounts_discount_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.discounts_discount_id_seq OWNER TO postgres;
ALTER SEQUENCE public.discounts_discount_id_seq OWNED BY public.discounts.discount_id;

CREATE TABLE IF NOT EXISTS public.employee_addresses (
    employee_address_id INT NOT NULL,
    employee_id INT NOT NULL,
    address_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_addresses OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employee_addresses_employee_address_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employee_addresses_employee_address_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_addresses_employee_address_id_seq OWNED BY public.employee_addresses.employee_address_id;

CREATE TABLE IF NOT EXISTS public.employee_reviews (
    employee_review_id INT NOT NULL,
    employee_id INT NOT NULL,
    customer_id INT NOT NULL,
    employee_stars_count INT NOT NULL,
    customer_employee_review VARCHAR(255),
    customer_employee_review_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employee_reviews_employee_review_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employee_reviews_employee_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_reviews_employee_review_id_seq OWNED BY public.employee_reviews.employee_review_id;

CREATE TABLE IF NOT EXISTS public.employee_roles (
    employee_role_id INT NOT NULL,
    employee_id INT NOT NULL,
    role_id INT NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employee_roles OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employee_roles_employee_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
ALTER SEQUENCE public.employee_roles_employee_role_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employee_roles_employee_role_id_seq OWNED BY public.employee_roles.employee_role_id;

CREATE TABLE IF NOT EXISTS public.employees (
    employee_id INT NOT NULL,
    employee_keycloak_id public.keycloak_domain NOT NULL,
    employee_fn public.name_domain,
    employee_ln public.name_domain NOT NULL,
    employee_email public.email_domain,
    employee_pn public.pn_domain,
    employee_dob date NOT NULL,
    employee_pronoun_id INT NOT NULL,
    employee_pfp VARCHAR(255),
    employee_role_id INT NOT NULL,
    hire_date date NOT NULL,
    employee_registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    employee_last_login timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.employees OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.employees_employee_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;
ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;

CREATE TABLE IF NOT EXISTS public.form_types (
    form_type_id INT NOT NULL,
    form_type public.form_type_domain NOT NULL,
    form_type_description VARCHAR(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.form_types OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.form_types_form_type_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.form_types_form_type_id_seq OWNER TO postgres;
ALTER SEQUENCE public.form_types_form_type_id_seq OWNED BY public.form_types.form_type_id;

CREATE TABLE IF NOT EXISTS public.forms (
    form_id INT NOT NULL,
    form_name VARCHAR(255) NOT NULL,
    form_description VARCHAR(255),
    form_type_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.forms OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.forms_form_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.forms_form_id_seq OWNER TO postgres;
ALTER SEQUENCE public.forms_form_id_seq OWNED BY public.forms.form_id;

CREATE TABLE IF NOT EXISTS public.inventory (
    inventory_id INT NOT NULL,
    product_id INT NOT NULL,
    production_date date,
    expiry_date date,
    stock_in_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    stock_out_date date,
    is_restocked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.inventory OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.inventory_inventory_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.inventory_inventory_id_seq OWNER TO postgres;
ALTER SEQUENCE public.inventory_inventory_id_seq OWNED BY public.inventory.inventory_id;

CREATE TABLE IF NOT EXISTS public.preferences (
    preference_id INT NOT NULL,
    preference_name VARCHAR(255) NOT NULL,
    preference_description VARCHAR(255),
    category_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.preferences OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.preferences_preference_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.preferences_preference_id_seq OWNER TO postgres;
ALTER SEQUENCE public.preferences_preference_id_seq OWNED BY public.preferences.preference_id;

CREATE TABLE IF NOT EXISTS public.product_brands (
    product_brand_id INT NOT NULL,
    product_brand VARCHAR(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_brands OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_brands_product_brand_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_brands_product_brand_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_brands_product_brand_id_seq OWNED BY public.product_brands.product_brand_id;

CREATE TABLE IF NOT EXISTS public.product_categories (
    product_category_id INT NOT NULL,
    product_category VARCHAR(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_categories OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_categories_product_category_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_categories_product_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_categories_product_category_id_seq OWNED BY public.product_categories.product_category_id;

CREATE TABLE IF NOT EXISTS public.product_favorites (
    product_favorite_id INT NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    favorited_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unfavorited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_favorites OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_favorites_product_favorite_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_favorites_product_favorite_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_favorites_product_favorite_id_seq OWNED BY public.product_favorites.product_favorite_id;

CREATE TABLE IF NOT EXISTS public.product_reviews (
    product_review_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    product_stars_count INT NOT NULL,
    customer_product_review VARCHAR(255),
    customer_product_review_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.product_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.product_reviews_product_review_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.product_reviews_product_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.product_reviews_product_review_id_seq OWNED BY public.product_reviews.product_review_id;

CREATE TABLE IF NOT EXISTS public.products (
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_description VARCHAR(255),
    product_price money NOT NULL,
    product_brand_id INT NOT NULL,
    product_category_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.products OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.products_product_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;
ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;

CREATE TABLE IF NOT EXISTS public.pronouns(
    pronoun_id INT NOT NULL,
    pronoun public.pronoun_domain NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.pronouns OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.pronouns_pronoun_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.pronouns_pronoun_id_seq OWNER TO postgres;
ALTER SEQUENCE public.pronouns_pronoun_id_seq OWNED BY public.pronouns.pronoun_id;

CREATE TABLE IF NOT EXISTS public.roles (
    role_id INT NOT NULL,
    role_name VARCHAR(255) NOT NULL,
    role_description VARCHAR(255),
    role_salary numeric NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone
);
ALTER TABLE public.roles OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.roles_role_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;
ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;

CREATE TABLE IF NOT EXISTS public.salon_reviews (
    salon_review_id INT NOT NULL,
    customer_id INT NOT NULL,
    salon_stars_count INT NOT NULL,
    customer_salon_review VARCHAR(255),
    customer_salon_review_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.salon_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.salon_reviews_salon_review_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.salon_reviews_salon_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.salon_reviews_salon_review_id_seq OWNED BY public.salon_reviews.salon_review_id;

CREATE TABLE IF NOT EXISTS public.service_categories (
    service_category_id INT NOT NULL,
    service_category_name VARCHAR(255) NOT NULL,
    service_category_description VARCHAR(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_categories OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_categories_service_category_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_categories_service_category_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_categories_service_category_id_seq OWNED BY public.service_categories.service_category_id;

CREATE TABLE IF NOT EXISTS public.service_favorites (
    service_favorite_id INT NOT NULL,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    favorited_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unfavorited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_favorites OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_favorites_service_favorite_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_favorites_service_favorite_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_favorites_service_favorite_id_seq OWNED BY public.service_favorites.service_favorite_id;

CREATE TABLE IF NOT EXISTS public.service_reviews (
    service_review_id INT NOT NULL,
    service_id INT NOT NULL,
    customer_id INT NOT NULL,
    service_stars_count INT NOT NULL,
    customer_service_review VARCHAR(255),
    customer_service_review_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.service_reviews OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_reviews_service_review_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_reviews_service_review_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_reviews_service_review_id_seq OWNED BY public.service_reviews.service_review_id;

CREATE TABLE IF NOT EXISTS public.services (
    service_id INT NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    service_description VARCHAR(255),
    service_price money,
    service_category_id INT NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.services OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.service_service_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.service_service_id_seq OWNER TO postgres;
ALTER SEQUENCE public.service_service_id_seq OWNED BY public.services.service_id;

CREATE TABLE IF NOT EXISTS public.transaction_types (
    transaction_type_id INT NOT NULL,
    transaction_type VARCHAR(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.transaction_types OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.transaction_types_transaction_type_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transaction_types_transaction_type_id_seq OWNER TO postgres;
ALTER SEQUENCE public.transaction_types_transaction_type_id_seq OWNED BY public.transaction_types.transaction_type_id;

CREATE TABLE IF NOT EXISTS public.transactions (
    transaction_id INT NOT NULL,
    customer_id INT NOT NULL,
    transaction_type_id INT NOT NULL,
    transaction_charge money NOT NULL,
    transaction_time timestamp without time zone NOT NULL,
    transaction_status public.transaction_status_domain NOT NULL,
    is_deposit boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.transactions OWNER TO postgres;

CREATE SEQUENCE IF NOT EXISTS public.transactions_transaction_id_seq
    AS INT
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;
ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);
ALTER TABLE ONLY public.appointments ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointments_appointment_id_seq'::regclass);
ALTER TABLE ONLY public.attendances ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendances_attendance_id_seq'::regclass);
ALTER TABLE ONLY public.bundle_items ALTER COLUMN bundle_item_id SET DEFAULT nextval('public.bundle_items_bundle_item_id_seq'::regclass);
ALTER TABLE ONLY public.bundles ALTER COLUMN bundle_id SET DEFAULT nextval('public.bundles_bundle_id_seq'::regclass);
ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);
ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);
ALTER TABLE ONLY public.countries ALTER COLUMN country_id SET DEFAULT nextval('public.countries_country_id_seq'::regclass);
ALTER TABLE ONLY public.customer_addresses ALTER COLUMN customer_address_id SET DEFAULT nextval('public.customer_addresses_customer_address_id_seq'::regclass);
ALTER TABLE ONLY public.customer_forms ALTER COLUMN customer_form_id SET DEFAULT nextval('public.customer_forms_customer_form_id_seq'::regclass);
ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);
ALTER TABLE ONLY public.customer_preferences ALTER COLUMN customer_preference_id SET DEFAULT nextval('public.customer_preferences_customer_preference_id_seq'::regclass);
ALTER TABLE ONLY public.discounts ALTER COLUMN discount_id SET DEFAULT nextval('public.discounts_discount_id_seq'::regclass);
ALTER TABLE ONLY public.employee_addresses ALTER COLUMN employee_address_id SET DEFAULT nextval('public.employee_addresses_employee_address_id_seq'::regclass);
ALTER TABLE ONLY public.employee_reviews ALTER COLUMN employee_review_id SET DEFAULT nextval('public.employee_reviews_employee_review_id_seq'::regclass);
ALTER TABLE ONLY public.employee_roles ALTER COLUMN employee_role_id SET DEFAULT nextval('public.employee_roles_employee_role_id_seq'::regclass);
ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);
ALTER TABLE ONLY public.form_types ALTER COLUMN form_type_id SET DEFAULT nextval('public.form_types_form_type_id_seq'::regclass);
ALTER TABLE ONLY public.forms ALTER COLUMN form_id SET DEFAULT nextval('public.forms_form_id_seq'::regclass);
ALTER TABLE ONLY public.inventory ALTER COLUMN inventory_id SET DEFAULT nextval('public.inventory_inventory_id_seq'::regclass);
ALTER TABLE ONLY public.preferences ALTER COLUMN preference_id SET DEFAULT nextval('public.preferences_preference_id_seq'::regclass);
ALTER TABLE ONLY public.product_brands ALTER COLUMN product_brand_id SET DEFAULT nextval('public.product_brands_product_brand_id_seq'::regclass);
ALTER TABLE ONLY public.product_categories ALTER COLUMN product_category_id SET DEFAULT nextval('public.product_categories_product_category_id_seq'::regclass);
ALTER TABLE ONLY public.product_favorites ALTER COLUMN product_favorite_id SET DEFAULT nextval('public.product_favorites_product_favorite_id_seq'::regclass);
ALTER TABLE ONLY public.product_reviews ALTER COLUMN product_review_id SET DEFAULT nextval('public.product_reviews_product_review_id_seq'::regclass);
ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
ALTER TABLE ONLY public.pronouns ALTER COLUMN pronoun_id SET DEFAULT nextval('public.pronouns_pronoun_id_seq'::regclass);
ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);
ALTER TABLE ONLY public.salon_reviews ALTER COLUMN salon_review_id SET DEFAULT nextval('public.salon_reviews_salon_review_id_seq'::regclass);
ALTER TABLE ONLY public.service_categories ALTER COLUMN service_category_id SET DEFAULT nextval('public.service_categories_service_category_id_seq'::regclass);
ALTER TABLE ONLY public.service_favorites ALTER COLUMN service_favorite_id SET DEFAULT nextval('public.service_favorites_service_favorite_id_seq'::regclass);
ALTER TABLE ONLY public.service_reviews ALTER COLUMN service_review_id SET DEFAULT nextval('public.service_reviews_service_review_id_seq'::regclass);
ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.service_service_id_seq'::regclass);
ALTER TABLE ONLY public.transaction_types ALTER COLUMN transaction_type_id SET DEFAULT nextval('public.transaction_types_transaction_type_id_seq'::regclass);
ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);

SELECT pg_catalog.setval('public.addresses_address_id_seq', 1, false);
SELECT pg_catalog.setval('public.appointments_appointment_id_seq', 1, false);
SELECT pg_catalog.setval('public.attendances_attendance_id_seq', 1, false);
SELECT pg_catalog.setval('public.bundle_items_bundle_item_id_seq', 1, false);
SELECT pg_catalog.setval('public.bundles_bundle_id_seq', 1, false);
SELECT pg_catalog.setval('public.categories_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.cities_city_id_seq', 1, false);
SELECT pg_catalog.setval('public.countries_country_id_seq', 1, false);
SELECT pg_catalog.setval('public.customer_forms_customer_form_id_seq', 1, false);
SELECT pg_catalog.setval('public.customer_addresses_customer_address_id_seq', 1, false);
SELECT pg_catalog.setval('public.customers_customer_id_seq', 1, false);
SELECT pg_catalog.setval('public.customer_preferences_customer_preference_id_seq', 1, false);
SELECT pg_catalog.setval('public.discounts_discount_id_seq', 1, false);
SELECT pg_catalog.setval('public.employee_addresses_employee_address_id_seq', 1, false);
SELECT pg_catalog.setval('public.employee_reviews_employee_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.employee_roles_employee_role_id_seq', 1, false);
SELECT pg_catalog.setval('public.employees_employee_id_seq', 1, false);
SELECT pg_catalog.setval('public.form_types_form_type_id_seq', 1, false);
SELECT pg_catalog.setval('public.forms_form_id_seq', 1, false);
SELECT pg_catalog.setval('public.inventory_inventory_id_seq', 1, false);
SELECT pg_catalog.setval('public.preferences_preference_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_brands_product_brand_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_categories_product_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_favorites_product_favorite_id_seq', 1, false);
SELECT pg_catalog.setval('public.product_reviews_product_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);
SELECT pg_catalog.setval('public.pronouns_pronoun_id_seq', 1, false);
SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);
SELECT pg_catalog.setval('public.salon_reviews_salon_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_categories_service_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_favorites_service_favorite_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_reviews_service_review_id_seq', 1, false);
SELECT pg_catalog.setval('public.service_service_id_seq', 1, false);
SELECT pg_catalog.setval('public.transaction_types_transaction_type_id_seq', 1, false);
SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 1, false);

------------------------
-- Primary Keys
------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'addresses_pkey'
    ) THEN
        ALTER TABLE ONLY public.addresses
        ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'appointments_pkey'
    ) THEN
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointment_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'attendances_pkey'
    ) THEN
        ALTER TABLE ONLY public.attendances
        ADD CONSTRAINT attendances_pkey PRIMARY KEY (attendance_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'bundle_items_pkey'
    ) THEN
        ALTER TABLE ONLY public.bundle_items
        ADD CONSTRAINT bundle_items_pkey PRIMARY KEY (bundle_item_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'bundles_pkey'
    ) THEN
        ALTER TABLE ONLY public.bundles
        ADD CONSTRAINT bundles_pkey PRIMARY KEY (bundle_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'categories_pkey'
    ) THEN
        ALTER TABLE ONLY public.categories
        ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'cities_pkey'
    ) THEN
        ALTER TABLE ONLY public.cities
        ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'countries_pkey'
    ) THEN
        ALTER TABLE ONLY public.countries
        ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customer_addresses_pkey'
    ) THEN
        ALTER TABLE ONLY public.customer_addresses
        ADD CONSTRAINT customer_addresses_pkey PRIMARY KEY (customer_address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customer_forms_pkey'
    ) THEN
        ALTER TABLE ONLY public.customer_forms
        ADD CONSTRAINT customer_forms_pkey PRIMARY KEY (customer_form_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customer_preferences_pkey'
    ) THEN
        ALTER TABLE ONLY public.customer_preferences
        ADD CONSTRAINT customer_preferences_pkey PRIMARY KEY (customer_preference_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customers_pkey'
    ) THEN
        ALTER TABLE ONLY public.customers
        ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'discounts_pkey'
    ) THEN
        ALTER TABLE ONLY public.discounts
        ADD CONSTRAINT discounts_pkey PRIMARY KEY (discount_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employee_addresses_pkey'
    ) THEN
        ALTER TABLE ONLY public.employee_addresses
        ADD CONSTRAINT employee_addresses_pkey PRIMARY KEY (employee_address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employee_reviews_pkey'
    ) THEN
        ALTER TABLE ONLY public.employee_reviews
        ADD CONSTRAINT employee_reviews_pkey PRIMARY KEY (employee_review_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employee_roles_pkey'
    ) THEN
        ALTER TABLE ONLY public.employee_roles
        ADD CONSTRAINT employee_roles_pkey PRIMARY KEY (employee_role_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employees_pkey'
    ) THEN
        ALTER TABLE ONLY public.employees
        ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'form_types_pkey'
    ) THEN
        ALTER TABLE ONLY public.form_types
        ADD CONSTRAINT form_types_pkey PRIMARY KEY (form_type_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'forms_pkey'
    ) THEN
        ALTER TABLE ONLY public.forms
        ADD CONSTRAINT forms_pkey PRIMARY KEY (form_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'inventory_pkey'
    ) THEN
        ALTER TABLE ONLY public.inventory
        ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'preferences_pkey'
    ) THEN
        ALTER TABLE ONLY public.preferences
        ADD CONSTRAINT preferences_pkey PRIMARY KEY (preference_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'product_brands_pkey'
    ) THEN
        ALTER TABLE ONLY public.product_brands
        ADD CONSTRAINT product_brands_pkey PRIMARY KEY (product_brand_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'product_categories_pkey'
    ) THEN
        ALTER TABLE ONLY public.product_categories
        ADD CONSTRAINT product_categories_pkey PRIMARY KEY (product_category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'product_favorites_pkey'
    ) THEN
        ALTER TABLE ONLY public.product_favorites
        ADD CONSTRAINT product_favorites_pkey PRIMARY KEY (product_favorite_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'product_reviews_pkey'
    ) THEN
        ALTER TABLE ONLY public.product_reviews
        ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (product_review_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'products_pkey'
    ) THEN
        ALTER TABLE ONLY public.products
        ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'pronouns_pkey'
    ) THEN
        ALTER TABLE ONLY public.pronouns
        ADD CONSTRAINT pronouns_pkey PRIMARY KEY (pronoun_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'roles_pkey'
    ) THEN
        ALTER TABLE ONLY public.roles
        ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'salon_reviews_pkey'
    ) THEN
        ALTER TABLE ONLY public.salon_reviews
        ADD CONSTRAINT salon_reviews_pkey PRIMARY KEY (salon_review_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'service_categories_pkey'
    ) THEN
        ALTER TABLE ONLY public.service_categories
        ADD CONSTRAINT service_categories_pkey PRIMARY KEY (service_category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'service_favorites_pkey'
    ) THEN
        ALTER TABLE ONLY public.service_favorites
        ADD CONSTRAINT service_favorites_pkey PRIMARY KEY (service_favorite_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'services_pkey'
    ) THEN
        ALTER TABLE ONLY public.services
        ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'service_reviews_pkey'
    ) THEN
        ALTER TABLE ONLY public.service_reviews
        ADD CONSTRAINT service_reviews_pkey PRIMARY KEY (service_review_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'transaction_types_pkey'
    ) THEN
        ALTER TABLE ONLY public.transaction_types
        ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (transaction_type_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'transactions_pkey'
    ) THEN
        ALTER TABLE ONLY public.transactions
        ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);
    END IF;
END $$;

------------------------
-- Uniques
------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_bundles_bundle_name'
    ) THEN
        ALTER TABLE ONLY public.bundles
        ADD CONSTRAINT uq_bundles_bundle_name UNIQUE (bundle_name);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_categories_category_name'
    ) THEN
        ALTER TABLE ONLY public.categories
        ADD CONSTRAINT uq_categories_category_name UNIQUE (category_name);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_customers_customer_email'
    ) THEN
        ALTER TABLE ONLY public.customers
        ADD CONSTRAINT uq_customers_customer_email UNIQUE (customer_email);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_forms_form_name'
    ) THEN
        ALTER TABLE ONLY public.forms
        ADD CONSTRAINT uq_forms_form_name UNIQUE (form_name);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_pronouns_pronoun'
    ) THEN
        ALTER TABLE ONLY public.pronouns
        ADD CONSTRAINT uq_pronouns_pronoun UNIQUE (pronoun);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_roles_role_name'
    ) THEN
        ALTER TABLE ONLY public.roles
        ADD CONSTRAINT uq_roles_role_name UNIQUE (role_name);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'uq_services_service_name'
    ) THEN
        ALTER TABLE ONLY public.services
        ADD CONSTRAINT uq_services_service_name UNIQUE (service_name);
    END IF;
END $$;

------------------------
-- Indexes
------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_addresses_address_id'
    ) THEN
        CREATE INDEX idx_addresses_address_id ON public.addresses USING btree (address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_addresses_city_id'
    ) THEN
        CREATE INDEX idx_addresses_city_id ON public.addresses USING btree (address_city_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_cities_city_id'
    ) THEN
        CREATE INDEX idx_cities_city_id ON public.cities USING btree (city_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_customer_addresses_customer_id'
    ) THEN
        CREATE INDEX idx_customer_addresses_customer_id ON public.customer_addresses USING btree (customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_customer_addresses_address_id'
    ) THEN
        CREATE INDEX idx_customer_addresses_address_id ON public.customer_addresses USING btree (address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_customers_customer_dob'
    ) THEN
        CREATE INDEX idx_customers_customer_dob ON public.customers USING btree (customer_dob);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_customers_customer_pronoun_id'
    ) THEN
        CREATE INDEX idx_customers_customer_pronoun_id ON public.customers USING btree (customer_pronoun_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_employee_addresses_employee_id'
    ) THEN
        CREATE INDEX idx_employee_addresses_employee_id ON public.employee_addresses USING btree (employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_employee_addresses_address_id'
    ) THEN
        CREATE INDEX idx_employee_addresses_address_id ON public.employee_addresses USING btree (address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_employee_reviews_employee_id'
    ) THEN
        CREATE INDEX idx_employee_reviews_employee_id ON public.employee_reviews USING btree (employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_employee_reviews_employee_stars_count'
    ) THEN
        CREATE INDEX idx_employee_reviews_employee_stars_count ON public.employee_reviews USING btree (employee_stars_count);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_product_favorites_product_id'
    ) THEN
        CREATE INDEX idx_product_favorites_product_id ON public.product_favorites USING btree (product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_service_favorites_service_id'
    ) THEN
        CREATE INDEX idx_service_favorites_service_id ON public.service_favorites USING btree (service_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_service_reviews_service_id'
    ) THEN
        CREATE INDEX idx_service_reviews_service_id ON public.service_reviews USING btree (service_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_service_reviews_service_stars_count'
    ) THEN
        CREATE INDEX idx_service_reviews_service_stars_count ON public.service_reviews USING btree (service_stars_count);
    END IF;
END $$;

------------------------
-- Foreign Keys
------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_addresses_address_city_id'
    ) THEN
        ALTER TABLE ONLY public.addresses
        ADD CONSTRAINT fk_addresses_address_city_id FOREIGN KEY (address_city_id) REFERENCES public.cities(city_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_appointments_customer_id'
    ) THEN
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT fk_appointments_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_appointments_employee_id'
    ) THEN
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT fk_appointments_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_appointments_service_id'
    ) THEN
        ALTER TABLE ONLY public.appointments
        ADD CONSTRAINT fk_appointments_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_attendances_employee_id'
    ) THEN
        ALTER TABLE ONLY public.attendances
        ADD CONSTRAINT fk_attendances_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_bundle_items_bundle_id'
    ) THEN
        ALTER TABLE ONLY public.bundle_items
        ADD CONSTRAINT fk_bundle_items_bundle_id FOREIGN KEY (bundle_id) REFERENCES public.bundles(bundle_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_bundle_items_product_id'
    ) THEN
        ALTER TABLE ONLY public.bundle_items
        ADD CONSTRAINT fk_bundle_items_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_cities_country_id'
    ) THEN
        ALTER TABLE ONLY public.cities
        ADD CONSTRAINT fk_cities_country_id FOREIGN KEY (country_id) REFERENCES public.countries(country_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customer_addresses_customer_id'
    ) THEN
        ALTER TABLE ONLY public.customer_addresses
        ADD CONSTRAINT fk_customer_addresses_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customer_addresses_address_id'
    ) THEN
        ALTER TABLE ONLY public.customer_addresses
        ADD CONSTRAINT fk_customer_addresses_address_id FOREIGN KEY (address_id) REFERENCES public.addresses(address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customer_forms_customer_id'
    ) THEN
        ALTER TABLE ONLY public.customer_forms
        ADD CONSTRAINT fk_customer_forms_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customer_forms_form_id'
    ) THEN
        ALTER TABLE ONLY public.customer_forms
        ADD CONSTRAINT fk_customer_forms_form_id FOREIGN KEY (form_id) REFERENCES public.forms(form_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customers_customer_pronoun_id'
    ) THEN
        ALTER TABLE ONLY public.customers
        ADD CONSTRAINT fk_customers_customer_pronoun_id FOREIGN KEY (customer_pronoun_id) REFERENCES public.pronouns(pronoun_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customer_preferences_customer_id'
    ) THEN
        ALTER TABLE ONLY public.customer_preferences
        ADD CONSTRAINT fk_customer_preferences_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_customer_preferences_preference_id'
    ) THEN
        ALTER TABLE ONLY public.customer_preferences
        ADD CONSTRAINT fk_customer_preferences_preference_id FOREIGN KEY (preference_id) REFERENCES public.preferences(preference_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_discounts_product_id'
    ) THEN
        ALTER TABLE ONLY public.discounts
        ADD CONSTRAINT fk_discounts_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employee_addresses_employee_id'
    ) THEN
        ALTER TABLE ONLY public.employee_addresses
        ADD CONSTRAINT fk_employee_addresses_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employee_addresses_address_id'
    ) THEN
        ALTER TABLE ONLY public.employee_addresses
        ADD CONSTRAINT fk_employee_addresses_address_id FOREIGN KEY (address_id) REFERENCES public.addresses(address_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employee_reviews_customer_id'
    ) THEN
        ALTER TABLE ONLY public.employee_reviews
        ADD CONSTRAINT fk_employee_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employee_reviews_employee_id'
    ) THEN
        ALTER TABLE ONLY public.employee_reviews
        ADD CONSTRAINT fk_employee_reviews_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employee_roles_employee_id'
    ) THEN
        ALTER TABLE ONLY public.employee_roles
        ADD CONSTRAINT fk_employee_roles_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employee_roles_role_id'
    ) THEN
        ALTER TABLE ONLY public.employee_roles
        ADD CONSTRAINT fk_employee_roles_role_id FOREIGN KEY (role_id) REFERENCES public.roles(role_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employees_employee_pronoun_id'
    ) THEN
        ALTER TABLE ONLY public.employees
        ADD CONSTRAINT fk_employees_employee_pronoun_id FOREIGN KEY (employee_pronoun_id) REFERENCES public.pronouns(pronoun_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_employees_employee_role_id'
    ) THEN
        ALTER TABLE ONLY public.employees
        ADD CONSTRAINT fk_employees_employee_role_id FOREIGN KEY (employee_role_id) REFERENCES public.employee_roles(employee_role_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_forms_form_type_id'
    ) THEN
        ALTER TABLE ONLY public.forms
        ADD CONSTRAINT fk_forms_form_type_id FOREIGN KEY (form_type_id) REFERENCES public.form_types(form_type_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_inventory_product_id'
    ) THEN
        ALTER TABLE ONLY public.inventory
        ADD CONSTRAINT fk_inventory_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_preferences_category_id'
    ) THEN
        ALTER TABLE ONLY public.preferences
        ADD CONSTRAINT fk_preferences_category_id FOREIGN KEY (category_id) REFERENCES public.categories(category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_product_favorites_customer_id'
    ) THEN
        ALTER TABLE ONLY public.product_favorites
        ADD CONSTRAINT fk_product_favorites_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_product_favorites_product_id'
    ) THEN
        ALTER TABLE ONLY public.product_favorites
        ADD CONSTRAINT fk_product_favorites_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_product_reviews_customer_id'
    ) THEN
        ALTER TABLE ONLY public.product_reviews
        ADD CONSTRAINT fk_product_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_product_reviews_product_id'
    ) THEN
        ALTER TABLE ONLY public.product_reviews
        ADD CONSTRAINT fk_product_reviews_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_products_product_brand_id'
    ) THEN
        ALTER TABLE ONLY public.products
        ADD CONSTRAINT fk_products_product_brand_id FOREIGN KEY (product_brand_id) REFERENCES public.product_brands(product_brand_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_products_product_category_id'
    ) THEN
        ALTER TABLE ONLY public.products
        ADD CONSTRAINT fk_products_product_category_id FOREIGN KEY (product_category_id) REFERENCES public.product_categories(product_category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_salon_reviews_customer_id'
    ) THEN
        ALTER TABLE ONLY public.salon_reviews
        ADD CONSTRAINT fk_salon_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_service_favorites_customer_id'
    ) THEN
        ALTER TABLE ONLY public.service_favorites
        ADD CONSTRAINT fk_service_favorites_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_service_favorites_service_id'
    ) THEN
        ALTER TABLE ONLY public.service_favorites
        ADD CONSTRAINT fk_service_favorites_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_service_reviews_customer_id'
    ) THEN
        ALTER TABLE ONLY public.service_reviews
        ADD CONSTRAINT fk_service_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_service_reviews_service_id'
    ) THEN
        ALTER TABLE ONLY public.service_reviews
        ADD CONSTRAINT fk_service_reviews_service_id FOREIGN KEY (service_id) REFERENCES public.services(service_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_services_service_category_id'
    ) THEN
        ALTER TABLE ONLY public.services
        ADD CONSTRAINT fk_services_service_category_id FOREIGN KEY (service_category_id) REFERENCES public.service_categories(service_category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_transactions_customer_id'
    ) THEN
        ALTER TABLE ONLY public.transactions
        ADD CONSTRAINT fk_transactions_customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_transactions_transaction_type_id'
    ) THEN
        ALTER TABLE ONLY public.transactions
        ADD CONSTRAINT fk_transactions_transaction_type_id FOREIGN KEY (transaction_type_id) REFERENCES public.transaction_types(transaction_type_id);
    END IF;
END $$;

------------------------
-- Insert Statements
------------------------

INSERT INTO public.countries(country_name) VALUES ('Afghanistan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Albania') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Algeria') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Andorra') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Angola') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Antigua and Barbuda') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Argentina') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Armenia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Australia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Austria') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Azerbaijan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bahamas') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bahrain') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bangladesh') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Barbados') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Belarus') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Belgium') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Belize') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Benin') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bhutan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bolivia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bosnia and Herzegovina') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Botswana') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Brazil') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Brunei') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Bulgaria') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Burkina Faso') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Burundi') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Cambodia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Cameroon') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Canada') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Cape Verde') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Central African Republic') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Chad') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Chile') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('China') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Colombia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Comoros') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('DR Congo') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Costa Rica') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Croatia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Cuba') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Cyprus') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Czech Republic') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Denmark') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Djibouti') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Dominica') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Dominican Republic') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('East Timor') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Ecuador') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Egypt') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('El Salvador') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Equatorial Guinea') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Eritrea') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Estonia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Eswatini') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Ethiopia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Fiji Islands') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Finland') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('France') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Gabon') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Gambia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Georgia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Germany') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Ghana') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Greece') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Grenada') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Guatemala') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Guinea') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Guinea-Bissau') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Guyana') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Haiti') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Honduras') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Hungary') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Iceland') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('India') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Indonesia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Iran') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Iraq') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Ireland') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Italy') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Ivory Coast') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Jamaica') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Japan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Jordan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Kazakhstan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Kenya') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Kiribati') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Kosovo') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Kuwait') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Kyrgyzstan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Laos') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Latvia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Lebanon') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Lesotho') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Liberia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Libya') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Liechtenstein') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Lithuania') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Luxembourg') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Madagascar') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Malawi') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Malaysia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Maldives') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Mali') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Malta') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Marshall Islands') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Mauritania') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Mauritius') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Mexico') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Micronesia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Moldova') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Monaco') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Mongolia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Montenegro') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Morocco') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Mozambique') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Myanmar') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Namibia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Nauru') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Nepal') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Netherlands') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('New Zealand') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Nicaragua') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Niger') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Nigeria') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('North Korea') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('North Macedonia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Norway') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Oman') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Pakistan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Palau') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Palestine') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Panama') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Papua New Guinea') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Paraguay') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Peru') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Philippines') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Poland') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Portugal') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Qatar') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Romania') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Russia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Rwanda') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Saint Kitts and Nevis') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Saint Lucia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Saint Vincent and the Grenadines') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Samoa') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('San Marino') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Sao Tome and Principe') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Saudi Arabia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Senegal') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Serbia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Seychelles') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Sierra Leone') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Singapore') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Slovakia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Slovenia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Solomon Islands') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Somalia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('South Africa') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('South Korea') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('South Sudan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Spain') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Sri Lanka') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Sudan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Suriname') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Sweden') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Switzerland') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Syria') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Taiwan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Tajikistan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Tanzania') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Thailand') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Togo') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Tonga') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Trinidad and Tobago') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Tunisia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Turkey') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Turkmenistan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Tuvalu') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Uganda') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Ukraine') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('United Arab Emirates') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('United Kingdom') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('United States') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Uruguay') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Uzbekistan') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Vanuatu') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Vatican City') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Venezuela') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Vietnam') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Yemen') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Zambia') ON CONFLICT (country_id) DO NOTHING;
INSERT INTO public.countries(country_name) VALUES ('Zimbabwe') ON CONFLICT (country_id) DO NOTHING;

INSERT INTO public.cities(city_name, country_id) VALUES ('Beirut', 94) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mar Roukoz', 94) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bekaa', 94) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tripoli', 94) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zahle', 94) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jezzine', 94) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chouf', 94) ON CONFLICT (city_id) DO NOTHING;

INSERT INTO public.form_types(form_type) VALUES ('Test') ON CONFLICT (form_type_id) DO NOTHING;
INSERT INTO public.form_types(form_type) VALUES ('Quiz') ON CONFLICT (form_type_id) DO NOTHING;
INSERT INTO public.form_types(form_type) VALUES ('Survey') ON CONFLICT (form_type_id) DO NOTHING;
INSERT INTO public.form_types(form_type) VALUES ('Other') ON CONFLICT (form_type_id) DO NOTHING;

INSERT INTO public.pronouns(pronoun) VALUES ('he/him') ON CONFLICT (pronoun_id) DO NOTHING;
INSERT INTO public.pronouns(pronoun) VALUES ('she/her') ON CONFLICT (pronoun_id) DO NOTHING;
INSERT INTO public.pronouns(pronoun) VALUES ('they/them') ON CONFLICT (pronoun_id) DO NOTHING;
INSERT INTO public.pronouns(pronoun) VALUES ('other') ON CONFLICT (pronoun_id) DO NOTHING;

INSERT INTO public.transaction_types(transaction_type)	VALUES ('Affirm') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('AmericanExpress') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Chainlink') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Clearpay') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Discover') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('EcoPayz') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Epay') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('FasaPay') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Interac') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Klarna') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Laybuy') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Mastercard') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('MoneyGram') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Neo') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Neosurf') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Neteller') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('BOB') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Paxum') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('PayPal') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('PaySera') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('PayU') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Payeer') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('PerfectMoney') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Qiwi') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Sezzle') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Skrill') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Splitit') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('SushiSwap') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Suyool') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('TransferGo') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Uphold') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('VeChain') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Venmo') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Visa') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('WeChatPay') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('WebMoney') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('YandexMoney') ON CONFLICT (transaction_type_id) DO NOTHING;
INSERT INTO public.transaction_types(transaction_type) VALUES ('Zelle') ON CONFLICT (transaction_type_id) DO NOTHING;

------------------------
-- Functions
------------------------

CREATE OR REPLACE FUNCTION get_pronoun_id(p_pronoun pronoun_domain)
RETURNS TABLE (
    "PronounId" INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT p.pronoun_id AS "PronounId"
        FROM pronouns p
        WHERE p.pronoun = p_pronoun;
END;
$$;

CREATE OR REPLACE FUNCTION insert_customer(
    p_customer_keycloak_id keycloak_domain,
    p_customer_fn name_domain,
    p_customer_ln name_domain,
    p_customer_email email_domain,
    p_customer_pn pn_domain,
    p_customer_dob DATE,
    p_customer_pronoun_id INT,
    p_is_google BOOLEAN,
    p_is_apple BOOLEAN
)
RETURNS TABLE (
    "CustomerId" INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id INT;
BEGIN
    INSERT INTO customers(
        customer_keycloak_id,
        customer_fn,
        customer_ln,
        customer_email,
        customer_pn,
        customer_dob,
        customer_pronoun_id,
        is_google,
        is_apple
    )
    VALUES (
        p_customer_keycloak_id,
        p_customer_fn,
        p_customer_ln,
        p_customer_email,
        p_customer_pn,
        p_customer_dob,
        p_customer_pronoun_id,
        p_is_google,
        p_is_apple
    )
    RETURNING customer_id INTO v_customer_id;

    RETURN QUERY
        SELECT v_customer_id AS "CustomerId";
END;
$$;

CREATE OR REPLACE FUNCTION get_city_id(p_city_name VARCHAR)
RETURNS TABLE (
    "CityId" INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT ci.city_id AS "CityId"
        FROM cities ci
        WHERE ci.city_name = p_city_name;
END;
$$;

/*CREATE OR REPLACE FUNCTION get_customer_by_id(p_customer_id INT)
RETURNS TABLE (
    "CustomerId" INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT c.customer_id AS "CustomerId"
        FROM customers c
        WHERE c.customer_id = p_customer_id;
END;
$$;*/

/*CREATE OR REPLACE FUNCTION get_customer_id_by_keycloak_id(p_customer_keycloak_id keycloak_domain)
RETURNS TABLE (
    "CustomerFn" name_domain,
    "CustomerLn" name_domain,
    "CustomerEmail" email_domain,
    "CustomerPn" pn_domain,
    "CustomerDob" DATE,
    "IsGoogle" BOOLEAN,
    "IsApple" BOOLEAN,
    "Is2fa" BOOLEAN,
    "PronounName" pronoun_domain
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            c.customer_fn AS "CustomerFn",
            c.customer_ln AS "CustomerLn",
            c.customer_email AS "CustomerEmail",
            c.customer_pn AS "CustomerPn",
            c.customer_dob AS "CustomerDob",
            c.is_google AS "IsGoogle",
            c.is_apple AS "IsApple",
            c.is_2fa AS "Is2fa",
            p.pronoun AS "PronounName"
        FROM customers c
        INNER JOIN pronouns p ON p.pronoun_id = c.customer_pronoun_id
        WHERE c.customer_keycloak_id = p_customer_keycloak_id;
END;
$$;*/

/*CREATE OR REPLACE FUNCTION t_get_customer_by_id(p_customer_id INT)
RETURNS TABLE (customer_fn name_domain, pronoun pronoun_domain)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT c.customer_fn, p.pronoun
        FROM customers c
        INNER JOIN pronouns p ON p.pronoun_id = c.customer_pronoun_id
        WHERE c.customer_id = p_customer_id;
END;
$$;*/

/*CREATE OR REPLACE FUNCTION get_city_by_id(p_city_id INT)
RETURNS TABLE (
    city_id INT,
    city_name VARCHAR,
    country_id INT,
    country_name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            ci.city_id,
            ci.city_name,
            co.country_id,
            co.country_name
        FROM cities ci
        INNER JOIN countries co ON co.country_id = ci.country_id
        WHERE ci.city_id = p_city_id;
END;
$$;*/

/*CREATE OR REPLACE FUNCTION get_cities()
RETURNS TABLE (
    city_id INT,
    city_name VARCHAR,
    country_id INT,
    country_name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            ci.city_id,
            ci.city_name,
            co.country_id,
            co.country_name
        FROM cities ci
        INNER JOIN countries co ON co.country_id = ci.country_id;
END;
$$;*/

CREATE OR REPLACE FUNCTION get_top_salon_reviews()
RETURNS TABLE (
    "SalonStarsCount" INT,
    "CustomerSalonReview" VARCHAR,
    "CustomerSalonReviewDate" TIMESTAMP,
    "CustomerPfp" VARCHAR,
    "CustomerFn" name_domain,
    "CustomerLn" name_domain
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            s.salon_stars_count AS "SalonStarsCount",
            s.customer_salon_review AS "CustomerSalonReview",
            s.customer_salon_review_date AS "CustomerSalonReviewDate",
            c.customer_pfp AS "CustomerPfp",
            c.customer_fn AS "CustomerFn",
            c.customer_ln AS "CustomerLn"
        FROM salon_reviews s
        INNER JOIN customers c ON c.customer_id = s.customer_id
        WHERE s.salon_stars_count >= 4
        AND s.customer_salon_review_date >= (CURRENT_DATE - INTERVAL '3 months')
        ORDER BY RANDOM()
        LIMIT 5;
END;
$$;