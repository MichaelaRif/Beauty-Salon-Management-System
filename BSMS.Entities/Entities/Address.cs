using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("addresses")]
[Index("AddressId", Name = "idx_addresses_address_id")]
[Index("AddressCityId", Name = "idx_addresses_city_id")]
public partial class Address
{
    [Key]
    [Column("address_id")]
    public int AddressId { get; set; }

    [Column("address_street")]
    [StringLength(255)]
    public string AddressStreet { get; set; } = null!;

    [Column("address_building")]
    [StringLength(255)]
    public string AddressBuilding { get; set; } = null!;

    [Column("address_floor")]
    [StringLength(255)]
    public string AddressFloor { get; set; } = null!;

    [Column("address_notes")]
    [StringLength(255)]
    public string? AddressNotes { get; set; }

    [Column("address_city_id")]
    public int AddressCityId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("AddressCityId")]
    [InverseProperty("Addresses")]
    public virtual City AddressCity { get; set; } = null!;

    [InverseProperty("Address")]
    public virtual ICollection<CustomerAddress> CustomerAddresses { get; set; } = new List<CustomerAddress>();

    [InverseProperty("Address")]
    public virtual ICollection<EmployeeAddress> EmployeeAddresses { get; set; } = new List<EmployeeAddress>();
}
