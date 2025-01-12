using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class ServiceRepository : IServiceRepository
    {
        private readonly string _connectionString;

        public ServiceRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public Task<IEnumerable<Service>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<Service?> GetByIdAsync(int id)
        {
            const string sql = @"
                                    SELECT * FROM get_service_by_id(
                                        @ServiceId
                                    )";


            using var connection = new NpgsqlConnection(_connectionString);

            await connection.OpenAsync();

            var result = await connection.QueryAsync<Service, ServiceCategory, Service>(
                sql,
                (service, serviceCategory) =>
                {
                    service.ServiceCategory = serviceCategory;
                    service.ServiceCategoryId = serviceCategory.ServiceCategoryId;
                    service.ServiceCategory.ServiceCategoryName = serviceCategory.ServiceCategoryName;
                    return service;
                },
                new { ServiceId = id },
                splitOn: "ServiceCategoryId"
            );

            return result.FirstOrDefault();
        }
    }
}