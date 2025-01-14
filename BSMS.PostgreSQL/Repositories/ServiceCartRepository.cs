using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class ServiceCartRepository : IServiceCartRepository
    {
        private readonly string _connectionString;

        public ServiceCartRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(ServiceCart entity)
        {
            const string sql = @"
                                SELECT * FROM insert_service_cart(
                                    @CustomerId, 
                                    @ServiceId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleAsync<int>(
                sql,
                entity
            );

            return result;
        }

        public async Task DeleteAsync(int customerId, int serviceId)
        {
            const string sql = @"
                                SELECT * FROM delete_service_cart(
                                    @CustomerId,
                                    @ServiceId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleAsync<Customer>(
                sql,
                new { CustomerId = customerId, ServiceId = serviceId });
        }

        public async Task<IEnumerable<int>?> GetAllAsync(int customerId)
        {
            const string sql = @"
                                SELECT * FROM get_service_carts(
                                    @CustomerId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryAsync<int>(
                sql,
                new { CustomerId = customerId });

            return result;
        }

    }
}