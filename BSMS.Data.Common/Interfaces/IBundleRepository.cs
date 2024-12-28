using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IBundleRepository : IRepositoryQuery<Bundle>, IRepositoryCommand<Bundle>
    {
    }
}
