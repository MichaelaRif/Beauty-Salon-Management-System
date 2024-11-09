using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("services")]
[Index("ServiceCategoryId", Name = "idx_services_service_category_id")]
[Index("ServicePrice", Name = "idx_services_service_price")]
[Index("ServiceName", Name = "uq_services_service_name", IsUnique = true)]
public partial class Service
{
    [Key]
    [Column("service_id")]
    public int ServiceId { get; set; }

    [Column("service_name")]
    [StringLength(255)]
    public string ServiceName { get; set; } = null!;

    [Column("service_description")]
    [StringLength(255)]
    public string? ServiceDescription { get; set; }

    [Column("service_price", TypeName = "money")]
    public decimal? ServicePrice { get; set; }

    [Column("service_category_id")]
    public int ServiceCategoryId { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Service")]
    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    [ForeignKey("ServiceCategoryId")]
    [InverseProperty("Services")]
    public virtual ServiceCategory ServiceCategory { get; set; } = null!;

    [InverseProperty("Service")]
    public virtual ICollection<ServiceFavorite> ServiceFavorites { get; set; } = new List<ServiceFavorite>();

    [InverseProperty("Service")]
    public virtual ICollection<ServiceReview> ServiceReviews { get; set; } = new List<ServiceReview>();
}
