﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("attendances")]
public partial class Attendance
{
    [Key]
    [Column("attendance_id")]
    public int AttendanceId { get; set; }

    [Column("employee_id")]
    public int EmployeeId { get; set; }

    [Column("employee_check_in", TypeName = "timestamp without time zone")]
    public DateTime EmployeeCheckIn { get; set; }

    [Column("employee_check_out", TypeName = "timestamp without time zone")]
    public DateTime EmployeeCheckOut { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("EmployeeId")]
    [InverseProperty("Attendances")]
    public virtual Employee Employee { get; set; } = null!;
}
