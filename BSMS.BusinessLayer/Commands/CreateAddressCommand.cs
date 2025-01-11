using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateAddressCommand : IRequest<int>
    {
        public string AddressStreet { get; set; } = null!;
        public string AddressBuilding { get; set; } = null!;
        public int AddressFloor { get; set; }
        public string? AddressNotes { get; set; }
        public int City { get; set; }
    }
}
