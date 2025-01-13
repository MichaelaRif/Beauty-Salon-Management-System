using BSMS.Data.Common.Interfaces;
using BSMS.PostgreSQL.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace BSMS.PostgreSQL
{
    public static class Dependencies
    {
        public static IServiceCollection AddPostgreSQLDependencies(this IServiceCollection services, IConfiguration configuration)
        {
            var connectionString = configuration.GetConnectionString("DefaultConnection");

            services.AddDbContext<BSMSDbContext>(options =>
                options.UseNpgsql(connectionString));

            services.AddScoped<ICityRepository>(sp =>
                        new CityRepository(connectionString));

            services.AddScoped<IBundleRepository, BundleRepository>();

            services.AddScoped<IAddressRepository>(sp =>
                        new AddressRepository(connectionString));
   
            services.AddScoped<ICustomerRepository>(sp =>
                        new CustomerRepository(connectionString));

            services.AddScoped<IPronounRepository>(sp =>
                        new PronounRepository(connectionString));

            services.AddScoped<IPreferenceRepository>(sp =>
                        new PreferenceRepository(connectionString));

            services.AddScoped<ICustomerAddressRepository>(sp =>
                        new CustomerAddressRepository(connectionString));

            services.AddScoped<ICustomerPreferenceRepository>(sp =>
                        new CustomerPreferenceRepository(connectionString));

            services.AddScoped<ISalonReviewRepository>(sp =>
                        new SalonReviewRepository(connectionString));

            services.AddScoped<IServiceRepository>(sp =>
                        new ServiceRepository(connectionString));

            services.AddScoped<IServiceFavoriteRepository>(sp =>
                        new ServiceFavoriteRepository(connectionString));

            services.AddScoped<IProductFavoriteRepository>(sp =>
                        new ProductFavoriteRepository(connectionString));


            return services;
        }
    }
}
