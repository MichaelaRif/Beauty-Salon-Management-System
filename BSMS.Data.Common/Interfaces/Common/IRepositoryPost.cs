namespace BSMS.Data.Common.Interfaces.Common
{
    public interface IRepositoryPost<T> where T : class
    {
        Task<int> AddAsync(T entity);
    }

}