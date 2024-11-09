using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace BSMS.PostgreSQL.Repositories
{
    public class CityRepository : BaseRepository<City>, ICityRepository
    {
        public CityRepository(BSMSDbContext context) : base(context) { }

        public override async Task<City?> GetByIdAsync(int id)
        {
            return await _context.Cities
                .Where(city => city.CityId == id)
                .Include(city => city.Country)
                .FirstOrDefaultAsync(x => x.CityId == id);
        }

        public override async Task<IEnumerable<City>> GetAllAsync()
        {
            return await _context.Cities
                .Include(city => city.Country)
                .ToListAsync();
        }
    }
}
