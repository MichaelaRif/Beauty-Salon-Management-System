using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

public class PronounRepository : IPronounRepository
{
    private readonly string _connectionString;
    public PronounRepository(string connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<int> GetIdByNameAsync(string pronoun1)
    {
        const string sql = "SELECT * FROM get_pronoun_id(@pronounName::pronoun_domain);";

        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var result = await connection.QueryFirstAsync<int>(sql, new { pronounName = pronoun1 });

        return result;
    }
}