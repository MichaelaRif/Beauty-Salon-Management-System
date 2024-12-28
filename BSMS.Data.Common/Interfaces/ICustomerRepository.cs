using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface ICustomerRepository : IRepositoryQuery<Customer>, IRepositoryCommand<Customer>
    {
        Task<Customer> GetByKeycloakIdAsync(string keycloakId);
    }
}