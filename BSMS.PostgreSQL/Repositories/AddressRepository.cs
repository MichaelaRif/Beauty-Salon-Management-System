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

        public Task UpdateAsync(Address entity)
        {
            throw new NotImplementedException();
        }
    }
}