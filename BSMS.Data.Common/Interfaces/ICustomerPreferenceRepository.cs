using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ICustomerPreferenceRepository : 
        IRepositoryQuery<CustomerPreference>,
        IRepositoryPost<CustomerPreference>,
        IRepositoryUpdate<CustomerPreference>,
        IRepositoryDelete<CustomerPreference>
    {
    }
}