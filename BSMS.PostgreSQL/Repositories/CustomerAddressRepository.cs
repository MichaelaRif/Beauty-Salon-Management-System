using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerAddressRepository : BaseRepository<CustomerAddress>, ICustomerAddressRepository
    {
        public CustomerAddressRepository(BSMSDbContext context) : base(context) { }
    }
}
