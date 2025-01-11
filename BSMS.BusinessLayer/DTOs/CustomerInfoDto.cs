namespace BSMS.BusinessLayer.DTOs
{
    public class CustomerInfoDto
    {
        public CustomerDto Customer { get; set; } = null!;
        public AddressDto Address { get; set; } = null!;
    }
}
