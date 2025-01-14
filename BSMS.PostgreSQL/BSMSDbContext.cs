using System;
using System.Collections.Generic;
using BSMS.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace BSMS.PostgreSQL;

public partial class BSMSDbContext : DbContext
{
    public BSMSDbContext()
    {
    }

    public BSMSDbContext(DbContextOptions<BSMSDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Address> Addresses { get; set; }

    public virtual DbSet<Appointment> Appointments { get; set; }

    public virtual DbSet<Attendance> Attendances { get; set; }

    public virtual DbSet<Bundle> Bundles { get; set; }

    public virtual DbSet<BundleItem> BundleItems { get; set; }

    public virtual DbSet<Category> Categories { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Country> Countries { get; set; }

    public virtual DbSet<Customer> Customers { get; set; }

    public virtual DbSet<CustomerAddress> CustomerAddresses { get; set; }

    public virtual DbSet<CustomerForm> CustomerForms { get; set; }

    public virtual DbSet<CustomerPreference> CustomerPreferences { get; set; }

    public virtual DbSet<Discount> Discounts { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<EmployeeAddress> EmployeeAddresses { get; set; }

    public virtual DbSet<EmployeeReview> EmployeeReviews { get; set; }

    public virtual DbSet<EmployeeRole> EmployeeRoles { get; set; }

    public virtual DbSet<Form> Forms { get; set; }

    public virtual DbSet<FormType> FormTypes { get; set; }

    public virtual DbSet<Inventory> Inventories { get; set; }

    public virtual DbSet<Preference> Preferences { get; set; }

    public virtual DbSet<Product> Products { get; set; }

    public virtual DbSet<ProductBrand> ProductBrands { get; set; }

    public virtual DbSet<ProductCart> ProductCarts { get; set; }

    public virtual DbSet<ProductCategory> ProductCategories { get; set; }

    public virtual DbSet<ProductFavorite> ProductFavorites { get; set; }

    public virtual DbSet<ProductReview> ProductReviews { get; set; }

    public virtual DbSet<Pronoun> Pronouns { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<SalonReview> SalonReviews { get; set; }

    public virtual DbSet<Service> Services { get; set; }

    public virtual DbSet<ServiceCart> ServiceCarts { get; set; }

    public virtual DbSet<ServiceCategory> ServiceCategories { get; set; }

    public virtual DbSet<ServiceFavorite> ServiceFavorites { get; set; }

    public virtual DbSet<ServiceReview> ServiceReviews { get; set; }

    public virtual DbSet<Transaction> Transactions { get; set; }

    public virtual DbSet<TransactionType> TransactionTypes { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=BSMS;Username=postgres;Password=admin");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasPostgresExtension("citext");

        modelBuilder.Entity<Address>(entity =>
        {
            entity.HasKey(e => e.AddressId).HasName("addresses_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.AddressCity).WithMany(p => p.Addresses)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_addresses_address_city_id");
        });

        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.HasKey(e => e.AppointmentId).HasName("appointments_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.IsWalkIn).HasDefaultValue(false);
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.Appointments)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_appointments_customer_id");

            entity.HasOne(d => d.Employee).WithMany(p => p.Appointments).HasConstraintName("fk_appointments_employee_id");

            entity.HasOne(d => d.Service).WithMany(p => p.Appointments)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_appointments_service_id");
        });

        modelBuilder.Entity<Attendance>(entity =>
        {
            entity.HasKey(e => e.AttendanceId).HasName("attendances_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.EmployeeCheckIn).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Employee).WithMany(p => p.Attendances)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_attendances_employee_id");
        });

        modelBuilder.Entity<Bundle>(entity =>
        {
            entity.HasKey(e => e.BundleId).HasName("bundles_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<BundleItem>(entity =>
        {
            entity.HasKey(e => e.BundleItemId).HasName("bundle_items_pkey");

            entity.Property(e => e.BundleProductQuantity).HasDefaultValue(1);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Bundle).WithMany(p => p.BundleItems)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_bundle_items_bundle_id");

            entity.HasOne(d => d.Product).WithMany(p => p.BundleItems)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_bundle_items_product_id");
        });

        modelBuilder.Entity<Category>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("categories_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.CityId).HasName("cities_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Country).WithMany(p => p.Cities)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_cities_country_id");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.HasKey(e => e.CountryId).HasName("countries_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<Customer>(entity =>
        {
            entity.HasKey(e => e.CustomerId).HasName("customers_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerLastLogin).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerRegistrationDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.Is2fa).HasDefaultValue(false);
            entity.Property(e => e.IsApple).HasDefaultValue(false);
            entity.Property(e => e.IsGoogle).HasDefaultValue(false);
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.Promotions).HasDefaultValue(false);

            entity.HasOne(d => d.CustomerPronoun).WithMany(p => p.Customers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customers_customer_pronoun_id");
        });

        modelBuilder.Entity<CustomerAddress>(entity =>
        {
            entity.HasKey(e => e.CustomerAddressId).HasName("customer_addresses_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Address).WithMany(p => p.CustomerAddresses)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customer_addresses_address_id");

            entity.HasOne(d => d.Customer).WithMany(p => p.CustomerAddresses)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customer_addresses_customer_id");
        });

        modelBuilder.Entity<CustomerForm>(entity =>
        {
            entity.HasKey(e => e.CustomerFormId).HasName("customer_forms_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerFormTimeCompleted).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerFormTimeStarted).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.CustomerForms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customer_forms_customer_id");

            entity.HasOne(d => d.Form).WithMany(p => p.CustomerForms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customer_forms_form_id");
        });

        modelBuilder.Entity<CustomerPreference>(entity =>
        {
            entity.HasKey(e => e.CustomerPreferenceId).HasName("customer_preferences_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.CustomerPreferences)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customer_preferences_customer_id");

            entity.HasOne(d => d.Preference).WithMany(p => p.CustomerPreferences)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customer_preferences_preference_id");
        });

        modelBuilder.Entity<Discount>(entity =>
        {
            entity.HasKey(e => e.DiscountId).HasName("discounts_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Product).WithMany(p => p.Discounts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_discounts_product_id");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.EmployeeId).HasName("employees_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.EmployeeRegistrationDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.EmployeePronoun).WithMany(p => p.Employees)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employees_employee_pronoun_id");

            entity.HasOne(d => d.EmployeeRole).WithMany(p => p.Employees)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employees_employee_role_id");
        });

        modelBuilder.Entity<EmployeeAddress>(entity =>
        {
            entity.HasKey(e => e.EmployeeAddressId).HasName("employee_addresses_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Address).WithMany(p => p.EmployeeAddresses)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employee_addresses_address_id");

            entity.HasOne(d => d.Employee).WithMany(p => p.EmployeeAddresses)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employee_addresses_employee_id");
        });

        modelBuilder.Entity<EmployeeReview>(entity =>
        {
            entity.HasKey(e => e.EmployeeReviewId).HasName("employee_reviews_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerEmployeeReviewDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.EmployeeReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employee_reviews_customer_id");

            entity.HasOne(d => d.Employee).WithMany(p => p.EmployeeReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employee_reviews_employee_id");
        });

        modelBuilder.Entity<EmployeeRole>(entity =>
        {
            entity.HasKey(e => e.EmployeeRoleId).HasName("employee_roles_pkey");

            entity.Property(e => e.Active).HasDefaultValue(true);
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Employee).WithMany(p => p.EmployeeRoles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employee_roles_employee_id");

            entity.HasOne(d => d.Role).WithMany(p => p.EmployeeRoles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employee_roles_role_id");
        });

        modelBuilder.Entity<Form>(entity =>
        {
            entity.HasKey(e => e.FormId).HasName("forms_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.FormType).WithMany(p => p.Forms)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_forms_form_type_id");
        });

        modelBuilder.Entity<FormType>(entity =>
        {
            entity.HasKey(e => e.FormTypeId).HasName("form_types_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<Inventory>(entity =>
        {
            entity.HasKey(e => e.InventoryId).HasName("inventory_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.IsRestocked).HasDefaultValue(false);
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.StockInDate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Product).WithMany(p => p.Inventories)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_inventory_product_id");
        });

        modelBuilder.Entity<Preference>(entity =>
        {
            entity.HasKey(e => e.PreferenceId).HasName("preferences_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Category).WithMany(p => p.Preferences)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_preferences_category_id");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("products_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.ProductBrand).WithMany(p => p.Products)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_products_product_brand_id");

            entity.HasOne(d => d.ProductCategory).WithMany(p => p.Products)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_products_product_category_id");
        });

        modelBuilder.Entity<ProductBrand>(entity =>
        {
            entity.HasKey(e => e.ProductBrandId).HasName("product_brands_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<ProductCart>(entity =>
        {
            entity.HasKey(e => e.ProductCartId).HasName("product_cart_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.ProductCarts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_product_cart_customer_id");

            entity.HasOne(d => d.Product).WithMany(p => p.ProductCarts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_product_cart_product_id");
        });

        modelBuilder.Entity<ProductCategory>(entity =>
        {
            entity.HasKey(e => e.ProductCategoryId).HasName("product_categories_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<ProductFavorite>(entity =>
        {
            entity.HasKey(e => e.ProductFavoriteId).HasName("product_favorites_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.FavoritedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.ProductFavorites)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_product_favorites_customer_id");

            entity.HasOne(d => d.Product).WithMany(p => p.ProductFavorites)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_product_favorites_product_id");
        });

        modelBuilder.Entity<ProductReview>(entity =>
        {
            entity.HasKey(e => e.ProductReviewId).HasName("product_reviews_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerProductReviewDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.ProductReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_product_reviews_customer_id");

            entity.HasOne(d => d.Product).WithMany(p => p.ProductReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_product_reviews_product_id");
        });

        modelBuilder.Entity<Pronoun>(entity =>
        {
            entity.HasKey(e => e.PronounId).HasName("pronouns_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("roles_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<SalonReview>(entity =>
        {
            entity.HasKey(e => e.SalonReviewId).HasName("salon_reviews_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerSalonReviewDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.SalonReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_salon_reviews_customer_id");
        });

        modelBuilder.Entity<Service>(entity =>
        {
            entity.HasKey(e => e.ServiceId).HasName("services_pkey");

            entity.Property(e => e.ServiceId).HasDefaultValueSql("nextval('service_service_id_seq'::regclass)");
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.ServiceCategory).WithMany(p => p.Services)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_services_service_category_id");
        });

        modelBuilder.Entity<ServiceCart>(entity =>
        {
            entity.HasKey(e => e.ServiceCartId).HasName("service_cart_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.ServiceCarts)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_service_cart_customer_id");
        });

        modelBuilder.Entity<ServiceCategory>(entity =>
        {
            entity.HasKey(e => e.ServiceCategoryId).HasName("service_categories_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<ServiceFavorite>(entity =>
        {
            entity.HasKey(e => e.ServiceFavoriteId).HasName("service_favorites_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.FavoritedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.ServiceFavorites)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_service_favorites_customer_id");

            entity.HasOne(d => d.Service).WithMany(p => p.ServiceFavorites)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_service_favorites_service_id");
        });

        modelBuilder.Entity<ServiceReview>(entity =>
        {
            entity.HasKey(e => e.ServiceReviewId).HasName("service_reviews_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.CustomerServiceReviewDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.ServiceReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_service_reviews_customer_id");

            entity.HasOne(d => d.Service).WithMany(p => p.ServiceReviews)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_service_reviews_service_id");
        });

        modelBuilder.Entity<Transaction>(entity =>
        {
            entity.HasKey(e => e.TransactionId).HasName("transactions_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.IsDeposit).HasDefaultValue(false);
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Customer).WithMany(p => p.Transactions)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_transactions_customer_id");

            entity.HasOne(d => d.TransactionType).WithMany(p => p.Transactions)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_transactions_transaction_type_id");
        });

        modelBuilder.Entity<TransactionType>(entity =>
        {
            entity.HasKey(e => e.TransactionTypeId).HasName("transaction_types_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.LastUpdate).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
