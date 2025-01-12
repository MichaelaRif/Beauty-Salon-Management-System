using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class AddressRepository : IAddressRepository
    {
        private readonly string _connectionString;

        public AddressRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(Address address)
        {
            const string sql = @"
                                SELECT * FROM insert_address(
                                    @AddressStreet, 
                                    @AddressBuilding, 
                                    @AddressFloor, 
                                    @AddressNotes, 
                                    @AddressCityId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleOrDefaultAsync<int>(
                sql,
                address
            );

            return result;
        }

        public Task DeleteAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Address>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<Address?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<Address?> UpdateAsync(Address address, int customerId)
        {
            const string sql = @"
                                SELECT * FROM update_customer_address(
                                    @AddressStreet, 
                                    @AddressBuilding, 
                                    @AddressFloor, 
                                    @AddressNotes, 
                                    @AddressCityId,
                                    @CustomerId
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleOrDefaultAsync<Address>(
                sql,
                new { AddressStreet = address.AddressStreet, 
                    AddressBuilding = address.AddressBuilding, 
                    AddressFloor = address.AddressFloor, 
                    AddressNotes = address.AddressNotes, 
                    AddressCityId = address.AddressCityId,
                    CustomerId = customerId }
            );

            return result;
        }
    }
}