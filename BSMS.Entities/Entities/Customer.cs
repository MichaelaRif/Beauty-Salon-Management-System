using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("customers")]
[Index("CustomerCityId", Name = "idx_customers_address")]
[Index("CustomerDob", Name = "idx_customers_customer_dob")]
[Index("CustomerPronouns", Name = "idx_customers_customer_pronouns")]
[Index("Preferences", Name = "idx_customers_preferences")]
[Index("CustomerEmail", Name = "uq_customers_customer_email", IsUnique = true)]
public partial class Customer
{
    [Key]
    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("customer_fn", TypeName = "citext")]
    public string CustomerFn { get; set; } = null!;

    [Column("customer_ln", TypeName = "citext")]
    public string CustomerLn { get; set; } = null!;

    [Column("customer_email", TypeName = "citext")]
    public string? CustomerEmail { get; set; }

    [Column("customer_pn", TypeName = "citext")]
    public string? CustomerPn { get; set; }

    [Column("customer_passhash")]
    [StringLength(255)]
    public string CustomerPasshash { get; set; } = null!;

    [Column("customer_dob")]
    public DateOnly CustomerDob { get; set; }

    [Column("customer_pronouns")]
    [StringLength(255)]
    public string CustomerPronouns { get; set; } = null!;

    [Column("customer_city_id")]
    public int CustomerCityId { get; set; }

    [Column("preferences", TypeName = "jsonb")]
    public string? Preferences { get; set; }

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

    [Column("customer_registration_date", TypeName = "timestamp(6) without time zone")]
    public DateTime CustomerRegistrationDate { get; set; }

    [Column("customer_last_login", TypeName = "timestamp(6) without time zone")]
    public DateTime CustomerLastLogin { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Customer")]
    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    [ForeignKey("CustomerCityId")]
    [InverseProperty("Customers")]
    public virtual City CustomerCity { get; set; } = null!;

    [InverseProperty("Customer")]
    public virtual ICollection<CustomerForm> CustomerForms { get; set; } = new List<CustomerForm>();

    [InverseProperty("Customer")]
    public virtual ICollection<EmployeeReview> EmployeeReviews { get; set; } = new List<EmployeeReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<ProductFavorite> ProductFavorites { get; set; } = new List<ProductFavorite>();

    [InverseProperty("Customer")]
    public virtual ICollection<ProductReview> ProductReviews { get; set; } = new List<ProductReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<ServiceFavorite> ServiceFavorites { get; set; } = new List<ServiceFavorite>();

    [InverseProperty("Customer")]
    public virtual ICollection<ServiceReview> ServiceReviews { get; set; } = new List<ServiceReview>();

    [InverseProperty("Customer")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}
