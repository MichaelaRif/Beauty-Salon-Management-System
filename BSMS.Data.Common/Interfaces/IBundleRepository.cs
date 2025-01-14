using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IBundleRepository :
        IRepositoryQuery<Bundle>, 
        IRepositoryUpdate<Bundle>, 
        IRepositoryDelete<Bundle>
    {
        Task <Bundle> AddAsync (Bundle bundle);  
    }
}
