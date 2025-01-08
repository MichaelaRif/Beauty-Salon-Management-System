namespace BSMS.Data.Common.Interfaces.Common
{
    public interface IRepositoryUpdate<T> where T : class
    {
        Task UpdateAsync(T entity);
    }

}