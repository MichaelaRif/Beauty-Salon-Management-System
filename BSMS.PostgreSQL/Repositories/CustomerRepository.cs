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
            const string sql = @"
                                SELECT * FROM get_customer_id_by_keycloak_id(
                                    @CustomerKeycloakId::keycloak_domain
                                )";


            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<int>(sql, new { CustomerKeycloakId = keycloakId });

            return result;
        }

        public async Task<Customer?> UpdateAsync(Customer customer)
        {
            const string sql = @"
                                SELECT * FROM update_customer(
                                    @CustomerId,
                                    @CustomerFn::name_domain,
                                    @CustomerLn::name_domain,
                                    @CustomerEmail::email_domain,
                                    @CustomerPn::pn_domain,
                                    @CustomerDob::date,
                                    @CustomerPronounId
                                )";


            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<Customer>(
                sql, 
                customer);

            return result;
        }
    }
}