using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ICustomerRepository :
        IRepositoryQuery<Customer>,
        IRepositoryPost<Customer>,
        IRepositoryUpdate<Customer>,
        IRepositoryDelete<Customer>
    {
        Task<Customer?> GetByKeycloakIdAsync(string keycloakId);
    }
}