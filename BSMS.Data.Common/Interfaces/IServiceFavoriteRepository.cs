using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IServiceFavoriteRepository
    {
        Task<int> AddAsync(ServiceFavorite entity);
        Task DeleteAsync(int customerId, int serviceId);
        Task<IEnumerable<int>?> GetAllAsync(int customerId);
    }
}
