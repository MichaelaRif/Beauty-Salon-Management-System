using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("appointments")]
public partial class Appointment
{
    [Key]
    [Column("appointment_id")]
    public int AppointmentId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("service_id")]
    public int ServiceId { get; set; }

    [Column("employee_id")]
    public int? EmployeeId { get; set; }

    [Column("appointment_date", TypeName = "timestamp without time zone")]
    public DateTime AppointmentDate { get; set; }

    [Column("is_walk_in")]
    public bool IsWalkIn { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("Appointments")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("EmployeeId")]
    [InverseProperty("Appointments")]
    public virtual Employee? Employee { get; set; }

    [ForeignKey("ServiceId")]
    [InverseProperty("Appointments")]
    public virtual Service Service { get; set; } = null!;
}
