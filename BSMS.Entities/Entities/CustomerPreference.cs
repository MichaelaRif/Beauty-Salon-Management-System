using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("customer_preferences")]
public partial class CustomerPreference
{
    [Key]
    [Column("customer_preference_id")]
    public int CustomerPreferenceId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("preference_id")]
    public int PreferenceId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("CustomerPreferences")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("PreferenceId")]
    [InverseProperty("CustomerPreferences")]
    public virtual Preference Preference { get; set; } = null!;
}
