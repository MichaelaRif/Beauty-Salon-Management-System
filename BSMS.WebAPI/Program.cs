using BSMS.BusinessLayer;
using BSMS.BusinessLayer.Profiles;
using BSMS.PostgreSQL;
using BSMS.WebAPI.Services;
using MediatR;

namespace BSMS.WebAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddControllers();

            builder.Services.AddHttpContextAccessor();


            var authority = builder.Configuration["Keycloak:Authority"];
            var clientid = builder.Configuration["Keycloak:ClientId"];

            if (string.IsNullOrEmpty(authority) || string.IsNullOrEmpty(clientid))
            {
                throw new InvalidOperationException("Keycloak is not configured");
            }

            builder.Services.AddKeycloakAuth(authority, clientid);


            builder.Services.AddAuthorization();


            builder.Services.AddMediatR(typeof(Program).Assembly); 


            builder.Services.AddBusinessLogicLayerDependencies();

            builder.Services.AddPostgreSQLDependencies(builder.Configuration);


            builder.Services.AddAutoMapper(typeof(MappingProfile).Assembly);


            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthentication();

            app.UseAuthorization();

            app.MapControllers();

            app.Run();

        }

    }
}
