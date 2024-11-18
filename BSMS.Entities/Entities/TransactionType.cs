using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("transaction_types")]
public partial class TransactionType
{
    [Key]
    [Column("transaction_type_id")]
    public int TransactionTypeId { get; set; }

    [Column("transaction_type")]
    [StringLength(255)]
    public string TransactionType1 { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("TransactionType")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}
