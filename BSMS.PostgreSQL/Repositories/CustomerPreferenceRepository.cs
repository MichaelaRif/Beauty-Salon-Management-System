using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerPreferenceRepository : BaseRepository<CustomerPreference>, ICustomerPreferenceRepository
    {
        public CustomerPreferenceRepository(BSMSDbContext context) : base(context) { }
    }
}
