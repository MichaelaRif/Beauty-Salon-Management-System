using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IProductCartRepository
    {
        Task<int> AddAsync(ProductCart entity);
        Task DeleteAsync(int customerId, int productId);
        Task<IEnumerable<ProductCart>?> GetAllAsync(int customerId);
    }
}
