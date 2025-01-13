using BSMS.BusinessLayer;
using BSMS.BusinessLayer.Profiles;
using BSMS.BusinessLayer.Services.KeycloakServices;
using BSMS.PostgreSQL;
using BSMS.PostgreSQL.Handlers;
using BSMS.WebAPI.Services;
using Dapper;
using MediatR;
using System.Reflection;

namespace BSMS.WebAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
     

            builder.Services.AddControllers();

            builder.Services.AddHttpContextAccessor();

            builder.Services.AddHttpClient<IUserInfoService, UserInfoService>();

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

            SqlMapper.RemoveTypeMap(typeof(DateOnly));
            SqlMapper.AddTypeHandler(new DateOnlyTypeHandler());

           
            builder.Services.AddSwaggerGen(options =>
            {
                options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
                {
                    Version = "v1",
                    Title = "Beauty Salon Management System API",
                });

                options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
                {
                    In = Microsoft.OpenApi.Models.ParameterLocation.Header,
                    Description = @"JWT Authorization header using the Bearer scheme. 
                      Enter 'Bearer' [space] and then your token in the text input below.
                      Example: 'Bearer 12345abcdef'",
                    Name = "Authorization",
                    BearerFormat = "JWT",
                    Scheme = "Bearer"
                });

                options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement {
                {
                    new Microsoft.OpenApi.Models.OpenApiSecurityScheme
                    {
                        Reference = new Microsoft.OpenApi.Models.OpenApiReference
                        {
                            Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    new string[] { }
                }});

            });


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
