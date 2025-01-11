using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("form_types")]
public partial class FormType
{
    [Key]
    [Column("form_type_id")]
    public int FormTypeId { get; set; }

    [Column("form_type", TypeName = "citext")]
    public string FormType1 { get; set; } = null!;

    [Column("form_type_description")]
    [StringLength(255)]
    public string? FormTypeDescription { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("FormType")]
    public virtual ICollection<Form> Forms { get; set; } = new List<Form>();
}
