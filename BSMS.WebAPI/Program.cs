using BSMS.BusinessLayer;
using BSMS.BusinessLayer.Profiles;
using BSMS.PostgreSQL;
using MediatR;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

namespace BSMS.WebAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddControllers();


            builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(options =>
            {
                options.Authority = builder.Configuration["Jwt:Authority"];
                options.Audience = builder.Configuration["Jwt:Audience"];
                options.RequireHttpsMetadata = false; // false for development, true for production mode
                options.SaveToken = true;

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = builder.Configuration["Jwt:Authority"],
                    ValidAudience = builder.Configuration["Jwt:Audience"],
                };
            });

            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("AdminPolicy", policy => policy.RequireRole("admin"));
                options.AddPolicy("GuestPolicy", policy => policy.RequireRole("guest"));
                options.AddPolicy("StaffPolicy", policy => policy.RequireRole("staff"));
            });


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
