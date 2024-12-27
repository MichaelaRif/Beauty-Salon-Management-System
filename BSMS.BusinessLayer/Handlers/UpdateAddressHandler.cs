using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class UpdateAddressHandler : IRequestHandler<UpdateAddressCommand, Unit>
    {
        private readonly IAddressRepository _addressRepository;

        public UpdateAddressHandler(IAddressRepository addressRepository)
        {
            _addressRepository = addressRepository;
        }

        public async Task<Unit> Handle(UpdateAddressCommand request, CancellationToken cancellationToken)
        {
            var existingAddress = await _addressRepository.GetByIdAsync(request.AddressId);

            existingAddress.AddressStreet = request.AddressStreet;
            existingAddress.AddressBuilding = request.AddressBuilding;
            existingAddress.AddressFloor = request.AddressFloor;
            existingAddress.AddressNotes = request.AddressNotes;
            existingAddress.AddressCityId = request.City;

            await _addressRepository.UpdateAsync(existingAddress);

            return Unit.Value;
        }
    }
}
