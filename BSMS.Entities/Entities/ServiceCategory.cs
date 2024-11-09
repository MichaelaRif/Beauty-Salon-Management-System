using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("service_categories")]
public partial class ServiceCategory
{
    [Key]
    [Column("service_category_id")]
    public int ServiceCategoryId { get; set; }

    [Column("service_category_name")]
    [StringLength(255)]
    public string ServiceCategoryName { get; set; } = null!;

    [Column("service_category_description")]
    [StringLength(255)]
    public string ServiceCategoryDescription { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("ServiceCategory")]
    public virtual ICollection<Service> Services { get; set; } = new List<Service>();
}
