using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("forms")]
[Index("FormName", Name = "uq_forms_form_name", IsUnique = true)]
public partial class Form
{
    [Key]
    [Column("form_id")]
    public int FormId { get; set; }

    [Column("form_name")]
    [StringLength(255)]
    public string FormName { get; set; } = null!;

    [Column("form_description")]
    [StringLength(255)]
    public string? FormDescription { get; set; }

    [Column("form_type_id")]
    public int FormTypeId { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Form")]
    public virtual ICollection<CustomerForm> CustomerForms { get; set; } = new List<CustomerForm>();

    [ForeignKey("FormTypeId")]
    [InverseProperty("Forms")]
    public virtual FormType FormType { get; set; } = null!;
}
