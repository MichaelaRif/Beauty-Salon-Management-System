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
            services.AddDbContext<BSMSDbContext>(options =>
                options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")));

            services.AddScoped<ICityRepository, CityRepository>();
            services.AddScoped<IBundleRepository, BundleRepository>();


            return services;
        }
    }
}
