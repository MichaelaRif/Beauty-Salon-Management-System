using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("employee_roles")]
[Index("EmployeeId", Name = "idx_employee_roles_employee_id")]
[Index("RoleId", Name = "idx_employee_roles_role_id")]
public partial class EmployeeRole
{
    [Key]
    [Column("employee_role_id")]
    public int EmployeeRoleId { get; set; }

    [Column("employee_id")]
    public int EmployeeId { get; set; }

    [Column("role_id")]
    public int RoleId { get; set; }

    [Column("active")]
    public bool Active { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("EmployeeId")]
    [InverseProperty("EmployeeRoles")]
    public virtual Employee Employee { get; set; } = null!;

    [InverseProperty("EmployeeRole")]
    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    [ForeignKey("RoleId")]
    [InverseProperty("EmployeeRoles")]
    public virtual Role Role { get; set; } = null!;
}
