using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IServiceCartRepository
    {
        Task<int> AddAsync(ServiceCart entity);
        Task DeleteAsync(int customerId, int serviceId);
        Task<IEnumerable<int>?> GetAllAsync(int customerId);
    }
}
