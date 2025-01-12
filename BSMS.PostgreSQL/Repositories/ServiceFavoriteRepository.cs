using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class ServiceFavoriteRepository : IServiceFavoriteRepository
    {
        private readonly string _connectionString;

        public ServiceFavoriteRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(ServiceFavorite entity)
        {
            const string sql = @"
                                SELECT * FROM insert_service_favorite(
                                    @CustomerId, 
                                    @ServiceId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleOrDefaultAsync<int>(
                sql,
                entity
            );

            return result;
        }

        public async Task DeleteAsync(int customerId, int serviceId)
        {
            const string sql = @"
                                SELECT * FROM delete_service_favorite(
                                    @CustomerId,
                                    @ServiceId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<Customer>(
                sql,
                new {  CustomerId = customerId, ServiceId = serviceId });
        }

        public async Task<IEnumerable<int>?> GetAllAsync(int customerId)
        {
            const string sql = @"
                                SELECT * FROM get_service_favorites(
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