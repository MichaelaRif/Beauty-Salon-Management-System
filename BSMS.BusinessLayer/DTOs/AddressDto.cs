namespace BSMS.BusinessLayer.DTOs
{
    public class AddressDto
    {
        public string AddressStreet { get; set; } = null!;
        public string AddressBuilding { get; set; } = null!;
        public string AddressFloor { get; set; } = null!;
        public string? AddressNotes { get; set; }
        public string AddressCity { get; set; } = null!;
    }

}
