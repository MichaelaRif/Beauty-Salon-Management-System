using BSMS.Data.Common.Interfaces;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class CityRepository : ICityRepository
    {
        private readonly string _connectionString;

        public CityRepository(string connectionString)
        {
            _connectionString = connectionString;
        }
        
        public async Task<int> GetIdByNameAsync(string cityName)
        {
            const string sql = "SELECT * FROM get_city_id(@cityName);";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryFirstAsync<int>(sql, new { cityName });

            return result;
        }
    }
}