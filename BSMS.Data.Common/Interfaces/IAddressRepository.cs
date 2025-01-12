using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IAddressRepository : 
        IRepositoryQuery<Address>, 
        IRepositoryPost<Address>, 
        IRepositoryDelete<Address>
    {
        Task<Address?> UpdateAsync(Address address, int customerId);
    }
}
