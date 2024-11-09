using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSMS.Domain.Entities;

[Table("bundles")]
[Index("BundleName", Name = "uq_bundles_bundle_name", IsUnique = true)]
public partial class Bundle
{
    [Key]
    [Column("bundle_id")]
    public int BundleId { get; set; }

    [Column("bundle_name")]
    [StringLength(255)]
    public string BundleName { get; set; } = null!;

    [Column("bundle_description")]
    [StringLength(255)]
    public string? BundleDescription { get; set; }

    [Column("bundle_price", TypeName = "money")]
    public decimal BundlePrice { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Bundle")]
    public virtual ICollection<BundleItem> BundleItems { get; set; } = new List<BundleItem>();
}
