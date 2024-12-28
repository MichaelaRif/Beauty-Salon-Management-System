using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using BSMS.PostgreSQL;
using Microsoft.EntityFrameworkCore;

public class PronounRepository : BaseRepository<Pronoun>, IPronounRepository
{
    public PronounRepository(BSMSDbContext context) : base(context) { }

    public async Task<int> GetIdByNameAsync(string pronounName)
    {
        var pronoun = await _context.Pronouns
            .FirstOrDefaultAsync(p => p.Pronoun1 == pronounName);

        return pronoun.PronounId;
    }
}