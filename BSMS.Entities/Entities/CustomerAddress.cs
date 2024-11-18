using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("customer_addresses")]
[Index("AddressId", Name = "idx_customer_addresses_address_id")]
[Index("CustomerId", Name = "idx_customer_addresses_customer_id")]
public partial class CustomerAddress
{
    [Key]
    [Column("customer_address_id")]
    public int CustomerAddressId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("address_id")]
    public int AddressId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("AddressId")]
    [InverseProperty("CustomerAddresses")]
    public virtual Address Address { get; set; } = null!;

    [ForeignKey("CustomerId")]
    [InverseProperty("CustomerAddresses")]
    public virtual Customer Customer { get; set; } = null!;
}
