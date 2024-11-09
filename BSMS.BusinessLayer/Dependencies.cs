using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Handlers;
using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.Extensions.DependencyInjection;

namespace BSMS.BusinessLayer
{
    public static class Dependencies
    {
        public static void AddBusinessLogicLayerDependencies(this IServiceCollection services)
        {
            // register MediatR handlers for cities
            services.AddScoped<IRequestHandler<GetCityByIdQuery, CityDto>, GetCityByIdHandler>();
            services.AddScoped<IRequestHandler<GetAllCitiesQuery, IEnumerable<CityDto>>, GetAllCitiesHandler>();

            // register MediatR handlers for bundles
            services.AddScoped<IRequestHandler<GetBundleByIdQuery, BundleDto>, GetBundleByIdHandler>();
            services.AddScoped<IRequestHandler<GetAllBundlesQuery, IEnumerable<BundleDto>>, GetAllBundlesHandler>();
            services.AddScoped<IRequestHandler<CreateBundleCommand, BundleDto>, CreateBundleHandler>();
            services.AddScoped<IRequestHandler<DeleteBundleCommand, bool>, DeleteBundleHandler>();
            services.AddScoped<IRequestHandler<UpdateBundleWithIdCommand, BundleDto>, UpdateBundleHandler>();

        }
    }
}
