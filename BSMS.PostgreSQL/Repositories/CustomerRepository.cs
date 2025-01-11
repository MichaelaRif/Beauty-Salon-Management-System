using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly string _connectionString;
        public CustomerRepository(string connectionString) 
        {
            _connectionString = connectionString;
        }

        public async Task<int> AddAsync(Customer customer)
        {
            const string sql = @"
                                SELECT * FROM insert_customer(
                                    @CustomerKeycloakId::keycloak_domain,
                                    @CustomerFn::name_domain,
                                    @CustomerLn::name_domain,
                                    @CustomerEmail::email_domain,
                                    @CustomerPn::pn_domain,
                                    @CustomerDob::date,
                                    @CustomerPronounId,
                                    @IsGoogle,
                                    @IsApple
                                )";


            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleOrDefaultAsync<int>(
                sql,
                customer
            );

            return result;
        }

        public Task DeleteAsync(string keycloakId)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Customer>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<Customer?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<int> GetByKeycloakIdAsync(string keycloakId)
        {
            throw new NotImplementedException();
        }

        public Task UpdateAsync(Customer entity)
        {
            throw new NotImplementedException();
        }
    }
}