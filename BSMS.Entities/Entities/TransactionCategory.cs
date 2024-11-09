using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("transaction_categories")]
public partial class TransactionCategory
{
    [Key]
    [Column("transaction_category_id")]
    public int TransactionCategoryId { get; set; }

    [Column("transaction_category")]
    [StringLength(255)]
    public string TransactionCategory1 { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("TransactionCategory")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}
