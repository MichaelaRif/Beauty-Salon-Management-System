using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("employee_pronouns")]
public partial class EmployeePronoun
{
    [Key]
    [Column("employee_pronoun_id")]
    public int EmployeePronounId { get; set; }

    [Column("employee_id")]
    public int EmployeeId { get; set; }

    [Column("pronoun_id")]
    public int PronounId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("EmployeeId")]
    [InverseProperty("EmployeePronouns")]
    public virtual Employee Employee { get; set; } = null!;

    [InverseProperty("EmployeePronoun")]
    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    [ForeignKey("PronounId")]
    [InverseProperty("EmployeePronouns")]
    public virtual Pronoun Pronoun { get; set; } = null!;
}
