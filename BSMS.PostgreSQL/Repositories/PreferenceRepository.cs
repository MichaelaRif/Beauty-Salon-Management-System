using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class PreferenceRepository : IPreferenceRepository
    {
        private readonly string _connectionString;
        public PreferenceRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<IEnumerable<Preference>?> GetAllAsync()
        {
            const string sql = "SELECT * FROM get_preferences();";

            using var connection = new NpgsqlConnection(_connectionString);

            await connection.OpenAsync();

            var result = await connection.QueryAsync<Preference, Category, Preference>(
                sql,
                (preference, category) =>
                {
                    preference.Category = category;
                    preference.Category.CategoryName = category.CategoryName;
                    return preference;
                },
                splitOn: "CategoryId"
            );

            return result;
        }

        public Task<Preference?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

    }
}