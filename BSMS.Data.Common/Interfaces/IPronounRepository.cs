using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IPronounRepository : IRepositoryQuery<Pronoun>
    {
        Task<int> GetIdByNameAsync(string pronounName);
    }
}