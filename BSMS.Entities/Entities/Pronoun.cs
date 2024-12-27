using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("pronouns")]
[Index("Pronoun1", Name = "uq_pronouns_pronoun", IsUnique = true)]
public partial class Pronoun
{
    [Key]
    [Column("pronoun_id")]
    public int PronounId { get; set; }

    [Column("pronoun", TypeName = "citext")]
    public string Pronoun1 { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("CustomerPronoun")]
    public virtual ICollection<Customer> Customers { get; set; } = new List<Customer>();

    [InverseProperty("EmployeePronoun")]
    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
