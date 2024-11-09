namespace BSMS.BusinessLayer.DTOs;

public partial class RoleDto
{
    public string RoleName { get; set; } = null!;
    public string? RoleDescription { get; set; }
    public decimal RoleSalary { get; set; }
}
