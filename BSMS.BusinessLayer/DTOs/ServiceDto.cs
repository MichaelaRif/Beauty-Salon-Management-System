namespace BSMS.BusinessLayer.DTOs
{
    public class ServiceDto
    {
        public int ServiceId { get; set; }
        public string ServiceName { get; set; } = null!;
        public string? ServiceDescription { get; set; }
        public decimal ServicePrice { get; set; }
        public int ServiceCategoryId { get; set; }
        public string ServiceCategoryName { get; set; } = null!;
    }
}
