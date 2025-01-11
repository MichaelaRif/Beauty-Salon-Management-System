using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ICustomerRepository :
        IRepositoryQuery<Customer>,
        IRepositoryPost<Customer>,
        IRepositoryUpdate<Customer>
    {
        Task<int> GetByKeycloakIdAsync(string keycloakId);
        Task DeleteAsync(string keycloakId);
    }
}