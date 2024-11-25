------------------------
-- Extensions
------------------------
CREATE EXTENSION IF NOT EXISTS citext;

------------------------
-- ENUMs
------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'appointment_status') THEN
        CREATE TYPE "public"."appointment_status" AS ENUM (
            'Booked',
            'Completed',
            'Cancelled',
            'Postponed',
            'Other'
        );
    END IF;
END $$;
ALTER TYPE "public"."appointment_status" OWNER TO "postgres";

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'form_type') THEN
        CREATE TYPE "public"."form_type" AS ENUM (
            'Test',
            'Quiz',
            'Survey',
            'Other'
        );
    END IF;
END $$;
ALTER TYPE "public"."form_type" OWNER TO "postgres";

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'pronoun') THEN
        CREATE TYPE "public"."pronoun" AS ENUM (
            'he/him',
            'she/her',
            'they/them',
            'other'
        );
    END IF;
END $$;
ALTER TYPE "public"."pronoun" OWNER TO "postgres";

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'transaction_status') THEN
        CREATE TYPE "public"."transaction_status" AS ENUM (
            'Pending',
            'Completed',
            'Failed'
        );
    END IF;
END $$;
ALTER TYPE "public"."transaction_status" OWNER TO "postgres";

------------------------
-- Domains
------------------------
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
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'email_domain') THEN
        CREATE DOMAIN "public"."email_domain" AS citext
        CHECK(VALUE ~* '^[A-Za-z0-9.-_]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_type WHERE typname = 'keycloak_domain') THEN
        CREATE DOMAIN "public"."keycloak_domain" AS citext
        CHECK(VALUE ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
    END IF;
END $$;

------------------------
-- Tables & Sequences
------------------------
CREATE TABLE IF NOT EXISTS public.addresses (
    address_id INT NOT NULL,
    address_street VARCHAR(255) NOT NULL,
    address_building VARCHAR(255) NOT NULL,
    address_floor VARCHAR(255) NOT NULL,
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
    appointment_status public.appointment_status NOT NULL,
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
    customer_product_review text,
    customer_product_review_date timestamp without time zone NOT NULL,
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
    form_type public.form_type,
    form_type_description text,
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
    customer_product_review text,
    customer_product_review_date timestamp without time zone NOT NULL,
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
    pronoun public.pronoun,
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
    customer_service_review text,
    customer_service_review_date timestamp without time zone NOT NULL,
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
    transaction_status public.transaction_status NOT NULL,
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

INSERT INTO public.cities(city_name, country_id) VALUES ('Abha', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Abu Dhabi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Acua', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Adana', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Addis Abeba', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Aden', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Adoni', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ahmadnagar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Akishima', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Akron', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('al-Ayn', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('al-Hawiya', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('al-Manama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('al-Qadarif', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('al-Qatif', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Alessandria', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Allappuzha (Alleppey)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Allende', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Almirante Brown', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Alvorada', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ambattur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Amersfoort', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Amroha', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Angra dos Reis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Anpolis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Antofagasta', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Aparecida de Goinia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Apeldoorn', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Araatuba', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Arak', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Arecibo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Arlington', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ashdod', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ashgabat', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ashqelon', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Asuncin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Athenai', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Atinsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Atlixco', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Augusta-Richmond County', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Aurora', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Avellaneda', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bag', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Baha Blanca', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Baicheng', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Baiyin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Baku', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Balaiha', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Balikesir', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Balurghat', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bamenda', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bandar Seri Begawan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Banjul', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Barcelona', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Basel', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bat Yam', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Batman', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Batna', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Battambang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Baybay', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bayugan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bchar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Beira', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bellevue', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Belm', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Benguela', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Beni-Mellal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Benin City', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bergamo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Berhampore (Baharampur)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bern', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bhavnagar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bhilwara', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bhimavaram', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bhopal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bhusawal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bijapur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bilbays', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Binzhou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Birgunj', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bislig', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Blumenau', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Boa Vista', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Boksburg', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Botosani', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Botshabelo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bradford', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Braslia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bratislava', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Brescia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Brest', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Brindisi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Brockton', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bucuresti', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Buenaventura', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Bydgoszcz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cabuyao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Callao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cam Ranh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cape Coral', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Caracas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Carmen', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cavite', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cayenne', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Celaya', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chandrapur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Changhwa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Changzhou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chapra', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Charlotte Amalie', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chatsworth', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cheju', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chiayi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chisinau', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Chungho', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cianjur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ciomas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ciparay', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Citrus Heights', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Citt del Vaticano', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ciudad del Este', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Clarksville', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Coacalco de Berriozbal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Coatzacoalcos', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Compton', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Coquimbo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Crdoba', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cuauhtmoc', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cuautla', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cuernavaca', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Cuman', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Czestochowa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dadu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dallas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Datong', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Daugavpils', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Davao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Daxian', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dayton', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Deba Habe', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Denizli', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dhaka', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dhule (Dhulia)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dongying', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Donostia-San Sebastin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dos Quebradas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Duisburg', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dundee', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Dzerzinsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ede', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Effon-Alaiye', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('El Alto', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('El Fuerte', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('El Monte', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Elista', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Emeishan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Emmen', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Enshi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Erlangen', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Escobar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Esfahan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Eskisehir', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Etawah', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ezeiza', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ezhou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Faaa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Fengshan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Firozabad', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Florencia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Fontana', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Fukuyama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Funafuti', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Fuyu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Fuzhou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gandhinagar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Garden Grove', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Garland', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gatineau', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gaziantep', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gijn', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gingoog', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Goinia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gorontalo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Grand Prairie', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Graz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Greensboro', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Guadalajara', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Guaruj', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('guas Lindas de Gois', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Gulbarga', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hagonoy', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Haining', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Haiphong', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Haldia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Halifax', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Halisahar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Halle/Saale', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hami', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hamilton', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hanoi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hidalgo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Higashiosaka', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hino', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hiroshima', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hodeida', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hohhot', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hoshiarpur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hsichuh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Huaian', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hubli-Dharwad', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Huejutla de Reyes', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Huixquilucan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Hunuco', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ibirit', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Idfu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ife', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ikerre', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Iligan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ilorin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Imus', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Inegl', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ipoh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Isesaki', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ivanovo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Iwaki', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Iwakuni', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Iwatsuki', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Izumisano', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jaffna', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jaipur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jakarta', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jalib al-Shuyukh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jamalpur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jaroslavl', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jastrzebie-Zdrj', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jedda', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jelets', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jhansi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jinchang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jining', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jinzhou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jodhpur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Johannesburg', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Joliet', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jos Azueta', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Juazeiro do Norte', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Juiz de Fora', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Junan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Jurez', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kabul', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kaduna', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kakamigahara', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kaliningrad', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kalisz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kamakura', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kamarhati', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kamjanets-Podilskyi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kamyin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kanazawa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kanchrapara', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kansas City', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Karnal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Katihar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kermanshah', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kilis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kimberley', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kimchon', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kingstown', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kirovo-Tepetsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kisumu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kitwe', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Klerksdorp', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kolpino', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Konotop', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Koriyama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Korla', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Korolev', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kowloon and New Kowloon', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kragujevac', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ktahya', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kuching', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kumbakonam', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kurashiki', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kurgan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kursk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Kuwana', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('La Paz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('La Plata', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('La Romana', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Laiwu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lancaster', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Laohekou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lapu-Lapu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Laredo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lausanne', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Le Mans', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lengshuijiang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Leshan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lethbridge', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lhokseumawe', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Liaocheng', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Liepaja', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lilongwe', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lima', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lincoln', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Linz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lipetsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Livorno', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ljubertsy', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Loja', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('London', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('London', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lublin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lubumbashi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Lungtan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Luzinia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Madiun', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mahajanga', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Maikop', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Malm', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Manchester', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mandaluyong', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mandi Bahauddin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mannheim', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Maracabo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mardan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Maring', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Masqat', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Matamoros', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Matsue', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Meixian', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Memphis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Merlo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mexicali', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Miraj', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mit Ghamr', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Miyakonojo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mogiljov', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Molodetno', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Monclova', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Monywa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Moscow', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mosul', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mukateve', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Munger (Monghyr)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mwanza', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mwene-Ditu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Myingyan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Mysore', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Naala-Porto', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nabereznyje Telny', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nador', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nagaon', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nagareyama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Najafabad', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Naju', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nakhon Sawan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nam Dinh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Namibe', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nantou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nanyang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('NDjamna', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Newcastle', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nezahualcyotl', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nha Trang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Niznekamsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Novi Sad', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Novoterkassk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nukualofa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nuuk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Nyeri', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ocumare del Tuy', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ogbomosho', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Okara', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Okayama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Okinawa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Olomouc', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Omdurman', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Omiya', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ondo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Onomichi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Oshawa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Osmaniye', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('ostka', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Otsu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Oulu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ourense (Orense)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Owo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Oyo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ozamis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Paarl', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pachuca de Soto', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pak Kret', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Palghat (Palakkad)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pangkal Pinang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Papeete', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Parbhani', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pathankot', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Patiala', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Patras', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pavlodar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pemalang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Peoria', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pereira', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Phnom Penh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pingxiang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pjatigorsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Plock', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Po', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ponce', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pontianak', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Poos de Caldas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Portoviejo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Probolinggo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pudukkottai', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pune', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Purnea (Purnia)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Purwakarta', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Pyongyang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Qalyub', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Qinhuangdao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Qomsheh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Quilmes', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rae Bareli', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rajkot', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rampur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rancagua', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ranchi', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Richmond Hill', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rio Claro', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rizhao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Roanoke', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Robamba', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rockford', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ruse', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Rustenburg', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('s-Hertogenbosch', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Saarbrcken', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sagamihara', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Saint Louis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Saint-Denis', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Salala', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Salamanca', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Salinas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Salzburg', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sambhal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('San Bernardino', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('San Felipe de Puerto Plata', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('San Felipe del Progreso', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('San Juan Bautista Tuxtepec', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('San Lorenzo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('San Miguel de Tucumn', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sanaa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Santa Brbara dOeste', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Santa F', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Santa Rosa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Santiago de Compostela', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Santiago de los Caballeros', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Santo Andr', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sanya', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sasebo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Satna', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sawhaj', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Serpuhov', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shahr-e Kord', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shanwei', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shaoguan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sharja', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shenzhen', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shikarpur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shimoga', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shimonoseki', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shivapuri', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Shubra al-Khayma', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Siegen', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Siliguri (Shiliguri)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Simferopol', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sincelejo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sirjan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sivas', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Skikda', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Smolensk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('So Bernardo do Campo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('So Leopoldo', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sogamoso', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sokoto', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Songkhla', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sorocaba', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Soshanguve', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sousse', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('South Hill', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Southampton', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Southend-on-Sea', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Southport', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Springs', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Stara Zagora', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sterling Heights', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Stockport', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sucre', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Suihua', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sullana', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sultanbeyli', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sumqayit', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sumy', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sungai Petani', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Sunnyvale', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Surakarta', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Syktyvkar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Syrakusa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Szkesfehrvr', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tabora', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tabriz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tabuk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tafuna', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Taguig', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Taizz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Talavera', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tallahassee', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tambaram', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tanauan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tandil', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tangail', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tanshui', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tanza', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tarlac', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tarsus', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tartu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Teboksary', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tegal', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tel Aviv-Jaffa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tete', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tianjin', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tiefa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tieli', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tokat', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tonghae', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tongliao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Torren', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Touliu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Toulon', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Toulouse', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Trshavn', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tsaotun', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tsuyama', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tuguegarao', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Tychy', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Udaipur', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Udine', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ueda', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Uijongbu', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Uluberia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Urawa', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Uruapan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Usak', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Usolje-Sibirskoje', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Uttarpara-Kotrung', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vaduz', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Valencia', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Valle de la Pascua', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Valle de Santiago', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Valparai', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vancouver', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Varanasi (Benares)', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vicente Lpez', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vijayawada', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vila Velha', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vilnius', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vinh', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Vitria de Santo Anto', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Warren', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Weifang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Witten', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Woodridge', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Wroclaw', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Xiangfan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Xiangtan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Xintai', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Xinxiang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yamuna Nagar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yangor', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yantai', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yaound', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yerevan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yinchuan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yingkou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('York', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yuncheng', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Yuzhou', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zalantun', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zanzibar', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zaoyang', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zapopan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zaria', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zeleznogorsk', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zhezqazghan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Zhoushan', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;
INSERT INTO public.cities(city_name, country_id) VALUES ('Ziguinchor', trunc(random() * 195 + 1)) ON CONFLICT (city_id) DO NOTHING;

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