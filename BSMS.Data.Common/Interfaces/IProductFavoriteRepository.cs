using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IProductFavoriteRepository
    {
        Task<int> AddAsync(ProductFavorite entity);
        Task DeleteAsync(int customerId, int productId);
        Task<IEnumerable<ProductFavorite>?> GetAllAsync(int customerId);
    }
}
