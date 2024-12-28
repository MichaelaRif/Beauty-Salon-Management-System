namespace BSMS.Data.Common.Interfaces.Common
{
    public interface IRepositoryQuery<T> where T : class
    {
        Task<IEnumerable<T>?> GetAllAsync();
        Task<T?> GetByIdAsync(int id);
    }

}