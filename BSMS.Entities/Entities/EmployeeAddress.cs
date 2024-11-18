using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("employee_addresses")]
[Index("AddressId", Name = "idx_employee_addresses_address_id")]
[Index("EmployeeId", Name = "idx_employee_addresses_employee_id")]
public partial class EmployeeAddress
{
    [Key]
    [Column("employee_address_id")]
    public int EmployeeAddressId { get; set; }

    [Column("employee_id")]
    public int EmployeeId { get; set; }

    [Column("address_id")]
    public int AddressId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("AddressId")]
    [InverseProperty("EmployeeAddresses")]
    public virtual Address Address { get; set; } = null!;

    [ForeignKey("EmployeeId")]
    [InverseProperty("EmployeeAddresses")]
    public virtual Employee Employee { get; set; } = null!;
}
