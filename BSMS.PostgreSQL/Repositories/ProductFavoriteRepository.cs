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

        public async Task DeleteAsync(int customerId, int productId)
        {
            const string sql = @"
                         SELECT * FROM delete_product_favorite(
                             @CustomerId,
                             @ProductId
                         )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<Customer>(
                sql,
                new { CustomerId = customerId, ProductId = productId });
        }

        public async Task<IEnumerable<ProductFavorite>?> GetAllAsync(int customerId)
        {
            const string sql = @"
                         SELECT * FROM get_product_favorites(
                             @CustomerId
                         )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryAsync<ProductFavorite>(
                sql,
                new { CustomerId = customerId });

            return result;
        }

    }
}