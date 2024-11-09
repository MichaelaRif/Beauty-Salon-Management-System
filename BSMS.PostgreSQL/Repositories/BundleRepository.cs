using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;

namespace BSMS.PostgreSQL.Repositories
{
    public class BundleRepository : BaseRepository<Bundle>, IBundleRepository
    {
        public BundleRepository(BSMSDbContext context) : base(context) { }

    }
}
