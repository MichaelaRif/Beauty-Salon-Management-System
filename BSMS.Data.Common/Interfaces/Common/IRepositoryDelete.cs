namespace BSMS.Data.Common.Interfaces.Common
{
    public interface IRepositoryDelete<T> where T : class
    {
        Task DeleteAsync(int id);
    }

}