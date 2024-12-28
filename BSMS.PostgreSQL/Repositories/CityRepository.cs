using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
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

        public async Task<City?> GetByIdAsync(int cityId)
        {
            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (var cmd = new NpgsqlCommand("SELECT * FROM get_city_by_id(@cityId)", connection))
                {
                    cmd.Parameters.AddWithValue("cityId", cityId);

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            return new City
                            {
                                CityId = reader.GetInt32(reader.GetOrdinal("city_id")),
                                CityName = reader.GetString(reader.GetOrdinal("city_name")),
                                Country = new Country
                                {
                                    CountryId = reader.GetInt32(reader.GetOrdinal("country_id")),
                                    CountryName = reader.GetString(reader.GetOrdinal("country_name"))
                                }
                            };
                        }
                        return null;
                    }
                }
            }
        }

        public async Task<IEnumerable<City>?> GetAllAsync()
        {
            var cities = new List<City>();

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (var cmd = new NpgsqlCommand("SELECT * FROM get_cities()", connection))
                {
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            cities.Add(new City
                            {
                                CityId = reader.GetInt32(reader.GetOrdinal("city_id")),
                                CityName = reader.GetString(reader.GetOrdinal("city_name")),
                                Country = new Country
                                {
                                    CountryId = reader.GetInt32(reader.GetOrdinal("country_id")),
                                    CountryName = reader.GetString(reader.GetOrdinal("country_name"))
                                }
                            });
                        }
                    }
                }
            }

            return cities;
        }
    }
}