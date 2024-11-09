namespace BSMS.BusinessLayer.DTOs;
public partial class EmployeeDto
{
    public string? EmployeeFn { get; set; }
    public string EmployeeLn { get; set; } = null!;
    public string? EmployeeEmail { get; set; }
    public string? EmployeePn { get; set; }
    public DateOnly EmployeeDob { get; set; }
    public string EmployeePronouns { get; set; } = null!;
    public string? CityName { get; set; } // fk
    public string? EmployeePfp { get; set; }
    public string? RoleName { get; set; } // fk
    public DateOnly HireDate { get; set; }

}