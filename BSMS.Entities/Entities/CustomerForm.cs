using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("customer_forms")]
public partial class CustomerForm
{
    [Key]
    [Column("customer_form_id")]
    public int CustomerFormId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("form_id")]
    public int FormId { get; set; }

    [Column("customer_form_time_started", TypeName = "timestamp without time zone")]
    public DateTime CustomerFormTimeStarted { get; set; }

    [Column("customer_form_time_completed", TypeName = "timestamp without time zone")]
    public DateTime CustomerFormTimeCompleted { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("CustomerForms")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("FormId")]
    [InverseProperty("CustomerForms")]
    public virtual Form Form { get; set; } = null!;
}
