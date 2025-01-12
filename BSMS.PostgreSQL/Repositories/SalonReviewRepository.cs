using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class SalonReviewRepository : ISalonReviewRepository
    {
        private readonly string _connectionString;

        public SalonReviewRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public Task<int> AddAsync(SalonReview entity)
        {
            throw new NotImplementedException();
        }

        public Task DeleteAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<SalonReview>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<SalonReview?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<SalonReview>?> GetTopAsync()
        {
            string sql = "SELECT * FROM get_top_salon_reviews()";

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                var result = await connection.QueryAsync<SalonReview, Customer, SalonReview>(
                    sql,
                    (salonReview, customer) =>
                    {
                        salonReview.Customer = customer;
                        return salonReview;
                    },
                    splitOn: "CustomerFn"
                );

                return result;
            }
        }

    }
}
