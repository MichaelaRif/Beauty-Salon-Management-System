using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerAddressRepository : ICustomerAddressRepository
    {
        private readonly string _connectionString;
        public CustomerAddressRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(CustomerAddress customerAddress)
        {
            const string sql = "SELECT * FROM insert_customer_address(@customerId, @addressId);";
            using var connection = new NpgsqlConnection(_connectionString);

            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<int>(
                sql,
                new { customerId = customerAddress.CustomerId, addressId = customerAddress.AddressId }
            );

            return result;
        }

        public Task DeleteAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<CustomerAddress>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<CustomerAddress?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task UpdateAsync(CustomerAddress entity)
        {
            throw new NotImplementedException();
        }
    }
}
