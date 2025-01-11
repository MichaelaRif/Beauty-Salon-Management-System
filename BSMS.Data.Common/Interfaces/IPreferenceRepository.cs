using BSMS.Data.Common.Interfaces.Common;
using BSMS.Domain.Entities;

namespace BSMS.Data.Common.Interfaces
{
    public interface IPreferenceRepository : 
        IRepositoryQuery<Preference>
    {
        Task<IEnumerable<Preference>?> GetAllAsync(string keycloakId);
    }
}