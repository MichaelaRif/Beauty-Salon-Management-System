using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class ProductFavoriteRepository : IProductFavoriteRepository
    {
        private readonly string _connectionString;

        public ProductFavoriteRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(ProductFavorite entity)
        {
            const string sql = @"
                                SELECT * FROM insert_product_favorite(
                                    @CustomerId, 
                                    @ProductId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleOrDefaultAsync<int>(
                sql,
                entity
            );

            return result;
        }

        public Task DeleteAsync(int customerId, int productId)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<ProductFavorite>?> GetAllAsync(int customerId)
        {
            throw new NotImplementedException();
        }
    }
}