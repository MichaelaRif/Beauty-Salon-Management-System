using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class UpdateAddressCommand : IRequest<Unit>
    {
        public int AddressId { get; set; }
        public string AddressStreet { get; set; } = null!;
        public string AddressBuilding { get; set; } = null!;
        public int AddressFloor { get; set; }
        public string? AddressNotes { get; set; }
        public int City { get; set; }
    }
}
