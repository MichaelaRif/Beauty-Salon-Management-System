using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace BSMS.PostgreSQL.Repositories
{
    public class AddressRepository : BaseRepository<Address>, IAddressRepository
    {
        public AddressRepository(BSMSDbContext context) : base(context) { }

        public override async Task<Address?> GetByIdAsync(int id)
        {
            return await _context.Addresses
                .Where(address => address.AddressId == id)
                .Include(address => address.AddressCity)
                    .ThenInclude(city => city.Country)
                .FirstOrDefaultAsync(x => x.AddressId == id);
        }

        public override async Task<IEnumerable<Address>> GetAllAsync()
        {
            return await _context.Addresses
                .Include(address => address.AddressCity)
                    .ThenInclude(city => city.Country)
                .ToListAsync();
        }
    }
}
