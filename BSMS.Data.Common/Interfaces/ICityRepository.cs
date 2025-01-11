namespace BSMS.Data.Common.Interfaces
{
    public interface ICityRepository
    {
        Task<int> GetIdByNameAsync(string cityName);
    }
}
