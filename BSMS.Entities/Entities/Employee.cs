﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("employees")]
public partial class Employee
{
    [Key]
    [Column("employee_id")]
    public int EmployeeId { get; set; }

    [Column("employee_keycloak_id", TypeName = "citext")]
    public string EmployeeKeycloakId { get; set; } = null!;

    [Column("employee_fn", TypeName = "citext")]
    public string? EmployeeFn { get; set; }

    [Column("employee_ln", TypeName = "citext")]
    public string EmployeeLn { get; set; } = null!;

    [Column("employee_email", TypeName = "citext")]
    public string? EmployeeEmail { get; set; }

    [Column("employee_pn", TypeName = "citext")]
    public string? EmployeePn { get; set; }

    [Column("employee_dob")]
    public DateOnly EmployeeDob { get; set; }

    [Column("employee_pronoun_id")]
    public int EmployeePronounId { get; set; }

    [Column("employee_pfp")]
    [StringLength(255)]
    public string? EmployeePfp { get; set; }

    [Column("employee_role_id")]
    public int EmployeeRoleId { get; set; }

    [Column("hire_date")]
    public DateOnly HireDate { get; set; }

    [Column("employee_registration_date", TypeName = "timestamp without time zone")]
    public DateTime EmployeeRegistrationDate { get; set; }

    [Column("employee_last_login", TypeName = "timestamp without time zone")]
    public DateTime EmployeeLastLogin { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Employee")]
    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    [InverseProperty("Employee")]
    public virtual ICollection<Attendance> Attendances { get; set; } = new List<Attendance>();

    [InverseProperty("Employee")]
    public virtual ICollection<EmployeeAddress> EmployeeAddresses { get; set; } = new List<EmployeeAddress>();

    [ForeignKey("EmployeePronounId")]
    [InverseProperty("Employees")]
    public virtual Pronoun EmployeePronoun { get; set; } = null!;

    [InverseProperty("Employee")]
    public virtual ICollection<EmployeeReview> EmployeeReviews { get; set; } = new List<EmployeeReview>();

    [ForeignKey("EmployeeRoleId")]
    [InverseProperty("Employees")]
    public virtual EmployeeRole EmployeeRole { get; set; } = null!;

    [InverseProperty("Employee")]
    public virtual ICollection<EmployeeRole> EmployeeRoles { get; set; } = new List<EmployeeRole>();
}
