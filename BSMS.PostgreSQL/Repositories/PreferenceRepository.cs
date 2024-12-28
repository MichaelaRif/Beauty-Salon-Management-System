using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;

namespace BSMS.PostgreSQL.Repositories
{
    public class PreferenceRepository : BaseRepository<Preference>, IPreferenceRepository
    {
        public PreferenceRepository(BSMSDbContext context) : base(context) { }
    }
}