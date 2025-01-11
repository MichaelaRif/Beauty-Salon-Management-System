namespace BSMS.Data.Common.Interfaces
{
    public interface IPronounRepository
    {
        Task<int> GetIdByNameAsync(string pronounName);
    }
}