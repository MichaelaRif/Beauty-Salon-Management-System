namespace BSMS.Data.Common.Interfaces.Common
{
    public interface IRepositoryCommand<T> where T : class
    {
        Task<T?> AddAsync(T entity);
        Task UpdateAsync(T entity);
        Task DeleteAsync(int id);
    }

}