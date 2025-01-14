using BSMS.BusinessLayer.Commands.Create;
using BSMS.BusinessLayer.Commands.Delete;
using BSMS.BusinessLayer.Commands.Update;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Handlers.Create;
using BSMS.BusinessLayer.Handlers.Delete;
using BSMS.BusinessLayer.Handlers.Get;
using BSMS.BusinessLayer.Handlers.Get.All;
using BSMS.BusinessLayer.Handlers.Get.ById;
using BSMS.BusinessLayer.Handlers.Update;
using BSMS.BusinessLayer.Queries.Get;
using BSMS.BusinessLayer.Queries.Get.All;
using BSMS.BusinessLayer.Queries.Get.ById;
using BSMS.BusinessLayer.Services.EmailServices;
using MediatR;
using Microsoft.Extensions.DependencyInjection;

namespace BSMS.BusinessLayer
{
    public static class Dependencies
    {
        public static void AddBusinessLogicLayerDependencies(this IServiceCollection services)
        {
            // register email sender service
            services.AddTransient<IEmailSender, EmailSender>();

            // register MediatR handlers for contact us
            services.AddScoped<IRequestHandler<CreateContactUsCommand, Unit>, CreateContactUsHandler>();

            // register MediatR handlers for bundles
            services.AddScoped<IRequestHandler<GetBundleByIdQuery, BundleDto>, GetBundleByIdHandler>();
            services.AddScoped<IRequestHandler<GetAllBundlesQuery, IEnumerable<BundleDto>>, GetAllBundlesHandler>();
            services.AddScoped<IRequestHandler<CreateBundleCommand, BundleDto>, CreateBundleHandler>();
            services.AddScoped<IRequestHandler<DeleteBundleCommand, Unit>, DeleteBundleHandler>();
            services.AddScoped<IRequestHandler<UpdateBundleCommand, Unit>, UpdateBundleHandler>();

            // register MediatR handlers for addresses
            services.AddScoped<IRequestHandler<GetAddressByIdQuery, AddressDto>, GetAddressByIdHandler>();
            services.AddScoped<IRequestHandler<GetAllAddressesQuery, IEnumerable<AddressDto>>, GetAllAddressesHandler>();
            services.AddScoped<IRequestHandler<CreateAddressCommand, int>, CreateAddressHandler>();
            services.AddScoped<IRequestHandler<DeleteAddressCommand, Unit>, DeleteAddressHandler>();

            // register MediatR handlers for customers
            services.AddScoped<IRequestHandler<CreateCustomerCommand, string>, CreateCustomerHandler>();
            services.AddScoped<IRequestHandler<GetCustomerByKeycloakIdQuery, CustomerInfoDto>, GetCustomerByKeycloakIdHandler>();
            services.AddScoped<IRequestHandler<DeleteCustomerCommand, Unit>, DeleteCustomerHandler>();

            // register MediatR handlers for customers profile
            services.AddScoped<IRequestHandler<GetCustomerProfileQuery, CustomerInfoDto>, GetCustomerProfileHandler>();
            services.AddScoped<IRequestHandler<UpdateCustomerProfileCommand, CustomerInfoDto>, UpdateCustomerProfileHandler>();

            // register MediatR handlers for preferences
            services.AddScoped<IRequestHandler<GetPreferenceByIdQuery, PreferenceDto>, GetPreferenceByIdHandler>();
            services.AddScoped<IRequestHandler<GetAllPreferencesQuery, IEnumerable<PreferenceDto>>, GetAllPreferencesHandler>();

            // register MediatR handlers for customer addresses
            services.AddScoped<IRequestHandler<CreateCustomerAddressCommand, int>, CreateCustomerAddressHandler>();

            // register MediatR handlers for customer preferences
            services.AddScoped<IRequestHandler<CreateCustomerPreferenceCommand, Unit>, CreateCustomerPreferenceHandler>();

            // register MediatR handlers for services favorites
            services.AddScoped<IRequestHandler<CreateServiceFavoriteCommand, int>, CreateServiceFavoriteHandler>();
            services.AddScoped<IRequestHandler<GetAllServiceFavoritesQuery, IEnumerable<ServiceDto>>, GetAllServiceFavoritesHandler>();
            services.AddScoped<IRequestHandler<DeleteServiceFavoriteCommand, Unit>, DeleteServiceFavoriteHandler>();

            // register MediatR handlers for product favorites
            services.AddScoped<IRequestHandler<CreateProductFavoriteCommand, int>, CreateProductFavoriteHandler>();
            services.AddScoped<IRequestHandler<GetAllProductFavoritesQuery, IEnumerable<ProductDto>>, GetAllProductFavoritesHandler>();
            services.AddScoped<IRequestHandler<DeleteProductFavoriteCommand, Unit>, DeleteProductFavoriteHandler>();

            // register MediatR handlers for salon reviews
            services.AddScoped<IRequestHandler<GetTopSalonReviewQuery, IEnumerable<SalonReviewDto>>, GetTopSalonReviewHandler>();
            services.AddScoped<IRequestHandler<CreateSalonReviewCommand, int>, CreateSalonReviewHandler>();
            services.AddScoped<IRequestHandler<GetSalonReviewByIdQuery, SalonReviewDto>, GetSalonReviewByIdHandler>();
            services.AddScoped<IRequestHandler<DeleteSalonReviewCommand, Unit>, DeleteSalonReviewHandler>();

        }
    }
}
