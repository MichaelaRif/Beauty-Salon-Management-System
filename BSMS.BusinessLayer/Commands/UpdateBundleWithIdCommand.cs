using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class UpdateBundleWithIdCommand : IRequest<BundleDto>
    {
        public int BundleId { get; }
        public UpdateBundleCommand Command { get; }

        public UpdateBundleWithIdCommand(int id, UpdateBundleCommand command)
        {
            BundleId = id;
            Command = command;
        }
    }
}
