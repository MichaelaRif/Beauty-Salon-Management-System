using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.BusinessLayer.DTOs;

public partial class EmployeeRoleDto
{
    public string Employee { get; set; } = null!; //fk
    public string Role { get; set; } = null!; //fk
}
