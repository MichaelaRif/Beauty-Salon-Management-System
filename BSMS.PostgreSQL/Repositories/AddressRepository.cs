using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;

namespace BSMS.PostgreSQL.Repositories
{
    public class AddressRepository : BaseRepository<Address>, IAddressRepository
    {
        public AddressRepository(BSMSDbContext context) : base(context) { }
    }
}
