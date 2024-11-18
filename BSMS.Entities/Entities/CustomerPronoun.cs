using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("customer_pronouns")]
[Index("CustomerId", Name = "idx_customer_pronouns_customer_id")]
[Index("PronounId", Name = "idx_customer_pronouns_pronoun_id")]
public partial class CustomerPronoun
{
    [Key]
    [Column("customer_pronoun_id")]
    public int CustomerPronounId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("pronoun_id")]
    public int PronounId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("CustomerPronouns")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("PronounId")]
    [InverseProperty("CustomerPronouns")]
    public virtual Pronoun Pronoun { get; set; } = null!;
}
