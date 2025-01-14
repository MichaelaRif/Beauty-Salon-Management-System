using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class ProductCartRepository : IProductCartRepository
    {
        private readonly string _connectionString;

        public ProductCartRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(ProductCart entity)
        {
            const string sql = @"
                                SELECT * FROM insert_product_cart(
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
                         SELECT * FROM delete_product_cart(
                             @CustomerId,
                             @ProductId
                         )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<Customer>(
                sql,
                new { CustomerId = customerId, ProductId = productId });
        }

        public async Task<IEnumerable<ProductCart>?> GetAllAsync(int customerId)
        {
            const string sql = @"
                         SELECT * FROM get_product_carts(
                             @CustomerId
                         )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryAsync<ProductCart>(
                sql,
                new { CustomerId = customerId });

            return result;
        }

    }
}