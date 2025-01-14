using BSMS.Data.Common.Interfaces.Common;
using BSMS.PostgreSQL;
using Microsoft.EntityFrameworkCore;

public abstract class BaseRepository<T> :
        IRepositoryQuery<T>,
        IRepositoryUpdate<T>,
        IRepositoryDelete<T>
    where T : class
{
    protected readonly BSMSDbContext _context;
    protected readonly DbSet<T> _dbSet;

    protected BaseRepository(BSMSDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public virtual async Task<IEnumerable<T>?> GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    public virtual async Task<T?> GetByIdAsync(int id)
    {
        return await _dbSet.FindAsync(id);
    }

    public virtual async Task<T?> AddAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();

        return entity;
    }

    public virtual async Task UpdateAsync(T entity)
    {
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }

    public virtual async Task DeleteAsync(int id)
    {
        var entity = await _dbSet.FindAsync(id);
        if (entity != null)
        {
            _dbSet.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}