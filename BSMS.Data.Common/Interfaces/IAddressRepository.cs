using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IAddressRepository : 
        IRepositoryQuery<Address>, 
        IRepositoryPost<Address>, 
        IRepositoryUpdate<Address>, 
        IRepositoryDelete<Address>
    {
    }
}
