namespace BSMS.Data.Common.Interfaces.Common
{
    public interface IRepositoryPost<T> where T : class
    {
        Task<T?> AddAsync(T entity);
    }

}