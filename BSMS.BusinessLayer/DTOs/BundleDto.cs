namespace BSMS.BusinessLayer.DTOs;

public partial class BundleDto
{
    public string BundleName { get; set; } = null!;
    public string? BundleDescription { get; set; }
    public decimal BundlePrice { get; set; }
}
