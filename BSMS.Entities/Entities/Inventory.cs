using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("inventory")]
[Index("InventoryId", Name = "idx_inventory_inventory_id")]
[Index("IsRestocked", Name = "idx_inventory_is_restocked")]
[Index("ProductId", Name = "idx_inventory_product_id")]
[Index("StockOutDate", Name = "idx_inventory_stock_out_date")]
public partial class Inventory
{
    [Key]
    [Column("inventory_id")]
    public int InventoryId { get; set; }

    [Column("product_id")]
    public int ProductId { get; set; }

    [Column("production_date")]
    public DateOnly? ProductionDate { get; set; }

    [Column("expiry_date")]
    public DateOnly? ExpiryDate { get; set; }

    [Column("stock_in_date")]
    public DateOnly StockInDate { get; set; }

    [Column("stock_out_date")]
    public DateOnly? StockOutDate { get; set; }

    [Column("is_restocked")]
    public bool IsRestocked { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("ProductId")]
    [InverseProperty("Inventories")]
    public virtual Product Product { get; set; } = null!;
}
