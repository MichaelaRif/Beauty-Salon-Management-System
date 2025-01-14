using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("customers")]
[Index("CustomerDob", Name = "idx_customers_customer_dob")]
[Index("CustomerPronounId", Name = "idx_customers_customer_pronoun_id")]
[Index("CustomerEmail", Name = "uq_customers_customer_email", IsUnique = true)]
public partial class Customer
{
    [Key]
    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("customer_keycloak_id", TypeName = "citext")]
    public string CustomerKeycloakId { get; set; } = null!;

    [Column("customer_fn", TypeName = "citext")]
    public string CustomerFn { get; set; } = null!;

    [Column("customer_ln", TypeName = "citext")]
    public string CustomerLn { get; set; } = null!;

    [Column("customer_email", TypeName = "citext")]
    public string? CustomerEmail { get; set; }

    [Column("customer_pn", TypeName = "citext")]
    public string? CustomerPn { get; set; }

    [Column("customer_dob")]
    public DateOnly CustomerDob { get; set; }

    [Column("customer_pronoun_id")]
    public int CustomerPronounId { get; set; }

    [Column("promotions")]
    public bool Promotions { get; set; }

    [Column("customer_pfp")]
    [StringLength(255)]
    public string? CustomerPfp { get; set; }

    [Column("is_google")]
    public bool IsGoogle { get; set; }

    [Column("is_apple")]
    public bool IsApple { get; set; }

    [Column("is_2fa")]
    public bool Is2fa { get; set; }

    [Column("customer_registration_date", TypeName = "timestamp without time zone")]
    public DateTime CustomerRegistrationDate { get; set; }

    [Column("customer_last_login", TypeName = "timestamp without time zone")]
    public DateTime CustomerLastLogin { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Customer")]
    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    [InverseProperty("Customer")]
    public virtual ICollection<CustomerAddress> CustomerAddresses { get; set; } = new List<CustomerAddress>();

    [InverseProperty("Customer")]
    public virtual ICollection<CustomerForm> CustomerForms { get; set; } = new List<CustomerForm>();

    [InverseProperty("Customer")]
    public virtual ICollection<CustomerPreference> CustomerPreferences { get; set; } = new List<CustomerPreference>();

    [ForeignKey("CustomerPronounId")]
    [InverseProperty("Customers")]
    public virtual Pronoun CustomerPronoun { get; set; } = null!;

    [InverseProperty("Customer")]
    public virtual ICollection<EmployeeReview> EmployeeReviews { get; set; } = new List<EmployeeReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<ProductCart> ProductCarts { get; set; } = new List<ProductCart>();

    [InverseProperty("Customer")]
    public virtual ICollection<ProductFavorite> ProductFavorites { get; set; } = new List<ProductFavorite>();

    [InverseProperty("Customer")]
    public virtual ICollection<ProductReview> ProductReviews { get; set; } = new List<ProductReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<SalonReview> SalonReviews { get; set; } = new List<SalonReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<ServiceCart> ServiceCarts { get; set; } = new List<ServiceCart>();

    [InverseProperty("Customer")]
    public virtual ICollection<ServiceFavorite> ServiceFavorites { get; set; } = new List<ServiceFavorite>();

    [InverseProperty("Customer")]
    public virtual ICollection<ServiceReview> ServiceReviews { get; set; } = new List<ServiceReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}
