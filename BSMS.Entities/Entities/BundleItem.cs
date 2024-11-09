using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSMS.Domain.Entities;

[Table("bundle_items")]
public partial class BundleItem
{
    [Key]
    [Column("bundle_item_id")]
    public int BundleItemId { get; set; }

    [Column("bundle_id")]
    public int BundleId { get; set; }

    [Column("product_id")]
    public int ProductId { get; set; }

    [Column("bundle_product_quantity")]
    public int BundleProductQuantity { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("BundleId")]
    [InverseProperty("BundleItems")]
    public virtual Bundle Bundle { get; set; } = null!;

    [ForeignKey("ProductId")]
    [InverseProperty("BundleItems")]
    public virtual Product Product { get; set; } = null!;
}
