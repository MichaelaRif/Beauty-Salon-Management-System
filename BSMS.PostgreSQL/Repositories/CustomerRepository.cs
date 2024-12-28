using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerRepository : BaseRepository<Customer>, ICustomerRepository
    {
        public CustomerRepository(BSMSDbContext context) : base(context) { }

        public async Task<Customer> GetByKeycloakIdAsync(string keycloakId)
        {
            return await _context.Customers
                .FirstOrDefaultAsync(c => c.CustomerKeycloakId == keycloakId);
        }

    }
}
