namespace BSMS.BusinessLayer.DTOs
{
    public class ProductDto
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = null!;
        public string? ProductDescription { get; set; }
        public decimal ProductPrice { get; set; }
        public int ProductBrandId { get; set; }
        public string ProductBrandName { get; set; } = null!;
        public int ProductCategoryId { get; set; }
        public string ProductCategoryName { get; set; } = null!;
    }
}
