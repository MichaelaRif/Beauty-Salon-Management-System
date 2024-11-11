using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerRepository : BaseRepository<Customer>, ICustomerRepository
    {
        public CustomerRepository(BSMSDbContext context) : base(context) { }
    }
}
