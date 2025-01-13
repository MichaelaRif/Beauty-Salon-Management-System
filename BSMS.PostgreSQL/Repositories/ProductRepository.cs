using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using Dapper;
using Npgsql;

namespace BSMS.PostgreSQL.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly string _connectionString;

        public ProductRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public Task<IEnumerable<Product>?> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<Product?> GetByIdAsync(int id)
        {
            const string sql = @"
                                SELECT * FROM get_product_by_id(
                                    @ProductId
                                )";


            using var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();

            var result = await connection.QueryAsync<Product, ProductBrand, ProductCategory, Product>
                (sql, 
                (product, productBrand, productCategory) =>
                {
                    product.ProductBrandId = productBrand.ProductBrandId;
                    product.ProductBrand = productBrand;
                    product.ProductCategoryId = productCategory.ProductCategoryId;
                    product.ProductCategory = productCategory;
                    return product;
                },
                new { ProductId = id },
                splitOn: "ProductBrandId, ProductCategoryId"
                );

            return result.FirstOrDefault();

        }
    }
}