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

        public async Task<int> AddAsync(SalonReview entity)
        {
            const string sql = @"
                                SELECT * FROM insert_salon_review(
                                    @CustomerId, 
                                    @SalonStarsCount,
                                    @CustomerSalonReview
                                )";

            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QuerySingleAsync<int>(
                sql,
                entity
            );

            return result;

        }

        public Task DeleteAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<SalonReview>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<SalonReview?> GetByIdAsync(int salonReviewId)
        {
            const string sql = "SELECT * FROM get_salon_review_by_id(@SalonReviewId)";

            using var connection = new NpgsqlConnection(_connectionString);

            await connection.OpenAsync();

            var result = await connection.QueryAsync<SalonReview, Customer, SalonReview>(
                sql,
                (salonReview, customer) =>
                {
                    salonReview.Customer = customer;
                    return salonReview;
                },
                new { SalonReviewId = salonReviewId },
                splitOn: "CustomerFn"
            );

            return result.FirstOrDefault();
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
