using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("preferences")]
public partial class Preference
{
    [Key]
    [Column("preference_id")]
    public int PreferenceId { get; set; }

    [Column("preference_name")]
    [StringLength(255)]
    public string PreferenceName { get; set; } = null!;

    [Column("preference_description")]
    [StringLength(255)]
    public string? PreferenceDescription { get; set; }

    [Column("category_id")]
    public int CategoryId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CategoryId")]
    [InverseProperty("Preferences")]
    public virtual Category Category { get; set; } = null!;

    [InverseProperty("Preference")]
    public virtual ICollection<CustomerPreference> CustomerPreferences { get; set; } = new List<CustomerPreference>();
}
