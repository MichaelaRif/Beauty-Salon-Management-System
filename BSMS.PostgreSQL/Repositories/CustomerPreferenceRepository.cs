using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerPreferenceRepository : ICustomerPreferenceRepository
    {
        private readonly string _connectionString;
        public CustomerPreferenceRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task AddAsync(CustomerPreference entity)
        {
            const string sql = "SELECT * FROM insert_customer_preference(@customerId, @preferenceId);";
            using var connection = new NpgsqlConnection(_connectionString);

            await connection.OpenAsync();

            await connection.QueryFirstAsync(
                sql,
                new { customerId = entity.CustomerId, preferenceId = entity.PreferenceId }
            );

        }

        public Task DeleteAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<CustomerPreference>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<CustomerPreference?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task UpdateAsync(CustomerPreference entity)
        {
            throw new NotImplementedException();
        }
    }

}
