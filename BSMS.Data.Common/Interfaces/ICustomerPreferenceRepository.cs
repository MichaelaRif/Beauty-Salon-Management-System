using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ICustomerPreferenceRepository : 
        IRepositoryQuery<CustomerPreference>,
        IRepositoryUpdate<CustomerPreference>,
        IRepositoryDelete<CustomerPreference>
    {
        Task AddAsync(CustomerPreference entity);
    }
}