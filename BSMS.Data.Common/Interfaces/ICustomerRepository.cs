using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ICustomerRepository :
        IRepositoryQuery<Customer>,
        IRepositoryPost<Customer>
    {
        Task<int> GetByKeycloakIdAsync(string keycloakId);
        Task<Customer?> UpdateAsync(Customer customer);
        Task DeleteAsync(string keycloakId);
    }
}